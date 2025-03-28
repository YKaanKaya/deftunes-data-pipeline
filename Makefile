.PHONY: setup terraform-init terraform-plan terraform-apply lint test

# Environment setup
setup:
	@echo "Setting up development environment..."
	pip install -r requirements.txt
	pre-commit install

# Terraform commands
terraform-init:
	@echo "Initializing Terraform..."
	cd terraform && terraform init

terraform-plan:
	@echo "Planning Terraform deployment..."
	cd terraform && terraform plan

terraform-apply:
	@echo "Applying Terraform changes..."
	cd terraform && terraform apply

terraform-extract:
	@echo "Applying extract job module..."
	cd terraform && terraform apply -target=module.extract_job

terraform-transform:
	@echo "Applying transform job module..."
	cd terraform && terraform apply -target=module.transform_job

terraform-serving:
	@echo "Applying serving module..."
	cd terraform && terraform apply -target=module.serving

terraform-quality:
	@echo "Applying data quality module..."
	cd terraform && terraform apply -target=module.data_quality

# Development tools
lint:
	@echo "Linting code..."
	flake8 .
	black --check .

format:
	@echo "Formatting code..."
	black .

test:
	@echo "Running tests..."
	pytest

# Deployment helpers
deploy-dags:
	@echo "Deploying DAGs to S3 bucket..."
	@read -p "Enter DAGs bucket name: " DAGS_BUCKET; \
	aws s3 cp dags/deftunes_songs_pipeline.py s3://$$DAGS_BUCKET/dags/ && \
	aws s3 cp dags/deftunes_api_pipeline.py s3://$$DAGS_BUCKET/dags/

deploy-dbt:
	@echo "Deploying DBT models to S3 bucket..."
	@read -p "Enter DBT bucket name: " DBT_BUCKET; \
	aws s3 cp dbt_modeling/models/bi_views s3://$$DBT_BUCKET/dbt_project/dbt_modeling/models/bi_views --recursive && \
	aws s3 cp dbt_modeling/dbt_project.yml s3://$$DBT_BUCKET/dbt_project/dbt_modeling/dbt_project.yml

# Help target
help:
	@echo "DeFtunes Data Pipeline - Available commands:"
	@echo "setup              - Set up development environment"
	@echo "terraform-init     - Initialize Terraform"
	@echo "terraform-plan     - Plan Terraform deployment"
	@echo "terraform-apply    - Apply all Terraform changes"
	@echo "terraform-extract  - Apply extract job module"
	@echo "terraform-transform - Apply transform job module"
	@echo "terraform-serving  - Apply serving module"
	@echo "terraform-quality  - Apply data quality module"
	@echo "lint               - Check code style"
	@echo "format             - Format code with Black"
	@echo "test               - Run tests"
	@echo "deploy-dags        - Deploy DAGs to S3"
	@echo "deploy-dbt         - Deploy DBT models to S3" 