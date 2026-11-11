const express = require('express');
const cors = require('cors');

const healthRoutes = require('./routes/health.routes');

const app = express();

app.use(
  cors({
    origin: process.env.FRONTEND_URL,
  })
);
app.use(express.json());

// Rotas
app.use('/api/health', healthRoutes);
// TODO: app.use('/api/auth', authRoutes);
// TODO: app.use('/api/dashboard', dashboardRoutes);
// TODO: app.use('/api/categorias', categoriasRoutes);
// TODO: app.use('/api/chamados', chamadosRoutes);
// TODO: app.use('/api/atendimento', atendimentoRoutes);

// 404 para rotas inexistentes
app.use((req, res) => {
  res.status(404).json({ erro: 'Rota não encontrada' });
});

module.exports = app;
