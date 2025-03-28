# DeFtunes Data Pipeline

## Project Overview
A comprehensive data engineering solution for DeFtunes, a music streaming and digital purchase platform. This project implements a robust data pipeline that extracts purchase data from APIs and operational databases, processes it through several transformation layers, and delivers insights through an analytics layer.

The new requirements for this project are:

<img src="images/Capstone-diagram2.png" alt="Capstone_Diagram_Part2" width="1150">

1. The pipeline should allow for incremental ingestion of new data from the data sources.
2. The pipeline should run daily using data orchestration (you will use Airflow).
3. Data quality checks should be implemented to verify the quality of newly ingested and cleansed data.
4. Analytical views should be added on top of the star schema data model.
5. A company dashboard would be added to the architecture to visualize analytical views and insights (this is out of scope for this course).


1. The pipeline should allow for incremental ingestion of new data from the data sources.
2. The pipeline should run daily using data orchestration (you will use Airflow).
3. Data quality checks should be implemented to verify the quality of newly ingested and cleansed data.
4. Analytical views should be added on top of the star schema data model.
5. A company dashboard would be added to the architecture to visualize analytical views and insights (this is out of scope for this course).

1. The pipeline should allow for incremental ingestion of new data from the data sources.
2. The pipeline should run daily using data orchestration (you will use Airflow).
3. Data quality checks should be implemented to verify the quality of newly ingested and cleansed data.
4. Analytical views should be added on top of the star schema data model.
5. A company dashboard would be added to the architecture to visualize analytical views and insights (this is out of scope for this course).

## Features

- **Incremental Data Ingestion**: Extract data from multiple sources with incremental loading capabilities
- **Automated Orchestration**: Apache Airflow DAGs for scheduling and monitoring the pipeline
- **Data Quality Checks**: AWS Glue Data Quality implementation with DQDL rule sets
- **Data Transformation**: Processing with AWS Glue ETL jobs
- **Data Modeling**: Star schema implementation using dbt
- **Analytical Views**: Business intelligence views for reporting
- **Data Visualization**: Dashboard implementation with Apache Superset

## Technology Stack

- **Cloud Services**: AWS (S3, Glue, Redshift, IAM)
- **Infrastructure as Code**: Terraform
- **ETL**: AWS Glue
- **Data Warehousing**: Amazon Redshift
- **Data Catalog**: AWS Glue Data Catalog
- **Data Quality**: AWS Glue Data Quality
- **Orchestration**: Apache Airflow
- **Data Modeling**: dbt (data build tool)
- **Visualization**: Apache Superset

## Architecture

The data architecture implements a modern lakehouse pattern:

1. **Data Sources**:
   - DeFtunes API (users and sessions endpoints)
   - Operational RDS database (songs information)

2. **Extract Layer**:
   - AWS Glue jobs extract data to S3 landing zone
   - Parametrized for incremental extraction

3. **Transform Layer**:
   - Glue ETL jobs for data cleansing
   - Apache Iceberg tables for data storage
   - Data quality validation

4. **Serving Layer**:
   - Redshift Spectrum for querying data
   - Star schema modeling with dbt
   - Materialized views for analytics

5. **Presentation Layer**:
   - Apache Superset dashboards
   - Business intelligence views

## Repository Structure

```
├── dags/                  # Airflow DAG definitions
├── dbt_modeling/          # dbt models and configurations
│   ├── models/
│   │   ├── bi_views/      # Business intelligence views
│   │   ├── staging/       # Staging models
│   │   └── dbt_project.yml    # dbt project configuration
├── images/                # Architecture diagrams and screenshots
├── scripts/               # Utility scripts
├── terraform/             # Infrastructure as code
│   ├── modules/
│   │   ├── data_quality/  # Data quality configurations
│   │   ├── extract_job/   # Data extraction job definitions
│   │   ├── serving/       # Data serving layer config
│   │   ├── transform_job/ # Data transformation job definitions
```

## Setup and Deployment

### Prerequisites
- AWS Account
- Terraform installed
- Access to Airflow environment

### Deployment Steps

1. Configure API endpoints in terraform/modules/extract_job/glue.tf
2. Set ingestion dates in the ETL job configurations
3. Deploy infrastructure with Terraform:
   ```bash
   cd terraform
   terraform init
   terraform apply -target=module.extract_job
   terraform apply -target=module.transform_job
   terraform apply -target=module.serving
   terraform apply -target=module.data_quality
   ```
4. Deploy Airflow DAGs to the DAGs bucket
5. Configure dbt models and deploy to the dbt bucket
6. Set up Apache Superset connection to Redshift

## Orchestration with Airflow

The project includes two main Airflow DAGs:

1. **Songs Pipeline DAG**: Processes data from the RDS source
   - Extracts song data
   - Performs data quality checks
   - Builds dimensional models with dbt

2. **API Pipeline DAG**: Processes user and session data
   - Extracts data from API endpoints
   - Transforms and validates data quality
   - Integrates with the star schema model

## Data Quality
Data quality is enforced using AWS Glue Data Quality with rule sets that validate:
- Data completeness
- Field uniqueness
- Value constraints
- Data type compliance

## Business Intelligence Views
The project includes analytical views for:
- Sales per artist by year
- Sales per country by month and year

## Future Enhancements
- Real-time data processing
- Machine learning integration for recommendations
- Expanded data quality monitoring
- Additional data sources integration

## License
[MIT License](LICENSE) 
