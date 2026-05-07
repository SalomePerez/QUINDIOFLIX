-- =============================================================================
-- QUINDIOFLIX — Datos de Prueba (Seed Data)
-- Ejecutar después de 02_create_tables.sql
-- =============================================================================

-- -------------------------
-- 1. PLANES
-- -------------------------
INSERT INTO PLANES (nombre, precio_mensual, num_pantallas, calidad_video, max_perfiles)
VALUES ('BASICO', 14900, 1, 'SD', 2);
INSERT INTO PLANES (nombre, precio_mensual, num_pantallas, calidad_video, max_perfiles)
VALUES ('ESTANDAR', 24900, 2, 'HD', 3);
INSERT INTO PLANES (nombre, precio_mensual, num_pantallas, calidad_video, max_perfiles)
VALUES ('PREMIUM', 34900, 4, '4K', 5);

-- -------------------------
-- 2. CATEGORIAS
-- -------------------------
INSERT INTO CATEGORIAS (nombre, descripcion) VALUES ('PELICULA', 'Largometrajes de ficción y no ficción');
INSERT INTO CATEGORIAS (nombre, descripcion) VALUES ('SERIE', 'Contenido serializado por temporadas y episodios');
INSERT INTO CATEGORIAS (nombre, descripcion) VALUES ('DOCUMENTAL', 'Documentales y reportajes');
INSERT INTO CATEGORIAS (nombre, descripcion) VALUES ('MUSICA', 'Conciertos, videos musicales y álbumes');
INSERT INTO CATEGORIAS (nombre, descripcion) VALUES ('PODCAST', 'Programas de audio y video en formato podcast');

-- -------------------------
-- 3. GENEROS
-- -------------------------
INSERT INTO GENEROS (nombre) VALUES ('Acción');
INSERT INTO GENEROS (nombre) VALUES ('Comedia');
INSERT INTO GENEROS (nombre) VALUES ('Drama');
INSERT INTO GENEROS (nombre) VALUES ('Suspenso');
INSERT INTO GENEROS (nombre) VALUES ('Romance');
INSERT INTO GENEROS (nombre) VALUES ('Ciencia Ficción');
INSERT INTO GENEROS (nombre) VALUES ('Terror');
INSERT INTO GENEROS (nombre) VALUES ('Infantil');
INSERT INTO GENEROS (nombre) VALUES ('Musical');
INSERT INTO GENEROS (nombre) VALUES ('Documental');
INSERT INTO GENEROS (nombre) VALUES ('Thriller');
INSERT INTO GENEROS (nombre) VALUES ('Aventura');

-- -------------------------
-- 4. DEPARTAMENTOS
-- -------------------------
INSERT INTO DEPARTAMENTOS (nombre, descripcion) VALUES ('Tecnología', 'Desarrollo y mantenimiento de la plataforma');
INSERT INTO DEPARTAMENTOS (nombre, descripcion) VALUES ('Contenido', 'Gestión y publicación del catálogo multimedia');
INSERT INTO DEPARTAMENTOS (nombre, descripcion) VALUES ('Marketing', 'Estrategias de adquisición y retención de usuarios');
INSERT INTO DEPARTAMENTOS (nombre, descripcion) VALUES ('Soporte', 'Atención al cliente y resolución de incidencias');
INSERT INTO DEPARTAMENTOS (nombre, descripcion) VALUES ('Finanzas', 'Gestión financiera y facturación');

-- -------------------------
-- 5. EMPLEADOS
-- id_departamento: 1=Tecnología, 2=Contenido, 3=Marketing, 4=Soporte, 5=Finanzas
-- -------------------------
-- Jefes (sin supervisor)
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Carlos', 'Ramírez', 'c.ramirez@quindioflix.co', '3101234567', 'Jefe de Tecnología', TO_DATE('15/01/2020','DD/MM/YYYY'), 8500000, 1, NULL);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Luisa', 'Fernández', 'l.fernandez@quindioflix.co', '3112345678', 'Jefa de Contenido', TO_DATE('10/02/2020','DD/MM/YYYY'), 8000000, 2, NULL);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Andrés', 'Ospina', 'a.ospina@quindioflix.co', '3123456789', 'Jefe de Marketing', TO_DATE('20/03/2020','DD/MM/YYYY'), 7500000, 3, NULL);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('María', 'Gómez', 'm.gomez@quindioflix.co', '3134567890', 'Jefa de Soporte', TO_DATE('05/04/2020','DD/MM/YYYY'), 7000000, 4, NULL);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Jorge', 'Salcedo', 'j.salcedo@quindioflix.co', '3145678901', 'Jefe de Finanzas', TO_DATE('12/05/2020','DD/MM/YYYY'), 8200000, 5, NULL);
-- Empleados con supervisor
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Sebastián', 'Torres', 's.torres@quindioflix.co', '3156789012', 'Desarrollador Senior', TO_DATE('01/06/2021','DD/MM/YYYY'), 5500000, 1, 1);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Valentina', 'Cruz', 'v.cruz@quindioflix.co', '3167890123', 'Editora de Contenido', TO_DATE('15/07/2021','DD/MM/YYYY'), 4800000, 2, 2);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Felipe', 'Morales', 'f.morales@quindioflix.co', '3178901234', 'Curador de Catálogo', TO_DATE('20/08/2021','DD/MM/YYYY'), 4500000, 2, 2);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Daniela', 'Ríos', 'd.rios@quindioflix.co', '3189012345', 'Analista de Marketing', TO_DATE('10/09/2021','DD/MM/YYYY'), 4200000, 3, 3);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Camilo', 'Vargas', 'c.vargas@quindioflix.co', '3190123456', 'Agente de Soporte', TO_DATE('05/10/2021','DD/MM/YYYY'), 3800000, 4, 4);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Laura', 'Patiño', 'l.patino@quindioflix.co', '3201234567', 'Agente de Soporte', TO_DATE('15/11/2021','DD/MM/YYYY'), 3800000, 4, 4);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Nicolás', 'Herrera', 'n.herrera@quindioflix.co', '3212345678', 'Analista Financiero', TO_DATE('01/12/2021','DD/MM/YYYY'), 4600000, 5, 5);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Alejandra', 'Mejía', 'a.mejia@quindioflix.co', '3223456789', 'Desarrolladora Junior', TO_DATE('10/01/2022','DD/MM/YYYY'), 3500000, 1, 6);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Julián', 'Cardona', 'j.cardona@quindioflix.co', '3234567890', 'Publicador de Contenido', TO_DATE('20/02/2022','DD/MM/YYYY'), 4000000, 2, 7);
INSERT INTO EMPLEADOS (nombre, apellido, email, telefono, cargo, fecha_ingreso, salario, id_departamento, id_supervisor)
VALUES ('Paola', 'Agudelo', 'p.agudelo@quindioflix.co', '3245678901', 'Diseñadora de Marketing', TO_DATE('01/03/2022','DD/MM/YYYY'), 4100000, 3, 3);

-- -------------------------
-- 6. JEFES_DEPARTAMENTO
-- -------------------------
INSERT INTO JEFES_DEPARTAMENTO (id_departamento, id_empleado, fecha_inicio) VALUES (1, 1, TO_DATE('15/01/2020','DD/MM/YYYY'));
INSERT INTO JEFES_DEPARTAMENTO (id_departamento, id_empleado, fecha_inicio) VALUES (2, 2, TO_DATE('10/02/2020','DD/MM/YYYY'));
INSERT INTO JEFES_DEPARTAMENTO (id_departamento, id_empleado, fecha_inicio) VALUES (3, 3, TO_DATE('20/03/2020','DD/MM/YYYY'));
INSERT INTO JEFES_DEPARTAMENTO (id_departamento, id_empleado, fecha_inicio) VALUES (4, 4, TO_DATE('05/04/2020','DD/MM/YYYY'));
INSERT INTO JEFES_DEPARTAMENTO (id_departamento, id_empleado, fecha_inicio) VALUES (5, 5, TO_DATE('12/05/2020','DD/MM/YYYY'));

COMMIT;

-- -------------------------
-- 7. CONTENIDO (40 registros)
-- id_categoria: 1=PELICULA, 2=SERIE, 3=DOCUMENTAL, 4=MUSICA, 5=PODCAST
-- id_empleado_resp: empleados del depto Contenido (2,7,8,14,15)
-- -------------------------
-- PELICULAS (12)
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('El Último Vuelo', 'PELICULA', 2022, 118, 'Un piloto debe salvar a sus pasajeros en una situación de emergencia extrema.', '+13', 'N', 1, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Amor en Cartagena', 'PELICULA', 2023, 105, 'Una historia de amor entre dos jóvenes de mundos opuestos en la ciudad amurallada.', '+13', 'S', 1, 8);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('La Sombra del Cóndor', 'PELICULA', 2021, 132, 'Un agente secreto colombiano descubre una conspiración internacional.', '+16', 'S', 1, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Pequeños Gigantes', 'PELICULA', 2023, 88, 'Una película animada sobre animales del Amazonas que salvan su hogar.', 'TP', 'S', 1, 14);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Noche de Brujas en Bogotá', 'PELICULA', 2022, 95, 'Terror urbano en las calles de Bogotá durante Halloween.', '+18', 'N', 1, 8);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Galaxia Perdida', 'PELICULA', 2024, 145, 'Una expedición espacial descubre una civilización alienígena en peligro.', '+7', 'S', 1, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('El Regreso', 'PELICULA', 2024, 110, 'Secuela de La Sombra del Cóndor. El agente enfrenta a su mayor enemigo.', '+16', 'S', 1, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Cumbia Eterna', 'PELICULA', 2023, 98, 'Biopic de una legendaria cantante de cumbia colombiana.', '+7', 'S', 1, 14);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Código Rojo', 'PELICULA', 2022, 120, 'Un hacker colombiano descubre que el gobierno lo está vigilando.', '+16', 'N', 1, 8);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('La Fiesta del Pueblo', 'PELICULA', 2021, 92, 'Comedia sobre las fiestas del Quindío y sus personajes pintorescos.', '+7', 'S', 1, 14);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Abismo', 'PELICULA', 2023, 115, 'Un grupo de espeleólogos queda atrapado en una cueva submarina.', '+13', 'N', 1, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Galaxia Perdida: El Origen', 'PELICULA', 2025, 138, 'Precuela de Galaxia Perdida. Los primeros exploradores del cosmos.', '+7', 'S', 1, 7);

-- SERIES (10)
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Los Cafeteros', 'SERIE', 2021, 45, 'Drama familiar en una hacienda cafetera del Quindío a través de tres generaciones.', '+13', 'S', 2, 8);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Medellín Noir', 'SERIE', 2022, 50, 'Un detective resuelve crímenes en el Medellín contemporáneo.', '+18', 'S', 2, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Ciberpatrulla', 'SERIE', 2023, 30, 'Niños superhéroes que protegen internet de los villanos digitales.', 'TP', 'S', 2, 14);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Bogotá 2050', 'SERIE', 2024, 55, 'Ciencia ficción distópica en una Bogotá del futuro controlada por corporaciones.', '+16', 'S', 2, 8);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Risas del Pacífico', 'SERIE', 2022, 25, 'Comedia de situaciones ambientada en Buenaventura.', '+7', 'N', 2, 14);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('La Clínica', 'SERIE', 2023, 45, 'Drama médico en un hospital público de Cali.', '+13', 'S', 2, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Medellín Noir: El Cartel', 'SERIE', 2024, 55, 'Spin-off de Medellín Noir. El origen del cartel que persigue el detective.', '+18', 'S', 2, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Selva Viva', 'SERIE', 2022, 40, 'Aventuras de una bióloga en el Amazonas colombiano.', '+7', 'S', 2, 8);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('El Ministerio del Tiempo CO', 'SERIE', 2025, 50, 'Agentes viajan en el tiempo para proteger la historia de Colombia.', '+13', 'S', 2, 14);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Ciberpatrulla: Nueva Generación', 'SERIE', 2025, 30, 'Los hijos de los Ciberpatrulleros continúan la misión.', 'TP', 'S', 2, 14);

-- DOCUMENTALES (8)
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Colombia Salvaje', 'DOCUMENTAL', 2021, 90, 'La biodiversidad de Colombia vista desde el aire.', 'TP', 'S', 3, 8);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('El Café Nuestro', 'DOCUMENTAL', 2022, 75, 'La historia del café colombiano desde la semilla hasta la taza.', 'TP', 'S', 3, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Ríos de Vida', 'DOCUMENTAL', 2023, 85, 'Los ríos colombianos y las comunidades que dependen de ellos.', 'TP', 'N', 3, 14);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Cumbia: Raíces y Ritmo', 'DOCUMENTAL', 2022, 68, 'El origen africano e indígena de la cumbia colombiana.', 'TP', 'S', 3, 8);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Mujeres que Construyen', 'DOCUMENTAL', 2024, 72, 'Historias de mujeres emprendedoras en zonas rurales de Colombia.', 'TP', 'S', 3, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Colombia Salvaje: Océanos', 'DOCUMENTAL', 2023, 95, 'Versión extendida de Colombia Salvaje enfocada en los océanos.', 'TP', 'S', 3, 8);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('La Paz Posible', 'DOCUMENTAL', 2022, 110, 'Crónica del proceso de paz en Colombia.', '+13', 'N', 3, 14);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Gastronomía Colombiana', 'DOCUMENTAL', 2024, 60, 'Un recorrido por los sabores y tradiciones culinarias del país.', 'TP', 'S', 3, 7);

-- MUSICA (5)
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Concierto Vallenato en Vivo', 'MUSICA', 2023, 120, 'Concierto en vivo del Festival Vallenato de Valledupar.', 'TP', 'N', 4, 14);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Beats Colombianos Vol. 1', 'MUSICA', 2022, 65, 'Compilado de música electrónica con ritmos colombianos.', '+13', 'S', 4, 8);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Trova Paisa: Lo Mejor', 'MUSICA', 2021, 90, 'Los mejores trovadores de Antioquia en un especial musical.', 'TP', 'S', 4, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Salsa Caleña en Vivo', 'MUSICA', 2024, 110, 'Noche de salsa en el Petronio Álvarez de Cali.', 'TP', 'N', 4, 14);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Indie Colombia 2024', 'MUSICA', 2024, 80, 'Los mejores artistas independientes colombianos del año.', '+7', 'S', 4, 8);

-- PODCASTS (5)
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Historias de Colombia', 'PODCAST', 2021, 45, 'Podcast de historia colombiana narrado de forma entretenida.', 'TP', 'S', 5, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Tech Quindío', 'PODCAST', 2022, 60, 'Tecnología, startups e innovación desde el Eje Cafetero.', '+7', 'S', 5, 8);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Emprendimiento CO', 'PODCAST', 2023, 50, 'Historias de emprendedores colombianos exitosos.', '+7', 'S', 5, 14);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Ciencia para Todos', 'PODCAST', 2022, 40, 'Divulgación científica en español para toda la familia.', 'TP', 'N', 5, 7);
INSERT INTO CONTENIDO (titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp)
VALUES ('Misterios de Colombia', 'PODCAST', 2024, 55, 'Leyendas urbanas, misterios y casos sin resolver en Colombia.', '+13', 'S', 5, 8);

COMMIT;

-- -------------------------
-- 8. CONTENIDO_RELACIONADO
-- Contenido IDs (aproximados por orden de inserción):
-- 1=El Último Vuelo, 2=Amor en Cartagena, 3=La Sombra del Cóndor, 4=Pequeños Gigantes
-- 5=Noche de Brujas, 6=Galaxia Perdida, 7=El Regreso, 8=Cumbia Eterna
-- 9=Código Rojo, 10=La Fiesta del Pueblo, 11=Abismo, 12=Galaxia Perdida: El Origen
-- 13=Los Cafeteros, 14=Medellín Noir, 15=Ciberpatrulla, 16=Bogotá 2050
-- 17=Risas del Pacífico, 18=La Clínica, 19=Medellín Noir: El Cartel, 20=Selva Viva
-- 21=El Ministerio del Tiempo CO, 22=Ciberpatrulla: Nueva Generación
-- 23=Colombia Salvaje, 24=El Café Nuestro, 25=Ríos de Vida, 26=Cumbia: Raíces
-- 27=Mujeres que Construyen, 28=Colombia Salvaje: Océanos, 29=La Paz Posible
-- 30=Gastronomía Colombiana, 31=Concierto Vallenato, 32=Beats Colombianos
-- 33=Trova Paisa, 34=Salsa Caleña, 35=Indie Colombia
-- 36=Historias de Colombia, 37=Tech Quindío, 38=Emprendimiento CO
-- 39=Ciencia para Todos, 40=Misterios de Colombia
-- -------------------------
-- El Regreso es secuela de La Sombra del Cóndor
INSERT INTO CONTENIDO_RELACIONADO (id_contenido_origen, id_contenido_destino, tipo_relacion, descripcion)
VALUES (7, 3, 'SECUELA', 'El Regreso continúa la historia de La Sombra del Cóndor');
-- La Sombra del Cóndor es precuela de El Regreso
INSERT INTO CONTENIDO_RELACIONADO (id_contenido_origen, id_contenido_destino, tipo_relacion, descripcion)
VALUES (3, 7, 'PRECUELA', 'La Sombra del Cóndor es el origen de la saga');
-- Galaxia Perdida: El Origen es precuela de Galaxia Perdida
INSERT INTO CONTENIDO_RELACIONADO (id_contenido_origen, id_contenido_destino, tipo_relacion, descripcion)
VALUES (12, 6, 'PRECUELA', 'El Origen narra los eventos antes de Galaxia Perdida');
INSERT INTO CONTENIDO_RELACIONADO (id_contenido_origen, id_contenido_destino, tipo_relacion, descripcion)
VALUES (6, 12, 'SECUELA', 'Galaxia Perdida es la continuación de El Origen');
-- Medellín Noir: El Cartel es spin-off de Medellín Noir
INSERT INTO CONTENIDO_RELACIONADO (id_contenido_origen, id_contenido_destino, tipo_relacion, descripcion)
VALUES (19, 14, 'SPIN_OFF', 'El Cartel expande el universo de Medellín Noir');
-- Ciberpatrulla: Nueva Generación es spin-off de Ciberpatrulla
INSERT INTO CONTENIDO_RELACIONADO (id_contenido_origen, id_contenido_destino, tipo_relacion, descripcion)
VALUES (22, 15, 'SPIN_OFF', 'Nueva Generación continúa el legado de Ciberpatrulla');
-- Colombia Salvaje: Océanos es versión extendida de Colombia Salvaje
INSERT INTO CONTENIDO_RELACIONADO (id_contenido_origen, id_contenido_destino, tipo_relacion, descripcion)
VALUES (28, 23, 'VERSION_EXTENDIDA', 'Versión extendida enfocada en los océanos colombianos');
-- Cumbia Eterna es adaptación de Cumbia: Raíces y Ritmo
INSERT INTO CONTENIDO_RELACIONADO (id_contenido_origen, id_contenido_destino, tipo_relacion, descripcion)
VALUES (8, 26, 'ADAPTACION', 'La película está basada en el documental sobre la cumbia');
-- Código Rojo es remake de El Último Vuelo (misma productora, diferente historia)
INSERT INTO CONTENIDO_RELACIONADO (id_contenido_origen, id_contenido_destino, tipo_relacion, descripcion)
VALUES (9, 1, 'OTRO', 'Misma productora, estilo similar de thriller de acción');
-- Misterios de Colombia relacionado con Historias de Colombia
INSERT INTO CONTENIDO_RELACIONADO (id_contenido_origen, id_contenido_destino, tipo_relacion, descripcion)
VALUES (40, 36, 'OTRO', 'Ambos podcasts exploran la historia y cultura colombiana');

COMMIT;

-- -------------------------
-- 9. CONTENIDO_GENEROS
-- -------------------------
-- Películas
INSERT INTO CONTENIDO_GENEROS VALUES (1, 1);  -- El Último Vuelo: Acción
INSERT INTO CONTENIDO_GENEROS VALUES (1, 4);  -- El Último Vuelo: Suspenso
INSERT INTO CONTENIDO_GENEROS VALUES (2, 3);  -- Amor en Cartagena: Drama
INSERT INTO CONTENIDO_GENEROS VALUES (2, 5);  -- Amor en Cartagena: Romance
INSERT INTO CONTENIDO_GENEROS VALUES (3, 1);  -- La Sombra del Cóndor: Acción
INSERT INTO CONTENIDO_GENEROS VALUES (3, 11); -- La Sombra del Cóndor: Thriller
INSERT INTO CONTENIDO_GENEROS VALUES (4, 8);  -- Pequeños Gigantes: Infantil
INSERT INTO CONTENIDO_GENEROS VALUES (4, 12); -- Pequeños Gigantes: Aventura
INSERT INTO CONTENIDO_GENEROS VALUES (5, 7);  -- Noche de Brujas: Terror
INSERT INTO CONTENIDO_GENEROS VALUES (6, 6);  -- Galaxia Perdida: Ciencia Ficción
INSERT INTO CONTENIDO_GENEROS VALUES (6, 12); -- Galaxia Perdida: Aventura
INSERT INTO CONTENIDO_GENEROS VALUES (7, 1);  -- El Regreso: Acción
INSERT INTO CONTENIDO_GENEROS VALUES (7, 11); -- El Regreso: Thriller
INSERT INTO CONTENIDO_GENEROS VALUES (8, 9);  -- Cumbia Eterna: Musical
INSERT INTO CONTENIDO_GENEROS VALUES (8, 3);  -- Cumbia Eterna: Drama
INSERT INTO CONTENIDO_GENEROS VALUES (9, 4);  -- Código Rojo: Suspenso
INSERT INTO CONTENIDO_GENEROS VALUES (9, 11); -- Código Rojo: Thriller
INSERT INTO CONTENIDO_GENEROS VALUES (10, 2); -- La Fiesta del Pueblo: Comedia
INSERT INTO CONTENIDO_GENEROS VALUES (11, 4); -- Abismo: Suspenso
INSERT INTO CONTENIDO_GENEROS VALUES (11, 12);-- Abismo: Aventura
INSERT INTO CONTENIDO_GENEROS VALUES (12, 6); -- Galaxia Perdida: El Origen: Ciencia Ficción
INSERT INTO CONTENIDO_GENEROS VALUES (12, 12);-- Galaxia Perdida: El Origen: Aventura
-- Series
INSERT INTO CONTENIDO_GENEROS VALUES (13, 3); -- Los Cafeteros: Drama
INSERT INTO CONTENIDO_GENEROS VALUES (13, 5); -- Los Cafeteros: Romance
INSERT INTO CONTENIDO_GENEROS VALUES (14, 11);-- Medellín Noir: Thriller
INSERT INTO CONTENIDO_GENEROS VALUES (14, 3); -- Medellín Noir: Drama
INSERT INTO CONTENIDO_GENEROS VALUES (15, 8); -- Ciberpatrulla: Infantil
INSERT INTO CONTENIDO_GENEROS VALUES (15, 12);-- Ciberpatrulla: Aventura
INSERT INTO CONTENIDO_GENEROS VALUES (16, 6); -- Bogotá 2050: Ciencia Ficción
INSERT INTO CONTENIDO_GENEROS VALUES (16, 11);-- Bogotá 2050: Thriller
INSERT INTO CONTENIDO_GENEROS VALUES (17, 2); -- Risas del Pacífico: Comedia
INSERT INTO CONTENIDO_GENEROS VALUES (18, 3); -- La Clínica: Drama
INSERT INTO CONTENIDO_GENEROS VALUES (19, 11);-- Medellín Noir: El Cartel: Thriller
INSERT INTO CONTENIDO_GENEROS VALUES (20, 12);-- Selva Viva: Aventura
INSERT INTO CONTENIDO_GENEROS VALUES (20, 3); -- Selva Viva: Drama
INSERT INTO CONTENIDO_GENEROS VALUES (21, 12);-- El Ministerio del Tiempo: Aventura
INSERT INTO CONTENIDO_GENEROS VALUES (21, 6); -- El Ministerio del Tiempo: Ciencia Ficción
INSERT INTO CONTENIDO_GENEROS VALUES (22, 8); -- Ciberpatrulla NG: Infantil
-- Documentales
INSERT INTO CONTENIDO_GENEROS VALUES (23, 10);-- Colombia Salvaje: Documental
INSERT INTO CONTENIDO_GENEROS VALUES (24, 10);-- El Café Nuestro: Documental
INSERT INTO CONTENIDO_GENEROS VALUES (25, 10);-- Ríos de Vida: Documental
INSERT INTO CONTENIDO_GENEROS VALUES (26, 9); -- Cumbia: Raíces: Musical
INSERT INTO CONTENIDO_GENEROS VALUES (26, 10);-- Cumbia: Raíces: Documental
INSERT INTO CONTENIDO_GENEROS VALUES (27, 10);-- Mujeres que Construyen: Documental
INSERT INTO CONTENIDO_GENEROS VALUES (28, 10);-- Colombia Salvaje: Océanos: Documental
INSERT INTO CONTENIDO_GENEROS VALUES (29, 3); -- La Paz Posible: Drama
INSERT INTO CONTENIDO_GENEROS VALUES (29, 10);-- La Paz Posible: Documental
INSERT INTO CONTENIDO_GENEROS VALUES (30, 10);-- Gastronomía: Documental
-- Música
INSERT INTO CONTENIDO_GENEROS VALUES (31, 9); -- Concierto Vallenato: Musical
INSERT INTO CONTENIDO_GENEROS VALUES (32, 9); -- Beats Colombianos: Musical
INSERT INTO CONTENIDO_GENEROS VALUES (33, 9); -- Trova Paisa: Musical
INSERT INTO CONTENIDO_GENEROS VALUES (34, 9); -- Salsa Caleña: Musical
INSERT INTO CONTENIDO_GENEROS VALUES (35, 9); -- Indie Colombia: Musical
-- Podcasts
INSERT INTO CONTENIDO_GENEROS VALUES (36, 10);-- Historias de Colombia: Documental
INSERT INTO CONTENIDO_GENEROS VALUES (37, 10);-- Tech Quindío: Documental
INSERT INTO CONTENIDO_GENEROS VALUES (38, 10);-- Emprendimiento CO: Documental
INSERT INTO CONTENIDO_GENEROS VALUES (39, 10);-- Ciencia para Todos: Documental
INSERT INTO CONTENIDO_GENEROS VALUES (40, 4); -- Misterios de Colombia: Suspenso

COMMIT;

-- -------------------------
-- 10. TEMPORADAS (15 para series y podcasts)
-- Series: 13=Los Cafeteros, 14=Medellín Noir, 15=Ciberpatrulla, 16=Bogotá 2050
--         17=Risas del Pacífico, 18=La Clínica, 19=Medellín Noir: El Cartel
--         20=Selva Viva, 21=El Ministerio del Tiempo, 22=Ciberpatrulla NG
-- Podcasts: 36=Historias de Colombia, 37=Tech Quindío, 38=Emprendimiento CO
-- -------------------------
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (13, 1, 'Los Cafeteros - Temporada 1', 2021);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (13, 2, 'Los Cafeteros - Temporada 2', 2022);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (14, 1, 'Medellín Noir - Temporada 1', 2022);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (14, 2, 'Medellín Noir - Temporada 2', 2023);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (15, 1, 'Ciberpatrulla - Temporada 1', 2023);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (16, 1, 'Bogotá 2050 - Temporada 1', 2024);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (17, 1, 'Risas del Pacífico - Temporada 1', 2022);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (18, 1, 'La Clínica - Temporada 1', 2023);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (19, 1, 'Medellín Noir: El Cartel - Temporada 1', 2024);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (20, 1, 'Selva Viva - Temporada 1', 2022);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (21, 1, 'El Ministerio del Tiempo CO - Temporada 1', 2025);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (22, 1, 'Ciberpatrulla NG - Temporada 1', 2025);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (36, 1, 'Historias de Colombia - Temporada 1', 2021);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (37, 1, 'Tech Quindío - Temporada 1', 2022);
INSERT INTO TEMPORADAS (id_contenido, numero, titulo, anio) VALUES (38, 1, 'Emprendimiento CO - Temporada 1', 2023);

COMMIT;

-- -------------------------
-- 11. EPISODIOS (50 episodios)
-- Temporadas IDs: 1=Los Cafeteros T1, 2=Los Cafeteros T2, 3=Medellín Noir T1
-- 4=Medellín Noir T2, 5=Ciberpatrulla T1, 6=Bogotá 2050 T1, 7=Risas Pacífico T1
-- 8=La Clínica T1, 9=Medellín Noir Cartel T1, 10=Selva Viva T1
-- 11=Ministerio Tiempo T1, 12=Ciberpatrulla NG T1, 13=Historias CO T1
-- 14=Tech Quindío T1, 15=Emprendimiento CO T1
-- -------------------------
-- Los Cafeteros T1 (6 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 1, 'La Cosecha', 45);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 2, 'Raíces', 47);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 3, 'El Abuelo', 44);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 4, 'Tierra Fértil', 46);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 5, 'La Tormenta', 48);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (1, 6, 'Nuevos Comienzos', 50);
-- Los Cafeteros T2 (4 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (2, 1, 'El Regreso al Campo', 45);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (2, 2, 'Conflicto de Herencia', 48);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (2, 3, 'La Decisión', 46);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (2, 4, 'Cosecha Final', 52);
-- Medellín Noir T1 (4 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (3, 1, 'El Primer Caso', 50);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (3, 2, 'Pistas en la Oscuridad', 52);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (3, 3, 'El Sospechoso', 49);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (3, 4, 'La Verdad', 55);
-- Medellín Noir T2 (3 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (4, 1, 'Nuevo Enemigo', 53);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (4, 2, 'La Red', 51);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (4, 3, 'Ajuste de Cuentas', 58);
-- Ciberpatrulla T1 (4 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (5, 1, 'El Virus Malvado', 28);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (5, 2, 'Contraseña Secreta', 30);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (5, 3, 'El Hacker del Bien', 29);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (5, 4, 'Misión Completada', 32);
-- Bogotá 2050 T1 (4 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (6, 1, 'La Ciudad Gris', 55);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (6, 2, 'Resistencia', 57);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (6, 3, 'El Algoritmo', 54);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (6, 4, 'Revolución Digital', 60);
-- Risas del Pacífico T1 (4 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (7, 1, 'El Vecino Nuevo', 25);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (7, 2, 'La Fiesta', 24);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (7, 3, 'El Malentendido', 26);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (7, 4, 'Reconciliación', 25);
-- La Clínica T1 (4 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (8, 1, 'Primer Turno', 45);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (8, 2, 'Urgencias', 47);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (8, 3, 'El Diagnóstico', 44);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (8, 4, 'Esperanza', 48);
-- Medellín Noir: El Cartel T1 (3 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (9, 1, 'Los Orígenes', 55);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (9, 2, 'El Ascenso', 57);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (9, 3, 'La Caída', 60);
-- Selva Viva T1 (3 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (10, 1, 'Adentrándose en la Selva', 40);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (10, 2, 'Especies Desconocidas', 42);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (10, 3, 'El Río Sagrado', 38);
-- El Ministerio del Tiempo T1 (3 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (11, 1, 'El Reclutamiento', 50);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (11, 2, 'Independencia en Peligro', 52);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (11, 3, 'La Batalla de Boyacá', 55);
-- Ciberpatrulla NG T1 (3 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (12, 1, 'Nueva Amenaza', 30);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (12, 2, 'El Legado', 28);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (12, 3, 'Unidos Venceremos', 32);
-- Historias de Colombia T1 (3 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (13, 1, 'La Conquista', 45);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (13, 2, 'La Independencia', 47);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (13, 3, 'El Siglo XX', 44);
-- Tech Quindío T1 (3 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (14, 1, 'Startups del Eje Cafetero', 60);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (14, 2, 'Inteligencia Artificial en Colombia', 58);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (14, 3, 'El Futuro del Trabajo', 62);
-- Emprendimiento CO T1 (3 episodios)
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (15, 1, 'De Cero a Empresa', 50);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (15, 2, 'Financiación y Riesgo', 52);
INSERT INTO EPISODIOS (id_temporada, numero, titulo, duracion_min) VALUES (15, 3, 'Escalar el Negocio', 48);

COMMIT;

-- -------------------------
-- 12. USUARIOS (30 usuarios)
-- Planes: 1=BASICO, 2=ESTANDAR, 3=PREMIUM
-- Ciudades: Armenia, Bogotá, Medellín, Cali, Pereira, Manizales
-- -------------------------
-- Moderadores (es_moderador='S')
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Ricardo', 'Montoya', 'r.montoya@gmail.com', '3001112233', TO_DATE('15/03/1985','DD/MM/YYYY'), 'Bogotá', 'ACTIVO', 3, 'S', TO_DATE('01/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Sandra', 'Pedraza', 's.pedraza@gmail.com', '3012223344', TO_DATE('22/07/1990','DD/MM/YYYY'), 'Medellín', 'ACTIVO', 2, 'S', TO_DATE('02/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Hernando', 'Castillo', 'h.castillo@gmail.com', '3023334455', TO_DATE('10/11/1988','DD/MM/YYYY'), 'Cali', 'ACTIVO', 3, 'S', TO_DATE('03/05/2026','DD/MM/YYYY'));
-- Usuarios regulares
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Ana', 'Martínez', 'ana.martinez@gmail.com', '3034445566', TO_DATE('05/06/1995','DD/MM/YYYY'), 'Armenia', 'ACTIVO', 1, 'N', TO_DATE('01/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Pedro', 'López', 'pedro.lopez@gmail.com', '3045556677', TO_DATE('18/09/1992','DD/MM/YYYY'), 'Bogotá', 'ACTIVO', 2, 'N', TO_DATE('30/04/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Claudia', 'Jiménez', 'claudia.jimenez@gmail.com', '3056667788', TO_DATE('25/12/1987','DD/MM/YYYY'), 'Medellín', 'ACTIVO', 3, 'N', TO_DATE('01/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, id_referidor, fecha_ultimo_pago)
VALUES ('Diego', 'Restrepo', 'diego.restrepo@gmail.com', '3067778899', TO_DATE('14/04/1993','DD/MM/YYYY'), 'Cali', 'ACTIVO', 1, 'N', 4, TO_DATE('02/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, id_referidor, fecha_ultimo_pago)
VALUES ('Marcela', 'Sánchez', 'marcela.sanchez@gmail.com', '3078889900', TO_DATE('30/08/1996','DD/MM/YYYY'), 'Pereira', 'ACTIVO', 2, 'N', 5, TO_DATE('03/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Tomás', 'Guerrero', 'tomas.guerrero@gmail.com', '3089990011', TO_DATE('07/02/1991','DD/MM/YYYY'), 'Armenia', 'ACTIVO', 3, 'N', TO_DATE('01/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Isabel', 'Duarte', 'isabel.duarte@gmail.com', '3090001122', TO_DATE('19/05/1994','DD/MM/YYYY'), 'Bogotá', 'ACTIVO', 1, 'N', TO_DATE('28/04/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, id_referidor, fecha_ultimo_pago)
VALUES ('Mauricio', 'Parra', 'mauricio.parra@gmail.com', '3101112233', TO_DATE('03/10/1989','DD/MM/YYYY'), 'Manizales', 'ACTIVO', 2, 'N', 1, TO_DATE('02/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Natalia', 'Cárdenas', 'natalia.cardenas@gmail.com', '3112223344', TO_DATE('11/01/1997','DD/MM/YYYY'), 'Cali', 'ACTIVO', 3, 'N', TO_DATE('01/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Esteban', 'Muñoz', 'esteban.munoz@gmail.com', '3123334455', TO_DATE('28/06/1986','DD/MM/YYYY'), 'Pereira', 'ACTIVO', 1, 'N', TO_DATE('30/04/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, id_referidor, fecha_ultimo_pago)
VALUES ('Viviana', 'Arango', 'viviana.arango@gmail.com', '3134445566', TO_DATE('16/03/1998','DD/MM/YYYY'), 'Armenia', 'ACTIVO', 2, 'N', 9, TO_DATE('03/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Rodrigo', 'Bedoya', 'rodrigo.bedoya@gmail.com', '3145556677', TO_DATE('22/11/1984','DD/MM/YYYY'), 'Bogotá', 'ACTIVO', 3, 'N', TO_DATE('01/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Lina', 'Zapata', 'lina.zapata@gmail.com', '3156667788', TO_DATE('09/07/1993','DD/MM/YYYY'), 'Medellín', 'INACTIVO', 1, 'N', TO_DATE('01/03/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Gustavo', 'Ríos', 'gustavo.rios@gmail.com', '3167778899', TO_DATE('14/04/1990','DD/MM/YYYY'), 'Cali', 'ACTIVO', 2, 'N', TO_DATE('02/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, id_referidor, fecha_ultimo_pago)
VALUES ('Patricia', 'Londoño', 'patricia.londono@gmail.com', '3178889900', TO_DATE('27/09/1995','DD/MM/YYYY'), 'Manizales', 'ACTIVO', 1, 'N', 6, TO_DATE('01/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Álvaro', 'Quintero', 'alvaro.quintero@gmail.com', '3189990011', TO_DATE('05/02/1988','DD/MM/YYYY'), 'Pereira', 'ACTIVO', 3, 'N', TO_DATE('03/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Mónica', 'Salazar', 'monica.salazar@gmail.com', '3190001122', TO_DATE('18/12/1991','DD/MM/YYYY'), 'Armenia', 'ACTIVO', 2, 'N', TO_DATE('30/04/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Hernán', 'Vélez', 'hernan.velez@gmail.com', '3201112233', TO_DATE('31/08/1983','DD/MM/YYYY'), 'Bogotá', 'ACTIVO', 1, 'N', TO_DATE('01/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, id_referidor, fecha_ultimo_pago)
VALUES ('Ximena', 'Castaño', 'ximena.castano@gmail.com', '3212223344', TO_DATE('12/05/1999','DD/MM/YYYY'), 'Medellín', 'ACTIVO', 3, 'N', 12, TO_DATE('02/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Fabio', 'Giraldo', 'fabio.giraldo@gmail.com', '3223334455', TO_DATE('24/01/1987','DD/MM/YYYY'), 'Cali', 'INACTIVO', 2, 'N', TO_DATE('15/02/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Adriana', 'Hoyos', 'adriana.hoyos@gmail.com', '3234445566', TO_DATE('07/10/1994','DD/MM/YYYY'), 'Manizales', 'ACTIVO', 1, 'N', TO_DATE('01/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, id_referidor, fecha_ultimo_pago)
VALUES ('Bernardo', 'Acosta', 'bernardo.acosta@gmail.com', '3245556677', TO_DATE('19/06/1992','DD/MM/YYYY'), 'Pereira', 'ACTIVO', 2, 'N', 19, TO_DATE('03/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Carolina', 'Escobar', 'carolina.escobar@gmail.com', '3256667788', TO_DATE('03/03/1996','DD/MM/YYYY'), 'Armenia', 'ACTIVO', 3, 'N', TO_DATE('01/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Oswaldo', 'Naranjo', 'oswaldo.naranjo@gmail.com', '3267778899', TO_DATE('15/11/1985','DD/MM/YYYY'), 'Bogotá', 'ACTIVO', 1, 'N', TO_DATE('28/04/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, id_referidor, fecha_ultimo_pago)
VALUES ('Esperanza', 'Mora', 'esperanza.mora@gmail.com', '3278889900', TO_DATE('28/07/1993','DD/MM/YYYY'), 'Medellín', 'ACTIVO', 2, 'N', 22, TO_DATE('02/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Ramiro', 'Palacio', 'ramiro.palacio@gmail.com', '3289990011', TO_DATE('11/04/1989','DD/MM/YYYY'), 'Cali', 'ACTIVO', 3, 'N', TO_DATE('01/05/2026','DD/MM/YYYY'));
INSERT INTO USUARIOS (nombre, apellido, email, telefono, fecha_nacimiento, ciudad, estado_cuenta, id_plan, es_moderador, fecha_ultimo_pago)
VALUES ('Gloria', 'Toro', 'gloria.toro@gmail.com', '3290001122', TO_DATE('22/09/1980','DD/MM/YYYY'), 'Manizales', 'ACTIVO', 1, 'N', TO_DATE('03/05/2026','DD/MM/YYYY'));

COMMIT;

-- -------------------------
-- 13. PERFILES (50 perfiles)
-- -------------------------
-- Usuario 1 (PREMIUM, max 5 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (1, 'Ricardo', 'avatar_01.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (1, 'Familia', 'avatar_02.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (1, 'Niños', 'avatar_kids.png', 'INFANTIL');
-- Usuario 2 (ESTANDAR, max 3 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (2, 'Sandra', 'avatar_03.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (2, 'Hijos', 'avatar_kids.png', 'INFANTIL');
-- Usuario 3 (PREMIUM, max 5 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (3, 'Hernando', 'avatar_04.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (3, 'Esposa', 'avatar_05.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (3, 'Junior', 'avatar_kids.png', 'INFANTIL');
-- Usuario 4 (BASICO, max 2 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (4, 'Ana', 'avatar_06.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (4, 'Bebé', 'avatar_kids.png', 'INFANTIL');
-- Usuario 5 (ESTANDAR, max 3 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (5, 'Pedro', 'avatar_07.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (5, 'Pareja', 'avatar_08.png', 'ADULTO');
-- Usuario 6 (PREMIUM, max 5 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (6, 'Claudia', 'avatar_09.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (6, 'Esposo', 'avatar_10.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (6, 'Hija Mayor', 'avatar_11.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (6, 'Hijo Menor', 'avatar_kids.png', 'INFANTIL');
-- Usuario 7 (BASICO, max 2 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (7, 'Diego', 'avatar_12.png', 'ADULTO');
-- Usuario 8 (ESTANDAR, max 3 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (8, 'Marcela', 'avatar_13.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (8, 'Mamá', 'avatar_14.png', 'ADULTO');
-- Usuario 9 (PREMIUM, max 5 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (9, 'Tomás', 'avatar_15.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (9, 'Trabajo', 'avatar_16.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (9, 'Niños', 'avatar_kids.png', 'INFANTIL');
-- Usuario 10 (BASICO, max 2 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (10, 'Isabel', 'avatar_17.png', 'ADULTO');
-- Usuario 11 (ESTANDAR, max 3 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (11, 'Mauricio', 'avatar_18.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (11, 'Esposa', 'avatar_19.png', 'ADULTO');
-- Usuario 12 (PREMIUM, max 5 perfiles)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (12, 'Natalia', 'avatar_20.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (12, 'Novio', 'avatar_21.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (12, 'Pequeños', 'avatar_kids.png', 'INFANTIL');
-- Usuarios 13-20 (un perfil cada uno)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (13, 'Esteban', 'avatar_22.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (14, 'Viviana', 'avatar_23.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (15, 'Rodrigo', 'avatar_24.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (16, 'Lina', 'avatar_25.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (17, 'Gustavo', 'avatar_26.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (18, 'Patricia', 'avatar_27.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (19, 'Álvaro', 'avatar_28.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (20, 'Mónica', 'avatar_29.png', 'ADULTO');
-- Usuarios 21-30 (un perfil cada uno)
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (21, 'Hernán', 'avatar_30.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (22, 'Ximena', 'avatar_31.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (23, 'Fabio', 'avatar_32.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (24, 'Adriana', 'avatar_33.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (25, 'Bernardo', 'avatar_34.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (26, 'Carolina', 'avatar_35.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (27, 'Oswaldo', 'avatar_36.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (28, 'Esperanza', 'avatar_37.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (29, 'Ramiro', 'avatar_38.png', 'ADULTO');
INSERT INTO PERFILES (id_usuario, nombre, avatar, tipo) VALUES (30, 'Gloria', 'avatar_39.png', 'ADULTO');

COMMIT;

-- -------------------------
-- 14. PAGOS (80 pagos, varios meses, algunos fallidos)
-- -------------------------
-- Pagos 2024 (histórico)
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (1, TO_DATE('05/01/2024','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 1, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (2, TO_DATE('05/01/2024','DD/MM/YYYY'), 24900, 'NEQUI', 'EXITOSO', 1, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (3, TO_DATE('05/01/2024','DD/MM/YYYY'), 34900, 'PSE', 'EXITOSO', 1, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (4, TO_DATE('05/01/2024','DD/MM/YYYY'), 14900, 'DAVIPLATA', 'EXITOSO', 1, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (5, TO_DATE('05/01/2024','DD/MM/YYYY'), 24900, 'TARJETA_DEBITO', 'EXITOSO', 1, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (6, TO_DATE('05/01/2024','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 1, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (7, TO_DATE('05/01/2024','DD/MM/YYYY'), 14900, 'NEQUI', 'FALLIDO', 1, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (7, TO_DATE('08/01/2024','DD/MM/YYYY'), 14900, 'NEQUI', 'EXITOSO', 1, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (8, TO_DATE('05/01/2024','DD/MM/YYYY'), 24900, 'PSE', 'EXITOSO', 1, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (9, TO_DATE('05/01/2024','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 1, 2024);
-- Pagos Feb 2024
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (1, TO_DATE('05/02/2024','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 2, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (2, TO_DATE('05/02/2024','DD/MM/YYYY'), 24900, 'NEQUI', 'EXITOSO', 2, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (3, TO_DATE('05/02/2024','DD/MM/YYYY'), 34900, 'PSE', 'EXITOSO', 2, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (10, TO_DATE('05/02/2024','DD/MM/YYYY'), 14900, 'DAVIPLATA', 'EXITOSO', 2, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (11, TO_DATE('05/02/2024','DD/MM/YYYY'), 24900, 'TARJETA_DEBITO', 'EXITOSO', 2, 2024);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (12, TO_DATE('05/02/2024','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 2, 2024);
-- Pagos 2025
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (1, TO_DATE('05/01/2025','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 1, 2025);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (2, TO_DATE('05/01/2025','DD/MM/YYYY'), 24900, 'NEQUI', 'EXITOSO', 1, 2025);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (3, TO_DATE('05/01/2025','DD/MM/YYYY'), 34900, 'PSE', 'EXITOSO', 1, 2025);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (4, TO_DATE('05/01/2025','DD/MM/YYYY'), 14900, 'DAVIPLATA', 'EXITOSO', 1, 2025);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (5, TO_DATE('05/01/2025','DD/MM/YYYY'), 24900, 'TARJETA_DEBITO', 'EXITOSO', 1, 2025);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (13, TO_DATE('05/01/2025','DD/MM/YYYY'), 14900, 'NEQUI', 'EXITOSO', 1, 2025);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (14, TO_DATE('05/01/2025','DD/MM/YYYY'), 24900, 'PSE', 'EXITOSO', 1, 2025);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (15, TO_DATE('05/01/2025','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 1, 2025);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (16, TO_DATE('05/01/2025','DD/MM/YYYY'), 14900, 'DAVIPLATA', 'FALLIDO', 1, 2025);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (17, TO_DATE('05/01/2025','DD/MM/YYYY'), 24900, 'NEQUI', 'EXITOSO', 1, 2025);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (18, TO_DATE('05/01/2025','DD/MM/YYYY'), 14900, 'PSE', 'EXITOSO', 1, 2025);
-- Pagos 2026 (año actual)
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (1, TO_DATE('05/01/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (2, TO_DATE('05/01/2026','DD/MM/YYYY'), 24900, 'NEQUI', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (3, TO_DATE('05/01/2026','DD/MM/YYYY'), 34900, 'PSE', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (4, TO_DATE('05/01/2026','DD/MM/YYYY'), 14900, 'DAVIPLATA', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (5, TO_DATE('05/01/2026','DD/MM/YYYY'), 24900, 'TARJETA_DEBITO', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (6, TO_DATE('05/01/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (7, TO_DATE('05/01/2026','DD/MM/YYYY'), 14900, 'NEQUI', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (8, TO_DATE('05/01/2026','DD/MM/YYYY'), 24900, 'PSE', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (9, TO_DATE('05/01/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (10, TO_DATE('05/01/2026','DD/MM/YYYY'), 14900, 'DAVIPLATA', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (11, TO_DATE('05/01/2026','DD/MM/YYYY'), 24900, 'TARJETA_DEBITO', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (12, TO_DATE('05/01/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (13, TO_DATE('05/01/2026','DD/MM/YYYY'), 14900, 'NEQUI', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (14, TO_DATE('05/01/2026','DD/MM/YYYY'), 24900, 'PSE', 'EXITOSO', 1, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (15, TO_DATE('05/01/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 1, 2026);
-- Pagos Feb-May 2026
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (1, TO_DATE('05/02/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 2, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (2, TO_DATE('05/02/2026','DD/MM/YYYY'), 24900, 'NEQUI', 'EXITOSO', 2, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (3, TO_DATE('05/02/2026','DD/MM/YYYY'), 34900, 'PSE', 'EXITOSO', 2, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (16, TO_DATE('05/02/2026','DD/MM/YYYY'), 14900, 'DAVIPLATA', 'FALLIDO', 2, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (19, TO_DATE('05/02/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 2, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (20, TO_DATE('05/02/2026','DD/MM/YYYY'), 24900, 'NEQUI', 'EXITOSO', 2, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (21, TO_DATE('05/02/2026','DD/MM/YYYY'), 14900, 'PSE', 'EXITOSO', 2, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (22, TO_DATE('05/02/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 2, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (1, TO_DATE('05/03/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 3, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (2, TO_DATE('05/03/2026','DD/MM/YYYY'), 24900, 'NEQUI', 'EXITOSO', 3, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (3, TO_DATE('05/03/2026','DD/MM/YYYY'), 34900, 'PSE', 'EXITOSO', 3, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (6, TO_DATE('05/03/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 3, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (9, TO_DATE('05/03/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 3, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (12, TO_DATE('05/03/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 3, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (25, TO_DATE('05/03/2026','DD/MM/YYYY'), 24900, 'DAVIPLATA', 'EXITOSO', 3, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (26, TO_DATE('05/03/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 3, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (1, TO_DATE('05/04/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 4, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (2, TO_DATE('05/04/2026','DD/MM/YYYY'), 24900, 'NEQUI', 'EXITOSO', 4, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (3, TO_DATE('05/04/2026','DD/MM/YYYY'), 34900, 'PSE', 'EXITOSO', 4, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (4, TO_DATE('05/04/2026','DD/MM/YYYY'), 14900, 'DAVIPLATA', 'EXITOSO', 4, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (5, TO_DATE('05/04/2026','DD/MM/YYYY'), 24900, 'TARJETA_DEBITO', 'EXITOSO', 4, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (23, TO_DATE('05/04/2026','DD/MM/YYYY'), 24900, 'PSE', 'FALLIDO', 4, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (27, TO_DATE('05/04/2026','DD/MM/YYYY'), 14900, 'NEQUI', 'EXITOSO', 4, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (28, TO_DATE('05/04/2026','DD/MM/YYYY'), 24900, 'TARJETA_DEBITO', 'EXITOSO', 4, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (1, TO_DATE('05/05/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 5, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (2, TO_DATE('05/05/2026','DD/MM/YYYY'), 24900, 'NEQUI', 'EXITOSO', 5, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (3, TO_DATE('05/05/2026','DD/MM/YYYY'), 34900, 'PSE', 'EXITOSO', 5, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (29, TO_DATE('05/05/2026','DD/MM/YYYY'), 34900, 'TARJETA_CREDITO', 'EXITOSO', 5, 2026);
INSERT INTO PAGOS (id_usuario, fecha_pago, monto, metodo_pago, estado_pago, periodo_mes, periodo_anio) VALUES (30, TO_DATE('05/05/2026','DD/MM/YYYY'), 14900, 'DAVIPLATA', 'EXITOSO', 5, 2026);

COMMIT;

-- -------------------------
-- 15. REPRODUCCIONES (200 registros distribuidos en 2024, 2025 y 2026)
-- Perfiles IDs aproximados: 1-3=usuario1, 4-5=usuario2, 6-8=usuario3, 9-10=usuario4
-- 11-12=usuario5, 13-16=usuario6, 17=usuario7, 18-19=usuario8, 20-22=usuario9
-- 23=usuario10, 24-25=usuario11, 26-28=usuario12, 29=usuario13, 30=usuario14...
-- -------------------------
-- 2024 reproducciones (partición reprod_2024)
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (1, 1, TO_TIMESTAMP('2024-01-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-01-10 21:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (1, 3, TO_TIMESTAMP('2024-01-15 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-01-15 23:12:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (2, 6, TO_TIMESTAMP('2024-01-20 19:30:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-01-20 21:55:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (3, 13, 1, TO_TIMESTAMP('2024-01-22 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-01-22 18:45:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (3, 13, 2, TO_TIMESTAMP('2024-01-23 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-01-23 18:47:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (4, 2, TO_TIMESTAMP('2024-02-05 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-02-05 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (5, 4, TO_TIMESTAMP('2024-02-10 15:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-02-10 16:28:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (6, 5, TO_TIMESTAMP('2024-02-14 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-02-14 23:35:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (7, 8, TO_TIMESTAMP('2024-02-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-02-20 20:38:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (8, 14, 11, TO_TIMESTAMP('2024-03-01 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-01 21:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (8, 14, 12, TO_TIMESTAMP('2024-03-02 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-02 21:52:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (9, 9, TO_TIMESTAMP('2024-03-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-10 22:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (10, 10, TO_TIMESTAMP('2024-03-15 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-15 20:32:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (11, 23, TO_TIMESTAMP('2024-03-20 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-03-20 19:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (12, 24, TO_TIMESTAMP('2024-04-01 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-04-01 21:15:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (13, 1, TO_TIMESTAMP('2024-04-05 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-04-05 22:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (14, 2, TO_TIMESTAMP('2024-04-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-04-10 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (15, 3, TO_TIMESTAMP('2024-04-15 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-04-15 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 65);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (16, 6, TO_TIMESTAMP('2024-04-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-04-20 21:25:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (17, 11, TO_TIMESTAMP('2024-05-01 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-01 21:55:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (18, 25, TO_TIMESTAMP('2024-05-05 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-05 19:25:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (19, 26, TO_TIMESTAMP('2024-05-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-10 21:08:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (20, 31, TO_TIMESTAMP('2024-05-15 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-15 21:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (21, 32, TO_TIMESTAMP('2024-05-20 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-20 22:05:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (22, 33, TO_TIMESTAMP('2024-06-01 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-06-01 19:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (23, 36, 43, TO_TIMESTAMP('2024-06-05 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-06-05 20:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (24, 37, 46, TO_TIMESTAMP('2024-06-10 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-06-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (25, 1, TO_TIMESTAMP('2024-06-15 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-06-15 22:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (26, 2, TO_TIMESTAMP('2024-06-20 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-06-20 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (27, 9, TO_TIMESTAMP('2024-07-01 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-07-01 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 75);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (28, 10, TO_TIMESTAMP('2024-07-05 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-07-05 20:32:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (29, 23, TO_TIMESTAMP('2024-07-10 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-07-10 19:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (30, 24, TO_TIMESTAMP('2024-07-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-07-15 21:15:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (1, 6, TO_TIMESTAMP('2024-07-20 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-07-20 23:25:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (2, 8, TO_TIMESTAMP('2024-08-01 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-08-01 20:38:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (3, 4, TO_TIMESTAMP('2024-08-05 15:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-08-05 16:28:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (4, 5, TO_TIMESTAMP('2024-08-10 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-08-10 23:35:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (5, 11, TO_TIMESTAMP('2024-08-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-08-15 21:55:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (6, 1, TO_TIMESTAMP('2024-08-20 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-08-20 22:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (7, 2, TO_TIMESTAMP('2024-09-01 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-09-01 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (8, 3, TO_TIMESTAMP('2024-09-05 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-09-05 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 45);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (9, 6, TO_TIMESTAMP('2024-09-10 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-09-10 21:25:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (10, 9, TO_TIMESTAMP('2024-09-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-09-15 22:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (11, 10, TO_TIMESTAMP('2024-09-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-09-20 20:32:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (12, 23, TO_TIMESTAMP('2024-10-01 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-01 19:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (13, 24, TO_TIMESTAMP('2024-10-05 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-05 21:15:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (14, 25, TO_TIMESTAMP('2024-10-10 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-10 19:25:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (15, 26, TO_TIMESTAMP('2024-10-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-15 21:08:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (16, 31, TO_TIMESTAMP('2024-10-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-10-20 21:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (17, 34, TO_TIMESTAMP('2024-11-01 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-11-01 21:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (18, 1, TO_TIMESTAMP('2024-11-05 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-11-05 22:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (19, 2, TO_TIMESTAMP('2024-11-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-11-10 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (20, 3, TO_TIMESTAMP('2024-11-15 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-11-15 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (21, 6, TO_TIMESTAMP('2024-11-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-11-20 21:25:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (22, 9, TO_TIMESTAMP('2024-12-01 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-01 22:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (23, 10, TO_TIMESTAMP('2024-12-05 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-05 20:32:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (24, 11, TO_TIMESTAMP('2024-12-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-10 21:55:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (25, 8, TO_TIMESTAMP('2024-12-15 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-15 20:38:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);

COMMIT;

-- 2025 reproducciones (partición reprod_2025)
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (1, 7, TO_TIMESTAMP('2025-01-05 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-05 22:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (2, 12, TO_TIMESTAMP('2025-01-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-10 22:18:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (3, 15, 18, TO_TIMESTAMP('2025-01-15 16:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-15 16:28:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, id_episodio, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (3, 15, 19, TO_TIMESTAMP('2025-01-16 16:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-16 16:30:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (4, 27, TO_TIMESTAMP('2025-01-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-20 20:12:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (5, 29, TO_TIMESTAMP('2025-01-25 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-01-25 21:50:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (6, 7, TO_TIMESTAMP('2025-02-01 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-02-01 22:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (7, 12, TO_TIMESTAMP('2025-02-05 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-02-05 22:18:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (8, 30, TO_TIMESTAMP('2025-02-10 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-02-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (9, 35, TO_TIMESTAMP('2025-02-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-02-15 21:20:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (10, 1, TO_TIMESTAMP('2025-02-20 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-02-20 22:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (11, 2, TO_TIMESTAMP('2025-03-01 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-01 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (12, 3, TO_TIMESTAMP('2025-03-05 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-05 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (13, 6, TO_TIMESTAMP('2025-03-10 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-10 21:25:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (14, 9, TO_TIMESTAMP('2025-03-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-15 22:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (15, 10, TO_TIMESTAMP('2025-03-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-03-20 20:32:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (16, 23, TO_TIMESTAMP('2025-04-01 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-04-01 19:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (17, 24, TO_TIMESTAMP('2025-04-05 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-04-05 21:15:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (18, 25, TO_TIMESTAMP('2025-04-10 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-04-10 19:25:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (19, 26, TO_TIMESTAMP('2025-04-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-04-15 21:08:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (20, 31, TO_TIMESTAMP('2025-04-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-04-20 21:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (21, 34, TO_TIMESTAMP('2025-05-01 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-01 21:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (22, 1, TO_TIMESTAMP('2025-05-05 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-05 22:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (23, 2, TO_TIMESTAMP('2025-05-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-10 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (24, 3, TO_TIMESTAMP('2025-05-15 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-15 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (25, 6, TO_TIMESTAMP('2025-05-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-05-20 21:25:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (26, 9, TO_TIMESTAMP('2025-06-01 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-06-01 22:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (27, 10, TO_TIMESTAMP('2025-06-05 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-06-05 20:32:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (28, 11, TO_TIMESTAMP('2025-06-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-06-10 21:55:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (29, 8, TO_TIMESTAMP('2025-06-15 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-06-15 20:38:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (30, 7, TO_TIMESTAMP('2025-06-20 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-06-20 22:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (1, 12, TO_TIMESTAMP('2025-07-01 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-07-01 22:18:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (2, 27, TO_TIMESTAMP('2025-07-05 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-07-05 20:12:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (3, 29, TO_TIMESTAMP('2025-07-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-07-10 21:50:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (4, 30, TO_TIMESTAMP('2025-07-15 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-07-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (5, 35, TO_TIMESTAMP('2025-07-20 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-07-20 21:20:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (6, 1, TO_TIMESTAMP('2025-08-01 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-08-01 22:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (7, 2, TO_TIMESTAMP('2025-08-05 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-08-05 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (8, 3, TO_TIMESTAMP('2025-08-10 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-08-10 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (9, 6, TO_TIMESTAMP('2025-08-15 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-08-15 21:25:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (10, 9, TO_TIMESTAMP('2025-08-20 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-08-20 22:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (11, 10, TO_TIMESTAMP('2025-09-01 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-09-01 20:32:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (12, 23, TO_TIMESTAMP('2025-09-05 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-09-05 19:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (13, 24, TO_TIMESTAMP('2025-09-10 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-09-10 21:15:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (14, 25, TO_TIMESTAMP('2025-09-15 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-09-15 19:25:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (15, 26, TO_TIMESTAMP('2025-09-20 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-09-20 21:08:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (16, 31, TO_TIMESTAMP('2025-10-01 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-10-01 21:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (17, 34, TO_TIMESTAMP('2025-10-05 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-10-05 21:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (18, 1, TO_TIMESTAMP('2025-10-10 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-10-10 22:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (19, 2, TO_TIMESTAMP('2025-10-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-10-15 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (20, 3, TO_TIMESTAMP('2025-10-20 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-10-20 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (21, 6, TO_TIMESTAMP('2025-11-01 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-01 21:25:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (22, 9, TO_TIMESTAMP('2025-11-05 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-05 22:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (23, 10, TO_TIMESTAMP('2025-11-10 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-10 20:32:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (24, 11, TO_TIMESTAMP('2025-11-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-15 21:55:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (25, 8, TO_TIMESTAMP('2025-11-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-20 20:38:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (26, 7, TO_TIMESTAMP('2025-12-01 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-12-01 22:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (27, 12, TO_TIMESTAMP('2025-12-05 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-12-05 22:18:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (28, 27, TO_TIMESTAMP('2025-12-10 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-12-10 20:12:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (29, 29, TO_TIMESTAMP('2025-12-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-12-15 21:50:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (30, 30, TO_TIMESTAMP('2025-12-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-12-20 20:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);

COMMIT;