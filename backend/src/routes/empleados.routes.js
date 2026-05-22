const express = require('express');
const router = express.Router();
const db = require('../config/database');
const { authMiddleware } = require('../middleware/auth.middleware');
const { moderadorMiddleware } = require('../middleware/moderador.middleware');

async function validarSupervisorMismoDepartamento(id_supervisor, id_departamento) {
  if (!id_supervisor) return;

  const result = await db.execute(
    `SELECT id_departamento FROM EMPLEADOS WHERE id_empleado = :sup AND activo = 'S'`,
    { sup: Number(id_supervisor) }
  );

  if (!result.rows.length) {
    const err = new Error('Supervisor no válido o inactivo.');
    err.status = 400;
    throw err;
  }

  if (Number(result.rows[0].ID_DEPARTAMENTO) !== Number(id_departamento)) {
    const err = new Error('El supervisor debe pertenecer al mismo departamento.');
    err.status = 400;
    throw err;
  }
}

// GET /api/empleados — listar todos los empleados
router.get('/', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT e.id_empleado, e.nombre, e.apellido, e.email, e.telefono, 
              e.cargo, e.fecha_ingreso, e.salario, e.activo,
              d.nombre AS departamento, d.id_departamento,
              s.nombre || ' ' || s.apellido AS supervisor,
              (SELECT COUNT(*) FROM EMPLEADOS WHERE id_supervisor = e.id_empleado) AS num_supervisados
       FROM EMPLEADOS e
       JOIN DEPARTAMENTOS d ON e.id_departamento = d.id_departamento
       LEFT JOIN EMPLEADOS s ON e.id_supervisor = s.id_empleado
       ORDER BY d.nombre, e.nombre`
    );
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

// GET /api/empleados/departamentos — listar departamentos
router.get('/departamentos', authMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT d.id_departamento, d.nombre, d.descripcion,
              e.nombre || ' ' || e.apellido AS jefe,
              (SELECT COUNT(*) FROM EMPLEADOS WHERE id_departamento = d.id_departamento AND activo = 'S') AS num_empleados
       FROM DEPARTAMENTOS d
       LEFT JOIN JEFES_DEPARTAMENTO jd ON d.id_departamento = jd.id_departamento AND jd.fecha_fin IS NULL
       LEFT JOIN EMPLEADOS e ON jd.id_empleado = e.id_empleado
       ORDER BY d.nombre`
    );
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

// GET /api/empleados/:id/contenidos — contenido publicado por el empleado
router.get('/:id/contenidos', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT c.id_contenido, c.titulo, c.tipo, c.fecha_agregado, c.clasificacion_edad,
              cat.nombre AS categoria
       FROM CONTENIDO c
       JOIN CATEGORIAS cat ON c.id_categoria = cat.id_categoria
       WHERE c.id_empleado_resp = :id
       ORDER BY c.fecha_agregado DESC`,
      [Number(req.params.id)]
    );
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

// GET /api/empleados/:id — detalle de un empleado
router.get('/:id', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  try {
    const [empRes, supervRes] = await Promise.all([
      db.execute(
        `SELECT e.*, d.nombre AS departamento,
                s.nombre || ' ' || s.apellido AS supervisor
         FROM EMPLEADOS e
         JOIN DEPARTAMENTOS d ON e.id_departamento = d.id_departamento
         LEFT JOIN EMPLEADOS s ON e.id_supervisor = s.id_empleado
         WHERE e.id_empleado = :id`,
        [Number(req.params.id)]
      ),
      db.execute(
        `SELECT id_empleado, nombre || ' ' || apellido AS nombre_completo, cargo
         FROM EMPLEADOS
         WHERE id_supervisor = :id AND activo = 'S'
         ORDER BY nombre`,
        [Number(req.params.id)]
      )
    ]);

    if (!empRes.rows.length) {
      return res.status(404).json({ error: 'Empleado no encontrado.' });
    }

    res.json({
      ...empRes.rows[0],
      supervisados: supervRes.rows
    });
  } catch (err) {
    next(err);
  }
});

// GET /api/empleados/departamento/:id — empleados de un departamento
router.get('/departamento/:id', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT e.id_empleado, e.nombre, e.apellido, e.cargo, e.email,
              s.nombre || ' ' || s.apellido AS supervisor
       FROM EMPLEADOS e
       LEFT JOIN EMPLEADOS s ON e.id_supervisor = s.id_empleado
       WHERE e.id_departamento = :id AND e.activo = 'S'
       ORDER BY e.nombre`,
      [Number(req.params.id)]
    );
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

// GET /api/empleados/:id/jerarquia — jerarquía de supervisión
router.get('/:id/jerarquia', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  try {
    // Obtener toda la jerarquía hacia arriba (supervisores)
    const supervisores = await db.execute(
      `SELECT LEVEL AS nivel, id_empleado, nombre || ' ' || apellido AS nombre_completo, cargo
       FROM EMPLEADOS
       START WITH id_empleado = :id
       CONNECT BY PRIOR id_supervisor = id_empleado
       ORDER BY nivel`,
      [Number(req.params.id)]
    );

    // Obtener toda la jerarquía hacia abajo (supervisados)
    const supervisados = await db.execute(
      `SELECT LEVEL AS nivel, id_empleado, nombre || ' ' || apellido AS nombre_completo, cargo
       FROM EMPLEADOS
       START WITH id_empleado = :id
       CONNECT BY PRIOR id_empleado = id_supervisor
       ORDER BY nivel, nombre`,
      [Number(req.params.id)]
    );

    res.json({
      supervisores: supervisores.rows,
      supervisados: supervisados.rows
    });
  } catch (err) {
    next(err);
  }
});

// POST /api/empleados — crear empleado
router.post('/', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  const { nombre, apellido, email, telefono, cargo, salario, id_departamento, id_supervisor } = req.body;

  if (!nombre || !apellido || !email || !cargo || !id_departamento) {
    return res.status(400).json({ error: 'Faltan campos obligatorios.' });
  }

  try {
    if (id_supervisor) {
      await validarSupervisorMismoDepartamento(id_supervisor, id_departamento);
    }

    const result = await db.execute(
      `INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, 
                              salario, id_departamento, id_supervisor, activo)
       VALUES (:nombre, :apellido, :email, :telefono, :cargo, SYSDATE, 
               :salario, :depto, :supervisor, 'S')
       RETURNING id_empleado INTO :id_out`,
      {
        nombre,
        apellido,
        email,
        telefono: telefono || null,
        cargo,
        salario: salario ? Number(salario) : null,
        depto: Number(id_departamento),
        supervisor: id_supervisor ? Number(id_supervisor) : null,
        id_out: { dir: require('oracledb').BIND_OUT, type: require('oracledb').NUMBER }
      },
      { autoCommit: true }
    );

    res.status(201).json({
      id_empleado: result.outBinds.id_out[0],
      message: 'Empleado creado exitosamente.'
    });
  } catch (err) {
    if (err.message && err.message.includes('ORA-00001')) {
      return res.status(409).json({ error: 'El email ya está registrado.' });
    }
    if (err.status) {
      return res.status(err.status).json({ error: err.message });
    }
    next(err);
  }
});

// PUT /api/empleados/:id — actualizar empleado
router.put('/:id', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  const { nombre, apellido, email, telefono, cargo, salario, id_departamento, id_supervisor } = req.body;

  try {
    if (id_supervisor) {
      if (Number(id_supervisor) === Number(req.params.id)) {
        return res.status(400).json({ error: 'Un empleado no puede ser su propio supervisor.' });
      }
      await validarSupervisorMismoDepartamento(id_supervisor, id_departamento);
    }

    await db.execute(
      `UPDATE EMPLEADOS
       SET nombre = :nombre, apellido = :apellido, email = :email, telefono = :telefono,
           cargo = :cargo, salario = :salario, id_departamento = :depto, id_supervisor = :supervisor
       WHERE id_empleado = :id`,
      {
        nombre,
        apellido,
        email,
        telefono: telefono || null,
        cargo,
        salario: salario ? Number(salario) : null,
        depto: Number(id_departamento),
        supervisor: id_supervisor ? Number(id_supervisor) : null,
        id: Number(req.params.id)
      },
      { autoCommit: true }
    );

    res.json({ message: 'Empleado actualizado exitosamente.' });
  } catch (err) {
    if (err.status) {
      return res.status(err.status).json({ error: err.message });
    }
    next(err);
  }
});

// DELETE /api/empleados/:id — desactivar empleado (eliminación lógica)
router.delete('/:id', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  try {
    await db.execute(
      `UPDATE EMPLEADOS SET activo = 'N' WHERE id_empleado = :id`,
      [Number(req.params.id)],
      { autoCommit: true }
    );

    res.json({ message: 'Empleado desactivado exitosamente.' });
  } catch (err) {
    next(err);
  }
});

// POST /api/empleados/jefe-departamento — asignar jefe de departamento
router.post('/jefe-departamento', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  const { id_departamento, id_empleado } = req.body;

  if (!id_departamento || !id_empleado) {
    return res.status(400).json({ error: 'Faltan campos obligatorios.' });
  }

  try {
    // Finalizar jefatura actual si existe
    await db.execute(
      `UPDATE JEFES_DEPARTAMENTO
       SET fecha_fin = SYSDATE
       WHERE id_departamento = :depto AND fecha_fin IS NULL`,
      { depto: Number(id_departamento) },
      { autoCommit: false }
    );

    // Asignar nuevo jefe
    await db.execute(
      `INSERT INTO JEFES_DEPARTAMENTO (id_departamento, id_empleado, fecha_inicio)
       VALUES (:depto, :emp, SYSDATE)`,
      { depto: Number(id_departamento), emp: Number(id_empleado) },
      { autoCommit: true }
    );

    res.json({ message: 'Jefe de departamento asignado exitosamente.' });
  } catch (err) {
    next(err);
  }
});

// GET /api/empleados/stats/general — estadísticas generales
router.get('/stats/general', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT 
         (SELECT COUNT(*) FROM EMPLEADOS WHERE activo = 'S') AS total_activos,
         (SELECT COUNT(*) FROM EMPLEADOS WHERE activo = 'N') AS total_inactivos,
         (SELECT COUNT(DISTINCT id_departamento) FROM EMPLEADOS WHERE activo = 'S') AS departamentos_con_empleados,
         (SELECT COUNT(*) FROM EMPLEADOS WHERE id_supervisor IS NULL AND activo = 'S') AS sin_supervisor,
         (SELECT ROUND(AVG(salario), 2) FROM EMPLEADOS WHERE activo = 'S' AND salario IS NOT NULL) AS salario_promedio
       FROM DUAL`
    );

    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
