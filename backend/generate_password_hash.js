// Script para generar hash de contraseña
// Uso: node generate_password_hash.js <contraseña>

const bcrypt = require('bcryptjs');

const password = process.argv[2] || 'password123';
const hash = bcrypt.hashSync(password, 10);

console.log('\n===========================================');
console.log('Contraseña:', password);
console.log('Hash bcrypt:', hash);
console.log('===========================================\n');
console.log('Para actualizar usuarios existentes, ejecuta en SQL:');
console.log(`UPDATE USUARIOS SET password_hash = '${hash}' WHERE password_hash IS NULL;`);
console.log('COMMIT;');
console.log('\n');
