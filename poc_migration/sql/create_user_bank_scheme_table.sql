-- Create user_bank table if it doesn't already exist
CREATE TABLE IF NOT EXISTS user_bank (
  bank_id serial PRIMARY KEY,
  user_id int REFERENCES "user" (userid),
  bank_name varchar(255) DEFAULT NULL,
  bank_accnum varchar(50) DEFAULT NULL,
  bank_benname varchar(255) DEFAULT NULL,
  created_at timestamp DEFAULT NULL,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  deleted_at timestamp DEFAULT NULL
);

-- Conditionally create index on bank_name if it doesn't already exist
-- DO $$
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'bank_name_idx') THEN
--         CREATE INDEX bank_name_idx ON user_bank (bank_name);
--     END IF;
-- END $$;

-- COMMIT;
