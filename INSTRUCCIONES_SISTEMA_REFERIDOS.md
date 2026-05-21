# Sistema de Referidos - QuindioFlix

## 📋 Descripción

QuindioFlix incluye un **programa de referidos** que permite a los usuarios invitar a sus amigos y recibir beneficios mutuos. Cuando un usuario referido se registra, tanto el que refirió como el nuevo usuario reciben un descuento especial.

---

## 🎁 Beneficios del Programa

### Para el Usuario que Refiere
- **10% de descuento** en su próximo pago mensual
- Por cada amigo que se registre con su código

### Para el Usuario Referido
- **10% de descuento** en su primer mes
- Al registrarse usando el código de su amigo

---

## 🚀 Cómo Funciona

### 1. Obtener tu Código de Referido

**Opción A: Desde la página de Referidos**
1. Iniciar sesión en QuindioFlix
2. Ir a **"Referidos"** en el menú de navegación
3. Ver tu código de referido (es tu **ID de usuario**)
4. Hacer clic en **"Copiar"** para copiarlo al portapapeles

**Opción B: Desde tu perfil**
- Tu código de referido es simplemente tu **ID de usuario**
- Ejemplo: Si tu ID es `5`, tu código de referido es `5`

### 2. Compartir tu Código

Comparte tu código de referido con tus amigos por:
- WhatsApp
- Email
- Redes sociales
- Mensaje de texto

**Ejemplo de mensaje:**
```
¡Únete a QuindioFlix! 🎬

Usa mi código de referido: 5

Ambos recibiremos 10% de descuento.

Regístrate aquí: http://localhost:5173/register
```

### 3. Tu Amigo se Registra

Tu amigo debe:
1. Ir a la página de registro
2. Completar todos los campos
3. En el campo **"Código de referido"** ingresar tu código
4. Completar el registro

### 4. Recibir los Beneficios

Una vez que tu amigo complete el registro:
- ✅ Tu amigo recibe 10% de descuento en su primer mes
- ✅ Tú recibes 10% de descuento en tu próximo pago
- ✅ El sistema registra la relación de referido

---

## 📱 Página de Referidos

### Acceso
- **URL:** `/referidos`
- **Menú:** Hacer clic en "Referidos" en la barra de navegación
- **Icono:** 🎁 (Gift)

### Funcionalidades

#### 1. Tu Código de Referido
- Muestra tu código en grande
- Botón para copiar al portapapeles
- Confirmación visual cuando se copia

#### 2. Información de Beneficios
- Muestra qué beneficio recibes tú
- Muestra qué beneficio recibe tu amigo
- Explicación clara de los descuentos

#### 3. Cómo Funciona
- Guía paso a paso del proceso
- Instrucciones claras para compartir
- Explicación de cómo se aplican los beneficios

#### 4. Lista de Referidos
- Muestra todos los usuarios que has referido
- Nombre completo de cada referido
- Fecha de registro
- Estado de la cuenta (Activo/Inactivo)
- Contador total de referidos

---

## 🎨 Interfaz de Usuario

### Tarjeta de Código
- **Fondo degradado** con colores brand
- **Código grande** y visible
- **Botón de copiar** con feedback visual
- **Grid de beneficios** para ti y tu amigo

### Guía Visual
- **Pasos numerados** (1, 2, 3)
- **Iconos circulares** con números
- **Descripciones claras** de cada paso

### Lista de Referidos
- **Tarjetas individuales** por cada referido
- **Badge de estado** (Activo en verde)
- **Fecha de registro** formateada
- **Mensaje vacío** si no hay referidos aún

---

## 💾 Estructura de Datos

### Tabla USUARIOS

```sql
CREATE TABLE USUARIOS (
    id_usuario    NUMBER PRIMARY KEY,
    nombre        VARCHAR2(100),
    apellido      VARCHAR2(100),
    email         VARCHAR2(150),
    id_referidor  NUMBER,  -- ID del usuario que lo refirió
    ...
    CONSTRAINT fk_usu_ref FOREIGN KEY (id_referidor) 
        REFERENCES USUARIOS(id_usuario)
);
```

### Relación de Referidos
- **Auto-referencia:** Un usuario puede referir a muchos usuarios
- **Campo:** `id_referidor` en la tabla USUARIOS
- **Valor:** ID del usuario que hizo la referencia
- **NULL:** Si el usuario se registró sin referido

---

## 🔧 Endpoints de la API

### Obtener Referidos de un Usuario

```
GET /api/usuarios/:id/referidos
```

**Respuesta:**
```json
[
  {
    "ID_USUARIO": 15,
    "NOMBRE": "Juan",
    "APELLIDO": "Pérez",
    "EMAIL": "juan@example.com",
    "CIUDAD": "Armenia",
    "FECHA_REGISTRO": "2026-05-20T00:00:00.000Z",
    "ESTADO_CUENTA": "ACTIVO"
  }
]
```

### Registro con Referido

```
POST /api/auth/register
```

**Body:**
```json
{
  "nombre": "María",
  "apellido": "García",
  "email": "maria@example.com",
  "password": "password123",
  "fecha_nacimiento": "1995-03-15",
  "ciudad": "Bogotá",
  "id_plan": 2,
  "id_referidor": 5  // Código del amigo que refirió
}
```

---

## 📊 Cálculo de Descuentos

### Descuento para el Referidor

El descuento se aplica en el **próximo pago** del usuario que refirió:

```sql
-- En la tabla PAGOS
descuento_pct = 10  -- 10% de descuento
```

**Ejemplo:**
- Plan ESTÁNDAR: $24.900/mes
- Con descuento 10%: $22.410/mes
- Ahorro: $2.490

### Descuento para el Referido

El descuento se aplica en el **primer pago** del usuario referido:

```sql
-- En el primer registro de PAGOS del usuario
descuento_pct = 10  -- 10% de descuento
```

---

## 🎯 Casos de Uso

### Caso 1: Usuario Comparte con Amigo

**Usuario A (ID: 5):**
1. Va a `/referidos`
2. Copia su código: `5`
3. Lo envía a su amigo por WhatsApp

**Usuario B (nuevo):**
1. Recibe el código `5`
2. Va a `/register`
3. Completa el formulario
4. Ingresa `5` en "Código de referido"
5. Se registra exitosamente

**Resultado:**
- Usuario B recibe 10% descuento en primer mes
- Usuario A recibe 10% descuento en próximo mes
- Usuario A ve a Usuario B en su lista de referidos

### Caso 2: Usuario sin Referido

**Usuario C (nuevo):**
1. Va a `/register`
2. Completa el formulario
3. Deja vacío "Código de referido"
4. Se registra exitosamente

**Resultado:**
- Usuario C paga precio completo
- No hay descuentos aplicados
- `id_referidor` es NULL en la base de datos

---

## 🔍 Validaciones

### Backend

✅ **Validaciones implementadas:**
- El `id_referidor` es opcional
- Si se proporciona, debe ser un ID de usuario válido
- No se puede auto-referir (referidor ≠ usuario actual)
- El referidor debe existir en la base de datos

❌ **Errores comunes:**
- `404 Not Found`: El código de referido no existe
- `400 Bad Request`: Intentando auto-referirse

### Frontend

✅ **Características:**
- Campo opcional en el registro
- Placeholder descriptivo
- Texto de ayuda explicativo
- Validación de número entero
- Mensaje claro sobre los beneficios

---

## 📈 Métricas y Reportes

### Para el Usuario

En la página de Referidos puede ver:
- **Total de referidos:** Contador en el título
- **Lista completa:** Todos los usuarios referidos
- **Estado:** Si están activos o inactivos
- **Fecha:** Cuándo se registraron

### Para Administradores

Consulta SQL para ver estadísticas:

```sql
-- Usuarios con más referidos
SELECT u.id_usuario, u.nombre, u.apellido, COUNT(r.id_usuario) AS total_referidos
FROM USUARIOS u
LEFT JOIN USUARIOS r ON u.id_usuario = r.id_referidor
GROUP BY u.id_usuario, u.nombre, u.apellido
ORDER BY total_referidos DESC;

-- Total de usuarios referidos
SELECT COUNT(*) AS total_referidos
FROM USUARIOS
WHERE id_referidor IS NOT NULL;
```

---

## ⚠️ Notas Importantes

### 1. Código de Referido = ID de Usuario
- El código de referido es simplemente el ID del usuario
- No hay códigos especiales o alfanuméricos
- Es un número entero simple

### 2. Descuentos Automáticos
- Los descuentos se calculan automáticamente
- Se aplican en el momento del pago
- Se registran en la tabla PAGOS

### 3. Sin Límite de Referidos
- Un usuario puede referir a tantos amigos como quiera
- Cada referido exitoso genera un descuento
- Los descuentos se acumulan

### 4. Referidos Activos
- Solo se muestran usuarios que completaron el registro
- El estado de la cuenta se muestra en la lista
- Los usuarios inactivos también aparecen

---

## 🐛 Solución de Problemas

### Problema: No veo mi código de referido
**Solución:** Tu código es tu ID de usuario. Ve a `/referidos` para verlo.

### Problema: Mi amigo no puede usar mi código
**Solución:** 
- Verifica que el código sea correcto (tu ID de usuario)
- Asegúrate de que tu amigo lo ingrese en el campo correcto
- El campo acepta solo números

### Problema: No veo a mi referido en la lista
**Solución:**
- Verifica que tu amigo haya completado el registro
- Verifica que haya ingresado tu código correctamente
- Refresca la página `/referidos`

### Problema: El descuento no se aplicó
**Solución:**
- Los descuentos se aplican en el momento del pago
- Verifica en tu próximo pago si aparece el descuento
- Contacta a soporte si el problema persiste

---

## 📞 Soporte

Si encuentras problemas:
1. Revisar esta documentación
2. Verificar que el código sea correcto
3. Revisar la consola del navegador (F12)
4. Contactar a soporte técnico

---

**Última actualización:** Mayo 20, 2026  
**Versión:** 1.0.0  
**Estado:** ✅ Implementado y funcional
