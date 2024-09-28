-- Create table if it doesn't already exist
CREATE TABLE IF NOT EXISTS user_details (
  userd_id serial PRIMARY KEY,
  user_id int REFERENCES "user" (userid),
  userd_fullname varchar(255) DEFAULT NULL,
  userd_kategori int DEFAULT NULL,
  userd_kp_type int DEFAULT NULL,
  userd_kp_value varchar(50) DEFAULT NULL,
  userd_phone varchar(50) DEFAULT NULL,
  userd_homenum varchar(50) DEFAULT NULL,
  userd_negerikelahiran int DEFAULT NULL,
  userd_daerahkelahiran int DEFAULT NULL,
  userd_dob date DEFAULT NULL,
  userd_jantina int DEFAULT NULL,
  userd_tarafperkahwinan int DEFAULT NULL,
  userd_keturunan int DEFAULT NULL,
  userd_agama int DEFAULT NULL,
  userd_warganegara int DEFAULT NULL,
  userd_ketuakeluarga int DEFAULT NULL,
  userd_pendapatan decimal(10, 2) DEFAULT NULL,
  userd_district int DEFAULT NULL,
  userd_kariah int DEFAULT NULL,
  userd_hasnaftype int DEFAULT NULL,
  userd_status int DEFAULT NULL,
  userd_jenis_pekerjaan int DEFAULT NULL,
  userd_tahapkesihatan int DEFAULT NULL,
  userd_oku boolean DEFAULT false,
  created_at timestamp DEFAULT NULL,
  updated_at timestamp DEFAULT NULL,
  deleted_at timestamp DEFAULT NULL
);

-- Create indexes if they don't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_kp_type_idx') THEN
        CREATE INDEX userd_kp_type_idx ON user_details (userd_kp_type);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_negerikelahiran_idx') THEN
        CREATE INDEX userd_negerikelahiran_idx ON user_details (userd_negerikelahiran);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_daerahkelahiran_idx') THEN
        CREATE INDEX userd_daerahkelahiran_idx ON user_details (userd_daerahkelahiran);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_jantina_idx') THEN
        CREATE INDEX userd_jantina_idx ON user_details (userd_jantina);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_tarafperkahwinan_idx') THEN
        CREATE INDEX userd_tarafperkahwinan_idx ON user_details (userd_tarafperkahwinan);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_keturunan_idx') THEN
        CREATE INDEX userd_keturunan_idx ON user_details (userd_keturunan);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_agama_idx') THEN
        CREATE INDEX userd_agama_idx ON user_details (userd_agama);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_status_idx') THEN
        CREATE INDEX userd_status_idx ON user_details (userd_status);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_district_idx') THEN
        CREATE INDEX userd_district_idx ON user_details (userd_district);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_kariah_idx') THEN
        CREATE INDEX userd_kariah_idx ON user_details (userd_kariah);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_hasnaftype_idx') THEN
        CREATE INDEX userd_hasnaftype_idx ON user_details (userd_hasnaftype);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_jenis_pekerjaan_idx') THEN
        CREATE INDEX userd_jenis_pekerjaan_idx ON user_details (userd_jenis_pekerjaan);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_warganegara_idx') THEN
        CREATE INDEX userd_warganegara_idx ON user_details (userd_warganegara);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_kategori_idx') THEN
        CREATE INDEX userd_kategori_idx ON user_details (userd_kategori);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'userd_tahapkesihatan_idx') THEN
        CREATE INDEX userd_tahapkesihatan_idx ON user_details (userd_tahapkesihatan);
    END IF;
END $$;

-- Create foreign key constraints if they don't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_1') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_1 FOREIGN KEY (userd_kp_type) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_10') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_10 FOREIGN KEY (userd_jenis_pekerjaan) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_11') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_11 FOREIGN KEY (userd_warganegara) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_12') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_12 FOREIGN KEY (userd_kategori) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_13') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_13 FOREIGN KEY (userd_tahapkesihatan) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_2') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_2 FOREIGN KEY (userd_negerikelahiran) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_3') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_3 FOREIGN KEY (userd_daerahkelahiran) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_4') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_4 FOREIGN KEY (userd_jantina) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_5') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_5 FOREIGN KEY (userd_tarafperkahwinan) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_6') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_6 FOREIGN KEY (userd_keturunan) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_7') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_7 FOREIGN KEY (userd_agama) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_details_fk_8') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT user_details_fk_8 FOREIGN KEY (userd_status) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'userd_district_fk') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT userd_district_fk FOREIGN KEY (userd_district) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'userd_hasnaftype_fk') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT userd_hasnaftype_fk FOREIGN KEY (userd_hasnaftype) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'userd_kariah_fk') THEN
        ALTER TABLE user_details
        ADD CONSTRAINT userd_kariah_fk FOREIGN KEY (userd_kariah) REFERENCES lookups (lookup_id);
    END IF;
END $$;
