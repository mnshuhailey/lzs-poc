import os
import logging
from dagster import op, job
from dagster import Output, Out
from poc_migration.resources import lzs_poc_migration_resource

logging.basicConfig(filename='error_log.txt', 
                    level=logging.ERROR, 
                    format='%(asctime)s %(levelname)s %(message)s')

@op(required_resource_keys={"lzs_poc_migration"})
def insert_transform_asnaf_data(context, asnaf_data):
    lzs_conn = context.resources.lzs_poc_migration
    cursor = lzs_conn.cursor()
    
    for row in asnaf_data:
        try:
            # Define a helper function to check for None or empty string and return a default value
            def get_default(value, default):
                if value is None or value == '':
                    return default
                return value

            context.log.info(f"Inserting data for asnafid: {row['vwlzs_asnafid']}")

            user_insert_query = """
                INSERT INTO "user" (asnafid, userusername, useremail, userstatus, created_at, updated_at)
                VALUES (%s, %s, %s, 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
                RETURNING userid;
            """
            cursor.execute(user_insert_query, (
                row['vwlzs_asnafid'],
                row['vwlzs_nric'] or row['vwlzs_nricoldmilitarypolice'] or row['vwlzs_passportno'],
                row['vwlzs_email'],
            ))
            user_id = cursor.fetchone()[0]

            # Check for mosque name in lookups table
            lookup_query = """
                            SELECT lookup_id FROM lookups WHERE lookup_name = %s LIMIT 1;
                        """
            cursor.execute(lookup_query, (row.get('vwlzs_mosquename'),))
            lookup_result = cursor.fetchone()

            userd_kariah = lookup_result[0] if lookup_result else None

            # Check for district name in lookups table
            lookup_district_query = """
                            SELECT lookup_id FROM lookups WHERE lookup_name = %s LIMIT 1;
                        """
            cursor.execute(lookup_district_query, (row.get('vwlzs_districtname'),))
            lookup_district_result = cursor.fetchone()

            district = lookup_district_result[0] if lookup_district_result else None

            # Define mappings
            category_asnaf_mapping = {
                1: 133,
                2: 134,
                10: 135,
                4: 144,
                7: 148,
                6: 145,
                8: 147,
                5: 146
            }
            marital_status_mapping = {
                816600000: 9,
                816600001: 11,
                816600002: 14,
                816600003: 137,
                816600004: 8,
                816600005: 136,
                816600006: 10,
                816600007: 13,
                816600008: 132
            }
            identification_type_mapping = {
                1: 2,
                2: 5,
                3: 3,
                4: 6,
                816600000: 2,
                816600001: 3,
            }
            profession_mapping = {
                816600000: 66,  # Bekerja
                816600001: 67  # Tidak Berkerja
            }
            gender_mapping = {
                0: 24,  # Lelaki
                1: 25  # Perempuan
            }
            health_level_mapping = {
                1: 269,  # Sihat
                2: 272,  # Sakit Kronik
                4: 270  # Uzur
            }
            race_mapping = {
                816600000: 15,
                816600001: 16,
                816600002: 17,
                816600003: 18
            }
            religion_mapping = {
                816600000: 19,
                816600001: 22,
                816600002: 20,
                816600003: 21,
                816600004: 23
            }

            # Assign mapped values
            userd_kategori = category_asnaf_mapping.get(row.get('vwlzs_categoryasnaf'), None)
            marital_status = marital_status_mapping.get(row.get('vwlzs_maritalstatus'), None)
            userd_kp_type = identification_type_mapping.get(row.get('vwlzs_identificationtype'), None)
            profession = profession_mapping.get(row.get('vwlzs_profession'), None)
            gender = gender_mapping.get(row.get('vwlzs_gender'), None)
            health_level = health_level_mapping.get(row.get('vwlzs_healthlevel'), None)
            race = race_mapping.get(row.get('vwlzs_race'), None)
            religion = religion_mapping.get(row.get('vwlzs_religion'), None)

            ketua_keluarga = 1 if row.get('vwlzs_pakidname') else None

            # Log the values to be passed into the query
            context.log.info(f"Values to insert into user_details: "
                             f"user_id: {user_id}, "
                             f"userd_fullname: {row.get('vwlzs_name')}, "
                             f"userd_ketuakeluarga: {ketua_keluarga}, "
                             f"userd_dob: {row.get('vwlzs_dateofbirth')}, "
                             f"userd_kariah: {userd_kariah}, "
                             f"userd_negerikelahiran: 26, "
                             f"userd_kategori: {userd_kategori}, "
                             f"userd_tarafperkahwinan: {marital_status}, "
                             f"userd_kp_type: {userd_kp_type}, "
                             f"userd_kp_value: {row.get('vwlzs_nric') or row.get('vwlzs_nricoldmilitarypolice') or row.get('vwlzs_passportno')}, "
                             f"userd_jenis_pekerjaan: {profession}, "
                             f"userd_jantina: {gender}, "
                             f"userd_tahapkesihatan: {health_level}, "
                             f"userd_keturunan: {race}, "
                             f"userd_phone: {row.get('vwlzs_telephonenohome')}, "
                             f"userd_pendapatan: {row.get('vwlzs_totalincome')}, "
                             f"userd_agama: {religion}, "
                             f"userd_hasnaftype: {userd_kategori}")

            # Insert into user_details table
            user_details_insert_query = """
                            INSERT INTO user_details (user_id, userd_fullname, userd_ketuakeluarga, userd_dob, userd_kariah, userd_negerikelahiran, userd_kategori, 
                                                      userd_tarafperkahwinan, userd_kp_type, userd_kp_value, userd_jenis_pekerjaan,
                                                      userd_jantina, userd_tahapkesihatan, userd_keturunan, userd_phone,
                                                      userd_pendapatan, userd_agama, userd_hasnaftype, created_at, updated_at)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
                        """
            cursor.execute(user_details_insert_query, (
                user_id,
                row.get('vwlzs_name'),
                ketua_keluarga,
                row.get('vwlzs_dateofbirth'),
                userd_kariah,
                26,  # Assuming negeriKelahiran as 26, replace as necessary
                userd_kategori,
                marital_status,
                userd_kp_type,
                row.get('vwlzs_nric') or row.get('vwlzs_nricoldmilitarypolice') or row.get('vwlzs_passportno'),
                profession,
                gender,
                health_level,
                race,
                get_default(row.get('vwlzs_telephonenohome'), None),  # Default to empty string if None
                get_default(row.get('vwlzs_totalincome'), 0.0),  # Default to 0.0 if None
                religion,
                userd_kategori
            ))

            state_mapping = {
                816600000: 122,  # Kuala Lumpur
                816600001: '',
                816600002: '',
                816600003: 129,
                816600004: 130,
                816600005: 131,
                816600006: '',
                816600007: 124,
                816600008: 128,
                816600009: '',
                816600010: 125,
                816600011: 123,
                816600012: 127,
                816600015: 26,  # Selangor
                816600013: 126,
                816600014: ''
            }
            state = state_mapping.get(row.get('vwlzs_state'), None)

            # Log the values to be passed into the query
            context.log.info(f"Values to insert into user_address: "
                             f"user_id: {user_id}, "
                             f"address_kariah: {userd_kariah}, "
                             f"address_negeri: {state}, "
                             f"address_baris1: {row.get('vwlzs_street1')}, "
                             f"address_baris2: {row.get('vwlzs_street2')}, "
                             f"address_baris3: {row.get('vwlzs_street3')}, "
                             f"address_daerah: {district}, "
                             f"address_postcode: {row.get('vwlzs_postcode')}")

            # Insert into user_address table
            user_address_insert_query = """
                INSERT INTO user_address (user_id, address_kariah, address_negeri, address_baris1, address_baris2, address_baris3, 
                                          address_daerah, address_postcode, created_at, updated_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            """
            cursor.execute(user_address_insert_query, (
                user_id,
                userd_kariah,
                state,
                row.get('vwlzs_street1'),
                row.get('vwlzs_street2'),
                row.get('vwlzs_street3'),
                district,
                row.get('vwlzs_postcode')
            ))

            # Log the values to be passed into the query
            context.log.info(f"Values to insert into user_bank: "
                             f"user_id: {user_id}, "
                             f"bank_name: {row.get('vwlzs_banknamename')}, "
                             f"bank_benname: {row.get('vwlzs_name')}, "
                             f"bank_accnum: {row.get('vwlzs_bankaccountno')}")

            # Insert into user_bank table
            user_bank_insert_query = """
                INSERT INTO user_bank (user_id, bank_name, bank_benname, bank_accnum, created_at, updated_at)
                VALUES (%s, %s, %s, %s, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            """
            cursor.execute(user_bank_insert_query, (
                user_id,
                row.get('vwlzs_banknamename'),
                row.get('vwlzs_name'),
                row.get('vwlzs_bankaccountno')
            ))

            education_mapping = {
                816600001: 41,  # SRP/PMR
                816600002: 43,  # SPM
                816600003: 198,  # STPM
                816600004: 44,  # Diploma
                816600011: 195  # Certificate
            }
            education = education_mapping.get(row.get('vwlzs_education'), None)

            highest_education_mapping = {
                816600000: 197,  # Peringkat Rendah
                816600005: 46,  # Ijazah
                816600009: 45,  # Ijazah Sarjana
                816600010: 47,  # Doktor Falsafah
                816600006: 196,  # Tidak Bersekolah
                816600007: 196  # Lain-lain
            }
            highest_education = highest_education_mapping.get(row.get('vwlzs_highesteducation'), None)

            # Log the values to be passed into the query
            context.log.info(f"Values to insert into user_pendidikan: "
                             f"user_id: {user_id}, "
                             f"education_remark: {education}, "
                             f"education_type: {highest_education}")

            # Insert into user_pendidikan table
            user_pendidikan_insert_query = """
                INSERT INTO user_pendidikan (user_id, education_remark, education_type, created_at, updated_at)
                VALUES (%s, %s, %s, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
            """
            cursor.execute(user_pendidikan_insert_query, (
                user_id,
                education,
                highest_education
            ))

            lzs_conn.commit()
            context.log.info(f"Inserted data for userID {user_id} successfully.")

        except Exception as e:
            lzs_conn.rollback()
            context.log.error(f"Error inserting data for asnafid {row['vwlzs_asnafid']}: {e}")
            # Log error data to the log file
            logging.error(f"Error inserting data for asnafid {row['vwlzs_asnafid']}: {e}, Data: {row}")
            # Continue to the next row

    cursor.close()
