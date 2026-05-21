# Instrucciones para Probar la Eliminación de Contenido

## ✅ Estado Actual
- **Backend:** ✅ Corriendo en http://localhost:3001
- **Frontend:** ✅ Corriendo en http://localhost:5173
- **Base de Datos:** ✅ Conectada

---

## 🧪 Pasos para Probar la Eliminación

### 1. Acceder al Panel de Administración

1. Abrir el navegador en: **http://localhost:5173**
2. Hacer clic en "Iniciar Sesión"
3. Usar uno de estos usuarios moderadores:
   - **Email:** r.montoya@gmail.com
   - **Contraseña:** password123

### 2. Ir al Panel Admin

1. Una vez iniciada la sesión, hacer clic en **"Admin"** en la barra de navegación superior
2. Verás la lista completa de contenidos del catálogo

### 3. Seleccionar un Contenido para Eliminar

**RECOMENDACIÓN:** Eliminar un contenido que NO tenga muchas relaciones para la primera prueba.

Busca un contenido que:
- No sea muy popular (menos reproducciones)
- Preferiblemente sea una película (no tiene temporadas/episodios)
- No esté en muchas listas de favoritos

### 4. Eliminar el Contenido

1. Hacer clic en el **icono de basura (rojo)** del contenido seleccionado
2. Aparecerá un diálogo de confirmación que dice:
   > "¿Estás seguro de eliminar este contenido? Se eliminarán también sus temporadas, episodios y todas las relaciones."
3. Hacer clic en **"Aceptar"** o **"OK"**

### 5. Verificar el Resultado

**Si funciona correctamente:**
- ✅ Verás un mensaje: "Contenido eliminado exitosamente."
- ✅ El contenido desaparecerá de la lista
- ✅ La lista se actualizará automáticamente

**Si hay un error:**
- ❌ Verás un error 500 en la consola del navegador
- ❌ Aparecerá un alert con el mensaje de error
- ❌ El contenido seguirá en la lista

---

## 🔍 Cómo Verificar si Hay Errores

### En el Navegador:
1. Presionar **F12** para abrir las herramientas de desarrollo
2. Ir a la pestaña **"Console"**
3. Buscar mensajes de error en rojo

### En el Backend:
Los logs del backend mostrarán información detallada:
- "Intentando eliminar contenido ID: X"
- "Géneros eliminados"
- "Favoritos eliminados"
- "Calificaciones eliminadas"
- etc.

---

## 🐛 Si Hay un Error 500

### Paso 1: Identificar el Contenido Problemático
Anota el **ID del contenido** que intentaste eliminar (aparece en el error de la consola).

### Paso 2: Verificar Relaciones en la Base de Datos
Ejecuta el script `test_delete_contenido.sql` en SQL Developer:
1. Abrir SQL Developer
2. Conectarse como usuario QUINDIOFLIX
3. Abrir el archivo `test_delete_contenido.sql`
4. Cambiar el valor de `v_id` al ID del contenido problemático
5. Ejecutar el script
6. Ver qué relaciones tiene y dónde falla

### Paso 3: Reportar el Error
Si encuentras un error, anota:
- ID del contenido
- Mensaje de error exacto
- Qué tabla está causando el problema (según el script de prueba)

---

## 📋 Contenidos Sugeridos para Probar

### Opción 1: Crear un Contenido de Prueba
1. En el panel Admin, hacer clic en **"Agregar Contenido"**
2. Crear una película simple:
   - Título: "Prueba de Eliminación"
   - Tipo: PELICULA
   - Año: 2026
   - Duración: 90 minutos
   - Clasificación: TP
   - Género: Seleccionar uno cualquiera
3. Crear el contenido
4. Inmediatamente eliminarlo

**Ventaja:** No tiene relaciones, debería eliminarse sin problemas.

### Opción 2: Eliminar un Contenido Existente
Busca en la lista un contenido con:
- Tipo: PELICULA (no tiene temporadas)
- Año reciente (menos probable que tenga muchas reproducciones)
- Título que no reconozcas como popular

---

## ✅ Prueba de Edición (Bonus)

Mientras estás en el panel Admin, también puedes probar la edición:

1. Hacer clic en el **icono de lápiz (azul)** de cualquier contenido
2. Modificar algún campo (por ejemplo, cambiar el año)
3. Cambiar los géneros seleccionados
4. Hacer clic en **"Actualizar Contenido"**
5. Verificar que los cambios se guardaron

---

## 🎯 Resultado Esperado

Después de probar:
- ✅ La eliminación debe funcionar sin errores
- ✅ El contenido debe desaparecer de la lista
- ✅ No debe haber errores 500 en la consola
- ✅ La edición debe funcionar correctamente
- ✅ Los cambios deben persistir en la base de datos

---

## 📞 Siguiente Paso

Una vez que hayas probado la eliminación:
1. Reporta si funcionó correctamente
2. Si hubo errores, proporciona los detalles
3. Podemos proceder a implementar más funcionalidades

---

**Nota:** Los servidores deben estar corriendo para que funcione. Si se detuvieron, reinícialos con:
```bash
# Backend
cd backend
npm start

# Frontend (en otra terminal)
cd frontend
npm run dev
```
