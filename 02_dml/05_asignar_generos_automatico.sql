-- =============================================================================
-- QUINDIOFLIX — Asignar géneros automáticamente a contenidos sin género
-- Este script asigna géneros basándose en el tipo de contenido
-- EJECUTAR ESTE SCRIPT CADA VEZ QUE AGREGUES CONTENIDO NUEVO SIN GÉNEROS
-- =============================================================================

-- Primero, ver qué contenidos no tienen géneros
SELECT c.id_contenido, c.titulo, c.tipo, cat.nombre AS categoria
FROM CONTENIDO c
JOIN CATEGORIAS cat ON c.id_categoria = cat.id_categoria
WHERE NOT EXISTS (
    SELECT 1 FROM CONTENIDO_GENEROS cg 
    WHERE cg.id_contenido = c.id_contenido
)
ORDER BY c.id_contenido;

-- Asignar géneros basándose en el tipo de contenido
-- Para SERIES sin género, asignar Drama (id_genero=3)
INSERT INTO CONTENIDO_GENEROS (id_contenido, id_genero)
SELECT c.id_contenido, 3  -- Drama
FROM CONTENIDO c
WHERE c.tipo = 'SERIE'
  AND NOT EXISTS (
      SELECT 1 FROM CONTENIDO_GENEROS cg 
      WHERE cg.id_contenido = c.id_contenido
  );

-- Para PELICULAS sin género, asignar Acción (id_genero=1)
INSERT INTO CONTENIDO_GENEROS (id_contenido, id_genero)
SELECT c.id_contenido, 1  -- Acción
FROM CONTENIDO c
WHERE c.tipo = 'PELICULA'
  AND NOT EXISTS (
      SELECT 1 FROM CONTENIDO_GENEROS cg 
      WHERE cg.id_contenido = c.id_contenido
  );

-- Para DOCUMENTALES sin género, asignar Documental (id_genero=10)
INSERT INTO CONTENIDO_GENEROS (id_contenido, id_genero)
SELECT c.id_contenido, 10  -- Documental
FROM CONTENIDO c
WHERE c.tipo = 'DOCUMENTAL'
  AND NOT EXISTS (
      SELECT 1 FROM CONTENIDO_GENEROS cg 
      WHERE cg.id_contenido = c.id_contenido
  );

-- Para MUSICA sin género, asignar Musical (id_genero=9)
INSERT INTO CONTENIDO_GENEROS (id_contenido, id_genero)
SELECT c.id_contenido, 9  -- Musical
FROM CONTENIDO c
WHERE c.tipo = 'MUSICA'
  AND NOT EXISTS (
      SELECT 1 FROM CONTENIDO_GENEROS cg 
      WHERE cg.id_contenido = c.id_contenido
  );

-- Para PODCASTS sin género, asignar Documental (id_genero=10)
INSERT INTO CONTENIDO_GENEROS (id_contenido, id_genero)
SELECT c.id_contenido, 10  -- Documental
FROM CONTENIDO c
WHERE c.tipo = 'PODCAST'
  AND NOT EXISTS (
      SELECT 1 FROM CONTENIDO_GENEROS cg 
      WHERE cg.id_contenido = c.id_contenido
  );

COMMIT;

-- Verificar que todos los contenidos ahora tengan al menos un género
SELECT 
    COUNT(DISTINCT c.id_contenido) AS total_contenidos,
    COUNT(DISTINCT cg.id_contenido) AS contenidos_con_genero,
    COUNT(DISTINCT c.id_contenido) - COUNT(DISTINCT cg.id_contenido) AS contenidos_sin_genero
FROM CONTENIDO c
LEFT JOIN CONTENIDO_GENEROS cg ON c.id_contenido = cg.id_contenido;

-- Mostrar algunos ejemplos de contenidos con sus géneros
SELECT c.id_contenido, c.titulo, c.tipo,
       LISTAGG(g.nombre, ', ') WITHIN GROUP (ORDER BY g.nombre) AS generos
FROM CONTENIDO c
LEFT JOIN CONTENIDO_GENEROS cg ON c.id_contenido = cg.id_contenido
LEFT JOIN GENEROS g ON cg.id_genero = g.id_genero
GROUP BY c.id_contenido, c.titulo, c.tipo
ORDER BY c.id_contenido
FETCH FIRST 20 ROWS ONLY;

-- =============================================================================
-- NOTA: Si quieres asignar géneros más específicos a ciertos contenidos,
-- puedes hacerlo manualmente después de ejecutar este script:
--
-- Ejemplo: Agregar más géneros a un contenido específico
-- INSERT INTO CONTENIDO_GENEROS VALUES (105, 12);  -- Agregar Aventura
-- COMMIT;
-- =============================================================================
