# Implementación de Sistema de Contraseñas

## Cambios Realizados

Se ha implementado un sistema completo de autenticación con contraseñas seguras usando bcrypt.

### 1. Base de Datos
- **Archivo**: `01_ddl/03_agregar_password.sql`
- **Cambio**: Se agregó la columna `password_hash` a la tabla `USUARIOS`

### 2. Backend
- **Instalado**: `bcryptjs` para hashear contraseñas de forma segura
- **Modificado**: `backend/src/routes/auth.routes.js`
  - Login ahora requiere email Y contraseña
  - Registro ahora hashea la contraseña antes de guardarla
  - Se valida que la contraseña tenga al menos 6 caracteres

### 3. Frontend
- **Modificado**: `frontend/src/pages/LoginPage.jsx`
  - Agregado campo de contraseña
- **Modificado**: `frontend/src/pages/RegisterPage.jsx`
  - Agregados campos de contraseña y confirmación
  - Validación de que las contraseñas coincidan
- **Modificado**: `frontend/src/context/AuthContext.jsx`
  - La función `login()` ahora envía la contraseña al backend

## Instrucciones de Instalación

### Paso 1: Ejecutar Script SQL
Ejecuta el siguiente script en SQL Developer:
```sql
@01_ddl/03_agregar_password.sql
```

### Paso 2: Reiniciar el Backend
El backend ya tiene bcryptjs instalado. Solo necesitas reiniciarlo:
1. Detén el proceso actual del backend (Ctrl+C)
2. Inicia nuevamente: `npm start` en la carpeta `backend`

### Paso 3: Reiniciar el Frontend
1. Detén el proceso actual del frontend (Ctrl+C)
2. Inicia nuevamente: `npm run dev` en la carpeta `frontend`

## Uso

### Registro de Nuevos Usuarios
1. Los nuevos usuarios deben crear una contraseña al registrarse
2. La contraseña debe tener al menos 6 caracteres
3. Deben confirmar la contraseña (ambos campos deben coincidir)

### Login
1. Los usuarios deben ingresar su email Y contraseña
2. Si la contraseña es incorrecta, se mostrará un error
3. Los usuarios antiguos (sin contraseña) verán un mensaje indicando que contacten al administrador

## Usuarios Existentes

Los usuarios que ya existen en la base de datos NO tienen contraseña configurada. Tienes dos opciones:

### Opción 1: Asignar Contraseña Temporal (Recomendado para Testing)
Ejecuta el script SQL que asigna la contraseña temporal "password123" a todos los usuarios existentes:

```bash
@02_dml/06_actualizar_passwords_usuarios_existentes.sql
```

Después de ejecutar este script, todos los usuarios existentes podrán hacer login con:
- **Email**: su email registrado
- **Contraseña**: `password123`

### Opción 2: Crear Función de Recuperación de Contraseña
Implementar un flujo de "Olvidé mi contraseña" que permita a los usuarios establecer una nueva contraseña.

## Seguridad

✅ **Implementado**:
- Contraseñas hasheadas con bcrypt (10 rounds)
- Validación de longitud mínima (6 caracteres)
- Confirmación de contraseña en el registro
- No se envía el hash al frontend

⚠️ **Pendiente** (Mejoras futuras):
- Recuperación de contraseña por email
- Requisitos de complejidad de contraseña (mayúsculas, números, símbolos)
- Límite de intentos de login
- Tokens JWT para sesiones más seguras
- Expiración de sesiones

## Pruebas

### Probar Registro:
1. Ve a `/register`
2. Completa el formulario incluyendo contraseña
3. Verifica que se cree el usuario correctamente

### Probar Login:
1. Ve a `/login`
2. Ingresa email y contraseña
3. Verifica que solo puedas entrar con la contraseña correcta

### Probar Validaciones:
- Intenta registrarte con contraseña menor a 6 caracteres
- Intenta registrarte con contraseñas que no coincidan
- Intenta hacer login con contraseña incorrecta
