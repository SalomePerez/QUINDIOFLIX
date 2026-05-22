const db = require('./src/config/database');
(async () => {
  await new Promise(r => setTimeout(r, 1000));
  try {
    const sql = `SELECT u.ciudad,
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
       ORDER BY u.ciudad, pa.periodo_mes, pl.nombre`;
    const res = await db.execute(sql, [2026]);
    console.log('ok rows', res.rows.length);
  } catch (err) {
    console.error('ERR', err);
  } finally {
    process.exit(0);
  }
})();
