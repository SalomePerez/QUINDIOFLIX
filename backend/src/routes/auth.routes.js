const express = require('express');
const router  = express.Router();
const db      = require('../config/database');

// POST /api/auth/login  — recibe email, devuelve datos del usuario
router.post('/login', async (req, res, next) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ error: 'Email requerido.' });
  try {
    const result = await db.execute(
      `SELECT u.id_usuario, u.nombre, u.apellido, u.email, u.ciudad,
              u.estado_cuenta, u.fecha_registro, u.es_moderador,
              p.nombre AS plan, p.precio_mensual, p.max_perfiles, p.calidad_video
       FROM USUARIOS u JOIN PLANES p ON u.id_plan = p.id_plan
       WHERE LOWER(u.email) = LOWER(:email)`,
      [email]
    );
    if (!result.rows.length) return res.status(404).json({ error: 'Usuario no encontrado.' });
    const user = result.rows[0];
    if (user.ESTADO_CUENTA !== 'ACTIVO') return res.status(403).json({ error: 'Cuenta inactiva.' });
    res.json({ user });
  } catch (err) { next(err); }
});

// POST /api/auth/register — llama SP_REGISTRAR_USUARIO
router.post('/register', async (req, res, next) => {
  const { nombre, apellido, email, telefono, fecha_nacimiento, ciudad, id_plan, id_referidor } = req.body;
  if (!nombre || !apellido || !email || !fecha_nacimiento || !ciudad || !id_plan)
    return res.status(400).json({ error: 'Faltan campos obligatorios.' });
  try {
    const result = await db.executeProc(
      `BEGIN SP_REGISTRAR_USUARIO(:nombre,:apellido,:email,:telefono,
         TO_DATE(:fnac,'YYYY-MM-DD'),:ciudad,:id_plan,:id_ref,'PSE',:id_out); END;`,
      {
        nombre, apellido, email,
        telefono: telefono || null,
        fnac: fecha_nacimiento,
        ciudad,
        id_plan: Number(id_plan),
        id_ref: id_referidor ? Number(id_referidor) : null,
        id_out: { dir: require('oracledb').BIND_OUT, type: require('oracledb').NUMBER }
      }
    );
    res.status(201).json({ id_usuario: result.outBinds.id_out, message: 'Usuario registrado exitosamente.' });
  } catch (err) {
    if (err.message && err.message.includes('20001'))
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

