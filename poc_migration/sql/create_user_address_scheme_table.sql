-- Create table if it doesn't already exist
CREATE TABLE IF NOT EXISTS user_address (
  address_id serial PRIMARY KEY,
  user_id int REFERENCES "user" (userid),
  address_baris1 varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL,
  address_baris2 varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL,
  address_baris3 varchar(100) COLLATE "pg_catalog"."default" DEFAULT NULL,
  address_negeri int DEFAULT NULL,
  address_daerah int DEFAULT NULL,
  address_postcode varchar(10) COLLATE "pg_catalog"."default" DEFAULT NULL,
  address_type int DEFAULT NULL,
  address_state int DEFAULT NULL,
  address_kariah int DEFAULT NULL,
  address_status int DEFAULT NULL,
  address_default boolean DEFAULT false,
  created_at timestamp DEFAULT NULL,
  updated_at timestamp DEFAULT NULL,
  deleted_at timestamp DEFAULT NULL
);

-- Create indexes if they don't already exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'address_daerah_idx') THEN
        CREATE INDEX address_daerah_idx ON user_address (address_daerah);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'address_state_idx') THEN
        CREATE INDEX address_state_idx ON user_address (address_state);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'address_status_idx') THEN
        CREATE INDEX address_status_idx ON user_address (address_status);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'address_type_idx') THEN
        CREATE INDEX address_type_idx ON user_address (address_type);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'address_negeri_idx') THEN
        CREATE INDEX address_negeri_idx ON user_address (address_negeri);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'address_kariah_idx') THEN
        CREATE INDEX address_kariah_idx ON user_address (address_kariah);
    END IF;
END $$;

-- Create foreign key constraints if they don't already exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_address_fk_2') THEN
        ALTER TABLE user_address
        ADD CONSTRAINT user_address_fk_2 FOREIGN KEY (address_daerah) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_address_fk_3') THEN
        ALTER TABLE user_address
        ADD CONSTRAINT user_address_fk_3 FOREIGN KEY (address_state) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_address_fk_4') THEN
        ALTER TABLE user_address
        ADD CONSTRAINT user_address_fk_4 FOREIGN KEY (address_status) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_address_fk_6') THEN
        ALTER TABLE user_address
        ADD CONSTRAINT user_address_fk_6 FOREIGN KEY (address_type) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_address_fk_7') THEN
        ALTER TABLE user_address
        ADD CONSTRAINT user_address_fk_7 FOREIGN KEY (address_negeri) REFERENCES lookups (lookup_id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'user_address_fk_8') THEN
        ALTER TABLE user_address
        ADD CONSTRAINT user_address_fk_8 FOREIGN KEY (address_kariah) REFERENCES lookups (lookup_id);
    END IF;
END $$;

COMMIT;
