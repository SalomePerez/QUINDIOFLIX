-- =============================================================================
-- QUINDIOFLIX — Núcleo 2: Disparadores (Sección 3.2.5)
-- =============================================================================

-- =============================================================================
-- TRIGGER 1: Verificar cuenta activa antes de insertar reproducción
-- Nivel de fila en REPRODUCCIONES
-- =============================================================================
CREATE OR REPLACE TRIGGER TRG_REPROD_CUENTA_ACTIVA
    BEFORE INSERT ON REPRODUCCIONES
    FOR EACH ROW
DECLARE
    v_estado_cuenta USUARIOS.estado_cuenta%TYPE;
    v_nombre_usuario VARCHAR2(200);
BEGIN
    -- Obtener estado de la cuenta del usuario propietario del perfil
    SELECT u.estado_cuenta, u.nombre || ' ' || u.apellido
    INTO v_estado_cuenta, v_nombre_usuario
    FROM USUARIOS u
    JOIN PERFILES p ON u.id_usuario = p.id_usuario
    WHERE p.id_perfil = :NEW.id_perfil;

    IF v_estado_cuenta <> 'ACTIVO' THEN
        RAISE_APPLICATION_ERROR(-20010,
            'No se puede registrar la reproducción. La cuenta del usuario ' ||
            v_nombre_usuario || ' está en estado: ' || v_estado_cuenta ||
            '. Solo las cuentas ACTIVAS pueden reproducir contenido.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20011,
            'Perfil ID=' || :NEW.id_perfil || ' no encontrado o sin usuario asociado.');
END TRG_REPROD_CUENTA_ACTIVA;
/

-- =============================================================================
-- TRIGGER 2: Verificar límite de perfiles al insertar un nuevo perfil
-- Nivel de fila en PERFILES
-- =============================================================================
CREATE OR REPLACE TRIGGER TRG_PERFIL_LIMITE_PLAN
    BEFORE INSERT ON PERFILES
    FOR EACH ROW
DECLARE
    v_perfiles_actuales NUMBER;
    v_max_perfiles      PLANES.max_perfiles%TYPE;
    v_nombre_plan       PLANES.nombre%TYPE;
BEGIN
    -- Contar perfiles activos del usuario
    SELECT COUNT(*)
    INTO v_perfiles_actuales
    FROM PERFILES
    WHERE id_usuario = :NEW.id_usuario AND activo = 'S';

    -- Obtener límite del plan actual
    SELECT pl.max_perfiles, pl.nombre
    INTO v_max_perfiles, v_nombre_plan
    FROM PLANES pl
    JOIN USUARIOS u ON pl.id_plan = u.id_plan
    WHERE u.id_usuario = :NEW.id_usuario;

    IF v_perfiles_actuales >= v_max_perfiles THEN
        RAISE_APPLICATION_ERROR(-20012,
            'No se puede crear el perfil. El plan ' || v_nombre_plan ||
            ' permite máximo ' || v_max_perfiles || ' perfiles. ' ||
            'El usuario ya tiene ' || v_perfiles_actuales || ' perfil(es) activo(s).');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20013,
            'Usuario ID=' || :NEW.id_usuario || ' no encontrado.');
END TRG_PERFIL_LIMITE_PLAN;
/

-- =============================================================================
-- TRIGGER 3: Verificar reproducción mínima antes de calificar
-- Nivel de fila en CALIFICACIONES
-- =============================================================================
CREATE OR REPLACE TRIGGER TRG_CAL_REPRODUCCION_MINIMA
    BEFORE INSERT ON CALIFICACIONES
    FOR EACH ROW
DECLARE
    v_max_avance    NUMBER;
    v_titulo        CONTENIDO.titulo%TYPE;
BEGIN
    -- Obtener el máximo porcentaje de avance del perfil para ese contenido
    SELECT MAX(r.porcentaje_avance), c.titulo
    INTO v_max_avance, v_titulo
    FROM CONTENIDO c
    LEFT JOIN REPRODUCCIONES r ON c.id_contenido = r.id_contenido
                               AND r.id_perfil = :NEW.id_perfil
    WHERE c.id_contenido = :NEW.id_contenido
    GROUP BY c.titulo;

    IF v_max_avance IS NULL OR v_max_avance < 50 THEN
        RAISE_APPLICATION_ERROR(-20014,
            'No se puede calificar "' || v_titulo || '". ' ||
            'Debes haber reproducido al menos el 50% del contenido. ' ||
            'Tu avance máximo registrado es: ' ||
            NVL(TO_CHAR(v_max_avance), '0') || '%.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20015,
            'Contenido ID=' || :NEW.id_contenido || ' no encontrado.');
END TRG_CAL_REPRODUCCION_MINIMA;
/

-- =============================================================================
-- TRIGGER 4: Actualizar estado de cuenta tras pago exitoso
-- Nivel de sentencia en PAGOS (AFTER INSERT)
-- =============================================================================
CREATE OR REPLACE TRIGGER TRG_PAGO_ACTIVAR_CUENTA
    AFTER INSERT ON PAGOS
DECLARE
    -- Cursor para procesar todos los pagos exitosos recién insertados
    CURSOR cur_pagos_nuevos IS
        SELECT DISTINCT p.id_usuario
        FROM PAGOS p
        WHERE p.estado_pago = 'EXITOSO'
          AND p.fecha_pago >= TRUNC(SYSDATE)  -- pagos de hoy
          AND EXISTS (
              SELECT 1 FROM USUARIOS u
              WHERE u.id_usuario = p.id_usuario
                AND u.estado_cuenta IN ('INACTIVO', 'ACTIVO')
          );
    v_actualizados NUMBER := 0;
BEGIN
    FOR rec IN cur_pagos_nuevos LOOP
        UPDATE USUARIOS
        SET estado_cuenta     = 'ACTIVO',
            fecha_ultimo_pago = SYSDATE
        WHERE id_usuario = rec.id_usuario;

        v_actualizados := v_actualizados + 1;
    END LOOP;

    IF v_actualizados > 0 THEN
        DBMS_OUTPUT.PUT_LINE('TRG_PAGO_ACTIVAR_CUENTA: ' || v_actualizados ||
                             ' cuenta(s) activada(s) tras pago exitoso.');
    END IF;
END TRG_PAGO_ACTIVAR_CUENTA;
/

-- =============================================================================
-- TRIGGER 5 (BONUS): Validar clasificación de edad para perfiles infantiles
-- Nivel de fila en REPRODUCCIONES
-- =============================================================================
CREATE OR REPLACE TRIGGER TRG_REPROD_CLASIFICACION_EDAD
    BEFORE INSERT ON REPRODUCCIONES
    FOR EACH ROW
DECLARE
    v_tipo_perfil       PERFILES.tipo%TYPE;
    v_clasificacion     CONTENIDO.clasificacion_edad%TYPE;
    v_titulo            CONTENIDO.titulo%TYPE;
BEGIN
    -- Obtener tipo de perfil y clasificación del contenido
    SELECT p.tipo INTO v_tipo_perfil
    FROM PERFILES p WHERE p.id_perfil = :NEW.id_perfil;

    SELECT c.clasificacion_edad, c.titulo
    INTO v_clasificacion, v_titulo
    FROM CONTENIDO c WHERE c.id_contenido = :NEW.id_contenido;

    -- Perfiles infantiles solo pueden ver TP, +7, +13
    IF v_tipo_perfil = 'INFANTIL' AND v_clasificacion IN ('+16', '+18') THEN
        RAISE_APPLICATION_ERROR(-20016,
            'El perfil infantil no puede reproducir "' || v_titulo ||
            '" (clasificación ' || v_clasificacion || '). ' ||
            'Los perfiles infantiles solo pueden acceder a contenido TP, +7 y +13.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL; -- El trigger TRG_REPROD_CUENTA_ACTIVA ya valida la existencia
END TRG_REPROD_CLASIFICACION_EDAD;
/

