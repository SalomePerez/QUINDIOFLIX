const express = require('express');
const router  = express.Router();
const db      = require('../config/database');
const { authMiddleware } = require('../middleware/auth.middleware');

// GET /api/usuarios/:id — perfil completo del usuario
router.get('/:id', authMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT u.id_usuario, u.nombre, u.apellido, u.email, u.telefono,
              u.ciudad, u.estado_cuenta, u.fecha_registro, u.fecha_ultimo_pago,
              u.es_moderador,
              p.nombre AS plan, p.precio_mensual, p.max_perfiles, p.calidad_video, p.num_pantallas,
              (SELECT nombre||' '||apellido FROM USUARIOS WHERE id_usuario=u.id_referidor) AS referidor
       FROM USUARIOS u JOIN PLANES p ON u.id_plan=p.id_plan
       WHERE u.id_usuario=:id`,
      [Number(req.params.id)]
    );
    if (!result.rows.length) return res.status(404).json({ error: 'Usuario no encontrado.' });
    res.json(result.rows[0]);
  } catch (err) { next(err); }
});

// GET /api/usuarios/:id/perfiles
router.get('/:id/perfiles', authMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT id_perfil, nombre, avatar, tipo, activo, fecha_creacion
       FROM PERFILES WHERE id_usuario=:id AND activo='S' ORDER BY id_perfil`,
      [Number(req.params.id)]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// POST /api/usuarios/:id/perfiles — crear perfil
router.post('/:id/perfiles', authMiddleware, async (req, res, next) => {
  const { nombre, avatar, tipo } = req.body;
  if (!nombre) return res.status(400).json({ error: 'Nombre del perfil requerido.' });
  try {
    await db.execute(
      `INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo)
       VALUES (:u, :n, :a, :t)`,
      { u: Number(req.params.id), n: nombre, a: avatar || 'avatar_default.png', t: tipo || 'ADULTO' },
      { autoCommit: true }
    );
    res.status(201).json({ message: 'Perfil creado.' });
  } catch (err) {
    if (err.message && err.message.includes('20012'))
      return res.status(400).json({ error: err.message.split('ORA-20012:')[1] || 'Límite de perfiles alcanzado.' });
    next(err);
  }
});

// PUT /api/usuarios/:id/plan — cambiar plan
router.put('/:id/plan', authMiddleware, async (req, res, next) => {
  const { id_plan_nuevo, motivo } = req.body;
  if (!id_plan_nuevo) return res.status(400).json({ error: 'id_plan_nuevo requerido.' });
  try {
    await db.executeProc(
      `BEGIN SP_CAMBIAR_PLAN(:id, :plan, :motivo); END;`,
      { id: Number(req.params.id), plan: Number(id_plan_nuevo), motivo: motivo || null }
    );
    res.json({ message: 'Plan actualizado exitosamente.' });
  } catch (err) {
    if (err.message && err.message.includes('20003'))
      return res.status(400).json({ error: 'No puedes bajar de plan: tienes más perfiles de los permitidos.' });
    next(err);
  }
});

// GET /api/usuarios/:id/pagos — historial de pagos
router.get('/:id/pagos', authMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT id_pago, fecha_pago, monto, metodo_pago, estado_pago,
              periodo_mes, periodo_anio, descuento_pct
       FROM PAGOS WHERE id_usuario=:id ORDER BY fecha_pago DESC`,
      [Number(req.params.id)]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// GET /api/usuarios/:id/favoritos/:id_perfil
router.get('/:id/favoritos/:id_perfil', authMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT c.id_contenido, c.titulo, c.tipo, c.clasificacion_edad,
              cat.nombre AS categoria, f.fecha_agregado
       FROM FAVORITOS f
       JOIN CONTENIDO  c   ON f.id_contenido=c.id_contenido
       JOIN CATEGORIAS cat ON c.id_categoria=cat.id_categoria
       WHERE f.id_perfil=:p ORDER BY f.fecha_agregado DESC`,
      [Number(req.params.id_perfil)]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// GET /api/usuarios/:id/recomendacion/:id_perfil
router.get('/:id/recomendacion/:id_perfil', authMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT FN_CONTENIDO_RECOMENDADO(:p) AS recomendado FROM DUAL`,
      [Number(req.params.id_perfil)]
    );
    res.json({ recomendado: result.rows[0].RECOMENDADO });
  } catch (err) { next(err); }
});

// GET /api/usuarios/:id/monto-proximo
router.get('/:id/monto-proximo', authMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT FN_CALCULAR_MONTO(:id) AS monto FROM DUAL`,
      [Number(req.params.id)]
    );
    res.json({ monto: result.rows[0].MONTO });
  } catch (err) { next(err); }
});

// GET /api/usuarios/:id/reporte-consumo
router.get('/:id/reporte-consumo', authMiddleware, async (req, res, next) => {
  const { fecha_inicio, fecha_fin } = req.query;
  if (!fecha_inicio || !fecha_fin) return res.status(400).json({ error: 'fecha_inicio y fecha_fin requeridos (YYYY-MM-DD).' });
  try {
    const result = await db.execute(
      `SELECT r.id_reproduccion, p.nombre AS perfil, c.titulo, cat.nombre AS categoria,
              r.dispositivo, r.fecha_hora_inicio, r.fecha_hora_fin, r.porcentaje_avance,
              ROUND((CAST(r.fecha_hora_fin AS DATE)-CAST(r.fecha_hora_inicio AS DATE))*1440,0) AS minutos
       FROM REPRODUCCIONES r
       JOIN PERFILES   p   ON r.id_perfil=p.id_perfil
       JOIN CONTENIDO  c   ON r.id_contenido=c.id_contenido
       JOIN CATEGORIAS cat ON c.id_categoria=cat.id_categoria
       WHERE p.id_usuario=:id
         AND r.fecha_hora_inicio >= TO_TIMESTAMP(:fi,'YYYY-MM-DD')
         AND r.fecha_hora_inicio <  TO_TIMESTAMP(:ff,'YYYY-MM-DD') + INTERVAL '1' DAY
       ORDER BY r.fecha_hora_inicio DESC`,
      { id: Number(req.params.id), fi: fecha_inicio, ff: fecha_fin }
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

module.exports = router;

