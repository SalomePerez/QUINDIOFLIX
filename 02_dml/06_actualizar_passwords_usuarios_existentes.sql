-- =============================================================================
-- QUINDIOFLIX — Asignar contraseña temporal a usuarios existentes
-- =============================================================================

-- Este script asigna la contraseña "password123" a todos los usuarios que no tienen contraseña
-- IMPORTANTE: Esto es solo para desarrollo/testing. En producción, los usuarios deberían
-- establecer sus propias contraseñas a través de un flujo de recuperación.

-- Contraseña temporal: password123
-- Hash bcrypt generado con bcryptjs (10 rounds)
UPDATE USUARIOS 
SET password_hash = '$2b$10$ZgUWXi9xwDwBaqFTKEU5U.S.vxyitxW7ofJ3WHNmk.tlOY.pBPMGK'
WHERE password_hash IS NULL;

COMMIT;

-- Verificar cuántos usuarios tienen contraseña
SELECT 
    COUNT(*) AS total_usuarios,
    COUNT(password_hash) AS usuarios_con_password,
    COUNT(*) - COUNT(password_hash) AS usuarios_sin_password
FROM USUARIOS;

-- Mostrar algunos usuarios (sin mostrar el hash completo por seguridad)
SELECT id_usuario, nombre, apellido, email,
       CASE 
           WHEN password_hash IS NOT NULL THEN 'SÍ' 
           ELSE 'NO' 
       END AS tiene_password
FROM USUARIOS
ORDER BY id_usuario
FETCH FIRST 10 ROWS ONLY;
