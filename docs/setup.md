# DeFtunes Pipeline Setup Guide

This document provides detailed instructions on how to set up and deploy the DeFtunes data pipeline.

## Prerequisites

Before you begin, make sure you have:
- An AWS account with appropriate permissions
- Terraform installed locally
- AWS CLI configured with your credentials
- Access to a Docker environment (for local development)

## Environment Setup

1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/yourusername/deftunes-data-pipeline.git
   cd deftunes-data-pipeline
   ```

2. Initialize your environment:
   ```bash
   source scripts/setup.sh
   ```

## AWS Infrastructure Deployment

### 1. Configure the API Endpoint

1. Deploy the initial CloudFormation stack in your AWS account
2. Go to CloudFormation in the AWS Console and find the stack outputs
3. Copy the `APIEndpoint` value
4. Edit terraform/modules/extract_job/glue.tf:
   - Replace `<API_ENDPOINT>` placeholders with the endpoint value
   - Set `<INGEST_DATE_YYYY-MM-DD>` to your desired start date, e.g., "2020-02-01"

### 2. Deploy Components Using Terraform

Deploy the infrastructure in the following order:

```bash
cd terraform
terraform init
terraform plan
terraform apply -target=module.extract_job
terraform apply -target=module.transform_job
terraform apply -target=module.serving
terraform apply -target=module.data_quality
```

### 3. Initial Data Load

Run the extraction jobs:

```bash
# Get job names from Terraform outputs
aws glue start-job-run --job-name <glue_api_users_extract_job> | jq -r '.JobRunId'
aws glue start-job-run --job-name <glue_sessions_users_extract_job> | jq -r '.JobRunId'
aws glue start-job-run --job-name <glue_rds_extract_job> | jq -r '.JobRunId'

# Monitor job status
aws glue get-job-run --job-name <JOB-NAME> --run-id <JobRunID> --output text --query "JobRun.JobRunState"
```

Run the transformation jobs:

```bash
aws glue start-job-run --job-name <glue_json_transformation_job> | jq -r '.JobRunId'
aws glue start-job-run --job-name <glue_songs_transformation_job> | jq -r '.JobRunId'
```

## Apache Airflow Setup

### 1. Configure Airflow Connection

1. Access the Airflow UI using the URL from CloudFormation output `AirflowDNS`
2. Login with username `airflow` and password `airflow`

### 2. Deploy DAGs

Edit the DAG files:

1. In `dags/deftunes_songs_pipeline.py`:
   - Replace `<DATA-LAKE-BUCKET>` with value of `data_lake_bucket`
   - Replace `<SCRIPTS-BUCKET>` with value of `scripts_bucket`
   - Replace `<GLUE-EXECUTION-ROLE>` with value of `glue_role_arn`

2. In `dags/deftunes_api_pipeline.py`:
   - Replace placeholders as above
   - Also replace `<API-ENDPOINT>` with the value of `APIEndpoint`

Upload DAGs to the S3 bucket:

```bash
aws s3 cp dags/deftunes_songs_pipeline.py s3://<DagsBucket>/dags/
aws s3 cp dags/deftunes_api_pipeline.py s3://<DagsBucket>/dags/
```

### 3. Activate DAGs

In the Airflow UI, toggle the DAGs to activate them. The DAGs will execute according to the scheduled intervals.

## DBT Models Deployment

Configure and deploy dbt models:

1. Edit the BI views in `dbt_modeling/models/bi_views/`
2. Upload to the dbt S3 bucket:

```bash
aws s3 cp dbt_modeling/models/bi_views s3://<DBTBucket>/dbt_project/dbt_modeling/models/bi_views --recursive
aws s3 cp dbt_modeling/dbt_project.yml s3://<DBTBucket>/dbt_project/dbt_modeling/dbt_project.yml
```

## Apache Superset Setup

1. Access Superset using the URL from CloudFormation output
2. Login with credentials (username: `admin`, password: `admin`)
3. Configure Redshift connection:
   - Go to Settings > Data Connections
   - Click "+ Database"
   - Select "Amazon Redshift"
   - Use the SQLAlchemy URI string:
     ```
     postgresql+psycopg2://defaultuser:Defaultuserpwrd1234+@<REDSHIFT_ENDPOINT>:5439/dev
     ```
4. Create datasets from the BI views
5. Build visualizations and dashboards

## Troubleshooting

### Common Issues

1. **Airflow Service Unavailable**
   - Use the `scripts/restart_airflow.sh` script to restart the service:
     ```bash
     bash ./restart_airflow.sh
     ```

2. **Terraform Errors**
   - Check error output with:
     ```bash
     terraform apply -no-color 2> errors.txt
     ```

3. **Glue Job Failures**
   - Check CloudWatch logs for detailed error messages
   - Verify IAM permissions are correct

### Health Checks

- **Redshift Connection:**
  ```sql
  SELECT 1;
  ```

- **DAG Status Check:**
  Check Airflow UI for task status and logs 