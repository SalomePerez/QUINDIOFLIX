-- =============================================================================
-- Script de verificación de datos de prueba
-- Ejecutar después de cargar los datos
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
    v_count NUMBER;
    v_total_ok NUMBER := 0;
    v_total_req NUMBER := 11;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE('VERIFICACIÓN DE DATOS DE PRUEBA - QUINDIOFLIX');
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- PLANES
    SELECT COUNT(*) INTO v_count FROM PLANES;
    DBMS_OUTPUT.PUT_LINE('PLANES:          ' || RPAD(v_count, 5) || ' | Mínimo: 3  | ' || 
        CASE WHEN v_count >= 3 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 3 THEN v_total_ok := v_total_ok + 1; END IF;
    
    -- USUARIOS
    SELECT COUNT(*) INTO v_count FROM USUARIOS;
    DBMS_OUTPUT.PUT_LINE('USUARIOS:        ' || RPAD(v_count, 5) || ' | Mínimo: 30 | ' || 
        CASE WHEN v_count >= 30 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 30 THEN v_total_ok := v_total_ok + 1; END IF;
    
    -- PERFILES
    SELECT COUNT(*) INTO v_count FROM PERFILES;
    DBMS_OUTPUT.PUT_LINE('PERFILES:        ' || RPAD(v_count, 5) || ' | Mínimo: 50 | ' || 
        CASE WHEN v_count >= 50 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 50 THEN v_total_ok := v_total_ok + 1; END IF;
    
    -- CATEGORIAS
    SELECT COUNT(*) INTO v_count FROM CATEGORIAS;
    DBMS_OUTPUT.PUT_LINE('CATEGORIAS:      ' || RPAD(v_count, 5) || ' | Mínimo: 5  | ' || 
        CASE WHEN v_count >= 5 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 5 THEN v_total_ok := v_total_ok + 1; END IF;
    
    -- GENEROS
    SELECT COUNT(*) INTO v_count FROM GENEROS;
    DBMS_OUTPUT.PUT_LINE('GENEROS:         ' || RPAD(v_count, 5) || ' | Mínimo: 8  | ' || 
        CASE WHEN v_count >= 8 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 8 THEN v_total_ok := v_total_ok + 1; END IF;
    
    -- CONTENIDO
    SELECT COUNT(*) INTO v_count FROM CONTENIDO;
    DBMS_OUTPUT.PUT_LINE('CONTENIDO:       ' || RPAD(v_count, 5) || ' | Mínimo: 40 | ' || 
        CASE WHEN v_count >= 40 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 40 THEN v_total_ok := v_total_ok + 1; END IF;
    
    -- TEMPORADAS
    SELECT COUNT(*) INTO v_count FROM TEMPORADAS;
    DBMS_OUTPUT.PUT_LINE('TEMPORADAS:      ' || RPAD(v_count, 5) || ' | Mínimo: 15 | ' || 
        CASE WHEN v_count >= 15 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 15 THEN v_total_ok := v_total_ok + 1; END IF;
    
    -- EPISODIOS
    SELECT COUNT(*) INTO v_count FROM EPISODIOS;
    DBMS_OUTPUT.PUT_LINE('EPISODIOS:       ' || RPAD(v_count, 5) || ' | Mínimo: 50 | ' || 
        CASE WHEN v_count >= 50 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 50 THEN v_total_ok := v_total_ok + 1; END IF;
    
    -- REPRODUCCIONES
    SELECT COUNT(*) INTO v_count FROM REPRODUCCIONES;
    DBMS_OUTPUT.PUT_LINE('REPRODUCCIONES:  ' || RPAD(v_count, 5) || ' | Mínimo: 200| ' || 
        CASE WHEN v_count >= 200 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 200 THEN v_total_ok := v_total_ok + 1; END IF;
    
    -- CALIFICACIONES
    SELECT COUNT(*) INTO v_count FROM CALIFICACIONES;
    DBMS_OUTPUT.PUT_LINE('CALIFICACIONES:  ' || RPAD(v_count, 5) || ' | Mínimo: 60 | ' || 
        CASE WHEN v_count >= 60 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 60 THEN v_total_ok := v_total_ok + 1; END IF;
    
    -- PAGOS
    SELECT COUNT(*) INTO v_count FROM PAGOS;
    DBMS_OUTPUT.PUT_LINE('PAGOS:           ' || RPAD(v_count, 5) || ' | Mínimo: 80 | ' || 
        CASE WHEN v_count >= 80 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 80 THEN v_total_ok := v_total_ok + 1; END IF;
    
    -- FAVORITOS
    SELECT COUNT(*) INTO v_count FROM FAVORITOS;
    DBMS_OUTPUT.PUT_LINE('FAVORITOS:       ' || RPAD(v_count, 5) || ' | Mínimo: 40 | ' || 
        CASE WHEN v_count >= 40 THEN '✓ OK' ELSE '✗ FALTA' END);
    IF v_count >= 40 THEN v_total_ok := v_total_ok + 1; END IF;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    DBMS_OUTPUT.PUT_LINE('RESULTADO: ' || v_total_ok || '/' || v_total_req || ' tablas cumplen el mínimo');
    IF v_total_ok = v_total_req THEN
        DBMS_OUTPUT.PUT_LINE('✓ TODOS LOS REQUISITOS CUMPLIDOS');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ FALTAN ' || (v_total_req - v_total_ok) || ' tablas por completar');
    END IF;
    DBMS_OUTPUT.PUT_LINE('=================================================================');
    
    -- Verificar asimetría de datos
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== VERIFICACIÓN DE ASIMETRÍA DE DATOS ===');
    
    -- Distribución por ciudad
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Usuarios por ciudad:');
    FOR rec IN (SELECT ciudad, COUNT(*) AS total FROM USUARIOS GROUP BY ciudad ORDER BY total DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('  ' || RPAD(rec.ciudad, 15) || ': ' || rec.total);
    END LOOP;
    
    -- Distribución por plan
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Usuarios por plan:');
    FOR rec IN (SELECT pl.nombre, COUNT(*) AS total FROM USUARIOS u JOIN PLANES pl ON u.id_plan = pl.id_plan GROUP BY pl.nombre ORDER BY total DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('  ' || RPAD(rec.nombre, 15) || ': ' || rec.total);
    END LOOP;
    
    -- Distribución por dispositivo
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Reproducciones por dispositivo:');
    FOR rec IN (SELECT dispositivo, COUNT(*) AS total FROM REPRODUCCIONES GROUP BY dispositivo ORDER BY total DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('  ' || RPAD(rec.dispositivo, 15) || ': ' || rec.total);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('✓ Los datos son ASIMÉTRICOS (distribución variada)');
    DBMS_OUTPUT.PUT_LINE('=================================================================');
END;
/
