const express = require('express');
const router  = express.Router();
const db      = require('../config/database');
const { authMiddleware } = require('../middleware/auth.middleware');

// GET /api/contenido — catálogo con filtros opcionales
router.get('/', async (req, res, next) => {
  const { tipo, id_categoria, genero, clasificacion, busqueda, page = 1, limit = 20 } = req.query;
  const offset = (Number(page) - 1) * Number(limit);
  const binds  = {};
  let where    = "WHERE 1=1";

  if (tipo)          { where += " AND c.tipo = :tipo";                    binds.tipo = tipo.toUpperCase(); }
  if (id_categoria)  { where += " AND c.id_categoria = :cat";             binds.cat  = Number(id_categoria); }
  if (clasificacion) { where += " AND c.clasificacion_edad = :clas";      binds.clas = clasificacion; }
  if (busqueda)      { where += " AND UPPER(c.titulo) LIKE UPPER(:bus)";  binds.bus  = `%${busqueda}%`; }
  if (genero)        {
    where += ` AND EXISTS (SELECT 1 FROM CONTENIDO_GENEROS cg JOIN GENEROS g ON cg.id_genero=g.id_genero
                           WHERE cg.id_contenido=c.id_contenido AND UPPER(g.nombre)=UPPER(:gen))`;
    binds.gen = genero;
  }

  try {
    const result = await db.execute(
      `SELECT c.id_contenido, c.titulo, c.tipo, c.anio_lanzamiento, c.duracion_min,
              c.sinopsis, c.clasificacion_edad, c.es_original, c.popularidad,
              cat.nombre AS categoria,
              (SELECT ROUND(AVG(estrellas),1) FROM CALIFICACIONES WHERE id_contenido=c.id_contenido) AS calificacion_promedio,
              (SELECT COUNT(*) FROM CALIFICACIONES WHERE id_contenido=c.id_contenido) AS total_calificaciones
       FROM CONTENIDO c JOIN CATEGORIAS cat ON c.id_categoria=cat.id_categoria
       ${where}
       ORDER BY c.popularidad DESC, c.fecha_agregado DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset, limit: Number(limit) }
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// GET /api/contenido/:id — detalle de un contenido
router.get('/:id', async (req, res, next) => {
  try {
    const [contRes, genRes, tempRes, relRes] = await Promise.all([
      db.execute(
        `SELECT c.*, cat.nombre AS categoria,
                e.nombre AS empleado_responsable,
                (SELECT ROUND(AVG(estrellas),1) FROM CALIFICACIONES WHERE id_contenido=c.id_contenido) AS calificacion_promedio,
                (SELECT COUNT(*) FROM REPRODUCCIONES WHERE id_contenido=c.id_contenido) AS total_reproducciones
         FROM CONTENIDO c
         JOIN CATEGORIAS cat ON c.id_categoria=cat.id_categoria
         JOIN EMPLEADOS  e   ON c.id_empleado_resp=e.id_empleado
         WHERE c.id_contenido=:id`, [Number(req.params.id)]),
      db.execute(
        `SELECT g.nombre FROM GENEROS g
         JOIN CONTENIDO_GENEROS cg ON g.id_genero=cg.id_genero
         WHERE cg.id_contenido=:id`, [Number(req.params.id)]),
      db.execute(
        `SELECT t.id_temporada, t.numero, t.titulo, t.anio,
                (SELECT COUNT(*) FROM EPISODIOS WHERE id_temporada=t.id_temporada) AS num_episodios
         FROM TEMPORADAS t WHERE t.id_contenido=:id ORDER BY t.numero`, [Number(req.params.id)]),
      db.execute(
        `SELECT cr.tipo_relacion, cr.descripcion, c2.titulo AS titulo_relacionado, c2.tipo AS tipo_relacionado
         FROM CONTENIDO_RELACIONADO cr JOIN CONTENIDO c2 ON cr.id_contenido_destino=c2.id_contenido
         WHERE cr.id_contenido_origen=:id`, [Number(req.params.id)])
    ]);
    if (!contRes.rows.length) return res.status(404).json({ error: 'Contenido no encontrado.' });
    res.json({
      ...contRes.rows[0],
      generos:    genRes.rows.map(r => r.NOMBRE),
      temporadas: tempRes.rows,
      relacionados: relRes.rows
    });
  } catch (err) { next(err); }
});

// GET /api/contenido/:id/episodios/:id_temporada
router.get('/:id/episodios/:id_temporada', async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT * FROM EPISODIOS WHERE id_temporada=:t ORDER BY numero`,
      [Number(req.params.id_temporada)]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// GET /api/contenido/:id/calificaciones
router.get('/:id/calificaciones', async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT cal.estrellas, cal.resena, cal.fecha, p.nombre AS perfil
       FROM CALIFICACIONES cal JOIN PERFILES p ON cal.id_perfil=p.id_perfil
       WHERE cal.id_contenido=:id ORDER BY cal.fecha DESC`,
      [Number(req.params.id)]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// POST /api/contenido/:id/calificar
router.post('/:id/calificar', authMiddleware, async (req, res, next) => {
  const { id_perfil, estrellas, resena } = req.body;
  if (!id_perfil || !estrellas) return res.status(400).json({ error: 'id_perfil y estrellas son requeridos.' });
  try {
    await db.execute(
      `INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena)
       VALUES (:p, :c, :e, :r)`,
      { p: Number(id_perfil), c: Number(req.params.id), e: Number(estrellas), r: resena || null },
      { autoCommit: true }
    );
    res.status(201).json({ message: 'Calificación registrada.' });
  } catch (err) {
    if (err.message && err.message.includes('20014'))
      return res.status(400).json({ error: 'Debes reproducir al menos el 50% del contenido para calificar.' });
    if (err.message && err.message.includes('ORA-00001'))
      return res.status(409).json({ error: 'Ya calificaste este contenido.' });
    next(err);
  }
});

// POST /api/contenido/:id/favorito
router.post('/:id/favorito', authMiddleware, async (req, res, next) => {
  const { id_perfil } = req.body;
  try {
    await db.execute(
      `INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (:p, :c)`,
      [Number(id_perfil), Number(req.params.id)],
      { autoCommit: true }
    );
    res.status(201).json({ message: 'Agregado a favoritos.' });
  } catch (err) {
    if (err.message && err.message.includes('ORA-00001'))
      return res.status(409).json({ error: 'Ya está en favoritos.' });
    next(err);
  }
});

// DELETE /api/contenido/:id/favorito
router.delete('/:id/favorito', authMiddleware, async (req, res, next) => {
  const { id_perfil } = req.body;
  try {
    await db.execute(
      `DELETE FROM FAVORITOS WHERE id_perfil=:p AND id_contenido=:c`,
      [Number(id_perfil), Number(req.params.id)],
      { autoCommit: true }
    );
    res.json({ message: 'Eliminado de favoritos.' });
  } catch (err) { next(err); }
});

// POST /api/contenido/:id/reportar
router.post('/:id/reportar', authMiddleware, async (req, res, next) => {
  const { id_perfil, motivo, descripcion } = req.body;
  if (!id_perfil || !motivo) return res.status(400).json({ error: 'id_perfil y motivo son requeridos.' });
  try {
    await db.execute(
      `INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion)
       VALUES (:p, :c, :m, :d)`,
      { p: Number(id_perfil), c: Number(req.params.id), m: motivo, d: descripcion || null },
      { autoCommit: true }
    );
    res.status(201).json({ message: 'Reporte enviado.' });
  } catch (err) { next(err); }
});

// GET /api/contenido/categorias/lista
router.get('/categorias/lista', async (_req, res, next) => {
  try {
    const result = await db.execute(`SELECT * FROM CATEGORIAS ORDER BY nombre`);
    res.json(result.rows);
  } catch (err) { next(err); }
});

// GET /api/contenido/generos/lista
router.get('/generos/lista', async (_req, res, next) => {
  try {
    const result = await db.execute(`SELECT * FROM GENEROS ORDER BY nombre`);
    res.json(result.rows);
  } catch (err) { next(err); }
});

module.exports = router;

