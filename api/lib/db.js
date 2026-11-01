const sql = require('mssql');
const path = require('path');
const fs = require('fs');

// Attempt to load .env if present and environment variables not yet set
const envPath = path.resolve(process.cwd(), '.env');
if (fs.existsSync(envPath)) {
    const lines = fs.readFileSync(envPath, 'utf-8').split('\n');
    for (const line of lines) {
        const trimmed = line.trim();
        if (trimmed && !trimmed.startsWith('#') && trimmed.includes('=')) {
            const [k, ...v] = trimmed.split('=');
            const key = k.trim();
            const val = v.join('=').trim();
            if (!process.env[key]) {
                process.env[key] = val;
            }
        }
    }
}

const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '1433', 10),
    database: process.env.DB_NAME || 'CSE9937',
    options: {
        encrypt: process.env.DB_ENCRYPT === 'true',
        trustServerCertificate: true,
        connectTimeout: 10000,
        requestTimeout: 15000
    },
    pool: {
        max: 10,
        min: 0,
        idleTimeoutMillis: 30000
    }
};

let poolPromise = null;

function getPool() {
    if (!poolPromise) {
        if (!config.user || !config.password) {
            throw new Error('Database credentials missing: DB_USER and DB_PASSWORD environment variables must be defined.');
        }
        poolPromise = new sql.ConnectionPool(config)
            .connect()
            .then(pool => {
                return pool;
            })
            .catch(err => {
                console.error('Database connection pool error:', err.message);
                poolPromise = null;
                throw err;
            });
    }
    return poolPromise;
}

async function query(queryString, params = {}) {
    const pool = await getPool();
    const request = pool.request();
    for (const [key, value] of Object.entries(params)) {
        request.input(key, value);
    }
    return await request.query(queryString);
}

module.exports = {
    sql,
    getPool,
    query
};
