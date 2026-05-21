-- =============================================================================
-- QUINDIOFLIX — Agregar columna de contraseña a tabla USUARIOS
-- =============================================================================

-- Agregar columna password_hash
ALTER TABLE USUARIOS ADD (
    password_hash VARCHAR2(255)
);

COMMENT ON COLUMN USUARIOS.password_hash IS 'Hash bcrypt de la contraseña del usuario';

-- Hacer la columna obligatoria después de agregar contraseñas a usuarios existentes
-- (Por ahora la dejamos opcional para no romper datos existentes)

COMMIT;

-- Verificar que la columna se agregó correctamente
DESC USUARIOS;
