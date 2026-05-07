-- =============================================================================
-- QUINDIOFLIX — Núcleo 2: Cursores (Sección 3.2.1)
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- =============================================================================
-- CURSOR 1: Usuarios con suscripción vencida (mora > 30 días)
-- Genera reporte con nombre, email, plan, días de mora y monto adeudado
-- =============================================================================
DECLARE
    -- Cursor explícito con parámetro de días de mora
    CURSOR cur_usuarios_morosos IS
        SELECT
            u.id_usuario,
            u.nombre || ' ' || u.apellido   AS nombre_completo,
            u.email,
            u.ciudad,
            pl.nombre                       AS plan,
            pl.precio_mensual,
            u.fecha_ultimo_pago,
            TRUNC(SYSDATE - u.fecha_ultimo_pago) AS dias_mora,
            CEIL((SYSDATE - u.fecha_ultimo_pago) / 30) AS meses_adeudados
        FROM USUARIOS u
        JOIN PLANES pl ON u.id_plan = pl.id_plan
        WHERE u.estado_cuenta IN ('ACTIVO', 'INACTIVO')
          AND (u.fecha_ultimo_pago IS NULL
               OR SYSDATE - u.fecha_ultimo_pago > 30)
        ORDER BY dias_mora DESC;

    v_total_usuarios    NUMBER := 0;
    v_total_deuda       NUMBER := 0;
    v_monto_adeudado    NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE('REPORTE DE USUARIOS CON SUSCRIPCIÓN VENCIDA');
    DBMS_OUTPUT.PUT_LINE('Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE(RPAD('USUARIO', 30) || RPAD('EMAIL', 35) ||
                         RPAD('PLAN', 10) || RPAD('DÍAS MORA', 12) ||
                         RPAD('MESES', 8) || 'DEUDA');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 110, '-'));

    FOR rec IN cur_usuarios_morosos LOOP
        -- Calcular monto adeudado (meses sin pagar * precio del plan)
        v_monto_adeudado := rec.meses_adeudados * rec.precio_mensual;
        v_total_usuarios := v_total_usuarios + 1;
        v_total_deuda    := v_total_deuda + v_monto_adeudado;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(rec.nombre_completo, 30) ||
            RPAD(rec.email, 35) ||
            RPAD(rec.plan, 10) ||
            RPAD(rec.dias_mora, 12) ||
            RPAD(rec.meses_adeudados, 8) ||
            TO_CHAR(v_monto_adeudado, '$999,999,990')
        );

        -- Desactivar cuenta si lleva más de 30 días en mora
        IF rec.dias_mora > 30 AND rec.dias_mora <= 60 THEN
            UPDATE USUARIOS
            SET estado_cuenta = 'INACTIVO'
            WHERE id_usuario = rec.id_usuario
              AND estado_cuenta = 'ACTIVO';
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 110, '-'));
    DBMS_OUTPUT.PUT_LINE('Total usuarios en mora: ' || v_total_usuarios);
    DBMS_OUTPUT.PUT_LINE('Deuda total estimada:   ' || TO_CHAR(v_total_deuda, '$999,999,990'));
    DBMS_OUTPUT.PUT_LINE('=================================================================');

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
END;
/

-- =============================================================================
-- CURSOR 2: Actualizar popularidad de contenido
-- Recorre el catálogo, calcula reproducciones completas (>=90%) y actualiza
-- el campo popularidad en la tabla CONTENIDO
-- =============================================================================
DECLARE
    CURSOR cur_popularidad IS
        SELECT
            c.id_contenido,
            c.titulo,
            COUNT(r.id_reproduccion)                            AS total_reproducciones,
            COUNT(CASE WHEN r.porcentaje_avance >= 90 THEN 1 END) AS reproducciones_completas,
            ROUND(AVG(r.porcentaje_avance), 2)                  AS avance_promedio
        FROM CONTENIDO c
        LEFT JOIN REPRODUCCIONES r ON c.id_contenido = r.id_contenido
        GROUP BY c.id_contenido, c.titulo
        ORDER BY reproducciones_completas DESC;

    v_contenidos_actualizados NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE('ACTUALIZACIÓN DE POPULARIDAD DE CONTENIDO');
    DBMS_OUTPUT.PUT_LINE('Fecha: ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('=================================================================');

    FOR rec IN cur_popularidad LOOP
        -- Actualizar campo popularidad con el número de reproducciones completas
        UPDATE CONTENIDO
        SET popularidad = rec.reproducciones_completas
        WHERE id_contenido = rec.id_contenido;

        v_contenidos_actualizados := v_contenidos_actualizados + 1;

        -- Mostrar los top 10
        IF v_contenidos_actualizados <= 10 THEN
            DBMS_OUTPUT.PUT_LINE(
                RPAD(rec.titulo, 40) ||
                ' | Total: '    || RPAD(rec.total_reproducciones, 6) ||
                ' | Completas: ' || RPAD(rec.reproducciones_completas, 6) ||
                ' | Avance prom: ' || rec.avance_promedio || '%'
            );
        END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE('Contenidos actualizados: ' || v_contenidos_actualizados);
    DBMS_OUTPUT.PUT_LINE('=================================================================');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR al actualizar popularidad: ' || SQLERRM);
        RAISE;
END;
/

