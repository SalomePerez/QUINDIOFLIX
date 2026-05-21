# 🎬 Instrucciones: Agregar Soporte de Archivos Multimedia

## ⚠️ Error Actual

```
ORA-00904: "URL_ARCHIVO": identificador no válido
```

Este error ocurre porque la columna `URL_ARCHIVO` no existe en las tablas `CONTENIDO` y `EPISODIOS`.

---

## ✅ Solución: Ejecutar Script SQL

### Opción 1: SQL Developer (Recomendado)

1. **Abrir SQL Developer**
2. **Conectarse** como usuario `QUINDIOFLIX`
3. **Abrir el archivo** `EJECUTAR_AGREGAR_URL_ARCHIVO.sql`
4. **Ejecutar el script completo** (F5 o botón "Run Script")
5. **Verificar** que aparezca el mensaje de éxito

### Opción 2: SQL*Plus

```bash
sqlplus QUINDIOFLIX/tu_password@localhost:1521/XEPDB1
@EJECUTAR_AGREGAR_URL_ARCHIVO.sql
```

### Opción 3: Copiar y Pegar

Si prefieres copiar y pegar, ejecuta estos comandos uno por uno:

```sql
-- 1. Agregar columna a CONTENIDO
ALTER TABLE CONTENIDO ADD (url_archivo VARCHAR2(500));

-- 2. Agregar columna a EPISODIOS
ALTER TABLE EPISODIOS ADD (url_archivo VARCHAR2(500));

-- 3. Confirmar cambios
COMMIT;

-- 4. Verificar
SELECT COUNT(*) FROM USER_TAB_COLUMNS 
WHERE TABLE_NAME = 'CONTENIDO' AND COLUMN_NAME = 'URL_ARCHIVO';
-- Debe devolver 1

SELECT COUNT(*) FROM USER_TAB_COLUMNS 
WHERE TABLE_NAME = 'EPISODIOS' AND COLUMN_NAME = 'URL_ARCHIVO';
-- Debe devolver 1
```

---

## 🔍 Verificación

Después de ejecutar el script, verifica que todo esté correcto:

### 1. Verificar que las columnas existen

```sql
-- Ver estructura de CONTENIDO
DESC CONTENIDO;

-- Ver estructura de EPISODIOS
DESC EPISODIOS;
```

Deberías ver `URL_ARCHIVO VARCHAR2(500)` en ambas tablas.

### 2. Verificar contenido de ejemplo

```sql
-- Ver contenidos con archivos
SELECT id_contenido, titulo, tipo, url_archivo 
FROM CONTENIDO 
WHERE url_archivo IS NOT NULL;
```

Deberías ver algunos contenidos con URLs de videos de ejemplo.

---

## 🎯 Después de Ejecutar el Script

### 1. Reiniciar el Backend

El backend ya está configurado para manejar archivos, solo necesita que la base de datos tenga las columnas.

**No es necesario reiniciar**, pero si quieres asegurarte:

```bash
# Detener el backend (Ctrl+C en la terminal)
# Iniciar nuevamente
cd backend
npm start
```

### 2. Probar la Funcionalidad

#### A. Subir un Archivo

1. **Ir al panel de administración**: http://localhost:5175/admin/contenido
2. **Editar un contenido** (hacer clic en el icono de lápiz)
3. **Scroll hacia abajo** hasta la sección "Archivo Multimedia"
4. **Hacer clic** en "Haz clic para seleccionar archivo"
5. **Seleccionar un video** (MP4, MPEG, MOV, AVI, WEBM - máx 500MB)
6. **Esperar** a que se suba (verás una barra de progreso)
7. **Confirmar** que aparece "Archivo subido exitosamente"

#### B. Ver el Contenido

1. **Ir a la página principal**: http://localhost:5175/
2. **Hacer clic** en el contenido que acabas de editar
3. **Verificar** que aparece el reproductor de video
4. **Hacer clic en Play** para reproducir

---

## 📁 Tipos de Archivos Soportados

### Videos (para PELICULA, SERIE, DOCUMENTAL)
- ✅ MP4 (recomendado)
- ✅ MPEG
- ✅ MOV (QuickTime)
- ✅ AVI
- ✅ WEBM

### Audio (para MUSICA, PODCAST)
- ✅ MP3 (recomendado)
- ✅ WAV
- ✅ OGG
- ✅ WEBM

### Límite de Tamaño
- **Máximo:** 500MB por archivo

---

## 🗂️ Ubicación de Archivos Subidos

Los archivos se guardan en:

```
backend/
  uploads/
    videos/     ← Videos (películas, series, documentales)
    audio/      ← Audio (música, podcasts)
```

**Importante:** Estas carpetas ya fueron creadas automáticamente por el sistema.

---

## 🎬 Funcionalidades del Reproductor

### Controles Disponibles

1. **Play/Pause** - Reproducir o pausar
2. **Barra de progreso** - Saltar a cualquier punto
3. **Volumen** - Ajustar volumen o silenciar
4. **Pantalla completa** - Solo para videos
5. **Reiniciar** - Volver al inicio
6. **Tiempo** - Muestra tiempo actual y duración total

### Seguimiento Automático

El reproductor automáticamente:
- ✅ Registra el inicio de reproducción en la base de datos
- ✅ Actualiza el porcentaje de avance cada 5 segundos
- ✅ Marca como finalizada cuando termina
- ✅ Permite calificar después del 50% de avance

---

## 🔧 Solución de Problemas

### Problema 1: "No se recibió ningún archivo"

**Causa:** El archivo no se seleccionó correctamente.

**Solución:** 
- Asegúrate de hacer clic en el botón y seleccionar un archivo
- Verifica que el archivo sea del tipo correcto

### Problema 2: "El archivo es demasiado grande"

**Causa:** El archivo supera los 500MB.

**Solución:**
- Comprimir el video usando herramientas como HandBrake
- Usar un formato más eficiente (MP4 con H.264)

### Problema 3: "Tipo de archivo no permitido"

**Causa:** El archivo no es un video o audio válido.

**Solución:**
- Verificar que el archivo sea uno de los tipos soportados
- Convertir el archivo a MP4 (video) o MP3 (audio)

### Problema 4: El reproductor no muestra el video

**Causa:** La URL del archivo no es correcta o el archivo no existe.

**Solución:**
- Verificar en la base de datos que `url_archivo` tenga un valor
- Verificar que el archivo exista en `backend/uploads/`
- Verificar que el backend esté sirviendo archivos estáticos

### Problema 5: Error 404 al reproducir

**Causa:** El backend no está sirviendo los archivos correctamente.

**Solución:**
- Verificar que el backend esté corriendo en http://localhost:3001
- Verificar que la carpeta `uploads` exista
- Reiniciar el backend

---

## 📊 Consultas SQL Útiles

### Ver todos los contenidos con archivos

```sql
SELECT id_contenido, titulo, tipo, url_archivo
FROM CONTENIDO
WHERE url_archivo IS NOT NULL
ORDER BY fecha_agregado DESC;
```

### Ver contenidos SIN archivos

```sql
SELECT id_contenido, titulo, tipo
FROM CONTENIDO
WHERE url_archivo IS NULL
ORDER BY tipo, titulo;
```

### Actualizar URL manualmente

```sql
-- Si quieres agregar una URL manualmente
UPDATE CONTENIDO
SET url_archivo = '/uploads/videos/mi-video.mp4'
WHERE id_contenido = 128;

COMMIT;
```

### Eliminar URL de un contenido

```sql
UPDATE CONTENIDO
SET url_archivo = NULL
WHERE id_contenido = 128;

COMMIT;
```

---

## 🎯 Flujo Completo de Uso

### Para Administradores (Subir Contenido)

1. **Crear contenido** en el panel de admin
2. **Editar el contenido** recién creado
3. **Subir archivo** multimedia
4. **Verificar** que se subió correctamente
5. **Probar** reproducción en la página de detalle

### Para Usuarios (Ver Contenido)

1. **Navegar** al catálogo
2. **Seleccionar** un contenido
3. **Reproducir** el video/audio
4. **Calificar** después del 50% de avance
5. **Agregar a favoritos** si les gusta

---

## ✅ Checklist de Verificación

Después de ejecutar el script, verifica:

- [ ] Columna `URL_ARCHIVO` existe en tabla `CONTENIDO`
- [ ] Columna `URL_ARCHIVO` existe en tabla `EPISODIOS`
- [ ] Algunos contenidos tienen URLs de ejemplo
- [ ] Backend está corriendo sin errores
- [ ] Frontend está corriendo sin errores
- [ ] Puedes acceder al panel de admin
- [ ] Puedes editar un contenido
- [ ] Ves la sección "Archivo Multimedia"
- [ ] Puedes subir un archivo
- [ ] El archivo se sube correctamente
- [ ] Puedes ver el contenido en la página principal
- [ ] El reproductor aparece en la página de detalle
- [ ] Puedes reproducir el video/audio

---

## 📞 Soporte

Si después de ejecutar el script sigues teniendo problemas:

1. **Verificar logs del backend** en la terminal
2. **Verificar logs del frontend** en la consola del navegador (F12)
3. **Verificar que las columnas existan** con `DESC CONTENIDO`
4. **Reiniciar ambos servidores** (backend y frontend)

---

**Última actualización:** Mayo 21, 2026  
**Versión:** 1.0.0  
**Estado:** ✅ Listo para ejecutar
