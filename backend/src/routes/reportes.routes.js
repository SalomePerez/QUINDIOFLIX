const express = require('express');
const router  = express.Router();
const db      = require('../config/database');
const { authMiddleware } = require('../middleware/auth.middleware');
const { moderadorMiddleware } = require('../middleware/moderador.middleware');

// GET /api/reportes — listar todos los reportes (solo moderadores)
router.get('/', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  const { estado, limit = 50 } = req.query;
  const binds = {};
  let where = 'WHERE 1=1';
  
  if (estado) {
    where += ' AND r.estado = :estado';
    binds.estado = estado.toUpperCase();
  }
  
  try {
    const result = await db.execute(
      `SELECT r.id_reporte, r.motivo, r.descripcion, r.estado, r.fecha_reporte,
              r.fecha_resolucion, r.resolucion_nota,
              p.nombre AS perfil_reportante, u.nombre||' '||u.apellido AS usuario_reportante,
              c.id_contenido, c.titulo AS contenido_titulo, c.tipo AS contenido_tipo,
              c.clasificacion_edad,
              m.nombre||' '||m.apellido AS moderador_nombre
       FROM REPORTES r
       JOIN PERFILES p ON r.id_perfil = p.id_perfil
       JOIN USUARIOS u ON p.id_usuario = u.id_usuario
       JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
       LEFT JOIN USUARIOS m ON r.id_moderador = m.id_usuario
       ${where}
       ORDER BY 
         CASE r.estado 
           WHEN 'PENDIENTE' THEN 1 
           WHEN 'EN_REVISION' THEN 2 
           WHEN 'RESUELTO' THEN 3 
           WHEN 'RECHAZADO' THEN 4 
         END,
         r.fecha_reporte ASC
       FETCH FIRST :limit ROWS ONLY`,
      { ...binds, limit: Number(limit) }
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// GET /api/reportes/pendientes — reportes pendientes (solo moderadores)
router.get('/pendientes', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT r.id_reporte, r.motivo, r.descripcion, r.estado, r.fecha_reporte,
              p.nombre AS perfil_reportante, u.nombre||' '||u.apellido AS usuario_reportante,
              c.id_contenido, c.titulo AS contenido_titulo, c.tipo AS contenido_tipo,
              c.clasificacion_edad
       FROM REPORTES r
       JOIN PERFILES p ON r.id_perfil = p.id_perfil
       JOIN USUARIOS u ON p.id_usuario = u.id_usuario
       JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
       WHERE r.estado = 'PENDIENTE'
       ORDER BY r.fecha_reporte ASC`
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// GET /api/reportes/stats — estadísticas de reportes (solo moderadores)
router.get('/stats', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT 
         COUNT(*) AS total,
         SUM(CASE WHEN estado = 'PENDIENTE' THEN 1 ELSE 0 END) AS pendientes,
         SUM(CASE WHEN estado = 'EN_REVISION' THEN 1 ELSE 0 END) AS en_revision,
         SUM(CASE WHEN estado = 'RESUELTO' THEN 1 ELSE 0 END) AS resueltos,
         SUM(CASE WHEN estado = 'RECHAZADO' THEN 1 ELSE 0 END) AS rechazados
       FROM REPORTES`
    );
    res.json(result.rows[0]);
  } catch (err) { next(err); }
});

// PUT /api/reportes/:id/revisar — marcar reporte como en revisión
router.put('/:id/revisar', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  try {
    await db.execute(
      `UPDATE REPORTES 
       SET estado = 'EN_REVISION', 
           id_moderador = :mod
       WHERE id_reporte = :id AND estado = 'PENDIENTE'`,
      { mod: Number(req.user.ID_USUARIO), id: Number(req.params.id) },
      { autoCommit: true }
    );
    res.json({ message: 'Reporte marcado como en revisión.' });
  } catch (err) { next(err); }
});

// PUT /api/reportes/:id/resolver — resolver reporte
router.put('/:id/resolver', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  const { resolucion_nota } = req.body;
  
  try {
    await db.execute(
      `UPDATE REPORTES 
       SET estado = 'RESUELTO',
           fecha_resolucion = SYSDATE,
           resolucion_nota = :nota,
           id_moderador = :mod
       WHERE id_reporte = :id`,
      { 
        nota: resolucion_nota || null, 
        mod: Number(req.user.ID_USUARIO), 
        id: Number(req.params.id) 
      },
      { autoCommit: true }
    );
    res.json({ message: 'Reporte resuelto exitosamente.' });
  } catch (err) { next(err); }
});

// PUT /api/reportes/:id/rechazar — rechazar reporte
router.put('/:id/rechazar', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  const { resolucion_nota } = req.body;
  
  try {
    await db.execute(
      `UPDATE REPORTES 
       SET estado = 'RECHAZADO',
           fecha_resolucion = SYSDATE,
           resolucion_nota = :nota,
           id_moderador = :mod
       WHERE id_reporte = :id`,
      { 
        nota: resolucion_nota || null, 
        mod: Number(req.user.ID_USUARIO), 
        id: Number(req.params.id) 
      },
      { autoCommit: true }
    );
    res.json({ message: 'Reporte rechazado.' });
  } catch (err) { next(err); }
});

module.exports = router;
