-- Create user_pendidikan table if it doesn't exist
CREATE TABLE IF NOT EXISTS user_pendidikan (
  relation_id serial PRIMARY KEY,
  user_id int REFERENCES "user" (userid),
  education_type int DEFAULT NULL,
  education_remark varchar(255) DEFAULT NULL,
  education_institusi varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL,
  education_startYear int DEFAULT NULL,
  education_endYear int DEFAULT NULL,
  education_result varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  deleted_at timestamp DEFAULT NULL
);

-- Indexes
CREATE INDEX IF NOT EXISTS education_type_idx ON user_pendidikan (education_type);

-- Foreign Key Constraints
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'user_pendidikan_fk_2'
    ) THEN
        ALTER TABLE user_pendidikan
        ADD CONSTRAINT user_pendidikan_fk_2 FOREIGN KEY (education_type) REFERENCES lookups (lookup_id);
    END IF;
END $$;

