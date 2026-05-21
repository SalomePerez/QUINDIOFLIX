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
router.post('/contenido', async (req, res, next) => {
  const { titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, 
          es_original, id_categoria, id_empleado_resp } = req.body;
  
  console.log('Datos recibidos:', req.body);
  
  if (!titulo || !tipo || !anio_lanzamiento || !duracion_min || !clasificacion_edad) {
    return res.status(400).json({ error: 'Faltan campos obligatorios.' });
  }
  
  try {
    const result = await db.execute(
      `INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, 
                              clasificacion_edad, es_original, id_categoria, id_empleado_resp)
       VALUES (:titulo, :tipo, :anio, :duracion, :sinopsis, :clasificacion, :original, :categoria, :empleado)
       RETURNING id_contenido INTO :id_out`,
      {
        titulo, 
        tipo, 
        anio: Number(anio_lanzamiento), 
        duracion: Number(duracion_min),
        sinopsis: sinopsis || null, 
        clasificacion: clasificacion_edad, 
        original: es_original || 'N',
        categoria: id_categoria ? Number(id_categoria) : 1,
        empleado: id_empleado_resp ? Number(id_empleado_resp) : 1,
        id_out: { dir: require('oracledb').BIND_OUT, type: require('oracledb').NUMBER }
      },
      { autoCommit: true }
    );
    
    res.status(201).json({ 
      id_contenido: result.outBinds.id_out[0], 
      message: 'Contenido creado exitosamente.' 
    });
  } catch (err) { 
    console.error('Error al crear contenido:', err);
    res.status(500).json({ error: 'Error al crear contenido: ' + err.message });
  }
});

// GET /api/admin/contenido/:id — obtener contenido para editar
router.get('/contenido/:id', async (req, res, next) => {
  try {
    const [contRes, genRes] = await Promise.all([
      db.execute(
        `SELECT * FROM CONTENIDO WHERE id_contenido = :id`,
        [Number(req.params.id)]
      ),
      db.execute(
        `SELECT id_genero FROM CONTENIDO_GENEROS WHERE id_contenido = :id`,
        [Number(req.params.id)]
      )
    ]);
    
    if (!contRes.rows.length) {
      return res.status(404).json({ error: 'Contenido no encontrado.' });
    }
    
    res.json({
      ...contRes.rows[0],
      generos: genRes.rows.map(r => r.ID_GENERO)
    });
  } catch (err) {
    console.error('Error al obtener contenido:', err);
    res.status(500).json({ error: 'Error al obtener contenido: ' + err.message });
  }
});

// POST /api/admin/contenido/:id/generos — asignar género a contenido
router.post('/contenido/:id/generos', async (req, res, next) => {
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
    console.error('Error al asignar género:', err);
    if (err.message && err.message.includes('ORA-00001')) {
      return res.status(409).json({ error: 'Este género ya está asignado al contenido.' });
    }
    res.status(500).json({ error: 'Error al asignar género: ' + err.message });
  }
});

// PUT /api/admin/contenido/:id — actualizar contenido
router.put('/contenido/:id', async (req, res, next) => {
  const { titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, 
          es_original, id_categoria, id_empleado_resp, generos } = req.body;
  
  console.log('Actualizando contenido:', req.params.id, req.body);
  
  const oracledb = require('oracledb');
  let conn;
  
  try {
    // Obtener conexión del pool
    conn = await oracledb.getPool().getConnection();
    const id = Number(req.params.id);
    
    // Actualizar contenido
    await conn.execute(
      `UPDATE CONTENIDO 
       SET titulo = :titulo, tipo = :tipo, anio_lanzamiento = :anio, duracion_min = :duracion,
           sinopsis = :sinopsis, clasificacion_edad = :clasificacion, es_original = :original,
           id_categoria = :categoria, id_empleado_resp = :empleado
       WHERE id_contenido = :id`,
      {
        titulo, 
        tipo, 
        anio: Number(anio_lanzamiento), 
        duracion: Number(duracion_min),
        sinopsis: sinopsis || null, 
        clasificacion: clasificacion_edad, 
        original: es_original || 'N',
        categoria: id_categoria ? Number(id_categoria) : 1,
        empleado: id_empleado_resp ? Number(id_empleado_resp) : 1,
        id: id
      }
    );
    
    console.log('Contenido actualizado');
    
    // Actualizar géneros si se proporcionaron
    if (generos && Array.isArray(generos)) {
      // Eliminar géneros actuales
      await conn.execute(
        `DELETE FROM CONTENIDO_GENEROS WHERE id_contenido = :id`,
        [id]
      );
      
      console.log('Géneros antiguos eliminados');
      
      // Insertar nuevos géneros
      for (const id_genero of generos) {
        await conn.execute(
          `INSERT INTO CONTENIDO_GENEROS (id_contenido, id_genero) VALUES (:id_contenido, :id_genero)`,
          { id_contenido: id, id_genero: Number(id_genero) }
        );
      }
      
      console.log('Nuevos géneros insertados:', generos.length);
    }
    
    await conn.commit();
    console.log('Transacción confirmada');
    
    res.json({ message: 'Contenido actualizado exitosamente.' });
  } catch (err) { 
    if (conn) {
      try {
        await conn.rollback();
        console.log('Rollback ejecutado');
      } catch (rollbackErr) {
        console.error('Error en rollback:', rollbackErr);
      }
    }
    console.error('Error al actualizar contenido:', err);
    res.status(500).json({ error: 'Error al actualizar contenido: ' + err.message });
  } finally {
    if (conn) {
      try {
        await conn.close();
      } catch (err) {
        console.error('Error al cerrar conexión:', err);
      }
    }
  }
});

// DELETE /api/admin/contenido/:id — eliminar contenido
router.delete('/contenido/:id', async (req, res, next) => {
  const oracledb = require('oracledb');
  let conn;
  
  try {
    // Obtener conexión del pool
    conn = await oracledb.getPool().getConnection();
    const id = Number(req.params.id);
    console.log('Intentando eliminar contenido ID:', id);
    
    // Eliminar en orden para evitar problemas de FK
    await conn.execute(`DELETE FROM CONTENIDO_GENEROS WHERE id_contenido = :id`, [id]);
    console.log('Géneros eliminados');
    
    await conn.execute(`DELETE FROM FAVORITOS WHERE id_contenido = :id`, [id]);
    console.log('Favoritos eliminados');
    
    await conn.execute(`DELETE FROM CALIFICACIONES WHERE id_contenido = :id`, [id]);
    console.log('Calificaciones eliminadas');
    
    await conn.execute(`DELETE FROM REPRODUCCIONES WHERE id_contenido = :id`, [id]);
    console.log('Reproducciones eliminadas');
    
    await conn.execute(`DELETE FROM REPORTES WHERE id_contenido = :id`, [id]);
    console.log('Reportes eliminados');
    
    await conn.execute(`DELETE FROM CONTENIDO_RELACIONADO WHERE id_contenido_origen = :id OR id_contenido_destino = :id`, [id, id]);
    console.log('Contenido relacionado eliminado');
    
    // Eliminar episodios de temporadas
    await conn.execute(
      `DELETE FROM EPISODIOS WHERE id_temporada IN (SELECT id_temporada FROM TEMPORADAS WHERE id_contenido = :id)`, 
      [id]
    );
    console.log('Episodios eliminados');
    
    // Eliminar temporadas
    await conn.execute(`DELETE FROM TEMPORADAS WHERE id_contenido = :id`, [id]);
    console.log('Temporadas eliminadas');
    
    // Finalmente eliminar el contenido
    const result = await conn.execute(`DELETE FROM CONTENIDO WHERE id_contenido = :id`, [id]);
    console.log('Contenido eliminado, filas afectadas:', result.rowsAffected);
    
    await conn.commit();
    
    res.json({ message: 'Contenido eliminado exitosamente.' });
  } catch (err) { 
    if (conn) {
      try {
        await conn.rollback();
      } catch (rollbackErr) {
        console.error('Error en rollback:', rollbackErr);
      }
    }
    console.error('Error al eliminar contenido:', err);
    res.status(500).json({ error: 'Error al eliminar contenido: ' + err.message });
  } finally {
    if (conn) {
      try {
        await conn.close();
      } catch (err) {
        console.error('Error al cerrar conexión:', err);
      }
    }
  }
});

// ============================================================================
// GESTIÓN DE CONTENIDO RELACIONADO
// ============================================================================

// GET /api/admin/contenido/:id/relacionados — listar contenido relacionado
router.get('/contenido/:id/relacionados', async (req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT cr.id_contenido_destino, cr.tipo_relacion, cr.descripcion,
              c.titulo, c.tipo, c.anio_lanzamiento, c.clasificacion_edad
       FROM CONTENIDO_RELACIONADO cr
       JOIN CONTENIDO c ON cr.id_contenido_destino = c.id_contenido
       WHERE cr.id_contenido_origen = :id
       ORDER BY cr.tipo_relacion, c.titulo`,
      [Number(req.params.id)]
    );
    res.json(result.rows);
  } catch (err) {
    console.error('Error al obtener contenido relacionado:', err);
    res.status(500).json({ error: 'Error al obtener contenido relacionado: ' + err.message });
  }
});

// POST /api/admin/contenido/:id/relacionados — agregar contenido relacionado
router.post('/contenido/:id/relacionados', async (req, res, next) => {
  const { id_contenido_destino, tipo_relacion, descripcion } = req.body;
  
  if (!id_contenido_destino || !tipo_relacion) {
    return res.status(400).json({ error: 'id_contenido_destino y tipo_relacion son obligatorios.' });
  }
  
  // Validar que el tipo de relación sea válido
  const tiposValidos = ['SECUELA', 'PRECUELA', 'REMAKE', 'SPIN_OFF', 'VERSION_EXTENDIDA', 'ADAPTACION', 'OTRO'];
  if (!tiposValidos.includes(tipo_relacion)) {
    return res.status(400).json({ error: 'Tipo de relación no válido.' });
  }
  
  try {
    await db.execute(
      `INSERT INTO CONTENIDO_RELACIONADO (id_contenido_origen, id_contenido_destino, tipo_relacion, descripcion)
       VALUES (:origen, :destino, :tipo, :descripcion)`,
      {
        origen: Number(req.params.id),
        destino: Number(id_contenido_destino),
        tipo: tipo_relacion,
        descripcion: descripcion || null
      },
      { autoCommit: true }
    );
    res.status(201).json({ message: 'Relación creada exitosamente.' });
  } catch (err) {
    console.error('Error al crear relación:', err);
    if (err.message && err.message.includes('ORA-00001')) {
      return res.status(409).json({ error: 'Esta relación ya existe.' });
    }
    if (err.message && err.message.includes('ORA-02291')) {
      return res.status(404).json({ error: 'El contenido destino no existe.' });
    }
    res.status(500).json({ error: 'Error al crear relación: ' + err.message });
  }
});

// DELETE /api/admin/contenido/:id/relacionados/:id_destino — eliminar relación
router.delete('/contenido/:id/relacionados/:id_destino', async (req, res, next) => {
  try {
    await db.execute(
      `DELETE FROM CONTENIDO_RELACIONADO 
       WHERE id_contenido_origen = :origen AND id_contenido_destino = :destino`,
      {
        origen: Number(req.params.id),
        destino: Number(req.params.id_destino)
      },
      { autoCommit: true }
    );
    res.json({ message: 'Relación eliminada exitosamente.' });
  } catch (err) {
    console.error('Error al eliminar relación:', err);
    res.status(500).json({ error: 'Error al eliminar relación: ' + err.message });
  }
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
