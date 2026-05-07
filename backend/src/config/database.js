const oracledb = require('oracledb');

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
oracledb.autoCommit = false;

const dbConfig = {
  user:          process.env.DB_USER          || 'QUINDIOFLIX',
  password:      process.env.DB_PASSWORD      || 'QuindioFlix2026!',
  connectString: process.env.DB_CONNECT_STRING || 'localhost:1521/XEPDB1',
  poolMin:  2,
  poolMax:  10,
  poolIncrement: 1,
};

let pool;

async function initialize() {
  pool = await oracledb.createPool(dbConfig);
  console.log('Pool de conexiones Oracle creado.');
}

async function close() {
  if (pool) await pool.close(0);
}

async function execute(sql, binds = [], opts = {}) {
  let conn;
  try {
    conn = await pool.getConnection();
    const result = await conn.execute(sql, binds, { outFormat: oracledb.OUT_FORMAT_OBJECT, ...opts });
    if (opts.autoCommit !== false) await conn.commit();
    return result;
  } finally {
    if (conn) await conn.close();
  }
}

async function executeProc(sql, binds = {}) {
  let conn;
  try {
    conn = await pool.getConnection();
    const result = await conn.execute(sql, binds);
    await conn.commit();
    return result;
  } finally {
    if (conn) await conn.close();
  }
}

initialize().catch(err => {
  console.error('Error al inicializar pool Oracle:', err);
  process.exit(1);
});

process.on('SIGTERM', close);
process.on('SIGINT',  close);

module.exports = { execute, executeProc };

