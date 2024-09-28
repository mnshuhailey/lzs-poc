from dagster import job
from poc_migration.resources import postgres_db_source_resource
from poc_migration.resources import lzs_poc_migration_resource
from poc_migration.ops.create_lookups_table import create_lookups_table
from poc_migration.ops.create_user_scheme_table import create_user_scheme_table
from poc_migration.ops.create_user_details_scheme_table import create_user_details_scheme_table
from poc_migration.ops.create_user_address_scheme_table import create_user_address_scheme_table
from poc_migration.ops.create_user_bank_scheme_table import create_user_bank_scheme_table
from poc_migration.ops.create_user_pendidikan_scheme_table import create_user_pendidikan_scheme_table
from poc_migration.ops.create_user_hubungan_scheme_table import create_user_hubungan_scheme_table
from poc_migration.ops.transform_asnaf_data import transform_asnaf_data
from poc_migration.ops.insert_transform_asnaf_data import insert_transform_asnaf_data

# Job definition
@job(resource_defs={"postgres_db_source": postgres_db_source_resource, "lzs_poc_migration": lzs_poc_migration_resource})
def poc_migration_pipeline():
    lookup_op = create_lookups_table()  # Step 1: Create lookups table
    user_op = create_user_scheme_table(lookup_op)  # Step 2: Create user table after lookups
    user_details_op = create_user_details_scheme_table(user_op)  # Step 3: Create user_details table after user table
    user_address_op = create_user_address_scheme_table(user_details_op)  # Step 4: Create user_address after user_details
    user_bank_op = create_user_bank_scheme_table(user_address_op)  # Step 5: Create user_bank after user_address
    user_pendidikan_op = create_user_pendidikan_scheme_table(user_bank_op)  # Step 6: Create user_pendidikan after user_bank
    user_hubungan_op = create_user_hubungan_scheme_table(user_pendidikan_op)  # Step 7: Create user_hubungan after user_pendidikan
    
    transformed_data = transform_asnaf_data(user_hubungan_op)  # Step 8: Fetch and transform the data from the source
    insert_transform_asnaf_data(transformed_data)  # Step 9: Insert transformed data into target tables
