-- =============================================================================
-- Agregar campo URL_ARCHIVO a la tabla CONTENIDO
-- Este campo almacenará la ruta del archivo multimedia (video/audio)
-- =============================================================================

-- Agregar columna para la URL del archivo
ALTER TABLE CONTENIDO ADD (
    url_archivo VARCHAR2(500)
);

COMMENT ON COLUMN CONTENIDO.url_archivo IS 'URL o ruta del archivo multimedia (video/audio) del contenido';

-- Actualizar algunos contenidos de ejemplo con URLs de prueba
-- (En producción, estos serían archivos reales subidos)
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

COMMIT;

-- Verificar
SELECT id_contenido, titulo, tipo, url_archivo 
FROM CONTENIDO 
WHERE url_archivo IS NOT NULL;
