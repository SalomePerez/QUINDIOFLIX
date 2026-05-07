-- =============================================================================
-- QUINDIOFLIX — Núcleo 3: Transacciones y Concurrencia (Sección 3.3)
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- =============================================================================
-- TRANSACCIÓN 1: Registro completo de usuario
-- Crear usuario + perfil + primer pago. Si falla cualquier paso, deshacer todo.
-- Estados: ACTIVA → PARCIALMENTE CONFIRMADA → CONFIRMADA | FALLIDA → ABORTADA
-- =============================================================================
DECLARE
    v_id_usuario    NUMBER;
    v_id_perfil     NUMBER;
    v_id_pago       NUMBER;
    v_precio_plan   NUMBER;
BEGIN
    -- ESTADO: ACTIVA
    DBMS_OUTPUT.PUT_LINE('=== TRANSACCIÓN 1: REGISTRO COMPLETO DE USUARIO ===');
    DBMS_OUTPUT.PUT_LINE('Estado: ACTIVA');

    -- Paso 1: Obtener precio del plan
    SELECT precio_mensual INTO v_precio_plan
    FROM PLANES WHERE id_plan = 2; -- Plan ESTANDAR

    -- Paso 2: Insertar usuario
    INSERT INTO USUARIOS (
        nombre, apellido, email, telefono, fecha_nacimiento,
        ciudad, estado_cuenta, id_plan, es_moderador
    ) VALUES (
        'Prueba', 'Transaccion', 'prueba.tx1@test.com', '3001234567',
        TO_DATE('01/01/1990','DD/MM/YYYY'),
        'Armenia', 'ACTIVO', 2, 'N'
    ) RETURNING id_usuario INTO v_id_usuario;

    DBMS_OUTPUT.PUT_LINE('Paso 1 OK: Usuario creado ID=' || v_id_usuario);

    -- Paso 3: Insertar perfil predeterminado
    INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo)
    VALUES (v_id_usuario, 'Prueba', 'avatar_default.png', 'ADULTO')
    RETURNING id_perfil INTO v_id_perfil;

    DBMS_OUTPUT.PUT_LINE('Paso 2 OK: Perfil creado ID=' || v_id_perfil);

    -- Paso 4: Registrar primer pago
    INSERT INTO PAGOS (
        id_usuario, fecha_pago, monto, metodo_pago,
        estado_pago, periodo_mes, periodo_anio
    ) VALUES (
        v_id_usuario, SYSDATE, v_precio_plan, 'PSE',
        'PENDIENTE', EXTRACT(MONTH FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE)
    ) RETURNING id_pago INTO v_id_pago;

    DBMS_OUTPUT.PUT_LINE('Paso 3 OK: Pago registrado ID=' || v_id_pago);

    -- ESTADO: PARCIALMENTE CONFIRMADA (todos los pasos OK)
    DBMS_OUTPUT.PUT_LINE('Estado: PARCIALMENTE CONFIRMADA');

    -- COMMIT — ESTADO: CONFIRMADA
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Estado: CONFIRMADA');
    DBMS_OUTPUT.PUT_LINE('Transacción 1 completada exitosamente.');

EXCEPTION
    WHEN OTHERS THEN
        -- ESTADO: FALLIDA → ABORTADA
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Estado: FALLIDA → ABORTADA');
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Todos los cambios fueron revertidos.');
        RAISE;
END;
/

-- Limpiar datos de prueba de la transacción 1
DELETE FROM PAGOS    WHERE id_usuario IN (SELECT id_usuario FROM USUARIOS WHERE email = 'prueba.tx1@test.com');
DELETE FROM PERFILES WHERE id_usuario IN (SELECT id_usuario FROM USUARIOS WHERE email = 'prueba.tx1@test.com');
DELETE FROM USUARIOS WHERE email = 'prueba.tx1@test.com';
COMMIT;

-- =============================================================================
-- TRANSACCIÓN 2: Renovación mensual masiva con SAVEPOINT
-- Para cada usuario activo: verificar vencimiento, calcular monto, registrar pago
-- Si falla un usuario, no se pierden los anteriores (SAVEPOINT por usuario)
-- =============================================================================
DECLARE
    CURSOR cur_usuarios_renovar IS
        SELECT u.id_usuario, u.nombre || ' ' || u.apellido AS nombre,
               u.fecha_ultimo_pago, u.id_plan
        FROM USUARIOS u
        WHERE u.estado_cuenta = 'ACTIVO'
          AND (u.fecha_ultimo_pago IS NULL
               OR TRUNC(SYSDATE) > TRUNC(u.fecha_ultimo_pago) + 28)
        ORDER BY u.id_usuario;

    v_monto         NUMBER;
    v_sp_name       VARCHAR2(50);
    v_procesados    NUMBER := 0;
    v_exitosos      NUMBER := 0;
    v_fallidos      NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TRANSACCIÓN 2: RENOVACIÓN MENSUAL MASIVA ===');
    DBMS_OUTPUT.PUT_LINE('Estado: ACTIVA');

    FOR usu IN cur_usuarios_renovar LOOP
        v_sp_name := 'SP_USU_' || usu.id_usuario;

        -- SAVEPOINT por usuario: si falla este, no afecta los anteriores
        SAVEPOINT sp_usuario_actual;

        BEGIN
            -- Calcular monto con descuentos
            v_monto := FN_CALCULAR_MONTO(usu.id_usuario);

            -- Registrar pago
            INSERT INTO PAGOS (
                id_usuario, fecha_pago, monto, metodo_pago,
                estado_pago, periodo_mes, periodo_anio
            ) VALUES (
                usu.id_usuario, SYSDATE, v_monto, 'TARJETA_CREDITO',
                'EXITOSO',
                EXTRACT(MONTH FROM SYSDATE),
                EXTRACT(YEAR FROM SYSDATE)
            );

            -- Actualizar fecha de último pago
            UPDATE USUARIOS
            SET fecha_ultimo_pago = SYSDATE,
                estado_cuenta     = 'ACTIVO'
            WHERE id_usuario = usu.id_usuario;

            v_exitosos := v_exitosos + 1;
            DBMS_OUTPUT.PUT_LINE('OK: ' || usu.nombre || ' — $' || v_monto);

        EXCEPTION
            WHEN OTHERS THEN
                -- Revertir solo este usuario, los anteriores se mantienen
                ROLLBACK TO SAVEPOINT sp_usuario_actual;
                v_fallidos := v_fallidos + 1;
                DBMS_OUTPUT.PUT_LINE('FALLO: ' || usu.nombre || ' — ' || SQLERRM);
        END;

        v_procesados := v_procesados + 1;
    END LOOP;

    -- COMMIT de todos los usuarios exitosos
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Estado: CONFIRMADA');
    DBMS_OUTPUT.PUT_LINE('Procesados: ' || v_procesados ||
                         ' | Exitosos: ' || v_exitosos ||
                         ' | Fallidos: ' || v_fallidos);
END;
/

-- =============================================================================
-- TRANSACCIÓN 3: Eliminación completa de cuenta (todo o nada)
-- Eliminar calificaciones, favoritos, reproducciones, perfiles, pagos, usuario
-- =============================================================================
CREATE OR REPLACE PROCEDURE SP_ELIMINAR_CUENTA (
    p_id_usuario IN USUARIOS.id_usuario%TYPE
) AS
    v_nombre    VARCHAR2(200);
    v_cal       NUMBER := 0;
    v_fav       NUMBER := 0;
    v_rep       NUMBER := 0;
    v_rep_cont  NUMBER := 0;
    v_perf      NUMBER := 0;
    v_pagos     NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TRANSACCIÓN 3: ELIMINACIÓN DE CUENTA ===');
    DBMS_OUTPUT.PUT_LINE('Estado: ACTIVA');

    -- Verificar que el usuario existe
    SELECT nombre || ' ' || apellido INTO v_nombre
    FROM USUARIOS WHERE id_usuario = p_id_usuario;

    DBMS_OUTPUT.PUT_LINE('Eliminando cuenta de: ' || v_nombre);

    -- Paso 1: Eliminar calificaciones de los perfiles del usuario
    DELETE FROM CALIFICACIONES
    WHERE id_perfil IN (SELECT id_perfil FROM PERFILES WHERE id_usuario = p_id_usuario);
    v_cal := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Paso 1: ' || v_cal || ' calificaciones eliminadas');

    -- Paso 2: Eliminar favoritos
    DELETE FROM FAVORITOS
    WHERE id_perfil IN (SELECT id_perfil FROM PERFILES WHERE id_usuario = p_id_usuario);
    v_fav := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Paso 2: ' || v_fav || ' favoritos eliminados');

    -- Paso 3: Eliminar reportes realizados por los perfiles
    DELETE FROM REPORTES
    WHERE id_perfil IN (SELECT id_perfil FROM PERFILES WHERE id_usuario = p_id_usuario);
    v_rep_cont := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Paso 3: ' || v_rep_cont || ' reportes eliminados');

    -- Paso 4: Eliminar reproducciones
    DELETE FROM REPRODUCCIONES
    WHERE id_perfil IN (SELECT id_perfil FROM PERFILES WHERE id_usuario = p_id_usuario);
    v_rep := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Paso 4: ' || v_rep || ' reproducciones eliminadas');

    -- Paso 5: Eliminar perfiles
    DELETE FROM PERFILES WHERE id_usuario = p_id_usuario;
    v_perf := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Paso 5: ' || v_perf || ' perfiles eliminados');

    -- Paso 6: Eliminar historial de planes
    DELETE FROM HISTORIAL_PLANES WHERE id_usuario = p_id_usuario;

    -- Paso 7: Eliminar pagos
    DELETE FROM PAGOS WHERE id_usuario = p_id_usuario;
    v_pagos := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Paso 6: ' || v_pagos || ' pagos eliminados');

    -- Paso 8: Eliminar usuario
    DELETE FROM USUARIOS WHERE id_usuario = p_id_usuario;
    DBMS_OUTPUT.PUT_LINE('Paso 7: Usuario eliminado');

    -- ESTADO: PARCIALMENTE CONFIRMADA → CONFIRMADA
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Estado: CONFIRMADA');
    DBMS_OUTPUT.PUT_LINE('Cuenta de ' || v_nombre || ' eliminada completamente.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Estado: FALLIDA → ABORTADA');
        RAISE_APPLICATION_ERROR(-20004, 'Usuario ID=' || p_id_usuario || ' no encontrado.');
    WHEN OTHERS THEN
        -- ESTADO: FALLIDA → ABORTADA (todo o nada)
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Estado: FALLIDA → ABORTADA');
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Todos los cambios fueron revertidos. La cuenta sigue intacta.');
        RAISE;
END SP_ELIMINAR_CUENTA;
/

-- =============================================================================
-- CONCURRENCIA: Escenario con SELECT FOR UPDATE
-- Dos sesiones intentan cambiar el plan del mismo usuario simultáneamente
-- =============================================================================

-- *** SESIÓN 1 (ejecutar primero) ***
-- Inicia transacción y bloquea el registro del usuario 5
/*
-- SESIÓN 1:
BEGIN
    -- Bloquear el registro del usuario para actualización exclusiva
    SELECT id_usuario, id_plan, nombre
    FROM USUARIOS
    WHERE id_usuario = 5
    FOR UPDATE NOWAIT;  -- NOWAIT: falla inmediatamente si hay bloqueo

    DBMS_OUTPUT.PUT_LINE('Sesión 1: Registro bloqueado. Cambiando plan...');

    UPDATE USUARIOS SET id_plan = 3 WHERE id_usuario = 5;

    -- Simular procesamiento largo (no hacer COMMIT aún)
    DBMS_LOCK.SLEEP(10);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Sesión 1: COMMIT realizado.');
END;
*/

-- *** SESIÓN 2 (ejecutar mientras Sesión 1 espera) ***
-- Intentará bloquear el mismo registro y recibirá ORA-00054
/*
-- SESIÓN 2:
BEGIN
    SELECT id_usuario, id_plan
    FROM USUARIOS
    WHERE id_usuario = 5
    FOR UPDATE NOWAIT;  -- Lanzará ORA-00054: resource busy

    UPDATE USUARIOS SET id_plan = 1 WHERE id_usuario = 5;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- ORA-00054: resource busy and acquire with NOWAIT specified
        DBMS_OUTPUT.PUT_LINE('Sesión 2 BLOQUEADA: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Oracle protege la integridad: solo una sesión puede modificar el registro.');
        ROLLBACK;
END;
*/

-- ANÁLISIS:
-- Oracle usa bloqueo pesimista a nivel de fila (row-level locking).
-- SELECT FOR UPDATE adquiere un bloqueo exclusivo sobre la fila.
-- La Sesión 2 recibe ORA-00054 con NOWAIT, o espera indefinidamente sin NOWAIT.
-- Cuando la Sesión 1 hace COMMIT o ROLLBACK, libera el bloqueo.
-- Esto garantiza que no haya actualizaciones perdidas (lost update problem).
-- El aislamiento por defecto en Oracle es READ COMMITTED.

