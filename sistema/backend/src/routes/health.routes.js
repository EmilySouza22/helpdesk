const { Router } = require('express');
const pool = require('../config/db');

const router = Router();

// GET /api/health -> confirma que a API e o banco estão no ar
router.get('/', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', api: 'ok', banco: 'ok' });
  } catch (erro) {
    console.error('Falha ao conectar no banco:', erro.message);
    res.status(503).json({ status: 'erro', api: 'ok', banco: 'falha' });
  }
});

module.exports = router;
