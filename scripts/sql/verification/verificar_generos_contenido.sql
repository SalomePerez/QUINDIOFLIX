-- Verificar géneros del contenido ID 61
SELECT c.id_contenido, c.titulo, g.nombre AS genero
FROM CONTENIDO c
LEFT JOIN CONTENIDO_GENEROS cg ON c.id_contenido = cg.id_contenido
LEFT JOIN GENEROS g ON cg.id_genero = g.id_genero
WHERE c.id_contenido = 61;

-- Ver todos los géneros disponibles
SELECT * FROM GENEROS ORDER BY nombre;

-- Ver cuántos contenidos tienen géneros asignados
SELECT 
    COUNT(DISTINCT c.id_contenido) AS contenidos_con_genero,
    (SELECT COUNT(*) FROM CONTENIDO) AS total_contenidos
FROM CONTENIDO c
JOIN CONTENIDO_GENEROS cg ON c.id_contenido = cg.id_contenido;

-- Ver algunos ejemplos de contenido con géneros
SELECT c.id_contenido, c.titulo, COUNT(cg.id_genero) AS num_generos
FROM CONTENIDO c
LEFT JOIN CONTENIDO_GENEROS cg ON c.id_contenido = cg.id_contenido
GROUP BY c.id_contenido, c.titulo
ORDER BY c.id_contenido
FETCH FIRST 10 ROWS ONLY;
