-- =============================================================================
-- QUINDIOFLIX — Modelo Físico: CREATE TABLE
-- Normalizado hasta 3FN
-- Ejecutar en el esquema QUINDIOFLIX (o con prefijo QUINDIOFLIX.)
-- =============================================================================

-- =============================================================================
-- BLOQUE 1: CATÁLOGO Y CONTENIDO
-- =============================================================================

-- Planes de suscripción
CREATE TABLE PLANES (
    id_plan          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre           VARCHAR2(20)   NOT NULL,
    precio_mensual   NUMBER(8,2)    NOT NULL,
    num_pantallas    NUMBER(1)      NOT NULL,
    calidad_video    VARCHAR2(10)   NOT NULL,
    max_perfiles     NUMBER(1)      NOT NULL,
    CONSTRAINT chk_plan_nombre    CHECK (nombre IN ('BASICO','ESTANDAR','PREMIUM','FAMILIAR','EMPRESARIAL','ESTUDIANTIL','ULTRA','INSTITUCIONAL','PLUS','PREMIUM_PLUS','VIP','ORO','PLATINO','DIAMANTE','INFINITO','MAX','ESSENTIAL','CULTURA','TECH','CINE','MUSICAL','STREAMING','KIDS','FIESTA','RED')),
    CONSTRAINT chk_plan_precio    CHECK (precio_mensual > 0),
    CONSTRAINT chk_plan_pantallas CHECK (num_pantallas BETWEEN 1 AND 4),
    CONSTRAINT chk_plan_calidad   CHECK (calidad_video IN ('SD','HD','4K')),
    CONSTRAINT chk_plan_perfiles  CHECK (max_perfiles BETWEEN 1 AND 5)
);
COMMENT ON TABLE  PLANES IS 'Planes de suscripción disponibles en la plataforma';
COMMENT ON COLUMN PLANES.id_plan        IS 'Identificador único del plan';
COMMENT ON COLUMN PLANES.nombre         IS 'Nombre del plan: BASICO, ESTANDAR o PREMIUM';
COMMENT ON COLUMN PLANES.precio_mensual IS 'Precio mensual en pesos colombianos';
COMMENT ON COLUMN PLANES.num_pantallas  IS 'Número de pantallas simultáneas permitidas';
COMMENT ON COLUMN PLANES.calidad_video  IS 'Calidad máxima de video: SD, HD o 4K';
COMMENT ON COLUMN PLANES.max_perfiles   IS 'Número máximo de perfiles por cuenta';

-- Categorías de contenido (Película, Serie, Documental, Música, Podcast)
CREATE TABLE CATEGORIAS (
    id_categoria  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre        VARCHAR2(50)  NOT NULL UNIQUE,
    descripcion   VARCHAR2(200)
);
COMMENT ON TABLE  CATEGORIAS IS 'Categorías generales de contenido multimedia';
COMMENT ON COLUMN CATEGORIAS.id_categoria IS 'Identificador único de la categoría';
COMMENT ON COLUMN CATEGORIAS.nombre       IS 'Nombre de la categoría (único)';
COMMENT ON COLUMN CATEGORIAS.descripcion  IS 'Descripción de la categoría';

-- Géneros (Acción, Comedia, Drama, etc.)
CREATE TABLE GENEROS (
    id_genero   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre      VARCHAR2(50)  NOT NULL UNIQUE,
    descripcion VARCHAR2(200)
);
COMMENT ON TABLE  GENEROS IS 'Géneros disponibles para clasificar el contenido';
COMMENT ON COLUMN GENEROS.id_genero  IS 'Identificador único del género';
COMMENT ON COLUMN GENEROS.nombre     IS 'Nombre del género (único)';

-- Departamentos de empleados
CREATE TABLE DEPARTAMENTOS (
    id_departamento  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre           VARCHAR2(50)  NOT NULL UNIQUE,
    descripcion      VARCHAR2(200)
);
COMMENT ON TABLE  DEPARTAMENTOS IS 'Departamentos de la empresa QuindioFlix';
COMMENT ON COLUMN DEPARTAMENTOS.id_departamento IS 'Identificador único del departamento';
COMMENT ON COLUMN DEPARTAMENTOS.nombre          IS 'Nombre del departamento';

-- Empleados (con auto-referencia para jerarquía de supervisión)
CREATE TABLE EMPLEADOS (
    id_empleado      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre           VARCHAR2(100) NOT NULL,
    apellido         VARCHAR2(100) NOT NULL,
    email            VARCHAR2(150) NOT NULL UNIQUE,
    telefono         VARCHAR2(20),
    cargo            VARCHAR2(100) NOT NULL,
    fecha_ingreso    DATE          NOT NULL,
    salario          NUMBER(12,2),
    id_departamento  NUMBER        NOT NULL,
    id_supervisor    NUMBER,       -- Auto-referencia: supervisor directo (mismo depto)
    activo           CHAR(1)       DEFAULT 'S' NOT NULL,
    CONSTRAINT fk_emp_depto  FOREIGN KEY (id_departamento) REFERENCES DEPARTAMENTOS(id_departamento),
    CONSTRAINT fk_emp_super  FOREIGN KEY (id_supervisor)   REFERENCES EMPLEADOS(id_empleado),
    CONSTRAINT chk_emp_activo CHECK (activo IN ('S','N'))
);
COMMENT ON TABLE  EMPLEADOS IS 'Empleados de QuindioFlix organizados por departamento';
COMMENT ON COLUMN EMPLEADOS.id_supervisor IS 'Supervisor directo del empleado (mismo departamento). NULL si es el jefe.';
COMMENT ON COLUMN EMPLEADOS.activo        IS 'S=activo, N=inactivo/desvinculado';

-- Jefes de departamento (relación 1:1 entre departamento y empleado jefe)
CREATE TABLE JEFES_DEPARTAMENTO (
    id_departamento  NUMBER  NOT NULL,
    id_empleado      NUMBER  NOT NULL,
    fecha_inicio     DATE    NOT NULL,
    fecha_fin        DATE,
    CONSTRAINT pk_jefe_depto PRIMARY KEY (id_departamento, id_empleado),
    CONSTRAINT fk_jefe_depto_d FOREIGN KEY (id_departamento) REFERENCES DEPARTAMENTOS(id_departamento),
    CONSTRAINT fk_jefe_depto_e FOREIGN KEY (id_empleado)     REFERENCES EMPLEADOS(id_empleado)
);
COMMENT ON TABLE  JEFES_DEPARTAMENTO IS 'Registro histórico de jefes por departamento';
COMMENT ON COLUMN JEFES_DEPARTAMENTO.fecha_fin IS 'NULL si es el jefe actual';

-- Contenido multimedia
CREATE TABLE CONTENIDO (
    id_contenido       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo             VARCHAR2(200)  NOT NULL,
    tipo               VARCHAR2(15)   NOT NULL,
    anio_lanzamiento   NUMBER(4)      NOT NULL,
    duracion_min       NUMBER(6)      NOT NULL,  -- duración total en minutos
    sinopsis           VARCHAR2(2000),
    clasificacion_edad VARCHAR2(5)    NOT NULL,
    fecha_agregado     DATE           DEFAULT SYSDATE NOT NULL,
    es_original        CHAR(1)        DEFAULT 'N' NOT NULL,
    popularidad        NUMBER(10)     DEFAULT 0,  -- campo actualizado por cursor
    id_categoria       NUMBER         NOT NULL,
    id_empleado_resp   NUMBER         NOT NULL,   -- empleado responsable de publicación
    CONSTRAINT fk_cont_cat  FOREIGN KEY (id_categoria)     REFERENCES CATEGORIAS(id_categoria),
    CONSTRAINT fk_cont_emp  FOREIGN KEY (id_empleado_resp) REFERENCES EMPLEADOS(id_empleado),
    CONSTRAINT chk_cont_tipo  CHECK (tipo IN ('PELICULA','SERIE','DOCUMENTAL','MUSICA','PODCAST')),
    CONSTRAINT chk_cont_edad  CHECK (clasificacion_edad IN ('TP','+7','+13','+16','+18')),
    CONSTRAINT chk_cont_dur   CHECK (duracion_min > 0),
    CONSTRAINT chk_cont_anio  CHECK (anio_lanzamiento BETWEEN 1888 AND 2100),
    CONSTRAINT chk_cont_orig  CHECK (es_original IN ('S','N'))
);
COMMENT ON TABLE  CONTENIDO IS 'Catálogo de contenido multimedia de la plataforma';
COMMENT ON COLUMN CONTENIDO.tipo             IS 'PELICULA, SERIE, DOCUMENTAL, MUSICA o PODCAST';
COMMENT ON COLUMN CONTENIDO.clasificacion_edad IS 'Clasificación: TP, +7, +13, +16, +18';
COMMENT ON COLUMN CONTENIDO.es_original      IS 'S si es producción original de QuindioFlix';
COMMENT ON COLUMN CONTENIDO.popularidad      IS 'Contador de reproducciones completas (>=90%), actualizado por cursor';
COMMENT ON COLUMN CONTENIDO.id_empleado_resp IS 'Empleado del depto. Contenido responsable de la publicación';

-- Relaciones entre contenidos (secuela, precuela, spin-off, remake, etc.)
CREATE TABLE CONTENIDO_RELACIONADO (
    id_contenido_origen  NUMBER        NOT NULL,
    id_contenido_destino NUMBER        NOT NULL,
    tipo_relacion        VARCHAR2(30)  NOT NULL,
    descripcion          VARCHAR2(200),
    CONSTRAINT pk_cont_rel PRIMARY KEY (id_contenido_origen, id_contenido_destino),
    CONSTRAINT fk_cont_rel_orig FOREIGN KEY (id_contenido_origen)  REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT fk_cont_rel_dest FOREIGN KEY (id_contenido_destino) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT chk_cont_rel_tipo CHECK (tipo_relacion IN ('SECUELA','PRECUELA','REMAKE','SPIN_OFF','VERSION_EXTENDIDA','ADAPTACION','OTRO')),
    CONSTRAINT chk_cont_rel_self CHECK (id_contenido_origen <> id_contenido_destino)
);
COMMENT ON TABLE  CONTENIDO_RELACIONADO IS 'Relaciones entre contenidos (secuela, precuela, spin-off, etc.)';
COMMENT ON COLUMN CONTENIDO_RELACIONADO.tipo_relacion IS 'Tipo de relación: SECUELA, PRECUELA, REMAKE, SPIN_OFF, VERSION_EXTENDIDA, ADAPTACION, OTRO';

-- Tabla intermedia N:M Contenido-Géneros
CREATE TABLE CONTENIDO_GENEROS (
    id_contenido  NUMBER NOT NULL,
    id_genero     NUMBER NOT NULL,
    CONSTRAINT pk_cont_gen PRIMARY KEY (id_contenido, id_genero),
    CONSTRAINT fk_cg_cont  FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT fk_cg_gen   FOREIGN KEY (id_genero)    REFERENCES GENEROS(id_genero)
);
COMMENT ON TABLE CONTENIDO_GENEROS IS 'Relación N:M entre contenido y géneros';

-- Temporadas (solo para SERIE y PODCAST)
CREATE TABLE TEMPORADAS (
    id_temporada   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_contenido   NUMBER        NOT NULL,
    numero         NUMBER(3)     NOT NULL,
    titulo         VARCHAR2(200),
    anio           NUMBER(4),
    descripcion    VARCHAR2(1000),
    CONSTRAINT fk_temp_cont FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT uq_temp_cont_num UNIQUE (id_contenido, numero)
);
COMMENT ON TABLE  TEMPORADAS IS 'Temporadas de series y podcasts';
COMMENT ON COLUMN TEMPORADAS.numero IS 'Número de temporada dentro del contenido';

-- Episodios
CREATE TABLE EPISODIOS (
    id_episodio    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_temporada   NUMBER        NOT NULL,
    numero         NUMBER(4)     NOT NULL,
    titulo         VARCHAR2(200) NOT NULL,
    duracion_min   NUMBER(5)     NOT NULL,
    sinopsis       VARCHAR2(1000),
    fecha_estreno  DATE,
    CONSTRAINT fk_epis_temp FOREIGN KEY (id_temporada) REFERENCES TEMPORADAS(id_temporada),
    CONSTRAINT uq_epis_temp_num UNIQUE (id_temporada, numero),
    CONSTRAINT chk_epis_dur CHECK (duracion_min > 0)
);
COMMENT ON TABLE  EPISODIOS IS 'Episodios de cada temporada';
COMMENT ON COLUMN EPISODIOS.numero IS 'Número de episodio dentro de la temporada';

-- =============================================================================
-- BLOQUE 2: USUARIOS, CUENTAS Y PERFILES
-- =============================================================================

-- Usuarios
CREATE TABLE USUARIOS (
    id_usuario        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre            VARCHAR2(100)  NOT NULL,
    apellido          VARCHAR2(100)  NOT NULL,
    email             VARCHAR2(150)  NOT NULL UNIQUE,
    telefono          VARCHAR2(20),
    fecha_nacimiento  DATE           NOT NULL,
    ciudad            VARCHAR2(100)  NOT NULL,
    estado_cuenta     VARCHAR2(15)   DEFAULT 'ACTIVO' NOT NULL,
    fecha_registro    DATE           DEFAULT SYSDATE NOT NULL,
    fecha_ultimo_pago DATE,
    id_plan           NUMBER         NOT NULL,
    id_referidor      NUMBER,        -- Auto-referencia: quién refirió a este usuario
    es_moderador      CHAR(1)        DEFAULT 'N' NOT NULL,
    CONSTRAINT fk_usu_plan FOREIGN KEY (id_plan)      REFERENCES PLANES(id_plan),
    CONSTRAINT fk_usu_ref  FOREIGN KEY (id_referidor) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT chk_usu_estado    CHECK (estado_cuenta IN ('ACTIVO','INACTIVO','SUSPENDIDO')),
    CONSTRAINT chk_usu_mod       CHECK (es_moderador IN ('S','N')),
    CONSTRAINT chk_usu_edad      CHECK (fecha_nacimiento < DATE '2013-01-01')
);
COMMENT ON TABLE  USUARIOS IS 'Usuarios registrados en la plataforma';
COMMENT ON COLUMN USUARIOS.estado_cuenta     IS 'ACTIVO, INACTIVO (mora >30 días) o SUSPENDIDO';
COMMENT ON COLUMN USUARIOS.id_referidor      IS 'Usuario que refirió a este usuario. NULL si se registró solo.';
COMMENT ON COLUMN USUARIOS.es_moderador      IS 'S si el usuario tiene rol de moderador de contenido';
COMMENT ON COLUMN USUARIOS.fecha_ultimo_pago IS 'Fecha del último pago exitoso. Usada para calcular mora.';

-- Perfiles dentro de una cuenta de usuario
CREATE TABLE PERFILES (
    id_perfil    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario   NUMBER        NOT NULL,
    nombre       VARCHAR2(50)  NOT NULL,
    avatar       VARCHAR2(200),
    tipo         VARCHAR2(10)  DEFAULT 'ADULTO' NOT NULL,
    activo       CHAR(1)       DEFAULT 'S' NOT NULL,
    fecha_creacion DATE        DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_perf_usu  FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT chk_perf_tipo   CHECK (tipo IN ('ADULTO','INFANTIL')),
    CONSTRAINT chk_perf_activo CHECK (activo IN ('S','N'))
);
COMMENT ON TABLE  PERFILES IS 'Perfiles de consumo dentro de una cuenta de usuario';
COMMENT ON COLUMN PERFILES.tipo   IS 'ADULTO o INFANTIL. Los infantiles solo ven contenido TP, +7, +13';
COMMENT ON COLUMN PERFILES.activo IS 'S=activo, N=eliminado lógicamente';

-- =============================================================================
-- BLOQUE 3: REPRODUCCIONES, FAVORITOS, CALIFICACIONES Y REPORTES
-- =============================================================================

-- Reproducciones (tabla particionada por rango de fecha)
CREATE TABLE REPRODUCCIONES (
    id_reproduccion    NUMBER GENERATED ALWAYS AS IDENTITY,
    id_perfil          NUMBER        NOT NULL,
    id_contenido       NUMBER        NOT NULL,
    id_episodio        NUMBER,       -- NULL si el contenido no es serie/podcast
    fecha_hora_inicio  TIMESTAMP     NOT NULL,
    fecha_hora_fin     TIMESTAMP,
    dispositivo        VARCHAR2(15)  NOT NULL,
    porcentaje_avance  NUMBER(5,2)   DEFAULT 0,
    CONSTRAINT pk_reprod PRIMARY KEY (id_reproduccion, fecha_hora_inicio),
    CONSTRAINT fk_rep_perf FOREIGN KEY (id_perfil)    REFERENCES PERFILES(id_perfil),
    CONSTRAINT fk_rep_cont FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT fk_rep_epis FOREIGN KEY (id_episodio)  REFERENCES EPISODIOS(id_episodio),
    CONSTRAINT chk_rep_disp CHECK (dispositivo IN ('CELULAR','TABLET','TV','COMPUTADOR')),
    CONSTRAINT chk_rep_porc CHECK (porcentaje_avance BETWEEN 0 AND 100)
)
PARTITION BY RANGE (fecha_hora_inicio) (
    PARTITION reprod_2024    VALUES LESS THAN (TIMESTAMP '2025-01-01 00:00:00') TABLESPACE TBS_REPROD_2024,
    PARTITION reprod_2025    VALUES LESS THAN (TIMESTAMP '2026-01-01 00:00:00') TABLESPACE TBS_REPROD_2025,
    PARTITION reprod_2026    VALUES LESS THAN (TIMESTAMP '2027-01-01 00:00:00') TABLESPACE TBS_REPROD_2026,
    PARTITION reprod_futuro  VALUES LESS THAN (MAXVALUE) TABLESPACE TBS_REPROD_FUTURO
);
COMMENT ON TABLE  REPRODUCCIONES IS 'Registro de cada reproducción de contenido por perfil. Particionada por año.';
COMMENT ON COLUMN REPRODUCCIONES.id_episodio       IS 'NULL para películas/documentales/música. Obligatorio para series/podcasts.';
COMMENT ON COLUMN REPRODUCCIONES.porcentaje_avance IS 'Porcentaje del contenido reproducido (0-100)';

-- Favoritos (lista personal de cada perfil)
CREATE TABLE FAVORITOS (
    id_perfil     NUMBER  NOT NULL,
    id_contenido  NUMBER  NOT NULL,
    fecha_agregado DATE   DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_favoritos PRIMARY KEY (id_perfil, id_contenido),
    CONSTRAINT fk_fav_perf FOREIGN KEY (id_perfil)    REFERENCES PERFILES(id_perfil),
    CONSTRAINT fk_fav_cont FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido)
);
COMMENT ON TABLE FAVORITOS IS 'Lista personal de contenido favorito por perfil';

-- Calificaciones y reseñas
CREATE TABLE CALIFICACIONES (
    id_calificacion  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_perfil        NUMBER        NOT NULL,
    id_contenido     NUMBER        NOT NULL,
    estrellas        NUMBER(1)     NOT NULL,
    resena           VARCHAR2(2000),
    fecha            DATE          DEFAULT SYSDATE NOT NULL,
    CONSTRAINT uq_cal_perf_cont UNIQUE (id_perfil, id_contenido),
    CONSTRAINT fk_cal_perf FOREIGN KEY (id_perfil)    REFERENCES PERFILES(id_perfil),
    CONSTRAINT fk_cal_cont FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT chk_cal_estrellas CHECK (estrellas BETWEEN 1 AND 5)
);
COMMENT ON TABLE  CALIFICACIONES IS 'Calificaciones (1-5 estrellas) y reseñas de contenido por perfil';
COMMENT ON COLUMN CALIFICACIONES.estrellas IS 'Calificación de 1 a 5 estrellas';
COMMENT ON COLUMN CALIFICACIONES.resena    IS 'Reseña escrita opcional';

-- Reportes de contenido inapropiado
CREATE TABLE REPORTES (
    id_reporte       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_perfil        NUMBER        NOT NULL,   -- perfil que reporta
    id_contenido     NUMBER        NOT NULL,
    motivo           VARCHAR2(100) NOT NULL,
    descripcion      VARCHAR2(1000),
    estado           VARCHAR2(15)  DEFAULT 'PENDIENTE' NOT NULL,
    fecha_reporte    DATE          DEFAULT SYSDATE NOT NULL,
    id_moderador     NUMBER,       -- usuario moderador que resuelve
    fecha_resolucion DATE,
    resolucion_nota  VARCHAR2(500),
    CONSTRAINT fk_rep_perf_r FOREIGN KEY (id_perfil)    REFERENCES PERFILES(id_perfil),
    CONSTRAINT fk_rep_cont_r FOREIGN KEY (id_contenido) REFERENCES CONTENIDO(id_contenido),
    CONSTRAINT fk_rep_mod    FOREIGN KEY (id_moderador) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT chk_rep_estado CHECK (estado IN ('PENDIENTE','EN_REVISION','RESUELTO','RECHAZADO'))
);
COMMENT ON TABLE  REPORTES IS 'Reportes de contenido inapropiado realizados por perfiles';
COMMENT ON COLUMN REPORTES.id_moderador IS 'Usuario con es_moderador=S que resuelve el reporte';

-- =============================================================================
-- BLOQUE 4: PAGOS Y FACTURACIÓN
-- =============================================================================

CREATE TABLE PAGOS (
    id_pago         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario      NUMBER        NOT NULL,
    fecha_pago      DATE          DEFAULT SYSDATE NOT NULL,
    monto           NUMBER(10,2)  NOT NULL,
    metodo_pago     VARCHAR2(20)  NOT NULL,
    estado_pago     VARCHAR2(15)  DEFAULT 'PENDIENTE' NOT NULL,
    periodo_mes     NUMBER(2)     NOT NULL,  -- mes al que corresponde el pago
    periodo_anio    NUMBER(4)     NOT NULL,  -- año al que corresponde el pago
    descuento_pct   NUMBER(5,2)   DEFAULT 0, -- porcentaje de descuento aplicado
    referencia      VARCHAR2(100),           -- referencia de la transacción
    CONSTRAINT fk_pago_usu FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario),
    CONSTRAINT chk_pago_metodo CHECK (metodo_pago IN ('TARJETA_CREDITO','TARJETA_DEBITO','PSE','NEQUI','DAVIPLATA')),
    CONSTRAINT chk_pago_estado CHECK (estado_pago IN ('EXITOSO','FALLIDO','PENDIENTE','REEMBOLSADO')),
    CONSTRAINT chk_pago_monto  CHECK (monto > 0),
    CONSTRAINT chk_pago_mes    CHECK (periodo_mes BETWEEN 1 AND 12),
    CONSTRAINT chk_pago_desc   CHECK (descuento_pct BETWEEN 0 AND 100)
);
COMMENT ON TABLE  PAGOS IS 'Historial de pagos de suscripción de los usuarios';
COMMENT ON COLUMN PAGOS.periodo_mes  IS 'Mes al que corresponde el pago (1-12)';
COMMENT ON COLUMN PAGOS.periodo_anio IS 'Año al que corresponde el pago';
COMMENT ON COLUMN PAGOS.descuento_pct IS 'Porcentaje de descuento aplicado (antigüedad o referido)';

-- Registro de cambios de plan
CREATE TABLE HISTORIAL_PLANES (
    id_historial   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario     NUMBER  NOT NULL,
    id_plan_ant    NUMBER  NOT NULL,
    id_plan_nuevo  NUMBER  NOT NULL,
    fecha_cambio   DATE    DEFAULT SYSDATE NOT NULL,
    motivo         VARCHAR2(200),
    CONSTRAINT fk_hist_usu  FOREIGN KEY (id_usuario)   REFERENCES USUARIOS(id_usuario),
    CONSTRAINT fk_hist_pant FOREIGN KEY (id_plan_ant)  REFERENCES PLANES(id_plan),
    CONSTRAINT fk_hist_pnue FOREIGN KEY (id_plan_nuevo) REFERENCES PLANES(id_plan)
);
COMMENT ON TABLE HISTORIAL_PLANES IS 'Registro histórico de cambios de plan de suscripción';

COMMIT;

-- Aca nos mostria 19 tablas
SELECT table_name FROM user_tables ORDER BY table_name;

