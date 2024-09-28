CREATE TABLE IF NOT EXISTS "user" (
  userid serial PRIMARY KEY,
  asnafid varchar(255) DEFAULT NULL,
  userusername varchar(255) COLLATE "pg_catalog"."default",
  useremail varchar(255) COLLATE "pg_catalog"."default",
  userpassword varchar(255) COLLATE "pg_catalog"."default",
  userstatus varchar(255) COLLATE "pg_catalog"."default",
  usertoken varchar(255) COLLATE "pg_catalog"."default",
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  deleted_at timestamp DEFAULT NULL
);
