-- Verificar si hay temporadas en la BD
SELECT COUNT(*) as total_temporadas FROM TEMPORADAS;

-- Ver temporadas con sus episodios
SELECT t.ID_TEMPORADA, t.ID_CONTENIDO, t.NUMERO, t.TITULO,
       (SELECT COUNT(*) FROM EPISODIOS WHERE id_temporada = t.id_temporada) AS num_episodios
FROM TEMPORADAS t
ORDER BY t.ID_CONTENIDO, t.NUMERO;

-- Ver episodios de la primera temporada
SELECT * FROM EPISODIOS WHERE id_temporada = (SELECT MIN(id_temporada) FROM TEMPORADAS);

-- Contar series y sus temporadas
SELECT c.ID_CONTENIDO, c.TITULO, c.TIPO,
       (SELECT COUNT(*) FROM TEMPORADAS WHERE id_contenido = c.id_contenido) AS num_temporadas
FROM CONTENIDO c
WHERE c.TIPO = 'SERIE'
ORDER BY c.ID_CONTENIDO DESC;
