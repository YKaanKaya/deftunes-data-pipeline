# DeFtunes Data Pipeline Integration Guide

This guide explains how to integrate the two parts of the DeFtunes Data Pipeline project: the initial setup from the Jupyter notebook (Part 1) and the enhanced implementation from the GitHub repository (Part 2).

## Prerequisites

Before beginning the integration, ensure you have:

1. Completed the Part 1 setup (Jupyter notebook)
2. Access to AWS resources
3. Airflow environment configured
4. dbt installed

## Integration Steps

### 1. Database Configuration

The initial setup in Part 1 created the Redshift database, schemas, and staging tables. The Phase 2 implementation builds on this foundation:

```sql
-- Ensure schemas exist
CREATE SCHEMA IF NOT EXISTS deftunes_landing;
CREATE SCHEMA IF NOT EXISTS deftunes_transform;
CREATE SCHEMA IF NOT EXISTS deftunes_serving;
```

### 2. Terraform Deployment

Deploy the infrastructure using Terraform:

```bash
cd terraform
terraform init
terraform apply -target=module.extract_job
terraform apply -target=module.transform_job
terraform apply -target=module.serving
terraform apply -target=module.data_quality
```

### 3. dbt Model Integration

The Part 1 implementation created basic models. The Part 2 implementation expands these:

1. Copy the `dbt_modeling` directory from Part 2 to your working directory
2. Update the profiles.yml file with your Redshift connection:

```yaml
deftunes:
  target: dev
  outputs:
    dev:
      type: redshift
      host: [your-redshift-cluster-endpoint]
      user: [your-user]
      password: [your-password]
      port: 5439
      dbname: dev
      schema: deftunes_serving
      threads: 4
```

3. Run the dbt models:

```bash
cd dbt_modeling
dbt run
```

### 4. Airflow DAG Deployment

1. Copy the DAG files from the `dags` directory to your Airflow DAGs folder
2. Update the configuration values in the DAGs:
   - `DATA_BUCKET_NAME`
   - `SCRIPTS_BUCKET_NAME`
   - `API_URL`
   - Any AWS resource names or ARNs

3. Enable the DAGs in the Airflow UI

### 5. Testing the Integration

1. Trigger a manual run of the DAGs in Airflow
2. Monitor the execution of each step
3. Verify data in Redshift using the following query:

```sql
-- Check fact table
SELECT COUNT(*) FROM deftunes_serving.fact_session;

-- Check BI views
SELECT * FROM deftunes_serving.sales_per_artist_vw LIMIT 10;
SELECT * FROM deftunes_serving.sales_per_country_vw LIMIT 10;
SELECT * FROM deftunes_serving.user_activity_vw LIMIT 10;
SELECT * FROM deftunes_serving.music_preference_vw LIMIT 10;
```

## Troubleshooting

### Common Issues

1. **Missing AWS permissions**: Ensure IAM roles have proper permissions for S3, Glue, and Redshift
2. **DAG failure**: Check Airflow logs for specific errors
3. **dbt model failures**: Run `dbt debug` to check connections

### Support

For further assistance, please refer to:
1. AWS Glue documentation
2. dbt documentation
3. Airflow documentation 