from dagster import repository
from poc_migration.jobs import poc_migration_pipeline
from poc_migration.schedules import daily_poc_migration_pipeline_schedule

@repository
def lzs_poc_migration_repo():
    return [poc_migration_pipeline, daily_poc_migration_pipeline_schedule]
