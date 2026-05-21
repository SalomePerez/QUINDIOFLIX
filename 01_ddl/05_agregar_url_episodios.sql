-- =============================================================================
-- Agregar campo URL_ARCHIVO a la tabla EPISODIOS
-- Para que cada episodio tenga su propio archivo de video
-- =============================================================================

-- Agregar columna para la URL del archivo
ALTER TABLE EPISODIOS ADD (
    url_archivo VARCHAR2(500)
);

COMMENT ON COLUMN EPISODIOS.url_archivo IS 'URL o ruta del archivo de video del episodio';

-- Actualizar algunos episodios de ejemplo con URLs de prueba
UPDATE EPISODIOS 
SET url_archivo = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'
WHERE ROWNUM <= 10;

UPDATE EPISODIOS 
SET url_archivo = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4'
WHERE url_archivo IS NULL AND ROWNUM <= 10;

COMMIT;

-- Verificar
SELECT e.id_episodio, e.titulo, e.url_archivo, t.numero AS temporada
FROM EPISODIOS e
JOIN TEMPORADAS t ON e.id_temporada = t.id_temporada
WHERE e.url_archivo IS NOT NULL
FETCH FIRST 10 ROWS ONLY;
