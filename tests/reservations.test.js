const request = require('supertest');
const app = require('../src/index');

beforeEach(() => {
  // Reiniciar el estado reiniciando el módulo 
  jest.resetModules();
});

describe('Reservation Endpoints', () => {
  it('POST /api/reservations - crea reserva válida', async () => {
    const reservationData = { fruitId: 1, userName: 'Ana', quantity: 2 };
    const res = await request(require('../src/index')).post('/api/reservations').send(reservationData);
    expect(res.statusCode).toEqual(201);
    expect(res.body).toHaveProperty('id');
    expect(res.body.userName).toBe('Ana');
  });

  it('POST /api/reservations - falla con datos incompletos', async () => {
    const invalidData = { fruitId: 1 };
    const res = await request(require('../src/index')).post('/api/reservations').send(invalidData);
    expect(res.statusCode).toEqual(400);
    expect(res.body).toHaveProperty('error');
  });

  it('GET /api/reservations - lista reservas (array)', async () => {
    const res = await request(require('../src/index')).get('/api/reservations');
    expect(res.statusCode).toEqual(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  it('POST /api/reservations - 404 si fruta no existe', async () => {
    const res = await request(require('../src/index')).post('/api/reservations').send({ fruitId: 999, userName: 'X', quantity: 1 });
    expect(res.statusCode).toEqual(404);
    expect(res.body).toHaveProperty('error');
  });
});