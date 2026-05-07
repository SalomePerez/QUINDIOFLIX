-- =============================================================================
-- QUINDIOFLIX — Núcleo 4: Índices y Análisis de Rendimiento (Sección 3.4)
-- =============================================================================

-- =============================================================================
-- ÍNDICE 1: REPRODUCCIONES(id_perfil, fecha_hora_inicio)
-- JUSTIFICACIÓN: Las consultas de historial de un perfil siempre filtran por
-- id_perfil y ordenan/filtran por fecha. Un índice compuesto en este orden
-- permite que Oracle use Index Range Scan en lugar de Full Table Scan,
-- especialmente crítico dado que REPRODUCCIONES es la tabla de mayor volumen.
-- =============================================================================
CREATE INDEX IDX_REPROD_PERFIL_FECHA
    ON REPRODUCCIONES(id_perfil, fecha_hora_inicio)
    TABLESPACE TBS_QUINDIOFLIX_IDX
    LOCAL;  -- LOCAL porque la tabla está particionada por fecha_hora_inicio

COMMENT ON INDEX IDX_REPROD_PERFIL_FECHA IS
    'Índice compuesto para consultas de historial de reproducción por perfil y fecha. LOCAL por particionamiento.';

-- =============================================================================
-- ÍNDICE 2: USUARIOS(email)
-- JUSTIFICACIÓN: El email es el identificador de autenticación. Cada login
-- y cada validación de duplicados en SP_REGISTRAR_USUARIO hace un lookup
-- por email. Sin índice, Oracle haría Full Table Scan en cada autenticación.
-- Con índice único, el lookup es O(log n) — crítico para la escalabilidad.
-- =============================================================================
CREATE UNIQUE INDEX IDX_USUARIOS_EMAIL
    ON USUARIOS(email)
    TABLESPACE TBS_QUINDIOFLIX_IDX;

COMMENT ON INDEX IDX_USUARIOS_EMAIL IS
    'Índice único en email para autenticación y validación de duplicados. Garantiza unicidad a nivel de índice.';

-- =============================================================================
-- ÍNDICE 3: CONTENIDO(id_categoria, anio_lanzamiento)
-- JUSTIFICACIÓN: Las búsquedas del catálogo siempre filtran por categoría
-- (tipo de contenido) y frecuentemente por año de lanzamiento. El índice
-- compuesto permite satisfacer ambos filtros con un solo acceso al índice,
-- evitando acceder a la tabla para la mayoría de las consultas de catálogo.
-- =============================================================================
CREATE INDEX IDX_CONTENIDO_CAT_ANIO
    ON CONTENIDO(id_categoria, anio_lanzamiento)
    TABLESPACE TBS_QUINDIOFLIX_IDX;

COMMENT ON INDEX IDX_CONTENIDO_CAT_ANIO IS
    'Índice compuesto para búsquedas de catálogo por categoría y año de lanzamiento.';

-- =============================================================================
-- ÍNDICE 4 (adicional): PAGOS(id_usuario, periodo_anio, periodo_mes, estado_pago)
-- JUSTIFICACIÓN: Los reportes financieros y la verificación de mora consultan
-- pagos por usuario y período. Este índice cubre las consultas más frecuentes:
-- - Verificar si un usuario pagó en un mes específico (trigger de mora)
-- - Reportes de ingresos por período (vistas materializadas)
-- - SP_REPORTE_CONSUMO que verifica estado de pagos
-- Es un índice de cobertura (covering index) para estas consultas.
-- =============================================================================
CREATE INDEX IDX_PAGOS_USU_PERIODO
    ON PAGOS(id_usuario, periodo_anio, periodo_mes, estado_pago)
    TABLESPACE TBS_QUINDIOFLIX_IDX;

COMMENT ON INDEX IDX_PAGOS_USU_PERIODO IS
    'Índice de cobertura para consultas de pagos por usuario y período. Cubre verificación de mora y reportes financieros.';

-- =============================================================================
-- ANÁLISIS DE RENDIMIENTO: EXPLAIN PLAN antes y después del índice
-- =============================================================================

-- Consulta de prueba: Historial de reproducciones de un perfil en 2026
-- Esta consulta se beneficia del IDX_REPROD_PERFIL_FECHA

-- PASO 1: Ver plan SIN índice (simulado — en producción se droparía el índice)
-- Para demostración, usamos HINT para forzar Full Table Scan
EXPLAIN PLAN FOR
    SELECT /*+ FULL(r) */ r.id_reproduccion, r.fecha_hora_inicio, r.dispositivo,
           c.titulo, r.porcentaje_avance
    FROM REPRODUCCIONES r
    JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
    WHERE r.id_perfil = 1
      AND r.fecha_hora_inicio >= TIMESTAMP '2026-01-01 00:00:00'
    ORDER BY r.fecha_hora_inicio;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(FORMAT => 'ALL'));

-- PASO 2: Ver plan CON índice (Oracle lo usará automáticamente)
EXPLAIN PLAN FOR
    SELECT r.id_reproduccion, r.fecha_hora_inicio, r.dispositivo,
           c.titulo, r.porcentaje_avance
    FROM REPRODUCCIONES r
    JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
    WHERE r.id_perfil = 1
      AND r.fecha_hora_inicio >= TIMESTAMP '2026-01-01 00:00:00'
    ORDER BY r.fecha_hora_inicio;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(FORMAT => 'ALL'));

-- ANÁLISIS ESPERADO:
-- SIN índice: FULL TABLE SCAN en REPRODUCCIONES (costo alto, lee todas las filas)
-- CON índice: INDEX RANGE SCAN en IDX_REPROD_PERFIL_FECHA (costo bajo, acceso directo)
-- La diferencia en costo puede ser de 10x a 100x dependiendo del volumen de datos.

-- Consulta adicional para demostrar IDX_USUARIOS_EMAIL
EXPLAIN PLAN FOR
    SELECT id_usuario, nombre, apellido, estado_cuenta, id_plan
    FROM USUARIOS
    WHERE LOWER(email) = LOWER('ana.martinez@gmail.com');

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(FORMAT => 'ALL'));
-- Resultado esperado: INDEX UNIQUE SCAN en IDX_USUARIOS_EMAIL

-- Estadísticas de los índices creados
SELECT
    index_name,
    table_name,
    uniqueness,
    status,
    num_rows,
    leaf_blocks,
    clustering_factor
FROM USER_INDEXES
WHERE table_name IN ('REPRODUCCIONES', 'USUARIOS', 'CONTENIDO', 'PAGOS')
ORDER BY table_name, index_name;

