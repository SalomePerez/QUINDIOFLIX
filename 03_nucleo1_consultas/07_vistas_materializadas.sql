-- =============================================================================
-- QUINDIOFLIX — Núcleo 1: Vistas Materializadas (Sección 3.1.4)
-- Ejecutar como DBA o con privilegios CREATE MATERIALIZED VIEW
-- =============================================================================

-- =============================================================================
-- VISTA MATERIALIZADA 1: Popularidad de contenido
-- Precalcula total de reproducciones y calificación promedio por contenido
-- Usada como base para el reporte "Contenido Más Popular"
-- =============================================================================
CREATE MATERIALIZED VIEW MV_POPULARIDAD_CONTENIDO
    TABLESPACE TBS_QUINDIOFLIX_MV
    BUILD IMMEDIATE
    REFRESH COMPLETE ON DEMAND
    ENABLE QUERY REWRITE
AS
SELECT
    c.id_contenido,
    c.titulo,
    c.tipo,
    cat.nombre                                  AS categoria,
    c.anio_lanzamiento,
    c.clasificacion_edad,
    c.es_original,
    COUNT(r.id_reproduccion)                    AS total_reproducciones,
    COUNT(CASE WHEN r.porcentaje_avance >= 90 THEN 1 END) AS reproducciones_completas,
    ROUND(AVG(r.porcentaje_avance), 2)          AS avance_promedio,
    COUNT(DISTINCT r.id_perfil)                 AS perfiles_unicos,
    COUNT(cal.id_calificacion)                  AS total_calificaciones,
    ROUND(AVG(cal.estrellas), 2)                AS calificacion_promedio,
    MIN(cal.estrellas)                          AS calificacion_minima,
    MAX(cal.estrellas)                          AS calificacion_maxima,
    COUNT(fav.id_perfil)                        AS veces_en_favoritos,
    SYSDATE                                     AS fecha_actualizacion
FROM CONTENIDO c
JOIN CATEGORIAS cat ON c.id_categoria = cat.id_categoria
LEFT JOIN REPRODUCCIONES r   ON c.id_contenido = r.id_contenido
LEFT JOIN CALIFICACIONES cal ON c.id_contenido = cal.id_contenido
LEFT JOIN FAVORITOS      fav ON c.id_contenido = fav.id_contenido
GROUP BY
    c.id_contenido, c.titulo, c.tipo, cat.nombre,
    c.anio_lanzamiento, c.clasificacion_edad, c.es_original;

COMMENT ON MATERIALIZED VIEW MV_POPULARIDAD_CONTENIDO IS
    'Vista materializada que precalcula métricas de popularidad por contenido. Refrescar manualmente con DBMS_MVIEW.REFRESH.';

-- Índice sobre la vista materializada para consultas frecuentes
CREATE INDEX IDX_MV_POP_TIPO ON MV_POPULARIDAD_CONTENIDO(tipo) TABLESPACE TBS_QUINDIOFLIX_IDX;
CREATE INDEX IDX_MV_POP_CAL  ON MV_POPULARIDAD_CONTENIDO(calificacion_promedio DESC) TABLESPACE TBS_QUINDIOFLIX_IDX;

-- Consulta de uso: Top 10 contenido más popular
SELECT titulo, categoria, tipo, total_reproducciones, calificacion_promedio, veces_en_favoritos
FROM MV_POPULARIDAD_CONTENIDO
ORDER BY total_reproducciones DESC, calificacion_promedio DESC
FETCH FIRST 10 ROWS ONLY;

-- =============================================================================
-- VISTA MATERIALIZADA 2: Ingresos mensuales por ciudad y plan
-- Usada como base para el reporte financiero mensual
-- =============================================================================
CREATE MATERIALIZED VIEW MV_INGRESOS_MENSUALES
    TABLESPACE TBS_QUINDIOFLIX_MV
    BUILD IMMEDIATE
    REFRESH COMPLETE ON DEMAND
    ENABLE QUERY REWRITE
AS
SELECT
    u.ciudad,
    pl.nombre                                   AS plan,
    pl.precio_mensual                           AS precio_base,
    pg.periodo_anio                             AS anio,
    pg.periodo_mes                              AS mes,
    TO_CHAR(TO_DATE(pg.periodo_mes, 'MM'), 'Month', 'NLS_DATE_LANGUAGE=SPANISH') AS nombre_mes,
    COUNT(pg.id_pago)                           AS total_pagos,
    COUNT(CASE WHEN pg.estado_pago = 'EXITOSO'     THEN 1 END) AS pagos_exitosos,
    COUNT(CASE WHEN pg.estado_pago = 'FALLIDO'     THEN 1 END) AS pagos_fallidos,
    COUNT(CASE WHEN pg.estado_pago = 'REEMBOLSADO' THEN 1 END) AS pagos_reembolsados,
    SUM(CASE WHEN pg.estado_pago = 'EXITOSO'       THEN pg.monto ELSE 0 END) AS ingresos_netos,
    SUM(CASE WHEN pg.estado_pago = 'REEMBOLSADO'   THEN pg.monto ELSE 0 END) AS reembolsos,
    SUM(pg.monto)                               AS ingresos_brutos,
    ROUND(AVG(CASE WHEN pg.estado_pago = 'EXITOSO' THEN pg.monto END), 2) AS ticket_promedio,
    SYSDATE                                     AS fecha_actualizacion
FROM PAGOS    pg
JOIN USUARIOS u  ON pg.id_usuario = u.id_usuario
JOIN PLANES   pl ON u.id_plan     = pl.id_plan
GROUP BY
    u.ciudad, pl.nombre, pl.precio_mensual,
    pg.periodo_anio, pg.periodo_mes;

COMMENT ON MATERIALIZED VIEW MV_INGRESOS_MENSUALES IS
    'Vista materializada que precalcula ingresos mensuales por ciudad y plan. Base para reportes financieros.';

-- Índice sobre la vista materializada
CREATE INDEX IDX_MV_ING_ANIO ON MV_INGRESOS_MENSUALES(anio, mes) TABLESPACE TBS_QUINDIOFLIX_IDX;
CREATE INDEX IDX_MV_ING_CIUDAD ON MV_INGRESOS_MENSUALES(ciudad) TABLESPACE TBS_QUINDIOFLIX_IDX;

-- Consulta de uso: Reporte financiero mensual 2026
SELECT ciudad, plan, mes, nombre_mes, ingresos_netos, pagos_exitosos, pagos_fallidos
FROM MV_INGRESOS_MENSUALES
WHERE anio = 2026
ORDER BY ciudad, mes, plan;

-- =============================================================================
-- Procedimiento para refrescar ambas vistas materializadas
-- =============================================================================
CREATE OR REPLACE PROCEDURE SP_REFRESCAR_VISTAS AS
BEGIN
    DBMS_MVIEW.REFRESH('MV_POPULARIDAD_CONTENIDO', 'C');
    DBMS_MVIEW.REFRESH('MV_INGRESOS_MENSUALES', 'C');
    DBMS_OUTPUT.PUT_LINE('Vistas materializadas refrescadas: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
END SP_REFRESCAR_VISTAS;
/

