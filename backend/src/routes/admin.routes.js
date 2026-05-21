const express = require('express');
const router  = express.Router();
const db      = require('../config/database');
const { authMiddleware } = require('../middleware/auth.middleware');

// Middleware para verificar que el usuario sea moderador/admin
function adminMiddleware(req, res, next) {
  // Por ahora, permitir a todos los usuarios autenticados
  // En producción, verificar que req.user.es_moderador === 'S'
  next();
}

// ============================================================================
// GESTIÓN DE CONTENIDO
// ============================================================================

// POST /api/admin/contenido — crear nuevo contenido
router.post('/contenido', authMiddleware, adminMiddleware, async (req, res, next) => {
  const { titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, 
          es_original, id_categoria, id_empleado_resp } = req.body;
  
  if (!titulo || !tipo || !anio_lanzamiento || !duracion_min || !clasificacion_edad || !id_categoria) {
    return res.status(400).json({ error: 'Faltan campos obligatorios.' });
  }
  
  try {
    const result = await db.execute(
      `INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, 
                              clasificacion_edad, es_original, id_categoria, id_empleado_resp)
       VALUES (:titulo, :tipo, :anio, :duracion, :sinopsis, :clasificacion, :original, :categoria, :empleado)
       RETURNING id_contenido INTO :id_out`,
      {
        titulo, tipo, anio: Number(anio_lanzamiento), duracion: Number(duracion_min),
        sinopsis: sinopsis || null, clasificacion, original: es_original || 'N',
        categoria: Number(id_categoria), empleado: id_empleado_resp ? Number(id_empleado_resp) : 1,
        id_out: { dir: require('oracledb').BIND_OUT, type: require('oracledb').NUMBER }
      },
      { autoCommit: true }
    );
    
    res.status(201).json({ 
      id_contenido: result.outBinds.id_out[0], 
      message: 'Contenido creado exitosamente.' 
    });
  } catch (err) { next(err); }
});

// POST /api/admin/contenido/:id/generos — asignar género a contenido
router.post('/contenido/:id/generos', authMiddleware, adminMiddleware, async (req, res, next) => {
  const { id_genero } = req.body;
  
  if (!id_genero) {
    return res.status(400).json({ error: 'id_genero es obligatorio.' });
  }
  
  try {
    await db.execute(
      `INSERT INTO CONTENIDO_GENEROS (id_contenido, id_genero) VALUES (:id_contenido, :id_genero)`,
      { id_contenido: Number(req.params.id), id_genero: Number(id_genero) },
      { autoCommit: true }
    );
    res.status(201).json({ message: 'Género asignado exitosamente.' });
  } catch (err) {
    if (err.message && err.message.includes('ORA-00001')) {
      return res.status(409).json({ error: 'Este género ya está asignado al contenido.' });
    }
    next(err);
  }
});

// PUT /api/admin/contenido/:id — actualizar contenido
router.put('/contenido/:id', authMiddleware, adminMiddleware, async (req, res, next) => {
  const { titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, 
          es_original, id_categoria } = req.body;
  
  try {
    await db.execute(
      `UPDATE CONTENIDO 
       SET titulo = :titulo, tipo = :tipo, anio_lanzamiento = :anio, duracion_min = :duracion,
           sinopsis = :sinopsis, clasificacion_edad = :clasificacion, es_original = :original,
           id_categoria = :categoria
       WHERE id_contenido = :id`,
      {
        titulo, tipo, anio: Number(anio_lanzamiento), duracion: Number(duracion_min),
        sinopsis: sinopsis || null, clasificacion, original: es_original || 'N',
        categoria: Number(id_categoria), id: Number(req.params.id)
      },
      { autoCommit: true }
    );
    
    res.json({ message: 'Contenido actualizado exitosamente.' });
  } catch (err) { next(err); }
});

// DELETE /api/admin/contenido/:id — eliminar contenido
router.delete('/contenido/:id', authMiddleware, adminMiddleware, async (req, res, next) => {
  try {
    await db.execute(
      `DELETE FROM CONTENIDO WHERE id_contenido = :id`,
      [Number(req.params.id)],
      { autoCommit: true }
    );
    res.json({ message: 'Contenido eliminado exitosamente.' });
  } catch (err) { next(err); }
});

// ============================================================================
// GESTIÓN DE TEMPORADAS
// ============================================================================

// GET /api/admin/contenido/:id/temporadas — listar temporadas de un contenido
router.get('/contenido/:id/temporadas', authMiddleware, adminMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT t.*, 
              (SELECT COUNT(*) FROM EPISODIOS WHERE id_temporada = t.id_temporada) AS num_episodios
       FROM TEMPORADAS t 
       WHERE t.id_contenido = :id 
       ORDER BY t.numero`,
      [Number(req.params.id)]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// POST /api/admin/contenido/:id/temporadas — crear temporada
router.post('/contenido/:id/temporadas', authMiddleware, adminMiddleware, async (req, res, next) => {
  const { numero, titulo, anio, descripcion } = req.body;
  
  if (!numero) {
    return res.status(400).json({ error: 'El número de temporada es obligatorio.' });
  }
  
  try {
    const result = await db.execute(
      `INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio, descripcion)
       VALUES (:id_contenido, :numero, :titulo, :anio, :descripcion)
       RETURNING id_temporada INTO :id_out`,
      {
        id_contenido: Number(req.params.id),
        numero: Number(numero),
        titulo: titulo || null,
        anio: anio ? Number(anio) : null,
        descripcion: descripcion || null,
        id_out: { dir: require('oracledb').BIND_OUT, type: require('oracledb').NUMBER }
      },
      { autoCommit: true }
    );
    
    res.status(201).json({ 
      id_temporada: result.outBinds.id_out[0], 
      message: 'Temporada creada exitosamente.' 
    });
  } catch (err) { next(err); }
});

// DELETE /api/admin/temporadas/:id — eliminar temporada
router.delete('/temporadas/:id', authMiddleware, adminMiddleware, async (req, res, next) => {
  try {
    await db.execute(
      `DELETE FROM TEMPORADAS WHERE id_temporada = :id`,
      [Number(req.params.id)],
      { autoCommit: true }
    );
    res.json({ message: 'Temporada eliminada exitosamente.' });
  } catch (err) { next(err); }
});

// ============================================================================
// GESTIÓN DE EPISODIOS
// ============================================================================

// GET /api/admin/temporadas/:id/episodios — listar episodios de una temporada
router.get('/temporadas/:id/episodios', authMiddleware, adminMiddleware, async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT * FROM EPISODIOS WHERE id_temporada = :id ORDER BY numero`,
      [Number(req.params.id)]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// POST /api/admin/temporadas/:id/episodios — crear episodio
router.post('/temporadas/:id/episodios', authMiddleware, adminMiddleware, async (req, res, next) => {
  const { numero, titulo, duracion_min, sinopsis, fecha_estreno } = req.body;
  
  if (!numero || !titulo || !duracion_min) {
    return res.status(400).json({ error: 'Número, título y duración son obligatorios.' });
  }
  
  try {
    const result = await db.execute(
      `INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min, sinopsis, fecha_estreno)
       VALUES (:id_temporada, :numero, :titulo, :duracion, :sinopsis, 
               ${fecha_estreno ? "TO_DATE(:fecha_estreno, 'YYYY-MM-DD')" : 'NULL'})
       RETURNING id_episodio INTO :id_out`,
      {
        id_temporada: Number(req.params.id),
        numero: Number(numero),
        titulo,
        duracion: Number(duracion_min),
        sinopsis: sinopsis || null,
        ...(fecha_estreno && { fecha_estreno }),
        id_out: { dir: require('oracledb').BIND_OUT, type: require('oracledb').NUMBER }
      },
      { autoCommit: true }
    );
    
    res.status(201).json({ 
      id_episodio: result.outBinds.id_out[0], 
      message: 'Episodio creado exitosamente.' 
    });
  } catch (err) { next(err); }
});

// DELETE /api/admin/episodios/:id — eliminar episodio
router.delete('/episodios/:id', authMiddleware, adminMiddleware, async (req, res, next) => {
  try {
    await db.execute(
      `DELETE FROM EPISODIOS WHERE id_episodio = :id`,
      [Number(req.params.id)],
      { autoCommit: true }
    );
    res.json({ message: 'Episodio eliminado exitosamente.' });
  } catch (err) { next(err); }
});

// ============================================================================
// LISTAS AUXILIARES
// ============================================================================

// GET /api/admin/empleados — listar empleados para asignar responsables
router.get('/empleados', async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT e.id_empleado, e.nombre, e.apellido, e.cargo, d.nombre AS departamento
       FROM EMPLEADOS e
       JOIN DEPARTAMENTOS d ON e.id_departamento = d.id_departamento
       WHERE e.activo = 'S'
       ORDER BY e.nombre, e.apellido`,
      []
    );
    res.json(result.rows);
  } catch (err) { 
    console.error('Error al obtener empleados:', err);
    res.status(500).json({ error: 'Error al obtener empleados: ' + err.message });
  }
});

module.exports = router;
