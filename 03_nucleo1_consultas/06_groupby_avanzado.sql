-- =============================================================================
-- QUINDIOFLIX — Núcleo 1: Funciones avanzadas del GROUP BY (Sección 3.1.3)
-- ROLLUP, CUBE, GROUPING(), GROUPING SETS
-- =============================================================================

-- =============================================================================
-- a) ROLLUP: Ingresos por ciudad y plan con subtotales y gran total
-- =============================================================================
SELECT
    CASE WHEN GROUPING(u.ciudad)    = 1 THEN '*** GRAN TOTAL ***'
         ELSE u.ciudad END                          AS ciudad,
    CASE WHEN GROUPING(pl.nombre)   = 1 THEN '-- SUBTOTAL CIUDAD --'
         ELSE pl.nombre END                         AS plan,
    COUNT(pg.id_pago)                               AS cantidad_pagos,
    SUM(pg.monto)                                   AS ingresos_totales,
    ROUND(AVG(pg.monto), 2)                         AS ingreso_promedio,
    GROUPING(u.ciudad)                              AS es_total_ciudad,
    GROUPING(pl.nombre)                             AS es_total_plan
FROM PAGOS    pg
JOIN USUARIOS u  ON pg.id_usuario = u.id_usuario
JOIN PLANES   pl ON u.id_plan     = pl.id_plan
WHERE pg.estado_pago = 'EXITOSO'
GROUP BY ROLLUP(u.ciudad, pl.nombre)
ORDER BY u.ciudad NULLS LAST, pl.nombre NULLS LAST;

-- =============================================================================
-- b) CUBE: Reproducciones por categoría y dispositivo con todas las combinaciones
-- =============================================================================
SELECT
    CASE WHEN GROUPING(cat.nombre)    = 1 THEN '=== TOTAL GENERAL ==='
         ELSE cat.nombre END                        AS categoria,
    CASE WHEN GROUPING(r.dispositivo) = 1 THEN '--- SUBTOTAL ---'
         ELSE r.dispositivo END                     AS dispositivo,
    COUNT(r.id_reproduccion)                        AS total_reproducciones,
    ROUND(AVG(r.porcentaje_avance), 2)              AS avance_promedio,
    COUNT(CASE WHEN r.porcentaje_avance >= 90 THEN 1 END) AS reproducciones_completas,
    GROUPING(cat.nombre)                            AS es_total_categoria,
    GROUPING(r.dispositivo)                         AS es_total_dispositivo
FROM REPRODUCCIONES r
JOIN CONTENIDO  c   ON r.id_contenido = c.id_contenido
JOIN CATEGORIAS cat ON c.id_categoria = cat.id_categoria
GROUP BY CUBE(cat.nombre, r.dispositivo)
ORDER BY cat.nombre NULLS LAST, r.dispositivo NULLS LAST;

-- =============================================================================
-- c) GROUPING(): Reemplazar NULLs con etiquetas legibles
-- Reporte de ingresos con etiquetas claras en lugar de NULLs
-- =============================================================================
SELECT
    NVL2(GROUPING_ID(u.ciudad, pl.nombre),
        CASE
            WHEN GROUPING(u.ciudad) = 1 AND GROUPING(pl.nombre) = 1 THEN 'GRAN TOTAL'
            WHEN GROUPING(u.ciudad) = 1 THEN 'TOTAL TODOS LOS PLANES'
            WHEN GROUPING(pl.nombre) = 1 THEN 'SUBTOTAL ' || u.ciudad
            ELSE u.ciudad
        END,
        u.ciudad
    )                                               AS ciudad_label,
    DECODE(GROUPING(pl.nombre), 1,
        DECODE(GROUPING(u.ciudad), 1, 'TODOS LOS PLANES', 'SUBTOTAL'),
        pl.nombre
    )                                               AS plan_label,
    SUM(pg.monto)                                   AS ingresos,
    COUNT(pg.id_pago)                               AS num_pagos,
    GROUPING_ID(u.ciudad, pl.nombre)                AS nivel_agrupacion
FROM PAGOS    pg
JOIN USUARIOS u  ON pg.id_usuario = u.id_usuario
JOIN PLANES   pl ON u.id_plan     = pl.id_plan
WHERE pg.estado_pago = 'EXITOSO'
GROUP BY ROLLUP(u.ciudad, pl.nombre)
ORDER BY GROUPING_ID(u.ciudad, pl.nombre), u.ciudad NULLS LAST, pl.nombre NULLS LAST;

-- =============================================================================
-- d) GROUPING SETS: Solo totales por categoría y por ciudad (sin cruce)
-- =============================================================================
SELECT
    CASE WHEN GROUPING(cat.nombre) = 0 THEN 'Por Categoría' ELSE NULL END AS tipo_agrupacion,
    CASE WHEN GROUPING(u.ciudad)   = 0 THEN 'Por Ciudad'    ELSE NULL END AS tipo_ciudad,
    cat.nombre                                      AS categoria,
    u.ciudad                                        AS ciudad,
    COUNT(r.id_reproduccion)                        AS total_reproducciones,
    COUNT(DISTINCT r.id_perfil)                     AS perfiles_unicos,
    ROUND(AVG(r.porcentaje_avance), 2)              AS avance_promedio
FROM REPRODUCCIONES r
JOIN PERFILES   p   ON r.id_perfil    = p.id_perfil
JOIN USUARIOS   u   ON p.id_usuario   = u.id_usuario
JOIN CONTENIDO  c   ON r.id_contenido = c.id_contenido
JOIN CATEGORIAS cat ON c.id_categoria = cat.id_categoria
GROUP BY GROUPING SETS (
    (cat.nombre),   -- Total por categoría
    (u.ciudad)      -- Total por ciudad
)
ORDER BY tipo_agrupacion NULLS LAST, cat.nombre NULLS LAST, u.ciudad NULLS LAST;

