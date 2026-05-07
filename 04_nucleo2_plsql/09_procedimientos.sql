-- =============================================================================
-- QUINDIOFLIX — Núcleo 2: Procedimientos Almacenados (Sección 3.2.2)
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- =============================================================================
-- SP_REGISTRAR_USUARIO
-- Registra un nuevo usuario, crea perfil predeterminado y primer pago
-- Maneja excepciones: email duplicado y plan inválido
-- =============================================================================
CREATE OR REPLACE PROCEDURE SP_REGISTRAR_USUARIO (
    p_nombre          IN USUARIOS.nombre%TYPE,
    p_apellido        IN USUARIOS.apellido%TYPE,
    p_email           IN USUARIOS.email%TYPE,
    p_telefono        IN USUARIOS.telefono%TYPE,
    p_fecha_nac       IN USUARIOS.fecha_nacimiento%TYPE,
    p_ciudad          IN USUARIOS.ciudad%TYPE,
    p_id_plan         IN USUARIOS.id_plan%TYPE,
    p_id_referidor    IN USUARIOS.id_referidor%TYPE DEFAULT NULL,
    p_metodo_pago     IN PAGOS.metodo_pago%TYPE DEFAULT 'PSE',
    p_id_usuario_out  OUT USUARIOS.id_usuario%TYPE
) AS
    -- Excepciones personalizadas
    ex_email_duplicado  EXCEPTION;
    ex_plan_invalido    EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_email_duplicado, -20001);
    PRAGMA EXCEPTION_INIT(ex_plan_invalido,   -20002);

    v_count_email   NUMBER;
    v_count_plan    NUMBER;
    v_precio_plan   PLANES.precio_mensual%TYPE;
    v_max_perfiles  PLANES.max_perfiles%TYPE;
    v_id_usuario    USUARIOS.id_usuario%TYPE;
    v_descuento     NUMBER := 0;
BEGIN
    -- Validar que el email no exista
    SELECT COUNT(*) INTO v_count_email
    FROM USUARIOS WHERE LOWER(email) = LOWER(p_email);

    IF v_count_email > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El email ' || p_email || ' ya está registrado en el sistema.');
    END IF;

    -- Validar que el plan exista
    BEGIN
        SELECT precio_mensual, max_perfiles
        INTO v_precio_plan, v_max_perfiles
        FROM PLANES
        WHERE id_plan = p_id_plan;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'El plan con ID ' || p_id_plan || ' no existe.');
    END;

    -- Calcular descuento si tiene referidor activo
    IF p_id_referidor IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count_email
        FROM USUARIOS
        WHERE id_usuario = p_id_referidor
          AND estado_cuenta = 'ACTIVO';

        IF v_count_email > 0 THEN
            v_descuento := 10; -- 10% de descuento por referido
        END IF;
    END IF;

    -- Insertar usuario
    INSERT INTO USUARIOS (
        nombre, apellido, email, telefono, fecha_nacimiento,
        ciudad, estado_cuenta, id_plan, id_referidor, es_moderador,
        fecha_registro, fecha_ultimo_pago
    ) VALUES (
        p_nombre, p_apellido, p_email, p_telefono, p_fecha_nac,
        p_ciudad, 'ACTIVO', p_id_plan, p_id_referidor, 'N',
        SYSDATE, NULL
    )
    RETURNING id_usuario INTO v_id_usuario;

    p_id_usuario_out := v_id_usuario;

    -- Crear perfil predeterminado
    INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo, activo)
    VALUES (v_id_usuario, p_nombre, 'avatar_default.png', 'ADULTO', 'S');

    -- Registrar primer pago (pendiente)
    INSERT INTO PAGOS (
        id_usuario, fecha_pago, monto, metodo_pago,
        estado_pago, periodo_mes, periodo_anio, descuento_pct
    ) VALUES (
        v_id_usuario, SYSDATE,
        ROUND(v_precio_plan * (1 - v_descuento / 100), 2),
        p_metodo_pago, 'PENDIENTE',
        EXTRACT(MONTH FROM SYSDATE),
        EXTRACT(YEAR FROM SYSDATE),
        v_descuento
    );

    -- Si tiene referidor, también darle descuento al referidor en su próximo pago
    IF p_id_referidor IS NOT NULL AND v_count_email > 0 THEN
        DBMS_OUTPUT.PUT_LINE('INFO: Usuario referidor ID=' || p_id_referidor ||
                             ' recibirá descuento en su próximo pago.');
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Usuario registrado exitosamente. ID: ' || v_id_usuario);

EXCEPTION
    WHEN ex_email_duplicado THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
    WHEN ex_plan_invalido THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR inesperado: ' || SQLERRM);
        RAISE;
END SP_REGISTRAR_USUARIO;
/

-- =============================================================================
-- SP_CAMBIAR_PLAN
-- Cambia el plan de un usuario validando compatibilidad con perfiles activos
-- =============================================================================
CREATE OR REPLACE PROCEDURE SP_CAMBIAR_PLAN (
    p_id_usuario    IN USUARIOS.id_usuario%TYPE,
    p_id_plan_nuevo IN PLANES.id_plan%TYPE,
    p_motivo        IN VARCHAR2 DEFAULT NULL
) AS
    ex_plan_invalido        EXCEPTION;
    ex_perfiles_excedidos   EXCEPTION;
    ex_usuario_no_existe    EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_plan_invalido,      -20002);
    PRAGMA EXCEPTION_INIT(ex_perfiles_excedidos, -20003);
    PRAGMA EXCEPTION_INIT(ex_usuario_no_existe,  -20004);

    v_id_plan_actual    USUARIOS.id_plan%TYPE;
    v_max_perfiles_nuevo PLANES.max_perfiles%TYPE;
    v_perfiles_activos  NUMBER;
    v_nombre_plan_ant   PLANES.nombre%TYPE;
    v_nombre_plan_nuevo PLANES.nombre%TYPE;
BEGIN
    -- Verificar que el usuario existe
    BEGIN
        SELECT id_plan INTO v_id_plan_actual
        FROM USUARIOS WHERE id_usuario = p_id_usuario;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20004, 'Usuario con ID ' || p_id_usuario || ' no encontrado.');
    END;

    -- Verificar que el nuevo plan existe
    BEGIN
        SELECT max_perfiles, nombre INTO v_max_perfiles_nuevo, v_nombre_plan_nuevo
        FROM PLANES WHERE id_plan = p_id_plan_nuevo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Plan con ID ' || p_id_plan_nuevo || ' no existe.');
    END;

    -- Obtener nombre del plan actual
    SELECT nombre INTO v_nombre_plan_ant
    FROM PLANES WHERE id_plan = v_id_plan_actual;

    -- Contar perfiles activos del usuario
    SELECT COUNT(*) INTO v_perfiles_activos
    FROM PERFILES
    WHERE id_usuario = p_id_usuario AND activo = 'S';

    -- Validar que el nuevo plan soporta los perfiles activos
    IF v_perfiles_activos > v_max_perfiles_nuevo THEN
        RAISE_APPLICATION_ERROR(-20003,
            'No se puede cambiar al plan ' || v_nombre_plan_nuevo ||
            '. El usuario tiene ' || v_perfiles_activos ||
            ' perfiles activos y el nuevo plan permite máximo ' ||
            v_max_perfiles_nuevo || '. Elimine ' ||
            (v_perfiles_activos - v_max_perfiles_nuevo) || ' perfil(es) primero.');
    END IF;

    -- Registrar en historial
    INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
    VALUES (p_id_usuario, v_id_plan_actual, p_id_plan_nuevo, SYSDATE, p_motivo);

    -- Actualizar plan del usuario
    UPDATE USUARIOS
    SET id_plan = p_id_plan_nuevo
    WHERE id_usuario = p_id_usuario;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Plan cambiado exitosamente: ' || v_nombre_plan_ant ||
                         ' -> ' || v_nombre_plan_nuevo ||
                         ' para usuario ID=' || p_id_usuario);

EXCEPTION
    WHEN ex_plan_invalido THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
    WHEN ex_perfiles_excedidos THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
    WHEN ex_usuario_no_existe THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERROR inesperado: ' || SQLERRM);
        RAISE;
END SP_CAMBIAR_PLAN;
/

-- =============================================================================
-- SP_REPORTE_CONSUMO
-- Genera reporte detallado de reproducciones de un usuario en un rango de fechas
-- =============================================================================
CREATE OR REPLACE PROCEDURE SP_REPORTE_CONSUMO (
    p_id_usuario    IN USUARIOS.id_usuario%TYPE,
    p_fecha_inicio  IN DATE,
    p_fecha_fin     IN DATE
) AS
    CURSOR cur_perfiles IS
        SELECT id_perfil, nombre, tipo
        FROM PERFILES
        WHERE id_usuario = p_id_usuario AND activo = 'S';

    CURSOR cur_reproducciones (p_id_perfil NUMBER) IS
        SELECT
            cat.nombre                          AS categoria,
            c.titulo,
            c.tipo                              AS tipo_contenido,
            r.dispositivo,
            r.fecha_hora_inicio,
            r.fecha_hora_fin,
            r.porcentaje_avance,
            CASE WHEN r.fecha_hora_fin IS NOT NULL
                 THEN ROUND((CAST(r.fecha_hora_fin AS DATE) -
                             CAST(r.fecha_hora_inicio AS DATE)) * 1440, 0)
                 ELSE 0 END                     AS minutos_vistos
        FROM REPRODUCCIONES r
        JOIN CONTENIDO  c   ON r.id_contenido = c.id_contenido
        JOIN CATEGORIAS cat ON c.id_categoria = cat.id_categoria
        WHERE r.id_perfil = p_id_perfil
          AND r.fecha_hora_inicio >= CAST(p_fecha_inicio AS TIMESTAMP)
          AND r.fecha_hora_inicio <  CAST(p_fecha_fin + 1 AS TIMESTAMP)
        ORDER BY cat.nombre, r.fecha_hora_inicio;

    v_nombre_usuario    VARCHAR2(200);
    v_total_min_usuario NUMBER := 0;
    v_total_rep_usuario NUMBER := 0;
    v_total_min_perfil  NUMBER;
    v_total_rep_perfil  NUMBER;
    v_cat_actual        VARCHAR2(50);
    v_min_cat           NUMBER;
    v_rep_cat           NUMBER;
BEGIN
    -- Obtener nombre del usuario
    BEGIN
        SELECT nombre || ' ' || apellido INTO v_nombre_usuario
        FROM USUARIOS WHERE id_usuario = p_id_usuario;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20004, 'Usuario ID=' || p_id_usuario || ' no encontrado.');
    END;

    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE('REPORTE DE CONSUMO — ' || v_nombre_usuario);
    DBMS_OUTPUT.PUT_LINE('Período: ' || TO_CHAR(p_fecha_inicio,'DD/MM/YYYY') ||
                         ' al ' || TO_CHAR(p_fecha_fin,'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('=================================================================');

    FOR perf IN cur_perfiles LOOP
        v_total_min_perfil := 0;
        v_total_rep_perfil := 0;
        v_cat_actual       := NULL;
        v_min_cat          := 0;
        v_rep_cat          := 0;

        DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Perfil: ' || perf.nombre ||
                             ' (' || perf.tipo || ') ---');

        FOR rep IN cur_reproducciones(perf.id_perfil) LOOP
            -- Detectar cambio de categoría para mostrar subtotal
            IF v_cat_actual IS NULL THEN
                v_cat_actual := rep.categoria;
                DBMS_OUTPUT.PUT_LINE('  [' || rep.categoria || ']');
            ELSIF v_cat_actual <> rep.categoria THEN
                DBMS_OUTPUT.PUT_LINE('  Subtotal ' || v_cat_actual || ': ' ||
                                     v_rep_cat || ' reproducciones, ' ||
                                     v_min_cat || ' minutos');
                v_cat_actual := rep.categoria;
                v_min_cat    := 0;
                v_rep_cat    := 0;
                DBMS_OUTPUT.PUT_LINE('  [' || rep.categoria || ']');
            END IF;

            DBMS_OUTPUT.PUT_LINE('    ' ||
                RPAD(rep.titulo, 35) || ' | ' ||
                RPAD(rep.dispositivo, 12) || ' | ' ||
                rep.porcentaje_avance || '% | ' ||
                rep.minutos_vistos || ' min');

            v_min_cat          := v_min_cat + rep.minutos_vistos;
            v_rep_cat          := v_rep_cat + 1;
            v_total_min_perfil := v_total_min_perfil + rep.minutos_vistos;
            v_total_rep_perfil := v_total_rep_perfil + 1;
        END LOOP;

        -- Último subtotal de categoría
        IF v_cat_actual IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('  Subtotal ' || v_cat_actual || ': ' ||
                                 v_rep_cat || ' reproducciones, ' ||
                                 v_min_cat || ' minutos');
        END IF;

        DBMS_OUTPUT.PUT_LINE('  TOTAL PERFIL: ' || v_total_rep_perfil ||
                             ' reproducciones, ' || v_total_min_perfil || ' minutos (' ||
                             ROUND(v_total_min_perfil/60, 1) || ' horas)');

        v_total_min_usuario := v_total_min_usuario + v_total_min_perfil;
        v_total_rep_usuario := v_total_rep_usuario + v_total_rep_perfil;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '=================================================================');
    DBMS_OUTPUT.PUT_LINE('TOTAL CUENTA: ' || v_total_rep_usuario ||
                         ' reproducciones, ' || v_total_min_usuario || ' minutos (' ||
                         ROUND(v_total_min_usuario/60, 1) || ' horas)');
    DBMS_OUTPUT.PUT_LINE('=================================================================');
END SP_REPORTE_CONSUMO;
/

