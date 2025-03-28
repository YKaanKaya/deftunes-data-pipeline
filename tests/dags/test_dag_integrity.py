"""Tests for DAG validation."""

import importlib
import os
import sys
from pathlib import Path
import pytest
from airflow.models import DagBag


# Add the project root directory to the Python path to allow importing the dags
sys.path.append(str(Path(__file__).parent.parent.parent))


def get_dag_files():
    """
    Get a list of all DAG filenames.
    
    Returns:
        List of DAG file paths
    """
    dag_folder = Path(__file__).parent.parent.parent / "dags"
    return [str(f) for f in dag_folder.glob("*.py") if f.is_file() and not f.name.startswith("test_")]


@pytest.mark.parametrize("dag_file", get_dag_files())
def test_dag_integrity(dag_file):
    """
    Test that DAGs load without errors.
    
    Args:
        dag_file: Path to a DAG file
    """
    dag_folder = os.path.dirname(dag_file)
    module_name = os.path.basename(dag_file).replace(".py", "")
    
    # Create a DagBag to load the dag file
    dagbag = DagBag(dag_folder, include_examples=False)
    
    # Check for errors
    assert len(dagbag.import_errors) == 0, f"DAG {module_name} has import errors: {dagbag.import_errors}"
    
    # Ensure the DAG was loaded
    assert module_name in dagbag.dag_ids, f"DAG {module_name} not found in {dagbag.dag_ids}"
    
    # Check that the DAG has tasks
    dag = dagbag.get_dag(module_name)
    assert len(dag.tasks) > 0, f"DAG {module_name} has no tasks"
    
    # Test DAG dependencies make sense
    for task in dag.tasks:
        # Every task should either have upstream or downstream dependencies, 
        # except for a single start/end task
        has_upstream = len(task.upstream_task_ids) > 0
        has_downstream = len(task.downstream_task_ids) > 0
        
        # Identify if this is a start or end task (no upstream or no downstream)
        is_start = not has_upstream and has_downstream
        is_end = has_upstream and not has_downstream
        
        # Tasks should either be start, end, or have both upstream and downstream tasks
        assert is_start or is_end or (has_upstream and has_downstream), \
            f"Task {task.task_id} in DAG {module_name} has invalid dependencies configuration" 