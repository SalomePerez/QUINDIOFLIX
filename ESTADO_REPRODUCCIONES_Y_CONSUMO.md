# 📊 Estado: Reproducciones y Consumo - QuindioFlix

## 📋 Requisito Completo

> **Reproducciones y consumo:** Cada vez que un perfil reproduce contenido, se registra la reproducción con la fecha y hora de inicio, la fecha y hora de fin (si terminó), el dispositivo utilizado (celular, tablet, TV, computador) y el porcentaje de avance. Si el contenido es un episodio de una serie, debe quedar claro cuál episodio se reprodujo.
>
> Los perfiles pueden agregar contenido a su lista personal de favoritos y pueden calificar contenido con estrellas (1 a 5) y opcionalmente dejar una reseña escrita. La plataforma permite que los usuarios reporten contenido como inapropiado, y otro usuario (un moderador) revisa y resuelve el reporte. Los moderadores son usuarios con un rol especial dentro del sistema.

---

## ✅ Estado de Implementación

### 1. Reproducciones ✅ **COMPLETO**

#### Base de Datos ✅
- [x] Tabla `REPRODUCCIONES` con particionamiento por año
- [x] Campos: `id_reproduccion`, `id_perfil`, `id_contenido`, `id_episodio`
- [x] Campos: `fecha_hora_inicio`, `fecha_hora_fin`, `dispositivo`, `porcentaje_avance`
- [x] Dispositivos: CELULAR, TABLET, TV, COMPUTADOR
- [x] Soporte para episodios de series/podcasts

#### Backend ✅
- [x] `POST /api/reproducciones` - Iniciar reproducción
- [x] `PUT /api/reproducciones/:id` - Actualizar progreso y finalizar
- [x] `GET /api/reproducciones/perfil/:id_perfil` - Historial de reproducciones
- [x] Validación de cuenta activa (trigger)
- [x] Validación de contenido apropiado para perfil infantil (trigger)

#### Frontend ✅
- [x] Botón "Reproducir ahora" en página de detalle
- [x] Simulación de reproducción (100%)
- [x] Carga de progreso de reproducción del perfil
- [x] Mensaje de estado de reproducción

---

### 2. Favoritos ✅ **COMPLETO**

#### Base de Datos ✅
- [x] Tabla `FAVORITOS` (id_perfil, id_contenido, fecha_agregado)
- [x] Clave primaria compuesta
- [x] Foreign keys a PERFILES y CONTENIDO

#### Backend ✅
- [x] `POST /api/contenido/:id/favorito` - Agregar a favoritos
- [x] `DELETE /api/contenido/:id/favorito` - Quitar de favoritos
- [x] `GET /api/usuarios/:id/favoritos/:id_perfil` - Lista de favoritos

#### Frontend ✅
- [x] Botón "Favorito" con icono de corazón en página de detalle
- [x] Mensaje de confirmación al agregar
- [x] Manejo de duplicados (409 Conflict)

---

### 3. Calificaciones y Reseñas ✅ **COMPLETO**

#### Base de Datos ✅
- [x] Tabla `CALIFICACIONES` (id_calificacion, id_perfil, id_contenido, estrellas, resena, fecha)
- [x] Estrellas: 1-5
- [x] Reseña opcional (VARCHAR2(2000))
- [x] Constraint único por perfil-contenido

#### Backend ✅
- [x] `POST /api/contenido/:id/calificar` - Calificar contenido
- [x] `GET /api/contenido/:id/calificaciones` - Obtener calificaciones
- [x] Validación: mínimo 50% de reproducción para calificar
- [x] Cálculo de calificación promedio en listado de contenido

#### Frontend ✅
- [x] Componente `StarRating` reutilizable
- [x] Formulario de calificación en página de detalle
- [x] Campo de reseña opcional (textarea)
- [x] Validación de 50% de reproducción
- [x] Sección de reseñas con estrellas y fecha
- [x] Mensaje de error si no cumple requisitos

---

### 4. Reportes de Contenido ⚠️ **PARCIALMENTE IMPLEMENTADO**

#### Base de Datos ✅
- [x] Tabla `REPORTES` completa
- [x] Campos: id_reporte, id_perfil, id_contenido, motivo, descripcion
- [x] Campos: estado, fecha_reporte, id_moderador, fecha_resolucion, resolucion_nota
- [x] Estados: PENDIENTE, EN_REVISION, RESUELTO, RECHAZADO
- [x] Foreign key a moderador (USUARIOS con es_moderador='S')

#### Backend ✅
- [x] `POST /api/contenido/:id/reportar` - Reportar contenido

#### Backend ❌ **FALTA**
- [ ] `GET /api/reportes` - Listar todos los reportes (para moderadores)
- [ ] `GET /api/reportes/pendientes` - Reportes pendientes
- [ ] `PUT /api/reportes/:id/revisar` - Cambiar estado a EN_REVISION
- [ ] `PUT /api/reportes/:id/resolver` - Resolver reporte
- [ ] `PUT /api/reportes/:id/rechazar` - Rechazar reporte

#### Frontend ❌ **FALTA**
- [ ] Botón "Reportar" en página de detalle de contenido
- [ ] Modal/formulario para reportar con motivo y descripción
- [ ] Página de moderación `/moderacion` o `/reportes`
- [ ] Lista de reportes con filtros (pendientes, en revisión, resueltos)
- [ ] Interfaz para que moderadores revisen y resuelvan reportes
- [ ] Protección de ruta: solo usuarios con `es_moderador='S'`

---

### 5. Sistema de Moderadores ✅ **COMPLETO**

#### Base de Datos ✅
- [x] Campo `es_moderador` en tabla USUARIOS (S/N)
- [x] Usuarios moderadores de prueba creados

#### Backend ✅
- [x] Campo `es_moderador` incluido en respuesta de login
- [x] Middleware de autenticación disponible

#### Frontend ⚠️ **PARCIAL**
- [x] Campo `es_moderador` disponible en contexto de usuario
- [ ] Protección de rutas para moderadores
- [ ] Enlace en Navbar para moderadores
- [ ] Página de moderación

---

## 🚀 Funcionalidades Adicionales Implementadas

### Validaciones y Reglas de Negocio ✅
- [x] Trigger: No reproducir si cuenta inactiva
- [x] Trigger: Perfiles infantiles solo ven contenido TP, +7, +13
- [x] Trigger: Mínimo 50% de reproducción para calificar
- [x] Cursor: Actualizar popularidad de contenido (reproducciones >= 90%)

### Métricas y Reportes ✅
- [x] Calificación promedio por contenido
- [x] Total de reproducciones por contenido
- [x] Total de calificaciones por contenido
- [x] Historial de reproducciones por perfil
- [x] Dashboard con reproducciones por dispositivo (PIVOT)

---

## 📝 Lo que FALTA Implementar

### 1. Sistema Completo de Reportes y Moderación

#### Backend - Nuevos Endpoints

```javascript
// backend/src/routes/reportes.routes.js (NUEVO ARCHIVO)

// GET /api/reportes - Listar todos los reportes (solo moderadores)
router.get('/', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  const { estado, limit = 50 } = req.query;
  // Filtrar por estado si se proporciona
  // Incluir información del perfil que reportó y del contenido
  // Ordenar por fecha_reporte DESC
});

// GET /api/reportes/pendientes - Reportes pendientes (solo moderadores)
router.get('/pendientes', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  // WHERE estado = 'PENDIENTE'
  // Ordenar por fecha_reporte ASC (más antiguos primero)
});

// PUT /api/reportes/:id/revisar - Marcar como en revisión
router.put('/:id/revisar', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  const { id_moderador } = req.body;
  // UPDATE estado = 'EN_REVISION', id_moderador = :id
});

// PUT /api/reportes/:id/resolver - Resolver reporte
router.put('/:id/resolver', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  const { resolucion_nota } = req.body;
  // UPDATE estado = 'RESUELTO', fecha_resolucion = SYSDATE, resolucion_nota
});

// PUT /api/reportes/:id/rechazar - Rechazar reporte
router.put('/:id/rechazar', authMiddleware, moderadorMiddleware, async (req, res, next) => {
  const { resolucion_nota } = req.body;
  // UPDATE estado = 'RECHAZADO', fecha_resolucion = SYSDATE, resolucion_nota
});
```

#### Backend - Middleware de Moderador

```javascript
// backend/src/middleware/moderador.middleware.js (NUEVO ARCHIVO)

function moderadorMiddleware(req, res, next) {
  // Verificar que req.user existe (viene de authMiddleware)
  // Verificar que req.user.ES_MODERADOR === 'S'
  // Si no, retornar 403 Forbidden
}
```

#### Frontend - Botón de Reportar

```jsx
// En ContenidoDetailPage.jsx

// Agregar estado
const [showReportModal, setShowReportModal] = useState(false);
const [reportMotivo, setReportMotivo] = useState('');
const [reportDesc, setReportDesc] = useState('');
const [reportMsg, setReportMsg] = useState('');

// Función para reportar
async function handleReportar(e) {
  e.preventDefault();
  if (!perfil) return setReportMsg('Selecciona un perfil primero.');
  if (!reportMotivo) return setReportMsg('Selecciona un motivo.');
  
  try {
    await api.post(`/contenido/${id}/reportar`, {
      id_perfil: perfil.ID_PERFIL,
      motivo: reportMotivo,
      descripcion: reportDesc
    });
    setReportMsg('Reporte enviado. Será revisado por un moderador.');
    setShowReportModal(false);
    setReportMotivo('');
    setReportDesc('');
  } catch (err) {
    setReportMsg(err.response?.data?.error || 'Error al enviar reporte.');
  }
}

// Agregar botón en la UI (junto al botón de Favorito)
<button onClick={() => setShowReportModal(true)}
  className="bg-red-600 hover:bg-red-700 px-4 py-2 rounded-lg text-sm transition flex items-center gap-2">
  <Flag size={16} />
  Reportar
</button>

// Modal de reporte
{showReportModal && (
  <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50">
    <div className="bg-gray-800 rounded-xl p-6 max-w-md w-full mx-4">
      <h3 className="text-xl font-semibold mb-4">Reportar Contenido</h3>
      <form onSubmit={handleReportar} className="space-y-4">
        <div>
          <label className="block text-sm text-gray-400 mb-2">Motivo</label>
          <select value={reportMotivo} onChange={e => setReportMotivo(e.target.value)}
            className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white">
            <option value="">Selecciona un motivo</option>
            <option value="Contenido inapropiado">Contenido inapropiado</option>
            <option value="Violencia excesiva">Violencia excesiva</option>
            <option value="Lenguaje ofensivo">Lenguaje ofensivo</option>
            <option value="Clasificación incorrecta">Clasificación incorrecta</option>
            <option value="Otro">Otro</option>
          </select>
        </div>
        <div>
          <label className="block text-sm text-gray-400 mb-2">Descripción (opcional)</label>
          <textarea value={reportDesc} onChange={e => setReportDesc(e.target.value)}
            rows={3} placeholder="Describe el problema..."
            className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white" />
        </div>
        {reportMsg && <p className="text-sm text-red-400">{reportMsg}</p>}
        <div className="flex gap-3">
          <button type="submit" className="flex-1 bg-red-600 hover:bg-red-700 px-4 py-2 rounded-lg">
            Enviar Reporte
          </button>
          <button type="button" onClick={() => setShowReportModal(false)}
            className="flex-1 bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded-lg">
            Cancelar
          </button>
        </div>
      </form>
    </div>
  </div>
)}
```

#### Frontend - Página de Moderación

```jsx
// frontend/src/pages/ModeracionPage.jsx (NUEVO ARCHIVO)

import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import api from '../api/axios';
import { Flag, CheckCircle, XCircle, Eye } from 'lucide-react';

export default function ModeracionPage() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [reportes, setReportes] = useState([]);
  const [filtro, setFiltro] = useState('PENDIENTE');
  const [loading, setLoading] = useState(true);
  const [selectedReporte, setSelectedReporte] = useState(null);
  const [resolucionNota, setResolucionNota] = useState('');
  const [msg, setMsg] = useState('');

  useEffect(() => {
    // Verificar que el usuario es moderador
    if (!user || user.ES_MODERADOR !== 'S') {
      navigate('/');
      return;
    }
    loadReportes();
  }, [user, navigate, filtro]);

  async function loadReportes() {
    setLoading(true);
    try {
      const { data } = await api.get(`/reportes?estado=${filtro}`);
      setReportes(data);
    } catch (err) {
      console.error('Error cargando reportes:', err);
    } finally {
      setLoading(false);
    }
  }

  async function handleRevisar(id) {
    try {
      await api.put(`/reportes/${id}/revisar`, { id_moderador: user.ID_USUARIO });
      setMsg('Reporte marcado como en revisión');
      loadReportes();
    } catch (err) {
      setMsg('Error al marcar reporte');
    }
  }

  async function handleResolver(id) {
    try {
      await api.put(`/reportes/${id}/resolver`, { resolucion_nota: resolucionNota });
      setMsg('Reporte resuelto exitosamente');
      setSelectedReporte(null);
      setResolucionNota('');
      loadReportes();
    } catch (err) {
      setMsg('Error al resolver reporte');
    }
  }

  async function handleRechazar(id) {
    try {
      await api.put(`/reportes/${id}/rechazar`, { resolucion_nota: resolucionNota });
      setMsg('Reporte rechazado');
      setSelectedReporte(null);
      setResolucionNota('');
      loadReportes();
    } catch (err) {
      setMsg('Error al rechazar reporte');
    }
  }

  // ... resto de la UI
}
```

---

## 🎯 Prioridades de Implementación

### Alta Prioridad 🔴
1. **Botón de Reportar en página de detalle** - Funcionalidad básica del requisito
2. **Endpoints de reportes para moderadores** - Backend necesario
3. **Middleware de moderador** - Seguridad

### Media Prioridad 🟡
4. **Página de moderación básica** - Lista de reportes pendientes
5. **Funcionalidad de resolver/rechazar reportes** - Completar flujo

### Baja Prioridad 🟢
6. **Filtros avanzados en moderación** - Por fecha, tipo de contenido, etc.
7. **Notificaciones para moderadores** - Badge con número de reportes pendientes
8. **Estadísticas de moderación** - Dashboard para moderadores

---

## 📊 Resumen de Completitud

| Funcionalidad | Estado | Completitud |
|---------------|--------|-------------|
| **Reproducciones** | ✅ Completo | 100% |
| **Favoritos** | ✅ Completo | 100% |
| **Calificaciones** | ✅ Completo | 100% |
| **Reseñas** | ✅ Completo | 100% |
| **Reportes (Backend)** | ⚠️ Parcial | 20% |
| **Reportes (Frontend)** | ❌ Falta | 0% |
| **Moderación** | ❌ Falta | 0% |
| **TOTAL GENERAL** | ⚠️ Parcial | **74%** |

---

## 🧪 Pruebas Realizadas

### Reproducciones ✅
- [x] Iniciar reproducción desde página de detalle
- [x] Actualizar progreso a 100%
- [x] Verificar que se guarda en base de datos
- [x] Verificar que se puede calificar después del 50%

### Favoritos ✅
- [x] Agregar contenido a favoritos
- [x] Verificar mensaje de confirmación
- [x] Intentar agregar duplicado (debe fallar)

### Calificaciones ✅
- [x] Calificar con menos del 50% (debe fallar)
- [x] Reproducir y calificar con estrellas
- [x] Agregar reseña opcional
- [x] Ver calificaciones de otros usuarios
- [x] Verificar calificación promedio

### Reportes ⚠️
- [x] Endpoint POST funciona
- [ ] No hay UI para reportar
- [ ] No hay sistema de moderación

---

## 📝 Notas Técnicas

### Dispositivos Soportados
- CELULAR
- TABLET
- TV
- COMPUTADOR

### Estados de Reportes
- PENDIENTE (inicial)
- EN_REVISION (moderador lo está revisando)
- RESUELTO (moderador tomó acción)
- RECHAZADO (reporte no válido)

### Usuarios Moderadores de Prueba
```
r.montoya@gmail.com / password123
s.pedraza@gmail.com / password123
h.castillo@gmail.com / password123
```

Todos tienen `es_moderador = 'S'` en la base de datos.

---

**Última actualización:** Mayo 21, 2026  
**Versión:** 1.0.0  
**Estado:** ⚠️ 74% Completo - Falta sistema de moderación
