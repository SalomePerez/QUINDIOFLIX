# Gestión de Contenido Relacionado - QuindioFlix

## 📋 Descripción

QuindioFlix permite asociar contenido relacionado entre sí. Por ejemplo:
- Una película puede tener una **secuela** o **precuela**
- Un documental puede tener una **versión extendida**
- Una serie puede tener un **spin-off**
- Contenido puede tener **remakes** o **adaptaciones**

Esta relación puede ser entre contenidos del mismo tipo o de tipos diferentes.

---

## 🎯 Tipos de Relaciones Disponibles

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| **SECUELA** | Continuación de la historia | "El Padrino II" es secuela de "El Padrino" |
| **PRECUELA** | Historia anterior | "Star Wars: Episodio I" es precuela de "Episodio IV" |
| **REMAKE** | Nueva versión de contenido existente | "El Rey León (2019)" es remake de "El Rey León (1994)" |
| **SPIN_OFF** | Historia derivada con personajes secundarios | "Better Call Saul" es spin-off de "Breaking Bad" |
| **VERSION_EXTENDIDA** | Versión con contenido adicional | "El Señor de los Anillos: Versión Extendida" |
| **ADAPTACION** | Basado en otro contenido | "The Witcher (Serie)" es adaptación del videojuego |
| **OTRO** | Cualquier otra relación | Relaciones personalizadas |

---

## 🔧 Cómo Gestionar Contenido Relacionado (Administradores)

### Acceder a la Gestión

1. Iniciar sesión como **moderador**
   - Email: r.montoya@gmail.com
   - Contraseña: password123

2. Ir al panel **"Admin"** en la barra de navegación

3. En la lista de contenidos, hacer clic en el **botón morado** (icono de flecha) del contenido que deseas gestionar

### Agregar una Relación

1. En la vista de "Contenido Relacionado", verás dos paneles:
   - **Izquierda:** Formulario para agregar relaciones
   - **Derecha:** Lista de relaciones existentes

2. En el formulario:
   - **Contenido Relacionado:** Seleccionar el contenido destino del dropdown
   - **Tipo de Relación:** Seleccionar el tipo (Secuela, Precuela, etc.)
   - **Descripción:** (Opcional) Agregar detalles adicionales

3. Hacer clic en **"Agregar Relación"**

4. La relación aparecerá inmediatamente en la lista de la derecha

### Eliminar una Relación

1. En la lista de contenido relacionado (panel derecho)
2. Hacer clic en el **icono de basura (rojo)** de la relación que deseas eliminar
3. Confirmar la eliminación
4. La relación se eliminará inmediatamente

---

## 👀 Cómo Ver Contenido Relacionado (Usuarios)

### En la Página de Detalle

1. Navegar a cualquier contenido (película, serie, etc.)
2. Hacer clic para ver los detalles
3. Si el contenido tiene relaciones, verás una sección **"Contenido Relacionado"**
4. Cada tarjeta muestra:
   - **Tipo de relación** (badge morado en la esquina superior)
   - **Tipo de contenido** (PELICULA, SERIE, etc.)
   - **Título** del contenido relacionado
   - **Descripción** (si existe)

---

## 🎨 Características de la UI

### Panel de Administración

- **Botón morado** con icono de flecha para acceder
- **Formulario intuitivo** con dropdown de contenidos
- **Lista visual** con badges de colores
- **Eliminación rápida** con confirmación

### Vista Pública (Detalle)

- **Grid responsivo** (1 columna en móvil, 2 en desktop)
- **Badges morados** para tipos de relación
- **Hover effects** para mejor UX
- **Información completa** de cada relación

---

## 📊 Ejemplos de Uso

### Ejemplo 1: Trilogía de Películas

**El Padrino (1972)**
- Agregar relación: SECUELA → "El Padrino II (1974)"
- Descripción: "Continuación de la saga Corleone"

**El Padrino II (1974)**
- Agregar relación: PRECUELA → "El Padrino (1972)"
- Agregar relación: SECUELA → "El Padrino III (1990)"

### Ejemplo 2: Serie y Spin-off

**Breaking Bad**
- Agregar relación: SPIN_OFF → "Better Call Saul"
- Descripción: "Precuela centrada en el abogado Saul Goodman"

### Ejemplo 3: Remake

**El Rey León (1994)**
- Agregar relación: REMAKE → "El Rey León (2019)"
- Descripción: "Versión con CGI fotorrealista"

### Ejemplo 4: Versión Extendida

**El Señor de los Anillos: La Comunidad del Anillo**
- Agregar relación: VERSION_EXTENDIDA → "LOTR: La Comunidad (Extendida)"
- Descripción: "Incluye 30 minutos de escenas adicionales"

---

## 🔍 Validaciones y Restricciones

### Backend

✅ **Validaciones implementadas:**
- Tipo de relación debe ser uno de los 7 tipos válidos
- No se puede relacionar un contenido consigo mismo
- No se pueden crear relaciones duplicadas
- El contenido destino debe existir

❌ **Errores comunes:**
- `400 Bad Request`: Faltan campos obligatorios
- `404 Not Found`: El contenido destino no existe
- `409 Conflict`: La relación ya existe

### Frontend

✅ **Características:**
- Dropdown excluye el contenido actual (no auto-relación)
- Validación de campos requeridos
- Mensajes de error claros
- Actualización automática de la lista

---

## 🚀 Endpoints de la API

### Para Administradores

```
GET    /api/admin/contenido/:id/relacionados
POST   /api/admin/contenido/:id/relacionados
DELETE /api/admin/contenido/:id/relacionados/:id_destino
```

### Para Usuarios (Público)

```
GET /api/contenido/:id
```
(Incluye el campo `relacionados` en la respuesta)

---

## 📝 Estructura de Datos

### Tabla en Base de Datos

```sql
CREATE TABLE CONTENIDO_RELACIONADO (
    id_contenido_origen  NUMBER NOT NULL,
    id_contenido_destino NUMBER NOT NULL,
    tipo_relacion        VARCHAR2(30) NOT NULL,
    descripcion          VARCHAR2(200),
    PRIMARY KEY (id_contenido_origen, id_contenido_destino)
);
```

### Respuesta de la API

```json
{
  "ID_CONTENIDO_DESTINO": 45,
  "TIPO_RELACION": "SECUELA",
  "DESCRIPCION": "Continuación de la historia",
  "TITULO": "El Padrino II",
  "TIPO": "PELICULA",
  "ANIO_LANZAMIENTO": 1974,
  "CLASIFICACION_EDAD": "+16"
}
```

---

## 🎯 Casos de Uso Recomendados

### 1. Franquicias de Películas
- Relacionar todas las películas de una saga
- Usar SECUELA/PRECUELA para orden cronológico

### 2. Universos Cinematográficos
- Conectar películas del mismo universo
- Usar SPIN_OFF para historias derivadas

### 3. Documentales
- Relacionar versiones extendidas
- Conectar documentales sobre el mismo tema

### 4. Series de TV
- Relacionar spin-offs
- Conectar remakes o adaptaciones

### 5. Contenido Musical
- Relacionar conciertos del mismo artista
- Conectar versiones en vivo con álbumes de estudio

---

## ⚠️ Notas Importantes

1. **Relaciones Unidireccionales:** 
   - Si "A" es secuela de "B", debes crear la relación desde "B" hacia "A"
   - Para relación bidireccional, crear dos relaciones (una en cada dirección)

2. **Eliminación en Cascada:**
   - Al eliminar un contenido, se eliminan automáticamente todas sus relaciones

3. **Permisos:**
   - Solo moderadores pueden gestionar relaciones
   - Todos los usuarios pueden ver las relaciones

4. **Límites:**
   - No hay límite en el número de relaciones por contenido
   - Se recomienda mantener relaciones relevantes y útiles

---

## 🐛 Solución de Problemas

### Problema: No veo el botón morado
**Solución:** Verifica que estés en el panel Admin como moderador

### Problema: Error al agregar relación
**Solución:** 
- Verifica que seleccionaste un contenido destino
- Verifica que la relación no exista ya
- Revisa los logs del backend

### Problema: No aparece el contenido relacionado en la vista pública
**Solución:**
- Verifica que la relación se creó correctamente en el panel Admin
- Refresca la página de detalle
- Revisa la consola del navegador para errores

---

## 📞 Soporte

Si encuentras problemas:
1. Revisar los logs del backend (Terminal 19)
2. Revisar la consola del navegador (F12)
3. Verificar que ambos servidores estén corriendo
4. Consultar este documento para casos de uso

---

**Última actualización:** Mayo 20, 2026  
**Versión:** 1.0.0  
**Estado:** ✅ Implementado y funcional
