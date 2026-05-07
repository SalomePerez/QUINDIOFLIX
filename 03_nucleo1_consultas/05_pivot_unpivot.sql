-- =============================================================================
-- QUINDIOFLIX — Núcleo 1: PIVOT y UNPIVOT (Sección 3.1.2)
-- =============================================================================

-- =============================================================================
-- PIVOT 1: Usuarios activos por ciudad y plan de suscripción
-- Filas = ciudades, Columnas = planes (BASICO, ESTANDAR, PREMIUM)
-- =============================================================================
SELECT *
FROM (
    SELECT
        u.ciudad,
        pl.nombre AS plan
    FROM USUARIOS u
    JOIN PLANES pl ON u.id_plan = pl.id_plan
    WHERE u.estado_cuenta = 'ACTIVO'
)
PIVOT (
    COUNT(*) AS usuarios
    FOR plan IN (
        'BASICO'    AS BASICO,
        'ESTANDAR'  AS ESTANDAR,
        'PREMIUM'   AS PREMIUM
    )
)
ORDER BY ciudad;

-- =============================================================================
-- PIVOT 2: Total de reproducciones por categoría y dispositivo
-- Filas = categorías, Columnas = dispositivos
-- =============================================================================
SELECT *
FROM (
    SELECT
        cat.nombre  AS categoria,
        r.dispositivo
    FROM REPRODUCCIONES r
    JOIN CONTENIDO  c   ON r.id_contenido = c.id_contenido
    JOIN CATEGORIAS cat ON c.id_categoria = cat.id_categoria
)
PIVOT (
    COUNT(*) AS reproducciones
    FOR dispositivo IN (
        'CELULAR'    AS CELULAR,
        'TABLET'     AS TABLET,
        'TV'         AS TV,
        'COMPUTADOR' AS COMPUTADOR
    )
)
ORDER BY categoria;

-- =============================================================================
-- UNPIVOT 1: Convertir el resultado del PIVOT de usuarios por ciudad/plan
-- de columnas a filas para análisis detallado
-- =============================================================================
SELECT ciudad, plan, cantidad_usuarios
FROM (
    SELECT *
    FROM (
        SELECT u.ciudad, pl.nombre AS plan
        FROM USUARIOS u
        JOIN PLANES pl ON u.id_plan = pl.id_plan
        WHERE u.estado_cuenta = 'ACTIVO'
    )
    PIVOT (
        COUNT(*) AS usuarios
        FOR plan IN (
            'BASICO'   AS BASICO,
            'ESTANDAR' AS ESTANDAR,
            'PREMIUM'  AS PREMIUM
        )
    )
)
UNPIVOT (
    cantidad_usuarios
    FOR plan IN (
        BASICO_USUARIOS    AS 'BASICO',
        ESTANDAR_USUARIOS  AS 'ESTANDAR',
        PREMIUM_USUARIOS   AS 'PREMIUM'
    )
)
ORDER BY ciudad, plan;

-- =============================================================================
-- UNPIVOT 2: Tabla de resumen de ingresos mensuales (columnas de meses)
-- convertida a filas individuales para análisis detallado
-- =============================================================================
-- Primero creamos la tabla pivoteada de ingresos por plan y mes
WITH ingresos_pivot AS (
    SELECT *
    FROM (
        SELECT
            pl.nombre AS plan,
            pg.periodo_mes,
            pg.monto
        FROM PAGOS pg
        JOIN USUARIOS u ON pg.id_usuario = u.id_usuario
        JOIN PLANES  pl ON u.id_plan     = pl.id_plan
        WHERE pg.estado_pago  = 'EXITOSO'
          AND pg.periodo_anio = 2026
    )
    PIVOT (
        SUM(monto) AS ingresos
        FOR periodo_mes IN (
            1 AS MES_01,
            2 AS MES_02,
            3 AS MES_03,
            4 AS MES_04,
            5 AS MES_05
        )
    )
)
SELECT plan, mes, ingresos_mes
FROM ingresos_pivot
UNPIVOT (
    ingresos_mes
    FOR mes IN (
        MES_01_INGRESOS AS 'Enero',
        MES_02_INGRESOS AS 'Febrero',
        MES_03_INGRESOS AS 'Marzo',
        MES_04_INGRESOS AS 'Abril',
        MES_05_INGRESOS AS 'Mayo'
    )
)
ORDER BY plan, mes;

