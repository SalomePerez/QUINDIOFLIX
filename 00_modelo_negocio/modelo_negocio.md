# Modelo de Negocio — QuindioFlix

## a) Actores del sistema y sus roles

| Actor | Descripción |
|---|---|
| **Usuario suscriptor** | Persona registrada con un plan activo. Puede crear perfiles, reproducir contenido, calificar, agregar favoritos y reportar contenido. |
| **Perfil** | Identidad de consumo dentro de una cuenta. Puede ser adulto o infantil. Es quien realmente interactúa con el catálogo. |
| **Moderador** | Usuario con rol especial que revisa y resuelve reportes de contenido inapropiado. |
| **Empleado de Contenido** | Empleado del departamento de Contenido. Agrega y administra el catálogo de la plataforma. |
| **Empleado de Soporte** | Empleado del departamento de Soporte. Atiende reportes de contenido inapropiado. |
| **Jefe de Departamento** | Empleado que lidera un departamento. Puede supervisar a otros empleados. |
| **Supervisor** | Empleado que supervisa a otros empleados dentro del mismo departamento. |
| **Administrador de BD** | Rol técnico con acceso total al sistema de base de datos. |
| **Analista / Gerencia** | Acceso de solo lectura para reportes y analítica. |

---

## b) Procesos de negocio principales

### 1. Registro de usuario
El usuario proporciona sus datos personales (nombre, email, teléfono, fecha de nacimiento, ciudad) y elige un plan de suscripción. El sistema valida que el email no exista, crea la cuenta, genera un perfil predeterminado de tipo adulto y registra el primer pago pendiente. Si el usuario fue referido, se registra la relación y se aplican los beneficios correspondientes.

### 2. Gestión de perfiles
El usuario puede crear, editar y eliminar perfiles dentro de su cuenta, respetando el límite del plan. Cada perfil tiene nombre, avatar y tipo (adulto/infantil). Los perfiles infantiles tienen restricciones de contenido.

### 3. Reproducción de contenido
Un perfil selecciona un contenido del catálogo. El sistema verifica que la cuenta esté activa y que el contenido sea apropiado para el tipo de perfil. Se registra la reproducción con dispositivo, tiempos de inicio/fin y porcentaje de avance.

### 4. Calificación y reseña
Un perfil puede calificar contenido con 1 a 5 estrellas y dejar una reseña escrita, siempre que haya reproducido al menos el 50% del contenido.

### 5. Gestión de favoritos
Un perfil puede agregar o quitar contenido de su lista personal de favoritos.

### 6. Reporte de contenido inapropiado
Un perfil reporta un contenido indicando el motivo. Un moderador (usuario con rol especial) revisa el reporte y lo resuelve (aprobado, rechazado, escalado).

### 7. Facturación y pagos
Mensualmente el sistema genera el cobro según el plan del usuario, aplicando descuentos si aplica (referidos activos, antigüedad). El pago se registra con método, monto, fecha y estado. Si el pago no se realiza en 30 días, la cuenta se desactiva.

### 8. Cambio de plan
El usuario solicita cambiar su plan. El sistema valida que el nuevo plan sea compatible con el número de perfiles activos. Se actualiza el plan y se registra el cambio.

### 9. Gestión del catálogo
Los empleados del departamento de Contenido agregan, editan y eliminan contenido del catálogo. Cada contenido queda asociado a un empleado responsable. Se registran géneros, temporadas, episodios y relaciones entre contenidos.

### 10. Reportes y analítica
La gerencia consulta reportes de consumo (por ciudad, categoría, género, dispositivo, plan, período), reportes financieros (ingresos por ciudad y plan) y reportes de rendimiento del equipo (contenido publicado por empleado, reportes resueltos por moderador).

---

## c) Reglas de negocio (mínimo 10)

### Reglas explícitas

**RN-01 — Límite de perfiles por plan**
El número máximo de perfiles por cuenta depende del plan: Básico = 2, Estándar = 3, Premium = 5. No se puede crear un perfil adicional si se alcanzó el límite.

**RN-02 — Restricción de contenido para perfiles infantiles**
Un perfil de tipo infantil solo puede reproducir, calificar o agregar a favoritos contenido con clasificación TP, +7 o +13. El contenido +16 y +18 está bloqueado para estos perfiles.

**RN-03 — Desactivación por mora**
Si un usuario no realiza un pago exitoso dentro de los 30 días siguientes a su fecha de vencimiento, su cuenta se desactiva automáticamente (estado_cuenta = 'INACTIVO').

**RN-04 — Calificación requiere reproducción mínima**
Un perfil solo puede calificar un contenido si ha reproducido al menos el 50% de su duración total (porcentaje_avance >= 50).

**RN-05 — Beneficio por referido**
Cuando un usuario referido se registra exitosamente, tanto el referidor como el referido reciben un descuento en su próximo pago mensual. El sistema debe registrar la relación de referido.

**RN-06 — Descuento por antigüedad**
Usuarios con más de 12 meses de suscripción activa reciben un 10% de descuento. Usuarios con más de 24 meses reciben un 15% de descuento. Estos descuentos no son acumulables entre sí.

**RN-07 — Cambio de plan con perfiles activos**
Un usuario no puede cambiar a un plan inferior si tiene más perfiles activos de los que permite el nuevo plan. Debe eliminar perfiles primero.

**RN-08 — Reproducción requiere cuenta activa**
Solo se puede registrar una reproducción si la cuenta del usuario propietario del perfil está en estado ACTIVO.

### Reglas implícitas (deducidas del contexto)

**RN-09 — Un empleado solo puede ser jefe de su propio departamento**
El jefe de un departamento debe ser un empleado que pertenezca a ese mismo departamento. No puede ser jefe de un departamento en el que no trabaja.

**RN-10 — Un supervisor solo puede supervisar empleados de su mismo departamento**
La jerarquía de supervisión es interna al departamento. Un empleado no puede supervisar a alguien de otro departamento.

**RN-11 — Un contenido solo puede tener un empleado responsable de publicación**
Cada contenido tiene exactamente un empleado del departamento de Contenido asignado como responsable de su publicación.

**RN-12 — Las relaciones entre contenidos son simétricas en tipo pero no en dirección**
Una relación "secuela" implica que el contenido A es secuela de B, pero B es precuela de A. La relación tiene dirección y descripción. No se puede relacionar un contenido consigo mismo.

**RN-13 — Un episodio pertenece a exactamente una temporada**
Un episodio no puede existir sin pertenecer a una temporada, y una temporada pertenece a exactamente un contenido de tipo serie o podcast.

**RN-14 — Las películas no tienen temporadas ni episodios**
Solo los contenidos de tipo Serie y Podcast pueden tener temporadas y episodios. Películas y Documentales no.

**RN-15 — Un moderador es también un usuario suscriptor**
Los moderadores no son una entidad separada; son usuarios del sistema con un atributo o rol especial que les permite gestionar reportes.

**RN-16 — Un reporte de contenido solo puede ser resuelto una vez**
Una vez que un moderador resuelve un reporte (estado = 'RESUELTO'), no puede volver a modificarse. Solo los reportes en estado 'PENDIENTE' o 'EN_REVISION' pueden ser actualizados.

**RN-17 — El email del usuario es único en el sistema**
No pueden existir dos usuarios con el mismo email. Es el identificador de autenticación.

**RN-18 — Un perfil no puede calificar el mismo contenido dos veces**
La combinación (id_perfil, id_contenido) en la tabla CALIFICACIONES debe ser única.

---

## d) Restricciones de dominio para atributos clave

| Atributo | Tabla | Restricción |
|---|---|---|
| `email` | USUARIOS | Formato válido de email, único, NOT NULL |
| `fecha_nacimiento` | USUARIOS | Debe ser anterior a la fecha actual, usuario debe tener al menos 13 años |
| `clasificacion_edad` | CONTENIDO | Solo valores: 'TP', '+7', '+13', '+16', '+18' |
| `tipo_perfil` | PERFILES | Solo valores: 'ADULTO', 'INFANTIL' |
| `estrellas` | CALIFICACIONES | Entero entre 1 y 5 |
| `porcentaje_avance` | REPRODUCCIONES | Decimal entre 0 y 100 |
| `estado_pago` | PAGOS | Solo valores: 'EXITOSO', 'FALLIDO', 'PENDIENTE', 'REEMBOLSADO' |
| `metodo_pago` | PAGOS | Solo valores: 'TARJETA_CREDITO', 'TARJETA_DEBITO', 'PSE', 'NEQUI', 'DAVIPLATA' |
| `dispositivo` | REPRODUCCIONES | Solo valores: 'CELULAR', 'TABLET', 'TV', 'COMPUTADOR' |
| `estado_cuenta` | USUARIOS | Solo valores: 'ACTIVO', 'INACTIVO', 'SUSPENDIDO' |
| `tipo_contenido` | CONTENIDO | Solo valores: 'PELICULA', 'SERIE', 'DOCUMENTAL', 'MUSICA', 'PODCAST' |
| `monto` | PAGOS | Debe ser mayor que 0 |
| `duracion` | CONTENIDO | Debe ser mayor que 0 (en minutos) |
| `anio_lanzamiento` | CONTENIDO | Entre 1888 y el año actual |
| `estado_reporte` | REPORTES | Solo valores: 'PENDIENTE', 'EN_REVISION', 'RESUELTO', 'RECHAZADO' |
| `precio_mensual` | PLANES | Debe ser mayor que 0 |
| `numero_pantallas` | PLANES | Entero entre 1 y 4 |
