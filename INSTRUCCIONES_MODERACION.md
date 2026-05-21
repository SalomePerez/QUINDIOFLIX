# 🛡️ Sistema de Moderación y Reportes - QuindioFlix

## 📋 Descripción

QuindioFlix incluye un **sistema completo de reportes y moderación** que permite a los usuarios reportar contenido inapropiado y a los moderadores revisar y resolver estos reportes.

---

## 🎯 Funcionalidades Implementadas

### Para Usuarios Regulares ✅
- Reportar contenido inapropiado desde la página de detalle
- Seleccionar motivo del reporte
- Agregar descripción opcional
- Recibir confirmación del reporte

### Para Moderadores ✅
- Ver todos los reportes con filtros por estado
- Estadísticas en tiempo real
- Marcar reportes como "En Revisión"
- Resolver reportes con nota de resolución
- Rechazar reportes con explicación
- Ver historial completo de reportes

---

## 👥 Usuarios Moderadores

Los moderadores son usuarios con un rol especial (`es_moderador = 'S'`) que tienen acceso a funcionalidades adicionales.

### Usuarios Moderadores de Prueba

```
Email: r.montoya@gmail.com
Password: password123

Email: s.pedraza@gmail.com
Password: password123

Email: h.castillo@gmail.com
Password: password123
```

Todos estos usuarios tienen `es_moderador = 'S'` en la base de datos.

---

## 🚀 Cómo Reportar Contenido (Usuario Regular)

### Paso 1: Ir a la Página de Detalle
1. Navegar a cualquier contenido (película, serie, documental, etc.)
2. URL: `http://localhost:5174/contenido/:id`

### Paso 2: Hacer Clic en "Reportar"
1. Buscar el botón rojo "Reportar" con icono de bandera
2. Está ubicado junto al botón "Favorito"

### Paso 3: Completar el Formulario
1. **Motivo** (requerido): Seleccionar de la lista
   - Contenido inapropiado
   - Violencia excesiva
   - Lenguaje ofensivo
   - Clasificación incorrecta
   - Contenido engañoso
   - Otro

2. **Descripción** (opcional): Explicar el problema con más detalle

### Paso 4: Enviar Reporte
1. Hacer clic en "Enviar Reporte"
2. Verás un mensaje de confirmación
3. El reporte queda en estado "PENDIENTE"

---

## 🛡️ Panel de Moderación

### Acceso
- **URL:** `http://localhost:5174/moderacion`
- **Requisito:** Usuario con `es_moderador = 'S'`
- **Enlace en Navbar:** "Moderación" (naranja, con icono de bandera)

### Secciones del Panel

#### 1. Estadísticas (Dashboard)
Muestra en tiempo real:
- **Total:** Todos los reportes en el sistema
- **Pendientes:** Reportes sin revisar (amarillo)
- **En Revisión:** Reportes siendo revisados (azul)
- **Resueltos:** Reportes resueltos (verde)
- **Rechazados:** Reportes rechazados (rojo)

#### 2. Filtros
Botones para filtrar reportes por estado:
- PENDIENTE
- EN_REVISION
- RESUELTO
- RECHAZADO

#### 3. Lista de Reportes
Cada reporte muestra:
- **Título del contenido** reportado
- **Tipo** (PELICULA, SERIE, etc.)
- **Clasificación de edad** (TP, +7, +13, +16, +18)
- **Perfil y usuario** que reportó
- **Fecha y hora** del reporte
- **Motivo** del reporte
- **Descripción** (si la hay)
- **Estado** actual (badge de color)
- **Moderador asignado** (si aplica)
- **Nota de resolución** (si está resuelto/rechazado)

---

## 🔧 Flujo de Moderación

### Estado 1: PENDIENTE (Amarillo)
**Acciones disponibles:**
- ✅ **Revisar:** Marca el reporte como "En Revisión" y asigna al moderador
- ✅ **Resolver:** Resuelve directamente el reporte
- ❌ **Rechazar:** Rechaza el reporte

### Estado 2: EN_REVISION (Azul)
**Acciones disponibles:**
- ✅ **Resolver:** Resuelve el reporte con nota
- ❌ **Rechazar:** Rechaza el reporte con explicación

### Estado 3: RESUELTO (Verde)
**Acciones:** Ninguna (estado final)
**Información visible:**
- Moderador que resolvió
- Fecha de resolución
- Nota de resolución

### Estado 4: RECHAZADO (Rojo)
**Acciones:** Ninguna (estado final)
**Información visible:**
- Moderador que rechazó
- Fecha de rechazo
- Nota explicando el rechazo

---

## 📝 Cómo Moderar un Reporte

### Opción A: Revisar Primero (Recomendado)

1. **Hacer clic en "Revisar"**
   - El reporte cambia a estado "EN_REVISION"
   - Se asigna tu usuario como moderador
   - Otros moderadores ven que está siendo revisado

2. **Analizar el contenido**
   - Ver el contenido reportado
   - Evaluar si el reporte es válido
   - Decidir acción a tomar

3. **Resolver o Rechazar**
   - Hacer clic en "Resolver" o "Rechazar"
   - Agregar nota explicando la decisión
   - Confirmar la acción

### Opción B: Resolver/Rechazar Directamente

1. **Hacer clic en "Resolver" o "Rechazar"**
   - Se abre un modal para agregar nota

2. **Agregar Nota de Resolución**
   - Explicar qué acción se tomó
   - O por qué se rechaza el reporte
   - La nota es obligatoria

3. **Confirmar**
   - Hacer clic en "Resolver" o "Rechazar" en el modal
   - El reporte cambia a estado final

---

## 🎨 Interfaz de Usuario

### Colores por Estado
- **Amarillo:** PENDIENTE (requiere atención)
- **Azul:** EN_REVISION (siendo revisado)
- **Verde:** RESUELTO (acción tomada)
- **Rojo:** RECHAZADO (reporte no válido)

### Iconos
- 🚩 **Flag:** Reportes y moderación
- ⚠️ **AlertTriangle:** Reportes pendientes
- 🕐 **Clock:** Reportes en revisión
- ✅ **CheckCircle:** Reportes resueltos
- ❌ **XCircle:** Reportes rechazados
- 👁️ **Eye:** Revisar reporte
- 📄 **FileCheck:** Sin reportes

---

## 💾 Estructura de Datos

### Tabla REPORTES

```sql
CREATE TABLE REPORTES (
    id_reporte       NUMBER PRIMARY KEY,
    id_perfil        NUMBER NOT NULL,        -- Perfil que reporta
    id_contenido     NUMBER NOT NULL,        -- Contenido reportado
    motivo           VARCHAR2(100) NOT NULL, -- Motivo del reporte
    descripcion      VARCHAR2(1000),         -- Descripción opcional
    estado           VARCHAR2(15) DEFAULT 'PENDIENTE' NOT NULL,
    fecha_reporte    DATE DEFAULT SYSDATE NOT NULL,
    id_moderador     NUMBER,                 -- Moderador asignado
    fecha_resolucion DATE,                   -- Fecha de resolución
    resolucion_nota  VARCHAR2(500),          -- Nota del moderador
    CONSTRAINT chk_rep_estado CHECK (estado IN ('PENDIENTE','EN_REVISION','RESUELTO','RECHAZADO'))
);
```

### Estados Posibles
1. **PENDIENTE:** Reporte recién creado, sin revisar
2. **EN_REVISION:** Moderador lo está revisando
3. **RESUELTO:** Moderador tomó acción sobre el contenido
4. **RECHAZADO:** Reporte no válido o sin fundamento

---

## 🔌 Endpoints de la API

### Para Usuarios

#### Reportar Contenido
```http
POST /api/contenido/:id/reportar
Authorization: Bearer <token>

Body:
{
  "id_perfil": 1,
  "motivo": "Contenido inapropiado",
  "descripcion": "Este contenido muestra violencia gráfica no apropiada para la clasificación +13"
}

Response: 201 Created
{
  "message": "Reporte enviado."
}
```

### Para Moderadores

#### Listar Reportes
```http
GET /api/reportes?estado=PENDIENTE&limit=50
Authorization: Bearer <token>
X-Moderador: true

Response: 200 OK
[
  {
    "ID_REPORTE": 1,
    "MOTIVO": "Contenido inapropiado",
    "DESCRIPCION": "...",
    "ESTADO": "PENDIENTE",
    "FECHA_REPORTE": "2026-05-21T10:30:00.000Z",
    "PERFIL_REPORTANTE": "Juan",
    "USUARIO_REPORTANTE": "Juan Pérez",
    "CONTENIDO_TITULO": "Noche de Brujas en Bogotá",
    "CONTENIDO_TIPO": "PELICULA",
    "CLASIFICACION_EDAD": "+18"
  }
]
```

#### Obtener Reportes Pendientes
```http
GET /api/reportes/pendientes
Authorization: Bearer <token>
X-Moderador: true

Response: 200 OK
[...]
```

#### Obtener Estadísticas
```http
GET /api/reportes/stats
Authorization: Bearer <token>
X-Moderador: true

Response: 200 OK
{
  "TOTAL": 15,
  "PENDIENTES": 5,
  "EN_REVISION": 3,
  "RESUELTOS": 6,
  "RECHAZADOS": 1
}
```

#### Marcar como En Revisión
```http
PUT /api/reportes/:id/revisar
Authorization: Bearer <token>
X-Moderador: true

Response: 200 OK
{
  "message": "Reporte marcado como en revisión."
}
```

#### Resolver Reporte
```http
PUT /api/reportes/:id/resolver
Authorization: Bearer <token>
X-Moderador: true

Body:
{
  "resolucion_nota": "Se revisó el contenido y se actualizó la clasificación de edad a +18. Se notificó al equipo de contenido."
}

Response: 200 OK
{
  "message": "Reporte resuelto exitosamente."
}
```

#### Rechazar Reporte
```http
PUT /api/reportes/:id/rechazar
Authorization: Bearer <token>
X-Moderador: true

Body:
{
  "resolucion_nota": "El contenido cumple con las normas de la plataforma. La clasificación de edad es correcta."
}

Response: 200 OK
{
  "message": "Reporte rechazado."
}
```

---

## 🧪 Pruebas del Sistema

### Prueba 1: Reportar Contenido

1. **Login como usuario regular**
   - Email: cualquier usuario no moderador
   - Password: su contraseña

2. **Ir a un contenido**
   - Ejemplo: http://localhost:5174/contenido/5

3. **Hacer clic en "Reportar"**
   - Seleccionar motivo: "Violencia excesiva"
   - Descripción: "Escenas muy gráficas para +13"
   - Enviar reporte

4. **Verificar confirmación**
   - Debe aparecer: "Reporte enviado. Será revisado por un moderador."

### Prueba 2: Revisar Reporte (Moderador)

1. **Login como moderador**
   - Email: r.montoya@gmail.com
   - Password: password123

2. **Ir a Moderación**
   - Hacer clic en "Moderación" en el navbar (naranja)
   - O ir a: http://localhost:5174/moderacion

3. **Ver estadísticas**
   - Verificar que aparece el reporte en "Pendientes"

4. **Hacer clic en "Revisar"**
   - El reporte cambia a "EN_REVISION"
   - Tu nombre aparece como moderador

### Prueba 3: Resolver Reporte

1. **Hacer clic en "Resolver"**
   - Se abre modal

2. **Agregar nota**
   - "Se actualizó la clasificación a +16. Contenido revisado."

3. **Confirmar**
   - El reporte cambia a "RESUELTO" (verde)
   - Aparece la nota de resolución

### Prueba 4: Rechazar Reporte

1. **Reportar otro contenido**
   - Como usuario regular

2. **Como moderador, hacer clic en "Rechazar"**
   - Agregar nota: "El contenido es apropiado para su clasificación"

3. **Confirmar**
   - El reporte cambia a "RECHAZADO" (rojo)

### Prueba 5: Filtros

1. **En el panel de moderación**
   - Hacer clic en "PENDIENTE" → Ver solo pendientes
   - Hacer clic en "RESUELTO" → Ver solo resueltos
   - Hacer clic en "RECHAZADO" → Ver solo rechazados

---

## 🔒 Seguridad

### Middleware de Moderador
```javascript
// backend/src/middleware/moderador.middleware.js

function moderadorMiddleware(req, res, next) {
  if (!req.user) {
    return res.status(401).json({ error: 'No autenticado.' });
  }
  
  if (req.user.ES_MODERADOR !== 'S') {
    return res.status(403).json({ 
      error: 'Acceso denegado. Solo moderadores pueden acceder a este recurso.' 
    });
  }
  
  next();
}
```

### Protección de Rutas
- Todas las rutas de `/api/reportes` requieren autenticación
- Todas las rutas de moderación requieren `es_moderador = 'S'`
- Los usuarios regulares solo pueden reportar, no moderar

### Validaciones
- El motivo del reporte es obligatorio
- La nota de resolución/rechazo es obligatoria
- Solo se pueden resolver reportes PENDIENTES o EN_REVISION
- Un reporte resuelto/rechazado no se puede modificar

---

## 📊 Consultas SQL Útiles

### Ver todos los reportes
```sql
SELECT r.*, 
       p.nombre AS perfil,
       u.nombre||' '||u.apellido AS usuario,
       c.titulo AS contenido,
       m.nombre||' '||m.apellido AS moderador
FROM REPORTES r
JOIN PERFILES p ON r.id_perfil = p.id_perfil
JOIN USUARIOS u ON p.id_usuario = u.id_usuario
JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
LEFT JOIN USUARIOS m ON r.id_moderador = m.id_usuario
ORDER BY r.fecha_reporte DESC;
```

### Reportes por estado
```sql
SELECT estado, COUNT(*) AS total
FROM REPORTES
GROUP BY estado
ORDER BY total DESC;
```

### Contenido más reportado
```sql
SELECT c.titulo, c.tipo, COUNT(*) AS num_reportes
FROM REPORTES r
JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
GROUP BY c.titulo, c.tipo
ORDER BY num_reportes DESC;
```

### Moderadores más activos
```sql
SELECT m.nombre||' '||m.apellido AS moderador,
       COUNT(*) AS reportes_resueltos
FROM REPORTES r
JOIN USUARIOS m ON r.id_moderador = m.id_usuario
WHERE r.estado IN ('RESUELTO', 'RECHAZADO')
GROUP BY m.nombre, m.apellido
ORDER BY reportes_resueltos DESC;
```

---

## 🐛 Solución de Problemas

### Problema: No veo el enlace "Moderación"
**Causa:** Tu usuario no es moderador  
**Solución:** Verifica que `es_moderador = 'S'` en la base de datos

### Problema: Error 403 al acceder a /moderacion
**Causa:** El backend detectó que no eres moderador  
**Solución:** Usa uno de los usuarios moderadores de prueba

### Problema: No puedo reportar contenido
**Causa:** No has seleccionado un perfil  
**Solución:** Ve a `/perfiles` y selecciona un perfil primero

### Problema: El modal de reporte no se cierra
**Causa:** Hay un error en el envío  
**Solución:** Revisa la consola del navegador (F12) y verifica el mensaje de error

### Problema: Los reportes no se actualizan
**Causa:** Necesitas recargar la página  
**Solución:** La página se recarga automáticamente después de cada acción

---

## 📈 Métricas y KPIs

### Para Administradores
- **Tiempo promedio de resolución:** Tiempo entre reporte y resolución
- **Tasa de reportes válidos:** % de reportes resueltos vs rechazados
- **Contenido más reportado:** Identificar contenido problemático
- **Moderadores más activos:** Evaluar desempeño del equipo

### Consulta de Tiempo Promedio
```sql
SELECT AVG(fecha_resolucion - fecha_reporte) AS dias_promedio
FROM REPORTES
WHERE estado IN ('RESUELTO', 'RECHAZADO')
  AND fecha_resolucion IS NOT NULL;
```

---

## 🎯 Mejoras Futuras

### Corto Plazo
- [ ] Notificaciones en tiempo real para moderadores
- [ ] Badge con número de reportes pendientes en navbar
- [ ] Filtro por tipo de contenido
- [ ] Búsqueda de reportes por título

### Mediano Plazo
- [ ] Sistema de prioridad de reportes
- [ ] Asignación automática de reportes a moderadores
- [ ] Historial de acciones del moderador
- [ ] Reportes duplicados (mismo contenido)

### Largo Plazo
- [ ] Machine Learning para detectar reportes spam
- [ ] Dashboard de analíticas para moderadores
- [ ] Sistema de apelaciones
- [ ] Integración con sistema de sanciones

---

## 📞 Soporte

Si encuentras problemas:
1. Revisar esta documentación
2. Verificar la consola del navegador (F12)
3. Revisar los logs del backend
4. Verificar que eres moderador en la base de datos

---

**Última actualización:** Mayo 21, 2026  
**Versión:** 1.0.0  
**Estado:** ✅ Completamente implementado y funcional
