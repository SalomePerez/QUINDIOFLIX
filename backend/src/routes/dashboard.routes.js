const express = require('express');
const router  = express.Router();
const db      = require('../config/database');
const { authMiddleware } = require('../middleware/auth.middleware');
const { moderadorMiddleware } = require('../middleware/moderador.middleware');

function handleDashboardError(err, res, next, viewName) {
  if (err.message && err.message.includes('ORA-00942')) {
    return res.status(500).json({
      error: `No se encontró la vista materializada ${viewName}. Ejecuta 03_nucleo1_consultas/07_vistas_materializadas.sql y vuelve a intentar.`
    });
  }
  next(err);
}

router.use(authMiddleware, moderadorMiddleware);

// GET /api/dashboard/popular — top contenido más popular
router.get('/popular', async (_req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT c.titulo,
              cat.nombre AS categoria,
              c.tipo,
              COUNT(r.id_reproduccion) AS total_reproducciones,
              ROUND(NVL(AVG(cal.estrellas), 0), 2) AS calificacion_promedio,
              COUNT(f.id_contenido) AS veces_en_favoritos,
              c.es_original
       FROM CONTENIDO c
       LEFT JOIN CATEGORIAS cat ON c.id_categoria = cat.id_categoria
       LEFT JOIN REPRODUCCIONES r ON r.id_contenido = c.id_contenido
       LEFT JOIN CALIFICACIONES cal ON cal.id_contenido = c.id_contenido
       LEFT JOIN FAVORITOS f ON f.id_contenido = c.id_contenido
       GROUP BY c.titulo, cat.nombre, c.tipo, c.es_original
       ORDER BY COUNT(r.id_reproduccion) DESC, ROUND(NVL(AVG(cal.estrellas), 0), 2) DESC
       FETCH FIRST 10 ROWS ONLY`
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// GET /api/dashboard/ingresos — ingresos mensuales
router.get('/ingresos', authMiddleware, async (req, res, next) => {
  const { anio = new Date().getFullYear() } = req.query;
  try {
    const result = await db.execute(
      `SELECT u.ciudad,
              pl.nombre AS plan,
              pa.periodo_mes AS mes,
              CASE pa.periodo_mes
                WHEN 1 THEN 'ENERO'
                WHEN 2 THEN 'FEBRERO'
                WHEN 3 THEN 'MARZO'
                WHEN 4 THEN 'ABRIL'
                WHEN 5 THEN 'MAYO'
                WHEN 6 THEN 'JUNIO'
                WHEN 7 THEN 'JULIO'
                WHEN 8 THEN 'AGOSTO'
                WHEN 9 THEN 'SEPTIEMBRE'
                WHEN 10 THEN 'OCTUBRE'
                WHEN 11 THEN 'NOVIEMBRE'
                WHEN 12 THEN 'DICIEMBRE'
                ELSE 'DESCONOCIDO'
              END AS nombre_mes,
              SUM(CASE WHEN pa.estado_pago='EXITOSO' THEN pa.monto ELSE 0 END) AS ingresos_netos,
              SUM(CASE WHEN pa.estado_pago='EXITOSO' THEN 1 ELSE 0 END) AS pagos_exitosos,
              SUM(CASE WHEN pa.estado_pago='FALLIDO' THEN 1 ELSE 0 END) AS pagos_fallidos,
              CASE WHEN SUM(CASE WHEN pa.estado_pago='EXITOSO' THEN 1 ELSE 0 END) = 0 THEN 0
                   ELSE ROUND(SUM(CASE WHEN pa.estado_pago='EXITOSO' THEN pa.monto ELSE 0 END) /
                              SUM(CASE WHEN pa.estado_pago='EXITOSO' THEN 1 ELSE 0 END), 2)
              END AS ticket_promedio
       FROM PAGOS pa
       JOIN USUARIOS u ON pa.id_usuario = u.id_usuario
       JOIN PLANES pl ON u.id_plan = pl.id_plan
       WHERE pa.periodo_anio = :a
       GROUP BY u.ciudad, pl.nombre, pa.periodo_mes
       ORDER BY u.ciudad, pa.periodo_mes, pl.nombre`,
      [Number(anio)]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// GET /api/dashboard/reproducciones-por-dispositivo — PIVOT dispositivos
router.get('/reproducciones-por-dispositivo', authMiddleware, async (_req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT categoria,
              NVL(CELULAR_REPRODUCCIONES, 0)    AS celular,
              NVL(TABLET_REPRODUCCIONES, 0)     AS tablet,
              NVL(TV_REPRODUCCIONES, 0)         AS tv,
              NVL(COMPUTADOR_REPRODUCCIONES, 0) AS computador
       FROM (
         SELECT cat.nombre AS categoria, r.dispositivo
         FROM REPRODUCCIONES r
         JOIN CONTENIDO  c   ON r.id_contenido=c.id_contenido
         JOIN CATEGORIAS cat ON c.id_categoria=cat.id_categoria
       )
       PIVOT (COUNT(*) AS reproducciones FOR dispositivo IN (
         'CELULAR' AS CELULAR, 'TABLET' AS TABLET,
         'TV' AS TV, 'COMPUTADOR' AS COMPUTADOR
       ))
       ORDER BY categoria`
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// GET /api/dashboard/usuarios-por-ciudad — usuarios activos por ciudad y plan
router.get('/usuarios-por-ciudad', authMiddleware, async (_req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT ciudad,
              NVL(BASICO_USUARIOS, 0)   AS basico,
              NVL(ESTANDAR_USUARIOS, 0) AS estandar,
              NVL(PREMIUM_USUARIOS, 0)  AS premium
       FROM (
         SELECT u.ciudad, pl.nombre AS plan
         FROM USUARIOS u JOIN PLANES pl ON u.id_plan=pl.id_plan
         WHERE u.estado_cuenta='ACTIVO'
       )
       PIVOT (COUNT(*) AS usuarios FOR plan IN (
         'BASICO' AS BASICO, 'ESTANDAR' AS ESTANDAR, 'PREMIUM' AS PREMIUM
       ))
       ORDER BY ciudad`
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// GET /api/dashboard/stats — estadísticas generales
router.get('/stats', async (_req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT
         (SELECT COUNT(*) FROM USUARIOS WHERE estado_cuenta='ACTIVO')   AS usuarios_activos,
         (SELECT COUNT(*) FROM CONTENIDO)                                AS total_contenido,
         (SELECT COUNT(*) FROM REPRODUCCIONES)                          AS total_reproducciones,
         (SELECT SUM(monto) FROM PAGOS WHERE estado_pago='EXITOSO'
          AND periodo_anio=EXTRACT(YEAR FROM SYSDATE)
          AND periodo_mes=EXTRACT(MONTH FROM SYSDATE))                  AS ingresos_mes_actual,
         (SELECT COUNT(*) FROM REPORTES WHERE estado='PENDIENTE')       AS reportes_pendientes,
         (SELECT ROUND(AVG(estrellas),2) FROM CALIFICACIONES)           AS calificacion_global
       FROM DUAL`
    );
    res.json(result.rows[0]);
  } catch (err) { next(err); }
});

// GET /api/dashboard/rendimiento-empleados
router.get('/rendimiento-empleados', authMiddleware, async (_req, res, next) => {
  try {
    const result = await db.execute(
      `SELECT e.nombre||' '||e.apellido AS empleado, d.nombre AS departamento,
              COUNT(c.id_contenido) AS contenido_publicado,
              (SELECT COUNT(*) FROM REPORTES r
               JOIN PERFILES p ON r.id_perfil=p.id_perfil
               JOIN USUARIOS u ON p.id_usuario=u.id_usuario
               WHERE u.es_moderador='S'
                 AND r.id_moderador=(SELECT id_usuario FROM USUARIOS WHERE email=e.email AND ROWNUM=1)
                 AND r.estado IN ('RESUELTO','RECHAZADO')) AS reportes_resueltos
       FROM EMPLEADOS e
       JOIN DEPARTAMENTOS d ON e.id_departamento=d.id_departamento
       LEFT JOIN CONTENIDO c ON e.id_empleado=c.id_empleado_resp
       WHERE e.activo='S'
       GROUP BY e.id_empleado, e.nombre, e.apellido, d.nombre, e.email
       ORDER BY contenido_publicado DESC`
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

module.exports = router;

