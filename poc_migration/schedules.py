from dagster import schedule
from poc_migration.jobs import poc_migration_pipeline

# Define the schedule
@schedule(
    cron_schedule="0 0 * * *",  # This cron expression runs the pipeline at midnight every day
    job=poc_migration_pipeline,
    execution_timezone="UTC",
)
def daily_poc_migration_pipeline_schedule(_context):
    return {}
