import os
from dagster import job, op, In, Out, Nothing, Output
from psycopg2.extras import RealDictCursor

@op(ins={"after_create_user_hubungan": In(Nothing)}, required_resource_keys={"postgres_db_source"}, out=Out(list))
def transform_asnaf_data(context):
    postgres_conn = context.resources.postgres_db_source
    with postgres_conn.cursor(cursor_factory=RealDictCursor) as cursor_pg:
        try:
            # Assuming you're fetching data from PostgreSQL
            fetch_data_query = "SELECT * FROM vwlzs_asnaf"  # Adjust the query as needed
            context.log.info("Fetching data from PostgreSQL.")
            cursor_pg.execute(fetch_data_query)
            rows = cursor_pg.fetchall()

            if not rows:
                context.log.warning("No data fetched from PostgreSQL.")
                return Output(value=[], metadata={"status": "empty"})
            else:
                context.log.info(f"Fetched {len(rows)} rows from PostgreSQL.")
                return Output(value=rows, metadata={"status": "success"})

        except Exception as e:
            context.log.error(f"Error fetching data: {e}")
            raise

