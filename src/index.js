// src/index.js  ← ESTA ES LA DEFINITIVA

const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Datos
let reservations = [];
const fruits = [
  { id: 1, name: 'Manzana', price: 10, available: true },
  { id: 2, name: 'Banana', price: 5, available: true },
  { id: 3, name: 'Naranja', price: 8, available: true }
];

// RUTAS API
app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'Servidor funcionando', version: process.env.APP_VERSION || 'dev' });
});

app.get('/api/fruits', (req, res) => res.json(fruits));

app.post('/api/reservations', (req, res) => {
  const { fruitId, userName, quantity } = req.body;
  if (!fruitId || !userName || !quantity) return res.status(400).json({ error: 'Faltan campos' });
  const fruit = fruits.find(f => f.id === fruitId);
  if (!fruit) return res.status(404).json({ error: 'Fruta no encontrada' });

  const reservation = { id: reservations.length + 1, fruitId, userName, quantity, status: 'confirmed', createdAt: new Date().toISOString() };
  reservations.push(reservation);
  return res.status(201).json(reservation);
});

app.get('/api/reservations', (req, res) => res.json(reservations));

// FRONTEND: solo si existe la carpeta y no estamos en test
const isTest = process.env.NODE_ENV === 'test';
const isDirectRun = require.main === module;

if (!isTest && isDirectRun) {
  const frontendPath = path.join(__dirname, '../frontend');

  // Solo monta si la carpeta existe (evita crash en contenedor si no hay frontend)
  try {
    require('fs').accessSync(frontendPath);
    app.use(express.static(frontendPath));
    app.get('*', (req, res) => {
      res.sendFile(path.join(frontendPath, 'index.html'));
    });
    console.log('Frontend servido desde', frontendPath);
  } catch (e) {
    console.log('No hay carpeta frontend, solo API');
  }
}

// Sirve frontend solo en producción
if (process.env.NODE_ENV !== 'test') {
  const frontend = path.join(__dirname, '../frontend');
  app.use(express.static(frontend));
  app.get('*', (_, res) => res.sendFile(path.join(frontend, 'index.html')));
}

// Solo arranca si es ejecución directa
if (require.main === module) {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`API + Frontend en puerto ${PORT}`);
  });
}

module.exports = app;