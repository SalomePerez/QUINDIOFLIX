-- =====================================================
-- SCRIPT PARA CREAR USUARIO QUINDIOFLIX
-- Ejecutar como SYSTEM o SYS
-- =====================================================

-- Conectarse como SYSTEM antes de ejecutar este script
-- sqlplus system/tu_password@localhost:1521/XEPDB1

-- 1. Crear usuario QUINDIOFLIX
CREATE USER QUINDIOFLIX IDENTIFIED BY "QuindioFlix2026!"
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;

-- 2. Otorgar privilegios necesarios
GRANT CONNECT, RESOURCE TO QUINDIOFLIX;
GRANT CREATE SESSION TO QUINDIOFLIX;
GRANT CREATE TABLE TO QUINDIOFLIX;
GRANT CREATE VIEW TO QUINDIOFLIX;
GRANT CREATE SEQUENCE TO QUINDIOFLIX;
GRANT CREATE PROCEDURE TO QUINDIOFLIX;
GRANT CREATE TRIGGER TO QUINDIOFLIX;
GRANT CREATE MATERIALIZED VIEW TO QUINDIOFLIX;
GRANT CREATE SYNONYM TO QUINDIOFLIX;
GRANT CREATE TYPE TO QUINDIOFLIX;

-- 3. Privilegios adicionales para tablespaces (si vas a crearlos)
GRANT UNLIMITED TABLESPACE TO QUINDIOFLIX;

-- 4. Privilegios para ejecutar EXPLAIN PLAN
GRANT SELECT ON SYS.V_$SESSION TO QUINDIOFLIX;
GRANT SELECT ON SYS.V_$SQL_PLAN TO QUINDIOFLIX;
GRANT SELECT ON SYS.V_$SQL TO QUINDIOFLIX;

-- 5. Verificar que el usuario fue creado
SELECT username, account_status, default_tablespace, temporary_tablespace
FROM dba_users
WHERE username = 'QUINDIOFLIX';

COMMIT;

-- =====================================================
-- INSTRUCCIONES:
-- =====================================================
-- 1. Abre SQL*Plus o SQL Developer
-- 2. Conéctate como SYSTEM:
--    sqlplus system/tu_password@localhost:1521/XEPDB1
-- 3. Ejecuta este script:
--    @00_setup_usuario.sql
-- 4. Luego conéctate como QUINDIOFLIX:
--    CONNECT QUINDIOFLIX/QuindioFlix2026!@localhost:1521/XEPDB1
-- 5. Ejecuta los scripts DDL y DML del proyecto
-- =====================================================
