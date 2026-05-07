const { execute } = require('../config/database');

/**
 * Middleware de autenticación simple basado en id_usuario en header.
 * En producción se reemplazaría por JWT.
 */
async function authMiddleware(req, res, next) {
  const userId = req.headers['x-user-id'];
  if (!userId) return res.status(401).json({ error: 'No autenticado. Envía x-user-id en el header.' });

  try {
    const result = await execute(
      `SELECT id_usuario, nombre, apellido, email, estado_cuenta, id_plan, es_moderador
       FROM USUARIOS WHERE id_usuario = :id`,
      [Number(userId)]
    );
    if (!result.rows.length) return res.status(401).json({ error: 'Usuario no encontrado.' });
    const user = result.rows[0];
    if (user.ESTADO_CUENTA !== 'ACTIVO') return res.status(403).json({ error: 'Cuenta inactiva o suspendida.' });
    req.user = user;
    next();
  } catch (err) {
    next(err);
  }
}

function requireModerador(req, res, next) {
  if (!req.user || req.user.ES_MODERADOR !== 'S') {
    return res.status(403).json({ error: 'Se requiere rol de moderador.' });
  }
  next();
}

module.exports = { authMiddleware, requireModerador };

