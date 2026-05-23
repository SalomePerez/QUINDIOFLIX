-- Script para probar eliminación de contenido ID 121
-- Ejecutar en SQL Developer para ver el error exacto

SET SERVEROUTPUT ON;

DECLARE
    v_id NUMBER := 121;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Intentando eliminar contenido ID: ' || v_id);
    
    -- Ver qué relaciones tiene este contenido
    DBMS_OUTPUT.PUT_LINE('=== RELACIONES EXISTENTES ===');
    
    FOR r IN (SELECT COUNT(*) AS cnt FROM CONTENIDO_GENEROS WHERE id_contenido = v_id) LOOP
        DBMS_OUTPUT.PUT_LINE('CONTENIDO_GENEROS: ' || r.cnt);
    END LOOP;
    
    FOR r IN (SELECT COUNT(*) AS cnt FROM FAVORITOS WHERE id_contenido = v_id) LOOP
        DBMS_OUTPUT.PUT_LINE('FAVORITOS: ' || r.cnt);
    END LOOP;
    
    FOR r IN (SELECT COUNT(*) AS cnt FROM CALIFICACIONES WHERE id_contenido = v_id) LOOP
        DBMS_OUTPUT.PUT_LINE('CALIFICACIONES: ' || r.cnt);
    END LOOP;
    
    FOR r IN (SELECT COUNT(*) AS cnt FROM REPRODUCCIONES WHERE id_contenido = v_id) LOOP
        DBMS_OUTPUT.PUT_LINE('REPRODUCCIONES: ' || r.cnt);
    END LOOP;
    
    FOR r IN (SELECT COUNT(*) AS cnt FROM REPORTES WHERE id_contenido = v_id) LOOP
        DBMS_OUTPUT.PUT_LINE('REPORTES: ' || r.cnt);
    END LOOP;
    
    FOR r IN (SELECT COUNT(*) AS cnt FROM CONTENIDO_RELACIONADO 
              WHERE id_contenido_origen = v_id OR id_contenido_destino = v_id) LOOP
        DBMS_OUTPUT.PUT_LINE('CONTENIDO_RELACIONADO: ' || r.cnt);
    END LOOP;
    
    FOR r IN (SELECT COUNT(*) AS cnt FROM TEMPORADAS WHERE id_contenido = v_id) LOOP
        DBMS_OUTPUT.PUT_LINE('TEMPORADAS: ' || r.cnt);
    END LOOP;
    
    FOR r IN (SELECT COUNT(*) AS cnt FROM EPISODIOS 
              WHERE id_temporada IN (SELECT id_temporada FROM TEMPORADAS WHERE id_contenido = v_id)) LOOP
        DBMS_OUTPUT.PUT_LINE('EPISODIOS: ' || r.cnt);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== INTENTANDO ELIMINAR ===');
    
    -- Intentar eliminar en orden
    DELETE FROM CONTENIDO_GENEROS WHERE id_contenido = v_id;
    DBMS_OUTPUT.PUT_LINE('✓ CONTENIDO_GENEROS eliminados');
    
    DELETE FROM FAVORITOS WHERE id_contenido = v_id;
    DBMS_OUTPUT.PUT_LINE('✓ FAVORITOS eliminados');
    
    DELETE FROM CALIFICACIONES WHERE id_contenido = v_id;
    DBMS_OUTPUT.PUT_LINE('✓ CALIFICACIONES eliminadas');
    
    DELETE FROM REPRODUCCIONES WHERE id_contenido = v_id;
    DBMS_OUTPUT.PUT_LINE('✓ REPRODUCCIONES eliminadas');
    
    DELETE FROM REPORTES WHERE id_contenido = v_id;
    DBMS_OUTPUT.PUT_LINE('✓ REPORTES eliminados');
    
    DELETE FROM CONTENIDO_RELACIONADO 
    WHERE id_contenido_origen = v_id OR id_contenido_destino = v_id;
    DBMS_OUTPUT.PUT_LINE('✓ CONTENIDO_RELACIONADO eliminado');
    
    DELETE FROM EPISODIOS 
    WHERE id_temporada IN (SELECT id_temporada FROM TEMPORADAS WHERE id_contenido = v_id);
    DBMS_OUTPUT.PUT_LINE('✓ EPISODIOS eliminados');
    
    DELETE FROM TEMPORADAS WHERE id_contenido = v_id;
    DBMS_OUTPUT.PUT_LINE('✓ TEMPORADAS eliminadas');
    
    DELETE FROM CONTENIDO WHERE id_contenido = v_id;
    DBMS_OUTPUT.PUT_LINE('✓ CONTENIDO eliminado');
    
    ROLLBACK; -- No hacer commit, solo probar
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA (ROLLBACK aplicado)');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ ERROR: ' || SQLERRM);
        ROLLBACK;
END;
/
