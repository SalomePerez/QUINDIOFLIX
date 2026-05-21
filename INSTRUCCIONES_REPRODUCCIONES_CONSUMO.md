# Sistema de Reproducciones y Consumo - QuindioFlix

## 📋 Descripción General

QuindioFlix implementa un sistema completo de seguimiento de reproducciones, favoritos, calificaciones y reportes de contenido. Este documento describe todas las funcionalidades implementadas.

---

## 🎬 Reproducciones

### Características Implementadas

✅ **Registro de Reproducciones:**
- Fecha y hora de inicio
- Fecha y hora de fin (cuando termina)
- Dispositivo utilizado (CELULAR, TABLET, TV, COMPUTADOR)
- Porcentaje de avance (0-100%)
- Soporte para episodios de series/podcasts

✅ **Tabla Particionada:**
- Particionada por año para mejor rendimiento
- Particiones: 2024, 2025, 2026, FUTURO

### Endpoints del Backend

#### 1. Iniciar Reproducción
```
POST /api/reproducciones
```

**Body:**
```json
{
  "id_perfil": 1,
  "id_contenido": 5,
  "id_episodio": null,  // Opcional, solo para series/podcasts
  "dispositivo": "TV"   // CELULAR, TABLET, TV, COMPUTADOR
}
```

**Respuesta:**
```json
{
  "id_reproduccion": 123,
  "message": "Reproducción iniciada"
}
```

#### 2. Actualizar Progreso
```
PUT /api/reproducciones/:id
```

**Body:**
```json
{
  "porcentaje_avance": 75,
  "finalizar": false  // true para marcar como finalizada
}
```

#### 3. Obtener Reproducciones de un Perfil
```
GET /api/reproducciones/perfil/:id_perfil
```

**Respuesta:**
```json
[
  {
    "ID_REPRODUCCION": 123,
    "TITULO": "Película X",
    "FECHA_HORA_INICIO": "2026-05-21T10:30:00",
    "FECHA_HORA_FIN": "2026-05-21T12:15:00",
    "DISPOSITIVO": "TV",
    "PORCENTAJE_AVANCE": 100
  }
]
```

### Uso en el Frontend

**Página de Detalle de Contenido:**
- Botón "Reproducir ahora" simula reproducción al 100%
- Necesario para poder calificar (mínimo 50% de avance)
- Se guarda el progreso automáticamente

```javascript
// Ejemplo de uso
async function handleReproducirAhora() {
  const { data } = await api.post('/reproducciones', {
    id_perfil: perfil.ID_PERFIL,
    id_contenido: id,
    dispositivo: 'TV'
  });
  
  const reproId = data.id_reproduccion;
  
  // Actualizar a 100%
  await api.put(`/reproducciones/${reproId}`, {
    porcentaje_avance: 100,
    finalizar: true
  });
}
```

---

## ⭐ Favoritos

### Características Implementadas

✅ **Lista Personal por Perfil:**
- Cada perfil tiene su propia lista de favoritos
- Fecha de agregado
- Agregar/eliminar contenido

✅ **Página Dedicada:**
- URL: `/favoritos`
- Accesible desde menú desplegable del usuario
- Grid responsivo con tarjetas de contenido
- Botón eliminar al hacer hover
- Enlace directo a detalles del contenido

### Endpoints del Backend

#### 1. Agregar a Favoritos
```
POST /api/contenido/:id/favorito
```

**Body:**
```json
{
  "id_perfil": 1
}
```

#### 2. Eliminar de Favoritos
```
DELETE /api/contenido/:id/favorito
```

**Body:**
```json
{
  "id_perfil": 1
}
```

#### 3. Obtener Favoritos de un Perfil
```
GET /api/usuarios/:id_usuario/favoritos/:id_perfil
```

**Respuesta:**
```json
[
  {
    "ID_CONTENIDO": 5,
    "TITULO": "Película X",
    "TIPO": "PELICULA",
    "CLASIFICACION_EDAD": "+13",
    "CATEGORIA": "Acción",
    "FECHA_AGREGADO": "2026-05-20T00:00:00"
  }
]
```

### Uso en el Frontend

**Página de Favoritos (`/favoritos`):**
- Lista completa de favoritos del perfil actual
- Tarjetas con información del contenido
- Botón eliminar (icono basura)
- Botón "Ver Detalles"
- Mensaje vacío si no hay favoritos

**Página de Detalle:**
- Botón "Favorito" con icono de corazón
- Feedback visual al agregar

**Menú de Usuario:**
- Opción "Mis Favoritos" en menú desplegable
- Icono de corazón

---

## ⭐ Calificaciones y Reseñas

### Características Implementadas

✅ **Sistema de Estrellas:**
- Calificación de 1 a 5 estrellas
- Reseña escrita opcional
- Una calificación por perfil por contenido
- Requiere haber visto al menos 50% del contenido

✅ **Visualización:**
- Promedio de calificaciones
- Total de reseñas
- Lista de reseñas con nombre de perfil y fecha
- Componente StarRating reutilizable

### Endpoints del Backend

#### 1. Calificar Contenido
```
POST /api/contenido/:id/calificar
```

**Body:**
```json
{
  "id_perfil": 1,
  "estrellas": 5,
  "resena": "Excelente película, muy recomendada"
}
```

**Validaciones:**
- Estrellas entre 1 y 5
- Reseña opcional (máx 2000 caracteres)
- Solo una calificación por perfil
- Requiere 50% de avance en reproducción

#### 2. Obtener Calificaciones de un Contenido
```
GET /api/contenido/:id/calificaciones
```

**Respuesta:**
```json
[
  {
    "PERFIL": "Juan",
    "ESTRELLAS": 5,
    "RESENA": "Excelente película",
    "FECHA": "2026-05-21T00:00:00"
  }
]
```

### Uso en el Frontend

**Componente StarRating:**
```jsx
<StarRating 
  value={calificacion} 
  onChange={setCalificacion}
  size="lg"  // sm, md, lg
  readonly={false}
/>
```

**Página de Detalle:**
- Sección "Calificar" con formulario
- Validación de 50% de avance
- Botón "Reproducir ahora" si no cumple requisito
- Sección "Reseñas" con lista de calificaciones

---

## 🚩 Reportes de Contenido

### Características Implementadas

✅ **Sistema de Reportes:**
- Cualquier perfil puede reportar contenido
- Motivos predefinidos
- Descripción opcional
- Estados: PENDIENTE, EN_REVISION, RESUELTO, RECHAZADO

✅ **Panel de Moderación:**
- Solo accesible para moderadores (es_moderador='S')
- Estadísticas de reportes
- Filtros por estado
- Acciones: Revisar, Resolver, Rechazar
- Notas de resolución

### Endpoints del Backend

#### 1. Reportar Contenido
```
POST /api/contenido/:id/reportar
```

**Body:**
```json
{
  "id_perfil": 1,
  "motivo": "Contenido inapropiado",
  "descripcion": "Descripción detallada del problema"
}
```

**Motivos Disponibles:**
- Contenido inapropiado
- Violencia excesiva
- Lenguaje ofensivo
- Clasificación incorrecta
- Contenido engañoso
- Otro

#### 2. Listar Reportes (Solo Moderadores)
```
GET /api/reportes?estado=PENDIENTE&limit=50
```

#### 3. Estadísticas de Reportes (Solo Moderadores)
```
GET /api/reportes/stats
```

**Respuesta:**
```json
{
  "TOTAL": 25,
  "PENDIENTES": 5,
  "EN_REVISION": 3,
  "RESUELTOS": 15,
  "RECHAZADOS": 2
}
```

#### 4. Marcar como En Revisión (Solo Moderadores)
```
PUT /api/reportes/:id/revisar
```

#### 5. Resolver Reporte (Solo Moderadores)
```
PUT /api/reportes/:id/resolver
```

**Body:**
```json
{
  "resolucion_nota": "Se actualizó la clasificación del contenido"
}
```

#### 6. Rechazar Reporte (Solo Moderadores)
```
PUT /api/reportes/:id/rechazar
```

**Body:**
```json
{
  "resolucion_nota": "El contenido cumple con las políticas"
}
```

### Uso en el Frontend

**Página de Detalle (Reportar):**
- Botón "Reportar" con icono de bandera
- Modal con formulario de reporte
- Dropdown de motivos
- Campo de descripción opcional
- Confirmación de envío

**Página de Moderación (`/moderacion`):**
- Solo accesible para moderadores
- Tarjetas de estadísticas
- Filtros por estado
- Lista de reportes con toda la información
- Acciones por reporte
- Modal para agregar notas de resolución

---

## 🎯 Menú Desplegable de Usuario

### Características Implementadas

✅ **Menú en Navbar:**
- Se abre al hacer clic en el nombre del usuario
- Se cierra al hacer clic fuera
- Animación suave

✅ **Opciones del Menú:**
1. **Cambiar Perfil** - Ir a `/perfiles`
2. **Mis Favoritos** - Ir a `/favoritos`
3. **Mi Dashboard** - Ir a `/dashboard`
4. **Cerrar Sesión** - Logout

✅ **Información Mostrada:**
- Nombre completo del usuario
- Email
- Plan actual
- Icono de flecha que rota al abrir

### Implementación

**Navbar.jsx:**
```jsx
const [showUserMenu, setShowUserMenu] = useState(false);

// Cerrar al hacer clic fuera
useEffect(() => {
  function handleClickOutside(event) {
    if (menuRef.current && !menuRef.current.contains(event.target)) {
      setShowUserMenu(false);
    }
  }
  document.addEventListener('mousedown', handleClickOutside);
  return () => document.removeEventListener('mousedown', handleClickOutside);
}, []);
```

---

## 📊 Estructura de Datos

### Tabla REPRODUCCIONES

```sql
CREATE TABLE REPRODUCCIONES (
    id_reproduccion    NUMBER GENERATED ALWAYS AS IDENTITY,
    id_perfil          NUMBER        NOT NULL,
    id_contenido       NUMBER        NOT NULL,
    id_episodio        NUMBER,       -- NULL si no es serie/podcast
    fecha_hora_inicio  TIMESTAMP     NOT NULL,
    fecha_hora_fin     TIMESTAMP,
    dispositivo        VARCHAR2(15)  NOT NULL,
    porcentaje_avance  NUMBER(5,2)   DEFAULT 0,
    CONSTRAINT pk_reprod PRIMARY KEY (id_reproduccion, fecha_hora_inicio),
    CONSTRAINT chk_rep_disp CHECK (dispositivo IN ('CELULAR','TABLET','TV','COMPUTADOR')),
    CONSTRAINT chk_rep_porc CHECK (porcentaje_avance BETWEEN 0 AND 100)
)
PARTITION BY RANGE (fecha_hora_inicio) (
    PARTITION reprod_2024 VALUES LESS THAN (TIMESTAMP '2025-01-01 00:00:00'),
    PARTITION reprod_2025 VALUES LESS THAN (TIMESTAMP '2026-01-01 00:00:00'),
    PARTITION reprod_2026 VALUES LESS THAN (TIMESTAMP '2027-01-01 00:00:00'),
    PARTITION reprod_futuro VALUES LESS THAN (MAXVALUE)
);
```

### Tabla FAVORITOS

```sql
CREATE TABLE FAVORITOS (
    id_perfil     NUMBER  NOT NULL,
    id_contenido  NUMBER  NOT NULL,
    fecha_agregado DATE   DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_favoritos PRIMARY KEY (id_perfil, id_contenido)
);
```

### Tabla CALIFICACIONES

```sql
CREATE TABLE CALIFICACIONES (
    id_calificacion  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_perfil        NUMBER        NOT NULL,
    id_contenido     NUMBER        NOT NULL,
    estrellas        NUMBER(1)     NOT NULL,
    resena           VARCHAR2(2000),
    fecha            DATE          DEFAULT SYSDATE NOT NULL,
    CONSTRAINT uq_cal_perf_cont UNIQUE (id_perfil, id_contenido),
    CONSTRAINT chk_cal_estrellas CHECK (estrellas BETWEEN 1 AND 5)
);
```

### Tabla REPORTES

```sql
CREATE TABLE REPORTES (
    id_reporte       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_perfil        NUMBER        NOT NULL,
    id_contenido     NUMBER        NOT NULL,
    motivo           VARCHAR2(100) NOT NULL,
    descripcion      VARCHAR2(1000),
    estado           VARCHAR2(15)  DEFAULT 'PENDIENTE' NOT NULL,
    fecha_reporte    DATE          DEFAULT SYSDATE NOT NULL,
    id_moderador     NUMBER,
    fecha_resolucion DATE,
    resolucion_nota  VARCHAR2(500),
    CONSTRAINT chk_rep_estado CHECK (estado IN ('PENDIENTE','EN_REVISION','RESUELTO','RECHAZADO'))
);
```

---

## 🔐 Roles y Permisos

### Usuario Normal
✅ Puede:
- Ver contenido
- Reproducir contenido
- Agregar/eliminar favoritos
- Calificar y reseñar (con 50% de avance)
- Reportar contenido inapropiado

❌ No puede:
- Acceder al panel de moderación
- Resolver reportes
- Acceder al panel de administración

### Moderador (es_moderador='S')
✅ Puede hacer todo lo de usuario normal, más:
- Acceder al panel de moderación (`/moderacion`)
- Ver todos los reportes
- Marcar reportes como en revisión
- Resolver reportes
- Rechazar reportes
- Ver estadísticas de reportes

### Usuarios Moderadores de Prueba
```
Email: r.montoya@gmail.com
Password: password123

Email: s.pedraza@gmail.com
Password: password123

Email: h.castillo@gmail.com
Password: password123
```

---

## 🎨 Componentes del Frontend

### 1. FavoritosPage.jsx
- Página completa de favoritos
- Grid responsivo
- Botón eliminar con confirmación visual
- Mensaje vacío
- Navegación a detalles

### 2. ModeracionPage.jsx
- Panel de moderación completo
- Estadísticas con tarjetas
- Filtros por estado
- Lista de reportes
- Modal de resolución
- Acciones por reporte

### 3. ContenidoDetailPage.jsx
- Botón "Favorito"
- Botón "Reportar" con modal
- Sección de calificación
- Lista de reseñas
- Validación de 50% de avance
- Botón "Reproducir ahora"

### 4. Navbar.jsx
- Menú desplegable de usuario
- Cierre automático al hacer clic fuera
- Opciones: Perfiles, Favoritos, Dashboard, Logout
- Información del usuario

### 5. StarRating.jsx
- Componente reutilizable
- Tamaños: sm, md, lg
- Modo readonly
- Modo interactivo
- Estrellas llenas/vacías

---

## 🧪 Flujo de Pruebas

### Prueba 1: Reproducción y Calificación

1. **Iniciar sesión** con cualquier usuario
2. **Seleccionar un perfil**
3. **Ir a un contenido** (hacer clic en una tarjeta)
4. **Intentar calificar** sin reproducir
   - ❌ Debe mostrar: "Debes reproducir al menos el 50%"
5. **Hacer clic en "Reproducir ahora"**
   - ✅ Simula reproducción al 100%
6. **Calificar con estrellas** y agregar reseña
   - ✅ Debe guardar exitosamente
7. **Ver la reseña** en la lista de reseñas

### Prueba 2: Favoritos

1. **En la página de detalle**, hacer clic en "Favorito"
   - ✅ Debe mostrar "Agregado a favoritos"
2. **Hacer clic en el nombre del usuario** en el Navbar
3. **Seleccionar "Mis Favoritos"**
   - ✅ Debe mostrar el contenido agregado
4. **Hacer hover sobre la tarjeta**
   - ✅ Debe aparecer botón de eliminar
5. **Hacer clic en eliminar**
   - ✅ Debe eliminar y recargar la lista

### Prueba 3: Reportes

1. **En la página de detalle**, hacer clic en "Reportar"
2. **Seleccionar un motivo** del dropdown
3. **Agregar descripción** (opcional)
4. **Enviar reporte**
   - ✅ Debe mostrar "Reporte enviado"
5. **Iniciar sesión como moderador**
6. **Ir a `/moderacion`**
   - ✅ Debe ver el reporte en la lista
7. **Hacer clic en "Revisar"**
   - ✅ Estado cambia a "EN_REVISION"
8. **Hacer clic en "Resolver"**
9. **Agregar nota de resolución**
10. **Confirmar**
    - ✅ Estado cambia a "RESUELTO"

### Prueba 4: Menú de Usuario

1. **Hacer clic en el nombre del usuario** en el Navbar
   - ✅ Debe abrir menú desplegable
2. **Verificar opciones:**
   - Cambiar Perfil
   - Mis Favoritos
   - Mi Dashboard
   - Cerrar Sesión
3. **Hacer clic fuera del menú**
   - ✅ Debe cerrarse automáticamente
4. **Hacer clic en "Mis Favoritos"**
   - ✅ Debe navegar a `/favoritos`

---

## 📈 Métricas y Reportes

### Consultas SQL Útiles

#### Contenido más reproducido
```sql
SELECT c.titulo, COUNT(*) as reproducciones
FROM REPRODUCCIONES r
JOIN CONTENIDO c ON r.id_contenido = c.id_contenido
GROUP BY c.titulo
ORDER BY reproducciones DESC
FETCH FIRST 10 ROWS ONLY;
```

#### Contenido mejor calificado
```sql
SELECT c.titulo, AVG(cal.estrellas) as promedio, COUNT(*) as total_calificaciones
FROM CALIFICACIONES cal
JOIN CONTENIDO c ON cal.id_contenido = c.id_contenido
GROUP BY c.titulo
HAVING COUNT(*) >= 5
ORDER BY promedio DESC
FETCH FIRST 10 ROWS ONLY;
```

#### Reportes por motivo
```sql
SELECT motivo, COUNT(*) as total
FROM REPORTES
GROUP BY motivo
ORDER BY total DESC;
```

#### Usuarios más activos (más reproducciones)
```sql
SELECT u.nombre, u.apellido, COUNT(r.id_reproduccion) as reproducciones
FROM USUARIOS u
JOIN PERFILES p ON u.id_usuario = p.id_usuario
JOIN REPRODUCCIONES r ON p.id_perfil = r.id_perfil
GROUP BY u.nombre, u.apellido
ORDER BY reproducciones DESC
FETCH FIRST 10 ROWS ONLY;
```

---

## ⚠️ Notas Importantes

### 1. Validación de 50% de Avance
- Para calificar, el perfil debe haber reproducido al menos el 50% del contenido
- Se verifica en el backend antes de permitir la calificación
- El botón "Reproducir ahora" simula reproducción al 100% para pruebas

### 2. Moderadores
- Solo usuarios con `es_moderador='S'` pueden acceder al panel de moderación
- El middleware `moderadorMiddleware` valida esto en cada endpoint
- Los moderadores también son usuarios normales con permisos adicionales

### 3. Favoritos por Perfil
- Cada perfil tiene su propia lista de favoritos
- No se comparten entre perfiles de la misma cuenta
- Se puede agregar el mismo contenido en múltiples perfiles

### 4. Reportes
- Un perfil puede reportar el mismo contenido múltiples veces
- Los reportes no eliminan ni ocultan el contenido automáticamente
- Los moderadores deciden la acción a tomar

### 5. Reproducciones Particionadas
- La tabla está particionada por año para mejor rendimiento
- Las consultas deben incluir el rango de fechas cuando sea posible
- Las particiones se gestionan automáticamente

---

## 🐛 Solución de Problemas

### Problema: No puedo calificar
**Solución:** Verifica que hayas reproducido al menos el 50% del contenido. Usa el botón "Reproducir ahora" para simular.

### Problema: No veo el menú de usuario
**Solución:** Asegúrate de estar logueado. El menú solo aparece para usuarios autenticados.

### Problema: No puedo acceder a moderación
**Solución:** Solo usuarios con rol de moderador pueden acceder. Verifica que `es_moderador='S'` en la base de datos.

### Problema: Los favoritos no se guardan
**Solución:** Verifica que hayas seleccionado un perfil. Los favoritos son por perfil, no por usuario.

### Problema: El reporte no aparece en moderación
**Solución:** Refresca la página. Verifica que el estado del filtro sea correcto (PENDIENTE por defecto).

---

**Última actualización:** Mayo 21, 2026  
**Versión:** 1.0.0  
**Estado:** ✅ Completamente implementado y funcional
