from dagster import resource
import psycopg2

# PostgreSQL resource configuration for the source database (postgres_db)
@resource
def postgres_db_source_resource(context):
    return psycopg2.connect(
        host="139.180.215.249",
        port=5432,
        user="mns",
        password="secret123",
        database="postgres_db",  # Source database
    )

# PostgreSQL resource configuration for the target database (lzs_poc_migration)
@resource
def lzs_poc_migration_resource(context):
    return psycopg2.connect(
        host="139.180.215.249",
        port=5432,
        user="mns",
        password="secret123",
        database="lzs_poc_migration",  # Target database
    )

