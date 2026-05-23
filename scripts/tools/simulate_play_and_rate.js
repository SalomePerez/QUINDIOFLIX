const http = require('http');

function request(options, body) {
  return new Promise((resolve, reject) => {
    const req = http.request(options, res => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try { resolve({ status: res.statusCode, body: data, headers: res.headers }); }
        catch (e) { reject(e); }
      });
    });
    req.on('error', reject);
    if (body) req.write(body);
    req.end();
  });
}

(async () => {
  try {
    // 1) Iniciar reproducción
    const playData = JSON.stringify({ id_perfil: 1, id_contenido: 63, dispositivo: 'TV' });
    let res = await request({ hostname: 'localhost', port: 3001, path: '/api/reproducciones', method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(playData), 'x-user-id': '1' } }, playData);
    console.log('INICIAR REPRODUCCION ->', res.status, res.body);
    const playJson = JSON.parse(res.body || '{}');
    const idReprod = (playJson.id_reproduccion || (playJson.id_reproduccion === 0 ? 0 : null)) || (playJson.id_reproduccion === undefined ? (playJson.id_reproduccion) : playJson.id_reproduccion);
    // Some endpoints return different keys; also check outBinds from direct DB call
    if (!idReprod && !/\d+/.test(res.body)) {
      // try to extract numeric id from body
      const m = res.body.match(/id_reproduccion"?:?\s*"?(\d+)"?/);
      if (m) {
        console.log('Parsed id_reproduccion from body:', m[1]);
        idReprod = Number(m[1]);
      }
    }

    // If body had outBinds form (node helper), try parse JSON anyway
    let createdId = null;
    try {
      const parsed = JSON.parse(res.body);
      if (parsed.id_reproduccion) createdId = parsed.id_reproduccion;
      if (parsed.id && parsed.id.id) createdId = parsed.id.id;
    } catch (e) { /* ignore */ }
    const finalId = createdId || idReprod || null;

    if (!finalId) {
      console.warn('No se obtuvo id_reproduccion; saliendo.');
      return;
    }

    // 2) Actualizar progreso a 100%
    const progData = JSON.stringify({ porcentaje_avance: 100, finalizar: true });
    res = await request({ hostname: 'localhost', port: 3001, path: `/api/reproducciones/${finalId}`, method: 'PUT', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(progData), 'x-user-id': '1' } }, progData);
    console.log('ACTUALIZAR PROGRESO ->', res.status, res.body);

    // 3) Intentar calificar
    const calData = JSON.stringify({ id_perfil: 1, estrellas: 5, resena: 'Prueba automática: excelente' });
    res = await request({ hostname: 'localhost', port: 3001, path: '/api/contenido/63/calificar', method: 'POST', headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(calData), 'x-user-id': '1' } }, calData);
    console.log('CALIFICAR ->', res.status, res.body);

  } catch (err) {
    console.error('ERROR:', err);
  }
})();
