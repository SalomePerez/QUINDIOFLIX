# 🧪 Prueba del Sistema de Referidos - QuindioFlix

## ✅ Estado de Implementación

El sistema de referidos está **completamente implementado** y listo para usar. Esta guía te ayudará a probarlo paso a paso.

---

## 📋 Checklist de Implementación

### Backend ✅
- [x] Endpoint `GET /api/usuarios/:id/referidos` - Obtener lista de referidos
- [x] Campo `id_referidor` en tabla USUARIOS
- [x] Registro con referido en `POST /api/auth/register`
- [x] Validación de referido opcional

### Frontend ✅
- [x] Página `/referidos` completa con UI
- [x] Campo de referido en página de registro
- [x] Enlace "Referidos" en Navbar
- [x] Botón copiar código al portapapeles
- [x] Lista de usuarios referidos
- [x] Información de beneficios

### Documentación ✅
- [x] `INSTRUCCIONES_SISTEMA_REFERIDOS.md` completo

---

## 🧪 Pasos para Probar el Sistema

### Paso 1: Obtener tu Código de Referido

1. **Iniciar sesión** en QuindioFlix
   - URL: http://localhost:5173/login
   - Usa cualquier usuario existente (ej: r.montoya@gmail.com / password123)

2. **Ir a la página de Referidos**
   - Hacer clic en "Referidos" en el menú superior
   - O ir directamente a: http://localhost:5173/referidos

3. **Ver tu código**
   - Verás tu código de referido en grande (es tu ID de usuario)
   - Ejemplo: Si tu ID es `5`, tu código es `5`

4. **Copiar el código**
   - Hacer clic en el botón "Copiar"
   - Verás un mensaje de confirmación "Copiado"

### Paso 2: Registrar un Nuevo Usuario con Referido

1. **Cerrar sesión** (si estás logueado)
   - Hacer clic en tu nombre de perfil → Cerrar sesión

2. **Ir a la página de registro**
   - URL: http://localhost:5173/register

3. **Completar el formulario**
   ```
   Nombre: Juan
   Apellido: Pérez
   Email: juan.perez@test.com
   Contraseña: password123
   Confirmar contraseña: password123
   Teléfono: 3001234567
   Fecha de nacimiento: 1995-05-15
   Ciudad: Armenia
   Plan: ESTÁNDAR (o el que prefieras)
   Código de referido: [PEGAR EL CÓDIGO QUE COPIASTE]
   ```

4. **Crear cuenta**
   - Hacer clic en "Crear cuenta"
   - Deberías ser redirigido al login con mensaje de éxito

### Paso 3: Verificar el Referido

1. **Iniciar sesión con el usuario original**
   - El que tenía el código de referido

2. **Ir a la página de Referidos**
   - http://localhost:5173/referidos

3. **Verificar la lista**
   - Deberías ver a "Juan Pérez" en tu lista de referidos
   - Con la fecha de registro de hoy
   - Estado: "Activo"
   - Contador: "Tus Referidos (1)"

### Paso 4: Verificar en la Base de Datos (Opcional)

Si tienes acceso a la base de datos, puedes verificar:

```sql
-- Ver el usuario referido
SELECT id_usuario, nombre, apellido, email, id_referidor
FROM USUARIOS
WHERE email = 'juan.perez@test.com';

-- Ver todos los referidos de un usuario
SELECT u.id_usuario, u.nombre, u.apellido, u.email, u.fecha_registro
FROM USUARIOS u
WHERE u.id_referidor = 5;  -- Reemplaza 5 con tu ID de usuario

-- Ver estadísticas de referidos
SELECT 
    r.id_usuario AS referidor_id,
    r.nombre || ' ' || r.apellido AS referidor,
    COUNT(u.id_usuario) AS total_referidos
FROM USUARIOS r
LEFT JOIN USUARIOS u ON r.id_usuario = u.id_referidor
GROUP BY r.id_usuario, r.nombre, r.apellido
HAVING COUNT(u.id_usuario) > 0
ORDER BY total_referidos DESC;
```

---

## 🎯 Casos de Prueba

### Caso 1: Registro CON Referido ✅

**Entrada:**
- Código de referido: `5` (ID de usuario existente)

**Resultado Esperado:**
- ✅ Usuario se registra exitosamente
- ✅ Campo `id_referidor` = 5 en la base de datos
- ✅ Usuario aparece en la lista de referidos del usuario 5
- ✅ Ambos usuarios reciben beneficio de 10% descuento

**Cómo Probar:**
1. Registrar nuevo usuario con código `5`
2. Login con usuario ID 5
3. Ir a `/referidos`
4. Verificar que el nuevo usuario aparece en la lista

---

### Caso 2: Registro SIN Referido ✅

**Entrada:**
- Campo de referido: vacío

**Resultado Esperado:**
- ✅ Usuario se registra exitosamente
- ✅ Campo `id_referidor` = NULL en la base de datos
- ✅ No aparece en ninguna lista de referidos
- ✅ No recibe descuento de referido

**Cómo Probar:**
1. Registrar nuevo usuario sin código
2. Verificar que el registro funciona normalmente

---

### Caso 3: Múltiples Referidos ✅

**Entrada:**
- Registrar 3 usuarios diferentes con el mismo código

**Resultado Esperado:**
- ✅ Los 3 usuarios se registran exitosamente
- ✅ Los 3 aparecen en la lista de referidos
- ✅ Contador muestra "Tus Referidos (3)"

**Cómo Probar:**
1. Registrar usuario A con código 5
2. Registrar usuario B con código 5
3. Registrar usuario C con código 5
4. Login con usuario 5
5. Ir a `/referidos`
6. Verificar que aparecen los 3 usuarios

---

### Caso 4: Código Inválido ❌

**Entrada:**
- Código de referido: `99999` (ID que no existe)

**Resultado Esperado:**
- ❌ Error al registrar
- ❌ Mensaje: "El código de referido no es válido"

**Cómo Probar:**
1. Intentar registrar con código inexistente
2. Verificar que muestra error

---

## 🎨 Elementos de UI a Verificar

### Página de Referidos (`/referidos`)

✅ **Tarjeta de Código:**
- [ ] Fondo degradado brand/purple
- [ ] Código grande y visible
- [ ] Botón "Copiar" funcional
- [ ] Feedback visual al copiar (cambia a "Copiado" con ✓)
- [ ] Grid de beneficios (10% para ti y tu amigo)

✅ **Sección "¿Cómo funciona?":**
- [ ] 3 pasos numerados
- [ ] Iconos circulares con números
- [ ] Descripciones claras

✅ **Lista de Referidos:**
- [ ] Título con contador "Tus Referidos (X)"
- [ ] Tarjetas por cada referido
- [ ] Nombre completo
- [ ] Fecha de registro formateada
- [ ] Badge "Activo" en verde
- [ ] Mensaje vacío si no hay referidos

### Página de Registro (`/register`)

✅ **Campo de Referido:**
- [ ] Label: "Código de referido (opcional)"
- [ ] Sublabel: "¿Te invitó un amigo?"
- [ ] Placeholder: "Ingresa el código de tu amigo"
- [ ] Texto de ayuda sobre beneficios
- [ ] Campo acepta solo números
- [ ] Campo es opcional (no requerido)

### Navbar

✅ **Enlace de Referidos:**
- [ ] Icono de regalo (Gift)
- [ ] Texto "Referidos"
- [ ] Enlace funcional a `/referidos`
- [ ] Visible cuando estás logueado

---

## 📊 Datos de Prueba Sugeridos

### Usuarios Existentes para Probar

```javascript
// Usuario 1 (Moderador)
{
  email: 'r.montoya@gmail.com',
  password: 'password123',
  // Usa su ID como código de referido
}

// Usuario 2 (Moderador)
{
  email: 's.pedraza@gmail.com',
  password: 'password123',
  // Usa su ID como código de referido
}

// Usuario 3 (Moderador)
{
  email: 'h.castillo@gmail.com',
  password: 'password123',
  // Usa su ID como código de referido
}
```

### Nuevos Usuarios para Crear

```javascript
// Usuario de prueba 1
{
  nombre: 'María',
  apellido: 'García',
  email: 'maria.garcia@test.com',
  password: 'password123',
  fecha_nacimiento: '1998-03-20',
  ciudad: 'Bogotá',
  id_plan: 2,
  id_referidor: 5  // ID del usuario que refiere
}

// Usuario de prueba 2
{
  nombre: 'Carlos',
  apellido: 'López',
  email: 'carlos.lopez@test.com',
  password: 'password123',
  fecha_nacimiento: '1992-07-10',
  ciudad: 'Medellín',
  id_plan: 1,
  id_referidor: 5  // Mismo referidor
}

// Usuario de prueba 3 (sin referido)
{
  nombre: 'Ana',
  apellido: 'Martínez',
  email: 'ana.martinez@test.com',
  password: 'password123',
  fecha_nacimiento: '1995-11-25',
  ciudad: 'Cali',
  id_plan: 3,
  id_referidor: null  // Sin referido
}
```

---

## 🐛 Problemas Comunes y Soluciones

### Problema 1: No veo el enlace "Referidos" en el Navbar
**Causa:** No has iniciado sesión  
**Solución:** Inicia sesión con cualquier usuario

### Problema 2: Mi código no aparece
**Causa:** El código es tu ID de usuario  
**Solución:** Ve a `/referidos` para verlo claramente

### Problema 3: El botón "Copiar" no funciona
**Causa:** Navegador no soporta clipboard API  
**Solución:** Copia manualmente el número que ves

### Problema 4: No veo a mi referido en la lista
**Causa:** El nuevo usuario no ingresó tu código correctamente  
**Solución:** Verifica en la base de datos si el campo `id_referidor` está correcto

### Problema 5: Error al registrar con código
**Causa:** El código no existe en la base de datos  
**Solución:** Verifica que el código sea un ID de usuario válido

---

## 📈 Métricas a Verificar

Después de las pruebas, verifica:

1. **Total de usuarios con referidos:**
   ```sql
   SELECT COUNT(*) FROM USUARIOS WHERE id_referidor IS NOT NULL;
   ```

2. **Usuario con más referidos:**
   ```sql
   SELECT id_referidor, COUNT(*) as total
   FROM USUARIOS
   WHERE id_referidor IS NOT NULL
   GROUP BY id_referidor
   ORDER BY total DESC;
   ```

3. **Referidos por fecha:**
   ```sql
   SELECT TRUNC(fecha_registro) as fecha, COUNT(*) as nuevos_referidos
   FROM USUARIOS
   WHERE id_referidor IS NOT NULL
   GROUP BY TRUNC(fecha_registro)
   ORDER BY fecha DESC;
   ```

---

## ✅ Checklist Final de Pruebas

- [ ] Puedo ver mi código de referido en `/referidos`
- [ ] Puedo copiar mi código al portapapeles
- [ ] Puedo registrar un nuevo usuario con mi código
- [ ] El nuevo usuario aparece en mi lista de referidos
- [ ] El contador de referidos se actualiza correctamente
- [ ] Puedo registrar múltiples usuarios con el mismo código
- [ ] Puedo registrar un usuario SIN código (campo opcional)
- [ ] La fecha de registro se muestra correctamente
- [ ] El estado "Activo" se muestra en verde
- [ ] El mensaje vacío aparece cuando no hay referidos
- [ ] La UI es responsive y se ve bien en móvil
- [ ] No hay errores en la consola del navegador
- [ ] No hay errores en la consola del backend

---

## 🎉 Resultado Esperado

Si todas las pruebas pasan:

✅ **Sistema de Referidos Funcional al 100%**

- Los usuarios pueden obtener su código fácilmente
- Los usuarios pueden compartir su código
- Los nuevos usuarios pueden registrarse con código
- Los referidos aparecen en la lista correctamente
- La UI es clara y fácil de usar
- Los beneficios están bien explicados

---

## 📞 Soporte

Si encuentras algún problema durante las pruebas:

1. Revisa la consola del navegador (F12)
2. Revisa los logs del backend
3. Verifica la base de datos directamente
4. Consulta `INSTRUCCIONES_SISTEMA_REFERIDOS.md`

---

**Fecha de creación:** Mayo 21, 2026  
**Versión:** 1.0.0  
**Estado:** ✅ Listo para probar
