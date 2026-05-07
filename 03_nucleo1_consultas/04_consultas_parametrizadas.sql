-- =============================================================================
-- QUINDIOFLIX — Núcleo 1: Consultas Parametrizadas (Sección 3.1.1)
-- Usar en SQL*Plus o SQL Developer con variables de sustitución
-- =============================================================================

-- =============================================================================
-- CONSULTA 1: Top 10 de contenido más reproducido en una ciudad
-- Parámetro: &ciudad (ej: 'Bogotá', 'Medellín', 'Armenia')
-- =============================================================================
DEFINE ciudad = '&ciudad'

SELECT *
FROM (
    SELECT
        c.titulo,
        cat.nombre                          AS categoria,
        COUNT(r.id_reproduccion)            AS total_reproducciones,
        ROUND(AVG(r.porcentaje_avance), 2)  AS promedio_avance,
        ROUND(AVG(
            CASE WHEN r.fecha_hora_fin IS NOT NULL
                 THEN (CAST(r.fecha_hora_fin AS DATE) - CAST(r.fecha_hora_inicio AS DATE)) * 1440
                 ELSE NULL END
        ), 2)                               AS minutos_promedio_sesion
    FROM REPRODUCCIONES r
    JOIN PERFILES       p   ON r.id_perfil    = p.id_perfil
    JOIN USUARIOS       u   ON p.id_usuario   = u.id_usuario
    JOIN CONTENIDO      c   ON r.id_contenido = c.id_contenido
    JOIN CATEGORIAS     cat ON c.id_categoria = cat.id_categoria
    WHERE UPPER(u.ciudad) = UPPER('&&ciudad')
    GROUP BY c.titulo, cat.nombre
    ORDER BY total_reproducciones DESC
)
WHERE ROWNUM <= 10;

-- =============================================================================
-- CONSULTA 2: Ingresos por plan de suscripción en un mes y año específico
-- Parámetros: &mes (1-12), &anio (ej: 2026)
-- =============================================================================
DEFINE mes  = &mes
DEFINE anio = &anio

SELECT
    pl.nombre                           AS plan,
    pl.precio_mensual                   AS precio_base,
    COUNT(pg.id_pago)                   AS cantidad_pagos,
    SUM(pg.monto)                       AS ingresos_totales,
    ROUND(AVG(pg.monto), 2)             AS ingreso_promedio,
    SUM(CASE WHEN pg.estado_pago = 'EXITOSO'    THEN pg.monto ELSE 0 END) AS ingresos_exitosos,
    SUM(CASE WHEN pg.estado_pago = 'FALLIDO'    THEN pg.monto ELSE 0 END) AS ingresos_fallidos,
    SUM(CASE WHEN pg.estado_pago = 'REEMBOLSADO' THEN pg.monto ELSE 0 END) AS ingresos_reembolsados,
    COUNT(CASE WHEN pg.estado_pago = 'EXITOSO'  THEN 1 END)               AS pagos_exitosos,
    COUNT(CASE WHEN pg.estado_pago = 'FALLIDO'  THEN 1 END)               AS pagos_fallidos
FROM PAGOS pg
JOIN USUARIOS u ON pg.id_usuario = u.id_usuario
JOIN PLANES   pl ON u.id_plan    = pl.id_plan
WHERE pg.periodo_mes  = &&mes
  AND pg.periodo_anio = &&anio
GROUP BY pl.nombre, pl.precio_mensual
ORDER BY ingresos_totales DESC;

-- =============================================================================
-- CONSULTA 3: Calificación promedio por categoría para un género específico
-- Parámetro: &genero (ej: 'Acción', 'Drama', 'Terror')
-- =============================================================================
DEFINE genero = '&genero'

SELECT
    cat.nombre                          AS categoria,
    g.nombre                            AS genero,
    COUNT(cal.id_calificacion)          AS total_calificaciones,
    ROUND(AVG(cal.estrellas), 2)        AS calificacion_promedio,
    MIN(cal.estrellas)                  AS calificacion_minima,
    MAX(cal.estrellas)                  AS calificacion_maxima,
    COUNT(CASE WHEN cal.estrellas = 5 THEN 1 END) AS cinco_estrellas,
    COUNT(CASE WHEN cal.estrellas = 4 THEN 1 END) AS cuatro_estrellas,
    COUNT(CASE WHEN cal.estrellas = 3 THEN 1 END) AS tres_estrellas,
    COUNT(CASE WHEN cal.estrellas <= 2 THEN 1 END) AS dos_o_menos_estrellas
FROM CALIFICACIONES  cal
JOIN CONTENIDO       c   ON cal.id_contenido = c.id_contenido
JOIN CATEGORIAS      cat ON c.id_categoria   = cat.id_categoria
JOIN CONTENIDO_GENEROS cg ON c.id_contenido  = cg.id_contenido
JOIN GENEROS         g   ON cg.id_genero     = g.id_genero
WHERE UPPER(g.nombre) = UPPER('&&genero')
GROUP BY cat.nombre, g.nombre
ORDER BY calificacion_promedio DESC;

