-- =============================================================================
-- QUINDIOFLIX — Núcleo 2: Funciones (Sección 3.2.3)
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- =============================================================================
-- FN_CALCULAR_MONTO
-- Retorna el monto a cobrar en el próximo mes considerando plan y descuentos
-- Descuentos: >12 meses = 10%, >24 meses = 15%, referido activo = 5% adicional
-- =============================================================================
CREATE OR REPLACE FUNCTION FN_CALCULAR_MONTO (
    p_id_usuario IN USUARIOS.id_usuario%TYPE
) RETURN NUMBER AS
    v_precio_plan       PLANES.precio_mensual%TYPE;
    v_fecha_registro    USUARIOS.fecha_registro%TYPE;
    v_id_referidor      USUARIOS.id_referidor%TYPE;
    v_meses_antiguedad  NUMBER;
    v_descuento_pct     NUMBER := 0;
    v_descuento_ref     NUMBER := 0;
    v_monto_final       NUMBER;
    v_referidor_activo  NUMBER;
BEGIN
    -- Obtener datos del usuario
    SELECT pl.precio_mensual, u.fecha_registro, u.id_referidor
    INTO v_precio_plan, v_fecha_registro, v_id_referidor
    FROM USUARIOS u
    JOIN PLANES pl ON u.id_plan = pl.id_plan
    WHERE u.id_usuario = p_id_usuario;

    -- Calcular meses de antigüedad
    v_meses_antiguedad := MONTHS_BETWEEN(SYSDATE, v_fecha_registro);

    -- Aplicar descuento por antigüedad (no acumulables entre sí)
    IF v_meses_antiguedad > 24 THEN
        v_descuento_pct := 15;
    ELSIF v_meses_antiguedad > 12 THEN
        v_descuento_pct := 10;
    END IF;

    -- Verificar si tiene referidor activo para descuento adicional
    IF v_id_referidor IS NOT NULL THEN
        SELECT COUNT(*) INTO v_referidor_activo
        FROM USUARIOS
        WHERE id_usuario = v_id_referidor
          AND estado_cuenta = 'ACTIVO';

        IF v_referidor_activo > 0 THEN
            v_descuento_ref := 5; -- 5% adicional por referido activo
        END IF;
    END IF;

    -- Calcular monto final (descuentos no superan el 20%)
    v_monto_final := ROUND(
        v_precio_plan * (1 - LEAST(v_descuento_pct + v_descuento_ref, 20) / 100),
        2
    );

    RETURN v_monto_final;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, 'Usuario ID=' || p_id_usuario || ' no encontrado.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20099, 'Error en FN_CALCULAR_MONTO: ' || SQLERRM);
END FN_CALCULAR_MONTO;
/

-- Prueba de la función
BEGIN
    DBMS_OUTPUT.PUT_LINE('Monto usuario 1: $' || FN_CALCULAR_MONTO(1));
    DBMS_OUTPUT.PUT_LINE('Monto usuario 4: $' || FN_CALCULAR_MONTO(4));
    DBMS_OUTPUT.PUT_LINE('Monto usuario 9: $' || FN_CALCULAR_MONTO(9));
END;
/

-- =============================================================================
-- FN_CONTENIDO_RECOMENDADO
-- Retorna el título del contenido más afín al perfil basándose en géneros
-- que más ha reproducido (excluye lo que ya vio completamente)
-- =============================================================================
CREATE OR REPLACE FUNCTION FN_CONTENIDO_RECOMENDADO (
    p_id_perfil IN PERFILES.id_perfil%TYPE
) RETURN VARCHAR2 AS
    v_titulo_recomendado    CONTENIDO.titulo%TYPE;
    v_tipo_perfil           PERFILES.tipo%TYPE;
    v_id_contenido          CONTENIDO.id_contenido%TYPE;
BEGIN
    -- Obtener tipo de perfil para filtrar clasificación
    SELECT tipo INTO v_tipo_perfil
    FROM PERFILES WHERE id_perfil = p_id_perfil;

    -- Encontrar el contenido más afín basado en géneros más reproducidos
    -- que el perfil NO haya visto completamente aún
    SELECT titulo INTO v_titulo_recomendado
    FROM (
        SELECT
            c.id_contenido,
            c.titulo,
            SUM(genero_score.score) AS relevancia
        FROM CONTENIDO c
        JOIN CONTENIDO_GENEROS cg ON c.id_contenido = cg.id_contenido
        JOIN (
            -- Géneros más reproducidos por el perfil (con su peso)
            SELECT
                cg2.id_genero,
                COUNT(*) AS score
            FROM REPRODUCCIONES r
            JOIN CONTENIDO_GENEROS cg2 ON r.id_contenido = cg2.id_contenido
            WHERE r.id_perfil = p_id_perfil
            GROUP BY cg2.id_genero
        ) genero_score ON cg.id_genero = genero_score.id_genero
        -- Excluir contenido ya visto completamente (>=90%)
        WHERE NOT EXISTS (
            SELECT 1 FROM REPRODUCCIONES r2
            WHERE r2.id_perfil    = p_id_perfil
              AND r2.id_contenido = c.id_contenido
              AND r2.porcentaje_avance >= 90
        )
        -- Filtrar por clasificación según tipo de perfil
        AND (
            v_tipo_perfil = 'ADULTO'
            OR (v_tipo_perfil = 'INFANTIL' AND c.clasificacion_edad IN ('TP', '+7', '+13'))
        )
        GROUP BY c.id_contenido, c.titulo
        ORDER BY relevancia DESC
    )
    WHERE ROWNUM = 1;

    RETURN v_titulo_recomendado;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Si no hay recomendación basada en historial, retornar el más popular
        BEGIN
            SELECT titulo INTO v_titulo_recomendado
            FROM (
                SELECT c.titulo
                FROM CONTENIDO c
                WHERE NOT EXISTS (
                    SELECT 1 FROM REPRODUCCIONES r
                    WHERE r.id_perfil = p_id_perfil AND r.id_contenido = c.id_contenido
                )
                AND (
                    v_tipo_perfil = 'ADULTO'
                    OR (v_tipo_perfil = 'INFANTIL' AND c.clasificacion_edad IN ('TP', '+7', '+13'))
                )
                ORDER BY c.popularidad DESC
            )
            WHERE ROWNUM = 1;
            RETURN v_titulo_recomendado;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN 'Sin recomendaciones disponibles';
        END;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20099, 'Error en FN_CONTENIDO_RECOMENDADO: ' || SQLERRM);
END FN_CONTENIDO_RECOMENDADO;
/

-- Prueba de la función
BEGIN
    DBMS_OUTPUT.PUT_LINE('Recomendado para perfil 1: ' || FN_CONTENIDO_RECOMENDADO(1));
    DBMS_OUTPUT.PUT_LINE('Recomendado para perfil 3: ' || FN_CONTENIDO_RECOMENDADO(3));
    DBMS_OUTPUT.PUT_LINE('Recomendado para perfil 5: ' || FN_CONTENIDO_RECOMENDADO(5));
END;
/

