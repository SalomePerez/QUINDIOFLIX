-- =============================================================================
-- SCRIPT PARA AGREGAR SOPORTE DE ARCHIVOS MULTIMEDIA
-- Ejecutar este script en SQL Developer o SQL*Plus como usuario QUINDIOFLIX
-- =============================================================================

-- 1. Agregar columna URL_ARCHIVO a la tabla CONTENIDO
ALTER TABLE CONTENIDO ADD (
    url_archivo VARCHAR2(500)
);

COMMENT ON COLUMN CONTENIDO.url_archivo IS 'URL o ruta del archivo multimedia (video/audio) del contenido';

-- 2. Agregar columna URL_ARCHIVO a la tabla EPISODIOS
ALTER TABLE EPISODIOS ADD (
    url_archivo VARCHAR2(500)
);

COMMENT ON COLUMN EPISODIOS.url_archivo IS 'URL o ruta del archivo de video del episodio';

-- 3. Actualizar algunos contenidos de ejemplo con URLs de prueba
-- (Videos de ejemplo públicos de Google)
UPDATE CONTENIDO 
SET url_archivo = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
WHERE tipo = 'PELICULA' AND ROWNUM <= 5;

UPDATE CONTENIDO 
SET url_archivo = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'
WHERE tipo = 'DOCUMENTAL' AND ROWNUM <= 3;

UPDATE CONTENIDO 
SET url_archivo = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'
WHERE tipo = 'MUSICA' AND ROWNUM <= 3;

UPDATE CONTENIDO 
SET url_archivo = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'
WHERE tipo = 'PODCAST' AND ROWNUM <= 3;

-- 4. Actualizar algunos episodios de ejemplo
UPDATE EPISODIOS 
SET url_archivo = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'
WHERE ROWNUM <= 10;

UPDATE EPISODIOS 
SET url_archivo = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4'
WHERE url_archivo IS NULL AND ROWNUM <= 10;

COMMIT;

-- 5. Verificar que las columnas se agregaron correctamente
SELECT 'CONTENIDO' AS tabla, COUNT(*) AS total, COUNT(url_archivo) AS con_archivo
FROM CONTENIDO
UNION ALL
SELECT 'EPISODIOS' AS tabla, COUNT(*) AS total, COUNT(url_archivo) AS con_archivo
FROM EPISODIOS;

-- 6. Ver algunos ejemplos
SELECT id_contenido, titulo, tipo, url_archivo 
FROM CONTENIDO 
WHERE url_archivo IS NOT NULL
FETCH FIRST 5 ROWS ONLY;

PROMPT
PROMPT ========================================
PROMPT Columnas agregadas exitosamente!
PROMPT ========================================
PROMPT
PROMPT Ahora puedes:
PROMPT 1. Subir archivos desde el panel de administración
PROMPT 2. Ver y reproducir contenido con archivos multimedia
PROMPT
