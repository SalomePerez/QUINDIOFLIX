-- Provision script for QuindioFlix schema
-- Replace SYSTEM_PASSWORD and adjust host/SID if needed
-- Usage from shell: sqlplus system/SYSTEM_PASSWORD@//localhost:1521/XEPDB1 @QUINDIOFLIX/db/provision_quindio_user.sql

CREATE USER quindio_user IDENTIFIED BY "QuindioFlix2026!";

GRANT CREATE SESSION TO quindio_user;
GRANT CREATE TABLE, CREATE VIEW, CREATE MATERIALIZED VIEW, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TRIGGER TO quindio_user;
GRANT UNLIMITED TABLESPACE TO quindio_user;

-- Allow running DBMS_MVIEW.REFRESH if needed
GRANT EXECUTE ON DBMS_MVIEW TO quindio_user;

-- Optional: create a simple default tablespace if you prefer (uncomment and adjust)
-- CREATE TABLESPACE TBS_QUINDIOFLIX DATAFILE 'tbs_quindioflix.dbf' SIZE 50M AUTOEXTEND ON NEXT 50M;
-- ALTER USER quindio_user DEFAULT TABLESPACE TBS_QUINDIOFLIX;

PROMPT Provisioning complete. Please run your DDL/DML scripts as `quindio_user`.
EXIT
