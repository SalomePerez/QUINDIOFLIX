-- Verificar usuarios con rol de moderador
SELECT id_usuario, nombre, apellido, email, es_moderador, estado_cuenta,
       CASE WHEN password_hash IS NOT NULL THEN 'SÍ' ELSE 'NO' END AS tiene_password
FROM USUARIOS
WHERE es_moderador = 'S'
ORDER BY id_usuario;

-- Ver todos los usuarios (primeros 10)
SELECT id_usuario, nombre, apellido, email, es_moderador, estado_cuenta,
       CASE WHEN password_hash IS NOT NULL THEN 'SÍ' ELSE 'NO' END AS tiene_password
FROM USUARIOS
ORDER BY id_usuario
FETCH FIRST 10 ROWS ONLY;
