const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  // Datas voltam como texto 'YYYY-MM-DD HH:mm:ss', evitando bug de fuso horário
  dateStrings: true,
});

module.exports = pool;
