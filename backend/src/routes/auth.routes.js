const express = require('express');
const router  = express.Router();
const db      = require('../config/database');
const bcrypt  = require('bcryptjs');

// POST /api/auth/login  — recibe email y password, devuelve datos del usuario
router.post('/login', async (req, res, next) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ error: 'Email y contraseña requeridos.' });
  try {
    const result = await db.execute(
      `SELECT u.id_usuario, u.nombre, u.apellido, u.email, u.ciudad,
              u.estado_cuenta, u.fecha_registro, u.es_moderador, u.password_hash,
              p.nombre AS plan, p.precio_mensual, p.max_perfiles, p.calidad_video
       FROM USUARIOS u JOIN PLANES p ON u.id_plan = p.id_plan
       WHERE LOWER(u.email) = LOWER(:email)`,
      [email]
    );
    if (!result.rows.length) return res.status(404).json({ error: 'Usuario no encontrado.' });
    const user = result.rows[0];
    
    // Verificar contraseña
    if (!user.PASSWORD_HASH) {
      return res.status(401).json({ error: 'Este usuario no tiene contraseña configurada. Contacta al administrador.' });
    }
    const passwordMatch = await bcrypt.compare(password, user.PASSWORD_HASH);
    if (!passwordMatch) {
      return res.status(401).json({ error: 'Contraseña incorrecta.' });
    }
    
    if (user.ESTADO_CUENTA !== 'ACTIVO') return res.status(403).json({ error: 'Cuenta inactiva.' });
    
    // No enviar el hash de la contraseña al frontend
    delete user.PASSWORD_HASH;
    res.json({ user });
  } catch (err) { next(err); }
});

// POST /api/auth/register — registra usuario con contraseña
router.post('/register', async (req, res, next) => {
  const { nombre, apellido, email, password, telefono, fecha_nacimiento, ciudad, id_plan, id_referidor } = req.body;
  if (!nombre || !apellido || !email || !password || !fecha_nacimiento || !ciudad || !id_plan)
    return res.status(400).json({ error: 'Faltan campos obligatorios.' });
  
  // Validar contraseña
  if (password.length < 6) {
    return res.status(400).json({ error: 'La contraseña debe tener al menos 6 caracteres.' });
  }
  
  try {
    // Hashear contraseña
    const password_hash = await bcrypt.hash(password, 10);
    
    // Insertar usuario directamente (sin usar el procedimiento almacenado por ahora)
    const insertResult = await db.execute(
      `INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, 
                             id_plan, id_referidor, password_hash, estado_cuenta, es_moderador)
       VALUES (:nombre, :apellido, :email, :telefono, TO_DATE(:fnac,'YYYY-MM-DD'), :ciudad,
               :id_plan, :id_ref, :password_hash, 'ACTIVO', 'N')
       RETURNING id_usuario INTO :id_out`,
      {
        nombre, apellido, email,
        telefono: telefono || null,
        fnac: fecha_nacimiento,
        ciudad,
        id_plan: Number(id_plan),
        id_ref: id_referidor ? Number(id_referidor) : null,
        password_hash,
        id_out: { dir: require('oracledb').BIND_OUT, type: require('oracledb').NUMBER }
      },
      { autoCommit: true }
    );
    
    const id_usuario = insertResult.outBinds.id_out[0];
    
    // Crear perfil principal automáticamente
    await db.execute(
      `INSERT INTO PERFILES (id_usuario, nombre, tipo, activo)
       VALUES (:id_usuario, :nombre, 'ADULTO', 'S')`,
      { id_usuario, nombre },
      { autoCommit: true }
    );
    
    res.status(201).json({ id_usuario, message: 'Usuario registrado exitosamente.' });
  } catch (err) {
    if (err.message && err.message.includes('ORA-00001'))
      return res.status(409).json({ error: 'El email ya está registrado.' });
    next(err);
  }
});

// GET /api/auth/perfiles/:id_usuario — perfiles de una cuenta
router.get('/perfiles/:id_usuario', async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT id_perfil, nombre, avatar, tipo, activo, fecha_creacion
       FROM PERFILES WHERE id_usuario = :id AND activo = 'S' ORDER BY id_perfil`,
      [Number(req.params.id_usuario)]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

module.exports = router;

