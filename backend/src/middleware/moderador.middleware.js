// Middleware para verificar que el usuario es moderador

function moderadorMiddleware(req, res, next) {
  // El authMiddleware ya debe haber ejecutado y agregado req.user
  if (!req.user) {
    return res.status(401).json({ error: 'No autenticado.' });
  }

  // Verificar que el usuario tiene rol de moderador
  if (req.user.ES_MODERADOR !== 'S') {
    return res.status(403).json({ error: 'Acceso denegado. Solo moderadores pueden acceder a este recurso.' });
  }

  next();
}

module.exports = { moderadorMiddleware };
