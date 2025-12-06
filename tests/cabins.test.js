const request = require('supertest');
const app = require('../src/index');

describe('Fruits endpoint', () => {
  it('GET /api/fruits - debería devolver array de frutas', async () => {
    const res = await request(app).get('/api/fruits');
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
    expect(res.body.length).toBeGreaterThanOrEqual(1);
  });
});