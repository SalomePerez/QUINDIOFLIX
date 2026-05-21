-- =============================================================================
-- QUINDIOFLIX — Agregar géneros faltantes a contenidos sin género
-- Este script agrega géneros a los contenidos que no tienen géneros asignados
-- =============================================================================

-- Verificar contenidos sin géneros
SELECT c.id_contenido, c.titulo, c.tipo
FROM CONTENIDO c
WHERE NOT EXISTS (
    SELECT 1 FROM CONTENIDO_GENEROS cg 
    WHERE cg.id_contenido = c.id_contenido
)
ORDER BY c.id_contenido;

-- Agregar géneros a contenidos faltantes (si existen más allá del ID 40)
-- Basándonos en el tipo y título del contenido

-- Si hay más series, documentales, música o podcasts sin géneros, agregarlos aquí
-- Por ejemplo, si hay contenidos del ID 41 en adelante:

-- Ejemplo para series adicionales (ajustar según los contenidos reales)
-- INSERT INTO CONTENIDO_GENEROS VALUES (41, 3);  -- Drama
-- INSERT INTO CONTENIDO_GENEROS VALUES (41, 11); -- Thriller

-- Ejemplo para documentales adicionales
-- INSERT INTO CONTENIDO_GENEROS VALUES (42, 10); -- Documental

-- Ejemplo para música adicional
-- INSERT INTO CONTENIDO_GENEROS VALUES (43, 9);  -- Musical

-- Ejemplo para podcasts adicionales
-- INSERT INTO CONTENIDO_GENEROS VALUES (44, 10); -- Documental

COMMIT;

-- Verificar que todos los contenidos tengan al menos un género
SELECT 
    COUNT(DISTINCT c.id_contenido) AS total_contenidos,
    COUNT(DISTINCT cg.id_contenido) AS contenidos_con_genero,
    COUNT(DISTINCT c.id_contenido) - COUNT(DISTINCT cg.id_contenido) AS contenidos_sin_genero
FROM CONTENIDO c
LEFT JOIN CONTENIDO_GENEROS cg ON c.id_contenido = cg.id_contenido;
