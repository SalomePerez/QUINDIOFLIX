# 🔍 DIAGNÓSTICO: Error 500 en Registro de Usuario

## Problema Reportado
Error 500 (Internal Server Error) al intentar registrar un nuevo usuario en QuindioFlix.

---

## ✅ Verificaciones Realizadas

### 1. **Código del Backend**
- ✅ Ruta `/api/auth/register` existe en `backend/src/routes/auth.routes.js`
- ✅ Llama al procedimiento `SP_REGISTRAR_USUARIO`
- ✅ Maneja excepciones correctamente (error 20001 para email duplicado)

### 2. **Procedimiento Almacenado**
- ✅ `SP_REGISTRAR_USUARIO` existe en `04_nucleo2_plsql/09_procedimientos.sql`
- ✅ Tiene manejo de excepciones

### 3. **Configuración de Base de Datos**
- ✅ Archivo `.env` configurado correctamente
- ✅ Usuario: QUINDIOFLIX
- ✅ Conexión: localhost:1521/XEPDB1

---

## 🐛 CAUSAS POSIBLES DEL ERROR 500

### **Causa 1: Procedimiento no compilado en la BD** ⚠️ MÁS PROBABLE
El procedimiento `SP_REGISTRAR_USUARIO` puede no estar creado en la base de datos.

**Solución:**
```bash
# Ejecutar el script de procedimientos
sqlplus QUINDIOFLIX/QuindioFlix2026!@localhost:1521/XEPDB1 @04_nucleo2_plsql/09_procedimientos.sql
```

---

### **Causa 2: Error en el formato de fecha**
El backend envía la fecha en formato 'YYYY-MM-DD' pero el procedimiento espera 'DD/MM/YYYY'.

**Verificar en el código:**
```javascript
// backend/src/routes/auth.routes.js línea 28
TO_DATE(:fnac,'YYYY-MM-DD')  // ✅ Formato correcto
```

---

### **Causa 3: Parámetro OUT no configurado correctamente**
El procedimiento retorna `p_id_usuario_out` pero el binding puede estar mal.

**Código actual:**
```javascript
id_out: { dir: require('oracledb').BIND_OUT, type: require('oracledb').NUMBER }
```

---

### **Causa 4: Tabla USUARIOS no existe o no tiene permisos**
El usuario QUINDIOFLIX puede no tener permisos para ejecutar el procedimiento.

**Verificar:**
```sql
-- Conectar como QUINDIOFLIX
SELECT COUNT(*) FROM USUARIOS;
SELECT COUNT(*) FROM PLANES;
```

---

## 🔧 PASOS PARA SOLUCIONAR

### **Paso 1: Verificar que las tablas existen**
```bash
sqlplus QUINDIOFLIX/QuindioFlix2026!@localhost:1521/XEPDB1
```

```sql
-- Verificar tablas
SELECT table_name FROM user_tables ORDER BY table_name;

-- Debe mostrar: USUARIOS, PLANES, PERFILES, PAGOS, etc.
```

---

### **Paso 2: Verificar que el procedimiento existe**
```sql
-- Verificar procedimientos
SELECT object_name, status FROM user_objects 
WHERE object_type = 'PROCEDURE' 
AND object_name = 'SP_REGISTRAR_USUARIO';

-- Debe mostrar: SP_REGISTRAR_USUARIO | VALID
```

Si muestra **INVALID**, recompilar:
```sql
ALTER PROCEDURE SP_REGISTRAR_USUARIO COMPILE;
```

---

### **Paso 3: Ejecutar los scripts en orden**
```bash
# 1. Crear tablespaces (como DBA)
sqlplus sys/password@localhost:1521/XEPDB1 as sysdba @01_ddl/01_tablespaces.sql

# 2. Crear tablas
sqlplus QUINDIOFLIX/QuindioFlix2026!@localhost:1521/XEPDB1 @01_ddl/02_create_tables.sql

# 3. Insertar datos
sqlplus QUINDIOFLIX/QuindioFlix2026!@localhost:1521/XEPDB1 @02_dml/03_insert_data.sql
sqlplus QUINDIOFLIX/QuindioFlix2026!@localhost:1521/XEPDB1 @02_dml/03b_insert_data_resto.sql

# 4. Crear procedimientos
sqlplus QUINDIOFLIX/QuindioFlix2026!@localhost:1521/XEPDB1 @04_nucleo2_plsql/09_procedimientos.sql
sqlplus QUINDIOFLIX/QuindioFlix2026!@localhost:1521/XEPDB1 @04_nucleo2_plsql/10_funciones.sql
```

---

### **Paso 4: Ver logs del servidor backend**
```bash
cd backend
npm run dev
```

Cuando intentes registrar un usuario, verás el error exacto en la consola.

---

### **Paso 5: Probar el procedimiento directamente en SQL**
```sql
-- Conectar como QUINDIOFLIX
DECLARE
    v_id_usuario NUMBER;
BEGIN
    SP_REGISTRAR_USUARIO(
        p_nombre => 'Test',
        p_apellido => 'Usuario',
        p_email => 'test@test.com',
        p_telefono => '3001234567',
        p_fecha_nac => TO_DATE('01/01/1990','DD/MM/YYYY'),
        p_ciudad => 'Armenia',
        p_id_plan => 1,
        p_id_referidor => NULL,
        p_metodo_pago => 'PSE',
        p_id_usuario_out => v_id_usuario
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Usuario creado con ID: ' || v_id_usuario);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        ROLLBACK;
END;
/
```

---

## 🔍 INFORMACIÓN ADICIONAL NECESARIA

Para diagnosticar mejor el problema, necesito que me proporciones:

1. **Logs del servidor backend** (consola donde ejecutas `npm run dev`)
2. **Datos que estás enviando** desde el frontend (JSON del request)
3. **Resultado de esta query:**
   ```sql
   SELECT object_name, object_type, status 
   FROM user_objects 
   WHERE object_name IN ('SP_REGISTRAR_USUARIO', 'USUARIOS', 'PLANES', 'PERFILES', 'PAGOS');
   ```

---

## 🚀 SOLUCIÓN RÁPIDA (Si todo lo demás falla)

Si el procedimiento no existe o está inválido, ejecuta esto:

```bash
# Recrear el procedimiento
cd /ruta/al/proyecto
sqlplus QUINDIOFLIX/QuindioFlix2026!@localhost:1521/XEPDB1 @04_nucleo2_plsql/09_procedimientos.sql
```

Luego reinicia el servidor backend:
```bash
cd backend
npm run dev
```

---

## 📝 CHECKLIST DE VERIFICACIÓN

- [ ] Tablas creadas (USUARIOS, PLANES, PERFILES, PAGOS)
- [ ] Procedimiento SP_REGISTRAR_USUARIO existe y está VALID
- [ ] Función FN_CALCULAR_MONTO existe (usada por el procedimiento)
- [ ] Backend conecta correctamente a la BD
- [ ] Logs del backend muestran el error específico
- [ ] Datos de prueba cargados (al menos 3 planes)

---

## 💡 PRÓXIMOS PASOS

1. **Ejecuta el Paso 4** para ver los logs exactos del error
2. **Copia el error completo** que aparece en la consola
3. **Compárteme el error** para darte una solución específica

El error 500 es genérico, pero los logs del backend te dirán exactamente qué está fallando (tabla no existe, procedimiento no encontrado, error de sintaxis, etc.).
