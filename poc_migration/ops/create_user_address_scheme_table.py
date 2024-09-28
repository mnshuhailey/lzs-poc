import os
from dagster import job, op, In, Out, Nothing
from poc_migration.resources import lzs_poc_migration_resource

def read_sql_file(file_path):
    with open(file_path, 'r') as file:
        return file.read()

@op(ins={"after_create_user_details": In(Nothing)}, required_resource_keys={"lzs_poc_migration"})
def create_user_address_scheme_table(context):
    base_dir = os.path.dirname(os.path.realpath(__file__))
    sql_file_path = os.path.join(base_dir, '../sql/create_user_address_scheme_table.sql')
    context.log.info(f"SQL file path: {sql_file_path}")

    # Check if the file exists before attempting to read it
    if not os.path.exists(sql_file_path):
        context.log.error(f"SQL file not found at {sql_file_path}")
        raise FileNotFoundError(f"SQL file not found at {sql_file_path}")

    # Load SQL query from file
    create_table_query = read_sql_file(sql_file_path)

    postgres_conn = context.resources.lzs_poc_migration
    cursor = postgres_conn.cursor()
    
    try:
        context.log.info("Creating table if not exists.")
        cursor.execute(create_table_query)
        postgres_conn.commit()
        context.log.info("Table created or already exists.")
    except Exception as e:
        context.log.error(f"Error creating table: {e}")
        raise
    finally:
        cursor.close()
        postgres_conn.close()
