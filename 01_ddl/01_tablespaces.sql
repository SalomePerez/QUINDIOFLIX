-- =============================================================================
-- QUINDIOFLIX — Tablespaces y Datafiles
-- Núcleo 1 — Fragmentación de tablas (Sección 3.1.5)
-- Ejecutar como DBA (SYS o SYSTEM)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tablespace general del esquema QuindioFlix
-- -----------------------------------------------------------------------------
CREATE TABLESPACE TBS_QUINDIOFLIX
    DATAFILE 'quindioflix_main.dbf'
    SIZE 100M
    AUTOEXTEND ON NEXT 50M MAXSIZE 500M
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- -----------------------------------------------------------------------------
-- Tablespaces para fragmentación por rango de fechas de REPRODUCCIONES
--
-- JUSTIFICACIÓN:
-- La tabla REPRODUCCIONES es la de mayor volumen de la plataforma (crece con
-- cada sesión de cada perfil). Las consultas de analítica y reportes siempre
-- filtran por rango de fechas (mes, trimestre, año). Fragmentar por año permite:
--   1. Que las consultas de un período solo lean la partición correspondiente
--      (partition pruning), reduciendo I/O drásticamente.
--   2. Que el mantenimiento (backup, purga de datos históricos) se haga por
--      partición sin afectar los datos activos.
--   3. Distribuir la carga de escritura en datafiles físicamente separados.
-- -----------------------------------------------------------------------------

-- Tablespace para reproducciones del año 2024
CREATE TABLESPACE TBS_REPROD_2024
    DATAFILE 'quindioflix_reprod_2024.dbf'
    SIZE 200M
    AUTOEXTEND ON NEXT 100M MAXSIZE 2G
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace para reproducciones del año 2025
CREATE TABLESPACE TBS_REPROD_2025
    DATAFILE 'quindioflix_reprod_2025.dbf'
    SIZE 200M
    AUTOEXTEND ON NEXT 100M MAXSIZE 2G
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace para reproducciones del año 2026 (año en curso)
CREATE TABLESPACE TBS_REPROD_2026
    DATAFILE 'quindioflix_reprod_2026.dbf'
    SIZE 200M
    AUTOEXTEND ON NEXT 100M MAXSIZE 2G
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace para reproducciones futuras (2027 en adelante)
CREATE TABLESPACE TBS_REPROD_FUTURO
    DATAFILE 'quindioflix_reprod_futuro.dbf'
    SIZE 100M
    AUTOEXTEND ON NEXT 100M MAXSIZE 5G
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- -----------------------------------------------------------------------------
-- Tablespace para índices (separar índices de datos mejora rendimiento de I/O)
-- -----------------------------------------------------------------------------
CREATE TABLESPACE TBS_QUINDIOFLIX_IDX
    DATAFILE 'quindioflix_idx.dbf'
    SIZE 50M
    AUTOEXTEND ON NEXT 25M MAXSIZE 200M
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- -----------------------------------------------------------------------------
-- Tablespace para vistas materializadas
-- -----------------------------------------------------------------------------
CREATE TABLESPACE TBS_QUINDIOFLIX_MV
    DATAFILE 'quindioflix_mv.dbf'
    SIZE 50M
    AUTOEXTEND ON NEXT 25M MAXSIZE 200M
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

COMMIT;
