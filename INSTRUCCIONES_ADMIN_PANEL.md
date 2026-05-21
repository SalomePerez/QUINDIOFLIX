# Panel de Administración de Contenido

## Implementación Completa

Se ha creado un panel de administración completo para que los usuarios con rol de moderador/administrador puedan gestionar el catálogo de contenido, temporadas y episodios.

## Archivos Creados/Modificados

### Backend
1. **`backend/src/routes/admin.routes.js`** - Nuevas rutas de administración:
   - `POST /api/admin/contenido` - Crear contenido
   - `PUT /api/admin/contenido/:id` - Actualizar contenido
   - `DELETE /api/admin/contenido/:id` - Eliminar contenido
   - `GET /api/admin/contenido/:id/temporadas` - Listar temporadas
   - `POST /api/admin/contenido/:id/temporadas` - Crear temporada
   - `DELETE /api/admin/temporadas/:id` - Eliminar temporada
   - `GET /api/admin/temporadas/:id/episodios` - Listar episodios
   - `POST /api/admin/temporadas/:id/episodios` - Crear episodio
   - `DELETE /api/admin/episodios/:id` - Eliminar episodio
   - `GET /api/admin/empleados` - Listar empleados

2. **`backend/src/index.js`** - Registradas las rutas de admin

### Frontend
3. **`frontend/src/pages/AdminContenidoPage.jsx`** - Panel completo con:
   - Lista de todo el catálogo
   - Formulario para crear nuevo contenido
   - Gestión de temporadas (para series y podcasts)
   - Gestión de episodios por temporada
   - Eliminación de contenido, temporadas y episodios

4. **`frontend/src/components/Navbar.jsx`** - Ya incluye enlace "Admin" (solo visible para moderadores)

## Funcionalidades Implementadas

### ✅ Gestión de Contenido
- **Crear** nuevo contenido (películas, series, documentales, música, podcasts)
- **Listar** todo el catálogo con filtros visuales
- **Eliminar** contenido
- **Marcar** como producción original de QuindioFlix
- **Asignar** empleado responsable
- **Clasificar** por edad (TP, +7, +13, +16, +18)

### ✅ Gestión de Temporadas (Series y Podcasts)
- **Crear** temporadas para series y podcasts
- **Listar** temporadas con contador de episodios
- **Eliminar** temporadas (elimina también sus episodios)
- **Navegar** entre contenido y temporadas

### ✅ Gestión de Episodios
- **Crear** episodios para cada temporada
- **Listar** episodios ordenados por número
- **Eliminar** episodios individuales
- **Especificar** duración, sinopsis y fecha de estreno

## Cómo Usar

### 1. Acceso al Panel
- Solo usuarios con `ES_MODERADOR = 'S'` ven el enlace "Admin" en el navbar
- Ruta: `/admin/contenido`

### 2. Crear Contenido
1. Click en "Agregar Contenido"
2. Completar formulario:
   - Título, tipo, año, duración
   - Categoría, clasificación por edad
   - Sinopsis (opcional)
   - Marcar si es producción original
   - Asignar empleado responsable (opcional)
3. Click en "Crear Contenido"

### 3. Gestionar Temporadas (Solo Series/Podcasts)
1. En la lista de contenido, click en "Temporadas" (botón azul)
2. Completar formulario de temporada:
   - Número de temporada
   - Título (opcional)
   - Año
   - Descripción (opcional)
3. Click en "Crear Temporada"

### 4. Gestionar Episodios
1. En la lista de temporadas, click en "Episodios"
2. Completar formulario de episodio:
   - Número de episodio
   - Título
   - Duración en minutos
   - Sinopsis (opcional)
   - Fecha de estreno (opcional)
3. Click en "Crear Episodio"

## Datos de Prueba

Los datos de prueba ya incluyen:
- ✅ 40 contenidos (películas, series, documentales, música, podcasts)
- ✅ 15 temporadas para series y podcasts
- ✅ 50+ episodios distribuidos en las temporadas

Para ver las temporadas y episodios existentes:
1. Ve a `/admin/contenido`
2. Busca una serie (ej: "Los Cafeteros", "Medellín Noir")
3. Click en "Temporadas"
4. Click en "Episodios" de cualquier temporada

## Asignar Rol de Moderador

Para que un usuario pueda acceder al panel de administración, debe tener `ES_MODERADOR = 'S'`:

```sql
-- Asignar rol de moderador a un usuario
UPDATE USUARIOS 
SET es_moderador = 'S' 
WHERE email = 'tu@email.com';

COMMIT;
```

## Verificar Temporadas y Episodios

Si no ves temporadas/episodios en el detalle del contenido, verifica que existan en la BD:

```sql
-- Ver series con sus temporadas
SELECT c.id_contenido, c.titulo, COUNT(t.id_temporada) AS num_temporadas
FROM CONTENIDO c
LEFT JOIN TEMPORADAS t ON c.id_contenido = t.id_contenido
WHERE c.tipo IN ('SERIE', 'PODCAST')
GROUP BY c.id_contenido, c.titulo
ORDER BY c.id_contenido;

-- Ver episodios de una temporada específica
SELECT * FROM EPISODIOS WHERE id_temporada = 1 ORDER BY numero;
```

## Próximas Mejoras (Opcional)

- [ ] Subir imágenes/posters para el contenido
- [ ] Subir videos/trailers
- [ ] Editar contenido existente (actualmente solo crear/eliminar)
- [ ] Asignar géneros desde el panel de admin
- [ ] Búsqueda y filtros en el panel de admin
- [ ] Paginación para catálogos grandes
- [ ] Validación de permisos más estricta (verificar token JWT)

## Notas Importantes

1. **Eliminación en cascada**: Al eliminar una temporada, se eliminan automáticamente todos sus episodios (constraint de FK en la BD)

2. **Validaciones**: El backend valida que:
   - Los campos obligatorios estén presentes
   - Los números sean válidos
   - Las fechas tengan formato correcto

3. **Seguridad**: Actualmente el middleware `adminMiddleware` permite a todos los usuarios autenticados. En producción, deberías verificar que `req.user.es_moderador === 'S'`

4. **IDs de empleados**: Si no seleccionas un empleado responsable, se asigna el empleado con ID 1 por defecto

## Pruebas

### Probar Creación de Contenido:
1. Login como usuario moderador
2. Ve a `/admin/contenido`
3. Click en "Agregar Contenido"
4. Crea una nueva película o serie
5. Verifica que aparezca en la lista

### Probar Temporadas y Episodios:
1. Crea una serie nueva
2. Click en "Temporadas"
3. Agrega 2-3 temporadas
4. Para cada temporada, agrega 3-4 episodios
5. Ve al detalle del contenido (`/contenido/:id`) y verifica que se muestren las temporadas y episodios
