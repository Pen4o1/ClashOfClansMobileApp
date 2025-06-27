const request = require('supertest');
const app = require('../index'); // Make sure app is exportable

describe('GET /api/coc/player/:id', () => {
  it('should return 404 for unknown player', async () => {
    const res = await request(app).get('/api/coc/player/P0LYGON');
    expect(res.statusCode).toBe(404); // Or whatever your handler returns
  });
});
