const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// === DATOS Y RUTAS API ===
let reservations = [];
const fruits = [
  { id: 1, name: 'Manzana', price: 10, available: true },
  { id: 2, name: 'Banana', price: 5, available: true },
  { id: 3, name: 'Naranja', price: 8, available: true }
];

app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'Servidor funcionando', version: process.env.APP_VERSION || 'dev' });
});

app.get('/api/fruits', (req, res) => res.json(fruits));

app.post('/api/reservations', (req, res) => {
  const { fruitId, userName, quantity } = req.body;
  if (!fruitId || !userName || !quantity) return res.status(400).json({ error: 'Faltan campos requeridos' });
  const fruit = fruits.find(f => f.id === fruitId);
  if (!fruit) return res.status(404).json({ error: 'Fruta no encontrada' });

  const reservation = { id: reservations.length + 1, fruitId, userName, quantity, status: 'confirmed', createdAt: new Date().toISOString() };
  reservations.push(reservation);
  return res.status(201).json(reservation);
});

app.get('/api/reservations', (req, res) => res.json(reservations));

// === FRONTEND SOLO EN PRODUCCIÓN ===
if (process.env.NODE_ENV !== 'test') {
  const frontendPath = path.join(__dirname, '../frontend');
  app.use(express.static(frontendPath));
  app.get('*', (req, res) => {
    res.sendFile(path.join(frontendPath, 'index.html'));
  });
}

// === ARRANQUE DEL SERVIDOR SOLO CUANDO SE EJECUTA DIRECTAMENTE ===
if (require.main === module) {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Servidor corriendo en puerto ${PORT}`);
    console.log(`Health: http://localhost:${PORT}/health`);
  });
}

module.exports = app; // para los tests