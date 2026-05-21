# Gestión de Perfiles - QuindioFlix

## 📋 Descripción

QuindioFlix ahora incluye un sistema completo de gestión de perfiles que permite a cada usuario crear múltiples perfiles según su plan de suscripción. Cada perfil puede ser de tipo **Adulto** o **Infantil**, con diferentes restricciones de contenido.

---

## 🎯 Características del Sistema de Perfiles

### Tipos de Perfiles

| Tipo | Descripción | Contenido Permitido |
|------|-------------|---------------------|
| **ADULTO** | Perfil sin restricciones | Todo el contenido (TP, +7, +13, +16, +18) |
| **INFANTIL** | Perfil con control parental | Solo contenido TP, +7 y +13 |

### Límites por Plan

| Plan | Perfiles Máximos |
|------|------------------|
| BÁSICO | 2 perfiles |
| ESTÁNDAR | 3 perfiles |
| PREMIUM | 5 perfiles |

---

## 🚀 Flujo de Usuario

### 1. Registro de Nueva Cuenta

1. El usuario completa el formulario de registro
2. Selecciona su plan de suscripción (Básico, Estándar o Premium)
3. Después del registro exitoso, es redirigido al login
4. Ve un mensaje: "¡Cuenta creada exitosamente! Ahora inicia sesión."

### 2. Primer Inicio de Sesión

1. El usuario inicia sesión con email y contraseña
2. Es redirigido automáticamente a `/perfiles`
3. Ve el mensaje: "Crea tu primer perfil"
4. **Debe crear al menos un perfil** para poder acceder al contenido

### 3. Creación del Primer Perfil

1. El formulario se muestra automáticamente
2. El usuario ingresa:
   - **Nombre del perfil** (ej: "Juan", "María", "Niños")
   - **Tipo de perfil** (Adulto o Infantil)
3. Hace clic en "Crear Perfil"
4. El perfil se crea y se selecciona automáticamente
5. Es redirigido a la página de inicio

### 4. Inicios de Sesión Posteriores

1. El usuario inicia sesión
2. Es redirigido a `/perfiles`
3. Ve todos sus perfiles existentes
4. Selecciona el perfil que desea usar
5. Es redirigido a la página de inicio

---

## 🎨 Página de Gestión de Perfiles

### Acceso

- **URL:** `/perfiles`
- **Desde el Navbar:** Hacer clic en el nombre del perfil actual (esquina superior derecha)
- **Automático:** Después de iniciar sesión

### Funcionalidades

#### Ver Perfiles Existentes
- Muestra todos los perfiles activos del usuario
- Cada perfil muestra:
  - Icono (👤 para Adulto, 👶 para Infantil)
  - Nombre del perfil
  - Badge "Infantil" si aplica

#### Seleccionar Perfil
- Hacer clic en cualquier perfil para seleccionarlo
- El usuario es redirigido automáticamente a la página de inicio
- El perfil seleccionado se guarda en localStorage

#### Agregar Nuevo Perfil
1. Hacer clic en el botón "+" (Agregar perfil)
2. Se muestra el formulario de creación
3. Completar nombre y tipo
4. Hacer clic en "Crear Perfil"
5. El nuevo perfil aparece en la lista

#### Eliminar Perfil
1. Pasar el mouse sobre un perfil
2. Aparece un botón rojo de basura en la esquina superior derecha
3. Hacer clic en el botón
4. Confirmar la eliminación
5. El perfil se elimina (eliminación lógica, `activo='N'`)

---

## 🔒 Validaciones y Restricciones

### Backend

✅ **Validaciones implementadas:**
- No se pueden crear más perfiles que el límite del plan
- El nombre del perfil es obligatorio (máximo 50 caracteres)
- El tipo debe ser 'ADULTO' o 'INFANTIL'
- Solo se pueden eliminar perfiles propios

❌ **Errores comunes:**
- `400 Bad Request`: Límite de perfiles alcanzado
- `400 Bad Request`: Nombre del perfil requerido
- `404 Not Found`: Perfil no encontrado

### Frontend

✅ **Características:**
- Muestra contador de perfiles (ej: "Tienes 2 de 3 perfiles disponibles")
- Deshabilita el botón "+" cuando se alcanza el límite
- Validación de campos requeridos
- Confirmación antes de eliminar
- Mensajes de error claros

---

## 🎯 Casos de Uso

### Caso 1: Familia con Niños

**Usuario:** Juan Pérez (Plan ESTÁNDAR - 3 perfiles)

**Perfiles creados:**
1. **Juan** (Adulto) - Para el padre
2. **María** (Adulto) - Para la madre
3. **Niños** (Infantil) - Para los hijos

**Beneficio:** Los niños solo ven contenido apropiado (TP, +7, +13)

### Caso 2: Usuario Individual

**Usuario:** Ana García (Plan BÁSICO - 2 perfiles)

**Perfiles creados:**
1. **Ana** (Adulto) - Perfil principal
2. **Trabajo** (Adulto) - Para ver documentales y contenido educativo

**Beneficio:** Separación de historial y recomendaciones

### Caso 3: Compartir Cuenta

**Usuario:** Carlos López (Plan PREMIUM - 5 perfiles)

**Perfiles creados:**
1. **Carlos** (Adulto)
2. **Laura** (Adulto)
3. **Mamá** (Adulto)
4. **Sofía** (Infantil)
5. **Mateo** (Infantil)

**Beneficio:** Cada miembro de la familia tiene su propio perfil personalizado

---

## 🔄 Flujo Técnico

### Almacenamiento de Sesión

```javascript
localStorage.setItem('qf_session', JSON.stringify({
  user: { ID_USUARIO, NOMBRE, EMAIL, PLAN, ES_MODERADOR },
  perfil: { ID_PERFIL, NOMBRE, TIPO }
}));
```

### Navegación

```
/register → /login → /perfiles → / (home)
                         ↑
                         |
                    (cambiar perfil)
```

### Protección de Rutas

- `/perfiles` requiere autenticación (usuario logueado)
- `/` requiere autenticación Y perfil seleccionado
- Si no hay perfil seleccionado, se redirige a `/perfiles`

---

## 📊 Endpoints de la API

### Perfiles

```
GET    /api/auth/perfiles/:id_usuario
POST   /api/auth/perfiles
DELETE /api/auth/perfiles/:id_perfil
```

### Usuario (con info del plan)

```
GET /api/usuarios/:id
```

Respuesta incluye:
- `MAX_PERFILES`: Límite de perfiles según el plan
- `PLAN`: Nombre del plan
- `PRECIO_MENSUAL`: Precio del plan
- `CALIDAD_VIDEO`: Calidad máxima
- `NUM_PANTALLAS`: Pantallas simultáneas

---

## 🎨 Componentes UI

### PerfilesPage.jsx

**Características:**
- Grid responsivo de perfiles
- Formulario inline para crear perfiles
- Hover effects y animaciones
- Iconos diferenciados por tipo
- Contador de perfiles disponibles

**Estados:**
- `perfiles`: Array de perfiles del usuario
- `showForm`: Mostrar/ocultar formulario
- `form`: Datos del nuevo perfil
- `maxPerfiles`: Límite según el plan

### Navbar.jsx

**Cambios:**
- El nombre del perfil ahora es un enlace a `/perfiles`
- Muestra el nombre del plan
- Permite cambiar de perfil fácilmente

---

## ⚠️ Notas Importantes

### 1. Primer Perfil Obligatorio
- Un usuario **no puede** acceder al contenido sin crear al menos un perfil
- El formulario se muestra automáticamente si no hay perfiles

### 2. Persistencia de Sesión
- El perfil seleccionado se guarda en localStorage
- Persiste entre recargas de página
- Se limpia al hacer logout

### 3. Control Parental
- Los perfiles infantiles tienen restricciones automáticas
- El filtrado se hace en el backend (no se puede burlar desde el frontend)
- Los perfiles infantiles solo ven contenido TP, +7 y +13

### 4. Límites del Plan
- El límite se valida en el backend
- Si el usuario baja de plan, debe eliminar perfiles primero
- No se pueden crear más perfiles que el límite

### 5. Eliminación Lógica
- Los perfiles no se eliminan físicamente de la BD
- Se marca como `activo='N'`
- Preserva el historial de reproducciones y calificaciones

---

## 🐛 Solución de Problemas

### Problema: No puedo crear más perfiles
**Solución:** Has alcanzado el límite de tu plan. Opciones:
- Eliminar un perfil existente
- Actualizar a un plan superior

### Problema: No veo el botón para agregar perfil
**Solución:** Ya tienes el máximo de perfiles permitidos por tu plan

### Problema: Después de login me redirige a /perfiles pero no veo perfiles
**Solución:** Es tu primera vez, debes crear tu primer perfil usando el formulario

### Problema: No puedo eliminar un perfil
**Solución:** 
- Verifica que sea tu perfil (no puedes eliminar perfiles de otros usuarios)
- Verifica que no sea el único perfil (debe haber al menos uno)

### Problema: El perfil infantil ve contenido +16 o +18
**Solución:** Esto no debería pasar. Reportar el bug con:
- ID del perfil
- ID del contenido que no debería ver
- Logs del backend

---

## 📞 Soporte

Si encuentras problemas:
1. Revisar la consola del navegador (F12)
2. Revisar los logs del backend
3. Verificar que ambos servidores estén corriendo
4. Consultar este documento

---

**Última actualización:** Mayo 20, 2026  
**Versión:** 1.0.0  
**Estado:** ✅ Implementado y funcional
