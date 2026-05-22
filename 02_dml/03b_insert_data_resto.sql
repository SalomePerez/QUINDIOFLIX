-- =============================================================================
-- QUINDIOFLIX — Datos de Prueba (continuación)
-- Reproducciones 2026 + Calificaciones + Favoritos + Reportes + Historial
-- =============================================================================

-- 2026 reproducciones (partición reprod_2026)
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (1, 6, TO_TIMESTAMP('2026-01-05 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-01-05 23:25:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (2, 7, TO_TIMESTAMP('2026-01-08 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-01-08 21:50:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (3, 12, TO_TIMESTAMP('2026-01-10 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-01-10 21:18:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (4, 2, TO_TIMESTAMP('2026-01-12 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-01-12 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (5, 3, TO_TIMESTAMP('2026-01-15 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-01-15 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (6, 9, TO_TIMESTAMP('2026-01-18 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-01-18 22:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (7, 10, TO_TIMESTAMP('2026-01-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-01-20 20:32:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (8, 11, TO_TIMESTAMP('2026-01-22 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-01-22 21:55:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (9, 23, TO_TIMESTAMP('2026-01-25 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-01-25 19:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (10, 24, TO_TIMESTAMP('2026-01-28 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-01-28 21:15:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (11, 1, TO_TIMESTAMP('2026-02-02 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-02-02 22:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (12, 6, TO_TIMESTAMP('2026-02-05 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-02-05 21:25:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (13, 7, TO_TIMESTAMP('2026-02-08 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-02-08 22:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (14, 8, TO_TIMESTAMP('2026-02-10 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-02-10 20:38:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (15, 2, TO_TIMESTAMP('2026-02-12 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-02-12 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (16, 3, TO_TIMESTAMP('2026-02-15 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-02-15 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 55);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (17, 25, TO_TIMESTAMP('2026-02-18 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-02-18 19:25:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (18, 26, TO_TIMESTAMP('2026-02-20 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-02-20 21:08:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (19, 31, TO_TIMESTAMP('2026-02-22 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-02-22 21:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (20, 34, TO_TIMESTAMP('2026-02-25 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-02-25 21:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (21, 9, TO_TIMESTAMP('2026-03-01 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-03-01 22:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (22, 10, TO_TIMESTAMP('2026-03-03 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-03-03 20:32:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (23, 11, TO_TIMESTAMP('2026-03-05 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-03-05 21:55:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (24, 1, TO_TIMESTAMP('2026-03-08 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-03-08 22:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (25, 6, TO_TIMESTAMP('2026-03-10 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-03-10 21:25:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (26, 7, TO_TIMESTAMP('2026-03-12 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-03-12 22:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (27, 12, TO_TIMESTAMP('2026-03-15 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-03-15 22:18:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (28, 27, TO_TIMESTAMP('2026-03-18 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-03-18 20:12:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (29, 30, TO_TIMESTAMP('2026-03-20 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-03-20 20:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (30, 35, TO_TIMESTAMP('2026-03-22 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-03-22 21:20:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (1, 3, TO_TIMESTAMP('2026-04-01 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-01 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (2, 9, TO_TIMESTAMP('2026-04-03 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-03 22:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (3, 4, TO_TIMESTAMP('2026-04-05 15:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-05 16:28:00','YYYY-MM-DD HH24:MI:SS'), 'TABLET', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (4, 5, TO_TIMESTAMP('2026-04-08 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-08 23:35:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (5, 8, TO_TIMESTAMP('2026-04-10 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-10 20:38:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (6, 2, TO_TIMESTAMP('2026-04-12 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-12 21:45:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (7, 23, TO_TIMESTAMP('2026-04-15 18:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-15 19:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (8, 24, TO_TIMESTAMP('2026-04-18 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-18 21:15:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (9, 1, TO_TIMESTAMP('2026-04-20 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-20 22:58:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (10, 6, TO_TIMESTAMP('2026-04-22 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-22 21:25:00','YYYY-MM-DD HH24:MI:SS'), 'COMPUTADOR', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (11, 7, TO_TIMESTAMP('2026-04-25 21:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-25 22:50:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (12, 12, TO_TIMESTAMP('2026-04-28 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-04-28 22:18:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (13, 3, TO_TIMESTAMP('2026-05-01 22:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-05-01 23:30:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (14, 9, TO_TIMESTAMP('2026-05-03 20:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-05-03 22:00:00','YYYY-MM-DD HH24:MI:SS'), 'TV', 100);
INSERT INTO REPRODUCCIONES (id_perfil, id_contenido, fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance) VALUES (15, 10, TO_TIMESTAMP('2026-05-05 19:00:00','YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2026-05-05 20:32:00','YYYY-MM-DD HH24:MI:SS'), 'CELULAR', 100);

COMMIT;

-- -------------------------
-- 16. CALIFICACIONES (60 registros)
-- Solo perfiles que hayan reproducido >= 50% del contenido
-- -------------------------
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (1, 1, 5, 'Excelente película, muy emocionante de principio a fin.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (1, 3, 5, 'La mejor película de acción colombiana que he visto.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (1, 6, 4, 'Muy buena ciencia ficción, efectos visuales impresionantes.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (2, 6, 5, 'Galaxia Perdida es una obra maestra del género.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (2, 8, 4, 'Cumbia Eterna me hizo llorar. Hermosa historia.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (3, 4, 5, 'Perfecta para ver con los niños. Los personajes son adorables.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (4, 2, 4, 'Amor en Cartagena es muy romántica, me encantó la ciudad.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (5, 4, 5, NULL);
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (5, 11, 3, 'Buena pero le faltó más desarrollo de personajes.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (6, 5, 2, 'Demasiado violenta para mi gusto, no la recomiendo.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (6, 1, 5, 'Increíble. La vi dos veces y sigue emocionando.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (7, 8, 5, 'Cumbia Eterna es una joya del cine colombiano.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (7, 2, 4, NULL);
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (8, 3, 3, 'Entretenida pero predecible en algunos momentos.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (9, 6, 5, 'La mejor producción original de QuindioFlix hasta ahora.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (9, 9, 4, 'Código Rojo es muy tensa, no pude parar de verla.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (10, 1, 4, NULL);
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (10, 9, 5, 'Thriller tecnológico muy bien logrado.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (11, 23, 5, 'Colombia Salvaje es impresionante. Qué biodiversidad.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (11, 10, 4, 'La Fiesta del Pueblo me hizo reír mucho.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (12, 24, 5, 'El Café Nuestro me enseñó mucho sobre nuestra cultura.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (12, 23, 4, NULL);
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (13, 1, 5, 'Acción pura. La recomiendo a todos.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (13, 24, 4, 'Muy informativo y bien producido.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (14, 2, 5, 'Amor en Cartagena es perfecta para una noche romántica.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (14, 25, 4, 'Ríos de Vida me hizo reflexionar sobre el medio ambiente.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (15, 26, 5, 'Cumbia: Raíces y Ritmo es un documental imprescindible.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (16, 6, 4, NULL);
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (16, 31, 5, 'El Concierto Vallenato en Vivo es una experiencia única.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (17, 11, 3, 'Abismo es tensa pero el final me decepcionó un poco.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (17, 34, 5, 'La Salsa Caleña en Vivo es pura energía. Espectacular.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (18, 1, 5, NULL);
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (18, 25, 3, 'Interesante pero un poco lento en algunos momentos.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (19, 2, 4, 'Muy bonita historia de amor ambientada en Colombia.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (19, 26, 5, 'Excelente documental sobre la cumbia colombiana.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (20, 3, 5, 'La Sombra del Cóndor es adrenalina pura.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (20, 31, 4, NULL);
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (21, 6, 5, 'Galaxia Perdida superó todas mis expectativas.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (21, 34, 5, 'La mejor noche de salsa que he visto en pantalla.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (22, 9, 4, 'Código Rojo es muy actual y relevante.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (22, 33, 5, 'La Trova Paisa es un tesoro cultural.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (23, 10, 5, 'La Fiesta del Pueblo es comedia colombiana en su mejor forma.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (24, 11, 4, NULL);
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (24, 3, 5, 'Acción y suspenso perfectamente combinados.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (25, 1, 5, 'El Último Vuelo es de las mejores películas del catálogo.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (25, 8, 4, 'Cumbia Eterna es emotiva y bien actuada.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (26, 2, 3, 'Bonita pero un poco lenta para mi gusto.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (26, 9, 5, NULL);
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (27, 10, 4, 'Muy divertida, la vi con toda la familia.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (27, 9, 4, 'Código Rojo es muy entretenida.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (28, 10, 5, 'La Fiesta del Pueblo es puro humor colombiano.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (28, 27, 5, 'Mujeres que Construyen es inspirador y necesario.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (29, 23, 5, 'Colombia Salvaje debería verse en todas las escuelas.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (29, 29, 4, 'La Paz Posible es un documental muy importante.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (30, 24, 5, 'El Café Nuestro es orgullo colombiano.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (30, 30, 4, NULL);
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (1, 7, 5, 'El Regreso supera a la primera película. Increíble.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (2, 12, 4, 'Galaxia Perdida: El Origen explica muy bien los orígenes.');
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (6, 7, 5, NULL);
INSERT INTO CALIFICACIONES (id_perfil, id_contenido, estrellas, resena) VALUES (9, 35, 4, 'Indie Colombia 2024 tiene artistas muy talentosos.');

COMMIT;

-- -------------------------
-- 17. FAVORITOS (40 registros)
-- -------------------------
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (1, 1);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (1, 3);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (1, 6);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (1, 7);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (2, 6);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (2, 12);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (2, 8);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (3, 4);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (3, 15);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (4, 2);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (5, 4);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (5, 11);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (6, 1);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (6, 5);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (7, 8);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (8, 14);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (9, 6);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (9, 9);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (10, 1);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (11, 23);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (11, 24);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (12, 24);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (12, 13);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (13, 1);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (14, 2);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (15, 26);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (16, 31);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (17, 34);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (18, 1);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (19, 2);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (20, 3);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (21, 6);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (22, 9);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (23, 10);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (24, 11);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (25, 8);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (26, 7);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (27, 12);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (28, 27);
INSERT INTO FAVORITOS (id_perfil, id_contenido) VALUES (29, 23);

COMMIT;

-- -------------------------
-- 18. REPORTES (15 registros)
-- id_moderador: usuarios 1, 2, 3 son moderadores
-- -------------------------
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (10, 5, 'Contenido inapropiado', 'La película contiene escenas de violencia extrema sin advertencia adecuada.', 'RESUELTO', 1, TO_DATE('15/01/2026','DD/MM/YYYY'), 'Revisado. La clasificación +18 es correcta y visible. Reporte cerrado.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (16, 14, 'Lenguaje ofensivo', 'Uso excesivo de lenguaje soez sin clasificación adecuada.', 'RESUELTO', 2, TO_DATE('20/01/2026','DD/MM/YYYY'), 'La serie tiene clasificación +18. El lenguaje es acorde al contenido. Reporte rechazado.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (23, 19, 'Contenido inapropiado', 'Escenas de violencia que no corresponden a la clasificación indicada.', 'RESUELTO', 3, TO_DATE('25/01/2026','DD/MM/YYYY'), 'Se revisó el contenido. La clasificación +18 es correcta. Reporte cerrado.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (27, 9, 'Información incorrecta', 'La sinopsis no corresponde al contenido real de la película.', 'EN_REVISION');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (13, 5, 'Contenido inapropiado', 'Escenas perturbadoras sin advertencia previa suficiente.', 'PENDIENTE');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (4, 16, 'Contenido para adultos', 'El contenido parece más apropiado para +18 que para +16.', 'RESUELTO', 1, TO_DATE('01/02/2026','DD/MM/YYYY'), 'Revisado por el equipo de contenido. La clasificación +16 es adecuada.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (18, 29, 'Información incorrecta', 'El documental presenta información desactualizada sobre el proceso de paz.', 'RECHAZADO', 2, TO_DATE('05/02/2026','DD/MM/YYYY'), 'El documental fue producido en 2022 y refleja el estado del proceso en esa fecha. No requiere modificación.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (25, 14, 'Contenido inapropiado', 'Escenas de violencia muy explícitas.', 'PENDIENTE');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (30, 5, 'Contenido inapropiado', 'Terror demasiado intenso, debería ser +18.', 'RESUELTO', 3, TO_DATE('10/02/2026','DD/MM/YYYY'), 'La clasificación +18 ya está asignada. Reporte duplicado, cerrado.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (7, 19, 'Lenguaje ofensivo', 'Demasiadas groserías en los primeros episodios.', 'EN_REVISION');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (11, 32, 'Contenido inapropiado', 'La música tiene letras con contenido adulto sin advertencia.', 'RESUELTO', 1, TO_DATE('15/02/2026','DD/MM/YYYY'), 'Se actualizó la clasificación a +13. Gracias por el reporte.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (20, 16, 'Información incorrecta', 'La descripción de la serie no menciona el contenido político.', 'PENDIENTE');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (15, 9, 'Contenido inapropiado', 'Escenas de hackeo que podrían ser usadas como tutorial.', 'RECHAZADO', 2, TO_DATE('20/02/2026','DD/MM/YYYY'), 'El contenido es ficción y no constituye un tutorial real. Reporte rechazado.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (22, 5, 'Contenido inapropiado', 'Muy perturbador para ver en familia.', 'PENDIENTE');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (29, 14, 'Lenguaje ofensivo', 'Lenguaje muy fuerte en todos los episodios.', 'RESUELTO', 3, TO_DATE('01/03/2026','DD/MM/YYYY'), 'Serie clasificada +18. El lenguaje es coherente con la clasificación. Reporte cerrado.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (1, 4, 'Descripción incorrecta', 'La sinopsis no coincide con el contenido mostrado.', 'EN_REVISION');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (2, 6, 'Contenido inapropiado', 'Escenas de violencia sin advertencia adecuada.', 'PENDIENTE');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (3, 7, 'Lenguaje ofensivo', 'Uso excesivo de malas palabras en escena.', 'RESUELTO', 1, TO_DATE('05/03/2026','DD/MM/YYYY'), 'Contenido clasificado +16 es válido para el lenguaje empleado.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (5, 18, 'Información incorrecta', 'El documental no respeta la fecha indicada en la sinopsis.', 'EN_REVISION');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (6, 23, 'Contenido inapropiado', 'No debería estar disponible para menores.', 'PENDIENTE');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (8, 25, 'Contenido inapropiado', 'Demasiado explícito para clasificación actual.', 'RECHAZADO', 2, TO_DATE('10/03/2026','DD/MM/YYYY'), 'La clasificación es correcta; el contenido es ficción.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (9, 14, 'Lenguaje ofensivo', 'Uso de insultos en más del 50% de los episodios.', 'EN_REVISION');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (12, 11, 'Información incorrecta', 'El título no coincide con la sinopsis.', 'PENDIENTE');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (14, 19, 'Contenido inapropiado', 'El tema de violencia es demasiado explícito para menores.', 'RESUELTO', 3, TO_DATE('15/03/2026','DD/MM/YYYY'), 'Clasificación +18 es adecuada. Reporte cerrado.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (17, 30, 'Información incorrecta', 'El documental presenta datos descontextualizados.', 'EN_REVISION');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (19, 32, 'Contenido inapropiado', 'El podcast tiene lenguaje soez sin clasificación.', 'RESUELTO', 1, TO_DATE('20/03/2026','DD/MM/YYYY'), 'Se evaluó y no requiere cambio de clasificación.');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (21, 27, 'Contenido inapropiado', 'Contenido demasiado explícito para menores.', 'PENDIENTE');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado)
VALUES (24, 13, 'Información incorrecta', 'La descripción no incluye la temática principal.', 'EN_REVISION');
INSERT INTO REPORTES (id_perfil, id_contenido, motivo, descripcion, estado, id_moderador, fecha_resolucion, resolucion_nota)
VALUES (26, 1, 'Descripción incorrecta', 'Se corrigió la sinopsis para mayor precisión.', 'RESUELTO', 2, TO_DATE('25/03/2026','DD/MM/YYYY'), 'Sinopsis actualizada. Reporte cerrado.');

COMMIT;

-- -------------------------
-- 19. HISTORIAL_PLANES (10 cambios de plan)
-- -------------------------
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (4, 2, 1, TO_DATE('15/03/2025','DD/MM/YYYY'), 'Reducción de costos personales');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (8, 1, 2, TO_DATE('01/04/2025','DD/MM/YYYY'), 'Necesito más perfiles para la familia');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (13, 2, 1, TO_DATE('10/05/2025','DD/MM/YYYY'), 'Cambio por economía');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (17, 1, 2, TO_DATE('20/06/2025','DD/MM/YYYY'), 'Quiero calidad HD');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (22, 2, 3, TO_DATE('01/07/2025','DD/MM/YYYY'), 'Upgrade a Premium por promoción');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (25, 1, 2, TO_DATE('15/08/2025','DD/MM/YYYY'), 'Más pantallas para el hogar');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (10, 1, 2, TO_DATE('01/09/2025','DD/MM/YYYY'), 'Upgrade por descuento de referido');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (27, 2, 1, TO_DATE('10/10/2025','DD/MM/YYYY'), 'Downgrade temporal');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (30, 2, 1, TO_DATE('01/11/2025','DD/MM/YYYY'), 'Ajuste de presupuesto');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (19, 2, 3, TO_DATE('01/12/2025','DD/MM/YYYY'), 'Upgrade a Premium por Black Friday');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (1, 1, 3, TO_DATE('05/01/2025','DD/MM/YYYY'), 'Más calidad para ver en familia');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (2, 2, 5, TO_DATE('10/01/2025','DD/MM/YYYY'), 'Cambio a plan empresarial para equipo de trabajo');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (3, 3, 4, TO_DATE('20/01/2025','DD/MM/YYYY'), 'Necesitaba más pantallas para invitados');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (5, 1, 2, TO_DATE('01/02/2025','DD/MM/YYYY'), 'Upgrade para ver en HD');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (6, 2, 4, TO_DATE('15/02/2025','DD/MM/YYYY'), 'Mejor calidad de video');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (7, 4, 5, TO_DATE('01/03/2025','DD/MM/YYYY'), 'Plan corporativo para equipo');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (9, 1, 4, TO_DATE('10/03/2025','DD/MM/YYYY'), 'Planeo ver más contenido 4K');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (11, 3, 5, TO_DATE('20/03/2025','DD/MM/YYYY'), 'Necesito más cuentas para la familia');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (12, 2, 1, TO_DATE('01/04/2025','DD/MM/YYYY'), 'Reducción temporal de costo');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (14, 1, 2, TO_DATE('10/04/2025','DD/MM/YYYY'), 'Promoción de familia');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (15, 2, 3, TO_DATE('20/04/2025','DD/MM/YYYY'), 'Subida a Premium por uso frecuente');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (18, 1, 3, TO_DATE('01/05/2025','DD/MM/YYYY'), 'Mejor experiencia para ver series');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (21, 3, 4, TO_DATE('10/05/2025','DD/MM/YYYY'), 'Necesitaba más pantallas simultáneas');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (24, 2, 3, TO_DATE('20/05/2025','DD/MM/YYYY'), 'Mayor calidad de reproducción');
INSERT INTO HISTORIAL_PLANES (id_usuario, id_plan_ant, id_plan_nuevo, fecha_cambio, motivo)
VALUES (28, 1, 2, TO_DATE('01/06/2025','DD/MM/YYYY'), 'Cambio para compartir con la familia');

COMMIT;




SELECT 'PLANES' AS tabla, COUNT(*) AS registros FROM PLANES
UNION ALL
SELECT 'CATEGORIAS', COUNT(*) FROM CATEGORIAS
UNION ALL
SELECT 'GENEROS', COUNT(*) FROM GENEROS
UNION ALL
SELECT 'USUARIOS', COUNT(*) FROM USUARIOS
UNION ALL
SELECT 'CONTENIDO', COUNT(*) FROM CONTENIDO
UNION ALL
SELECT 'PERFILES', COUNT(*) FROM PERFILES
UNION ALL
SELECT 'REPRODUCCIONES', COUNT(*) FROM REPRODUCCIONES
UNION ALL
SELECT 'PAGOS', COUNT(*) FROM PAGOS;


SELECT email, nombre, apellido, es_moderador 
FROM USUARIOS 
WHERE ROWNUM <= 5
ORDER BY id_usuario;