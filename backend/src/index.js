require('dotenv').config();
const express = require('express');
const cors    = require('cors');
const path    = require('path');

const authRoutes          = require('./routes/auth.routes');
const contenidoRoutes     = require('./routes/contenido.routes');
const usuariosRoutes      = require('./routes/usuarios.routes');
const reproduccionesRoutes = require('./routes/reproducciones.routes');
const dashboardRoutes     = require('./routes/dashboard.routes');
const adminRoutes         = require('./routes/admin.routes');
const reportesRoutes      = require('./routes/reportes.routes');
const uploadRoutes        = require('./routes/upload.routes');

const app  = express();
const PORT = process.env.PORT || 3001;

app.use(cors({ origin: ['http://localhost:5173', 'http://localhost:5174', 'http://localhost:5175'], credentials: true }));
app.use(express.json());

// Servir archivos estáticos (uploads)
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Rutas
app.use('/api/auth',           authRoutes);
app.use('/api/contenido',      contenidoRoutes);
app.use('/api/usuarios',       usuariosRoutes);
app.use('/api/reproducciones', reproduccionesRoutes);
app.use('/api/dashboard',      dashboardRoutes);
app.use('/api/admin',          adminRoutes);
app.use('/api/reportes',       reportesRoutes);
app.use('/api/upload',         uploadRoutes);

// Health check
app.get('/api/health', (_req, res) => res.json({ status: 'ok', timestamp: new Date() }));

// Manejo global de errores
app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(err.status || 500).json({ error: err.message || 'Error interno del servidor' });
});

app.listen(PORT, () => console.log(`QuindioFlix API corriendo en http://localhost:${PORT}`));

