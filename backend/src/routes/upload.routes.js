const express = require('express');
const router = express.Router();
const path = require('path');
const db = require('../config/database');
const { authMiddleware } = require('../middleware/auth.middleware');
const { upload } = require('../middleware/upload.middleware');

// POST /api/upload/contenido/:id — subir archivo para contenido
router.post('/contenido/:id', authMiddleware, upload.single('archivo'), async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No se recibió ningún archivo.' });
    }

    const idContenido = Number(req.params.id);
    
    // Construir URL relativa del archivo
    const isVideo = req.file.mimetype.startsWith('video/');
    const folder = isVideo ? 'videos' : 'audio';
    const urlArchivo = `/uploads/${folder}/${req.file.filename}`;

    // Actualizar la base de datos
    await db.execute(
      `UPDATE CONTENIDO SET url_archivo = :url WHERE id_contenido = :id`,
      { url: urlArchivo, id: idContenido },
      { autoCommit: true }
    );

    res.json({
      message: 'Archivo subido exitosamente',
      url_archivo: urlArchivo,
      filename: req.file.filename,
      size: req.file.size,
      mimetype: req.file.mimetype
    });
  } catch (err) {
    // Si hay error, intentar eliminar el archivo subido
    if (req.file) {
      const fs = require('fs');
      fs.unlink(req.file.path, () => {});
    }
    next(err);
  }
});

// POST /api/upload/episodio/:id — subir archivo para episodio
router.post('/episodio/:id', authMiddleware, upload.single('archivo'), async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No se recibió ningún archivo.' });
    }

    const idEpisodio = Number(req.params.id);
    
    // Construir URL relativa del archivo
    const urlArchivo = `/uploads/videos/${req.file.filename}`;

    // Actualizar la base de datos
    await db.execute(
      `UPDATE EPISODIOS SET url_archivo = :url WHERE id_episodio = :id`,
      { url: urlArchivo, id: idEpisodio },
      { autoCommit: true }
    );

    res.json({
      message: 'Archivo subido exitosamente',
      url_archivo: urlArchivo,
      filename: req.file.filename,
      size: req.file.size,
      mimetype: req.file.mimetype
    });
  } catch (err) {
    // Si hay error, intentar eliminar el archivo subido
    if (req.file) {
      const fs = require('fs');
      fs.unlink(req.file.path, () => {});
    }
    next(err);
  }
});

// DELETE /api/upload/contenido/:id — eliminar archivo de contenido
router.delete('/contenido/:id', authMiddleware, async (req, res, next) => {
  try {
    const idContenido = Number(req.params.id);
    
    // Obtener la URL actual del archivo
    const result = await db.execute(
      `SELECT url_archivo FROM CONTENIDO WHERE id_contenido = :id`,
      [idContenido]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Contenido no encontrado.' });
    }

    const urlArchivo = result.rows[0].URL_ARCHIVO;
    
    if (urlArchivo) {
      // Eliminar archivo físico
      const fs = require('fs');
      const filePath = path.join(__dirname, '../../', urlArchivo);
      fs.unlink(filePath, (err) => {
        if (err) console.error('Error al eliminar archivo:', err);
      });
    }

    // Actualizar base de datos
    await db.execute(
      `UPDATE CONTENIDO SET url_archivo = NULL WHERE id_contenido = :id`,
      [idContenido],
      { autoCommit: true }
    );

    res.json({ message: 'Archivo eliminado exitosamente' });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
