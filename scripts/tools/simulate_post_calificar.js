const http = require('http');
const data = JSON.stringify({ id_perfil: 1, estrellas: 5, resena: 'Prueba Node' });
const options = {
  hostname: 'localhost',
  port: 3001,
  path: '/api/contenido/63/calificar',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(data),
    'x-user-id': '1'
  }
};
const req = http.request(options, res => {
  console.log('status', res.statusCode);
  let body = '';
  res.on('data', d => body += d);
  res.on('end', () => console.log('body', body));
});
req.on('error', e => console.error('error', e));
req.write(data);
req.end();
