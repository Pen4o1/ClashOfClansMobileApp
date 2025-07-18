jest.mock('../services/cocApi', () => ({
  getPlayer: jest.fn((tag) => {
    if (tag === 'VALID123') {
      return Promise.resolve({
        tag: 'VALID123',
        name: 'MockCocPlayer',
        expLevel: 100,
      });
    } else {
      const error = new Error('Player not found');
      error.reason = 'notFound';
      return Promise.reject(error);
    }
  }),
}));

const request = require('supertest');
const app = require('../index');

describe('GET /api/coc/player/:tag', () => {
  it('should return player data for valid tag', async () => {
    const res = await request(app).get('/api/coc/player/valid123');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('tag', 'VALID123');
    expect(res.body).toHaveProperty('name', 'MockCocPlayer');
    expect(res.body).toHaveProperty('expLevel', 100);
  });

  it('should return 404 for invalid tag', async () => {
    const res = await request(app).get('/api/coc/player/unknown999');
    expect(res.statusCode).toBe(404);
    expect(res.body).toHaveProperty('error', 'Player not found');
  });

  it('should return 500 for unknown errors from the service', async () => {
    const { getPlayer } = require('../services/cocApi');
    getPlayer.mockImplementationOnce(() => Promise.reject(new Error('Something went wrong')));
    const res = await request(app).get('/api/coc/player/valid123');
    expect(res.statusCode).toBe(500);
    expect(res.body).toHaveProperty('error', 'Something went wrong');
  });

  it('should handle tags in lowercase and mixed case', async () => {
    const resLower = await request(app).get('/api/coc/player/valid123');
    expect(resLower.statusCode).toBe(200);
    expect(resLower.body).toHaveProperty('tag', 'VALID123');
    const resMixed = await request(app).get('/api/coc/player/ValiD123');
    expect(resMixed.statusCode).toBe(200);
    expect(resMixed.body).toHaveProperty('tag', 'VALID123');
  });

  it('should return 404 for empty tag', async () => {
    const res = await request(app).get('/api/coc/player/');
    expect([404, 400]).toContain(res.statusCode); // Express may return 404 or 400 for missing param
  });

  it('should return 404 for malformed tag', async () => {
    const res = await request(app).get('/api/coc/player/!@#$%');
    expect([404, 400]).toContain(res.statusCode); // Service will likely treat as not found or bad request
  });
});
