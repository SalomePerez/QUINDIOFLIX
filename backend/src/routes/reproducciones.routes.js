const express = require('express');
const router  = express.Router();
const db      = require('../config/database');
const { authMiddleware } = require('../middleware/auth.middleware');

// POST /api/reproducciones — registrar inicio de reproducción
router.post('/', authMiddleware, async (req, res, next) => {
  const { id_perfil, id_contenido, id_episodio, dispositivo } = req.body;
  if (!id_perfil || !id_contenido || !dispositivo)
    return res.status(400).json({ error: 'id_perfil, id_contenido y dispositivo son requeridos.' });
  try {
    const result = await db.execute(
      `INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, id_episodio, fecha_hora_inicio, dispositivo, porcentaje_avance)
       VALUES (:p, :c, :e, SYSTIMESTAMP, :d, 0)
       RETURNING id_reproduccion INTO :id`,
      {
        p: Number(id_perfil), c: Number(id_contenido),
        e: id_episodio ? Number(id_episodio) : null,
        d: dispositivo.toUpperCase(),
        id: { dir: require('oracledb').BIND_OUT, type: require('oracledb').NUMBER }
      },
      { autoCommit: true }
    );
    res.status(201).json({ id_reproduccion: result.outBinds.id, message: 'Reproducción iniciada.' });
  } catch (err) {
    if (err.message && err.message.includes('20010'))
      return res.status(403).json({ error: 'Cuenta inactiva. No se puede reproducir.' });
    if (err.message && err.message.includes('20016'))
      return res.status(403).json({ error: 'Contenido no permitido para perfil infantil.' });
    next(err);
  }
});

// PUT /api/reproducciones/:id — actualizar progreso
router.put('/:id', authMiddleware, async (req, res, next) => {
  const { porcentaje_avance, finalizar } = req.body;
  try {
    await db.execute(
      `UPDATE REPRODUCCIONES
       SET porcentaje_avance = :p,
           fecha_hora_fin    = CASE WHEN :fin = 1 THEN SYSTIMESTAMP ELSE fecha_hora_fin END
       WHERE id_reproduccion = :id`,
      { p: Number(porcentaje_avance || 0), fin: finalizar ? 1 : 0, id: Number(req.params.id) },
      { autoCommit: true }
    );
    res.json({ message: 'Progreso actualizado.' });
  } catch (err) { next(err); }
});

// GET /api/reproducciones/perfil/:id_perfil — historial de un perfil
router.get('/perfil/:id_perfil', authMiddleware, async (req, res, next) => {
  const { limit = 20 } = req.query;
  try {
    const result = await db.execute(
      `SELECT r.id_reproduccion, c.titulo, cat.nombre AS categoria, c.tipo,
              r.dispositivo, r.fecha_hora_inicio, r.porcentaje_avance,
              e.titulo AS episodio
       FROM REPRODUCCIONES r
       JOIN CONTENIDO  c   ON r.id_contenido=c.id_contenido
       JOIN CATEGORIAS cat ON c.id_categoria=cat.id_categoria
       LEFT JOIN EPISODIOS e ON r.id_episodio=e.id_episodio
       WHERE r.id_perfil=:p
       ORDER BY r.fecha_hora_inicio DESC
       FETCH FIRST :lim ROWS ONLY`,
      { p: Number(req.params.id_perfil), lim: Number(limit) }
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

module.exports = router;

