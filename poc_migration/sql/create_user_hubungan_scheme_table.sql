-- Create user_hubungan table if it doesn't exist
CREATE TABLE IF NOT EXISTS user_hubungan (
  relation_id serial PRIMARY KEY,
  upline_id int REFERENCES "user" (userid),
  downline_id int REFERENCES "user" (userid),
  relation_hubungan int NOT NULL,
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  deleted_at timestamp DEFAULT NULL
);

-- Indexes
CREATE INDEX IF NOT EXISTS upline_id_idx ON user_hubungan (upline_id);
CREATE INDEX IF NOT EXISTS relation_hubungan_idx ON user_hubungan (relation_hubungan);
CREATE INDEX IF NOT EXISTS downline_id_idx ON user_hubungan (downline_id);

-- Foreign Key Constraints
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'relation_hubungan_fk'
    ) THEN
        ALTER TABLE user_hubungan
        ADD CONSTRAINT relation_hubungan_fk FOREIGN KEY (relation_hubungan) REFERENCES lookups (lookup_id);
    END IF;
END $$;

