# DeFtunes Data Pipeline Tests

This directory contains automated tests for the DeFtunes data pipeline.

## Structure

- `dags/`: Tests for Airflow DAGs
- `utils/`: Tests for utility functions

## Running Tests

You can run the tests using pytest:

```bash
# Run all tests
pytest

# Run only DAG tests
pytest tests/dags

# Run only utility tests
pytest tests/utils

# Run with coverage
pytest --cov=./ --cov-report=html
```

## Adding New Tests

When adding new tests, follow these guidelines:

1. Test files should be named with a `test_` prefix
2. Test functions should also have a `test_` prefix
3. Use pytest fixtures for common setup/teardown
4. Group related tests in classes prefixed with `Test`
5. Add docstrings to all test functions explaining what they test

## Mocking External Services

When testing components that interact with external services (AWS, API endpoints), 
use the mocking utilities provided by pytest and the relevant service libraries.

Example:

```python
import boto3
import pytest
from moto import mock_s3

@mock_s3
def test_s3_operation():
    # Mock S3 bucket setup
    s3 = boto3.client('s3', region_name='us-east-1')
    s3.create_bucket(Bucket='test-bucket')
    
    # Your test logic here
    assert True
``` 