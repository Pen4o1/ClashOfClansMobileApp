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
});
