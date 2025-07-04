jest.mock('../services/brawApi', () => ({
  getPlayer: jest.fn((tag) => {
    if (tag === 'VALID123') {
      return Promise.resolve({
        tag: 'VALID123',
        name: 'MockPlayer',
        trophies: 1234,
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

describe('GET /api/braw/player/:tag', () => {
  it('should return player data for valid tag', async () => {
    const res = await request(app).get('/api/braw/player/valid123');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('tag', 'VALID123');
    expect(res.body).toHaveProperty('name', 'MockPlayer');
    expect(res.body).toHaveProperty('trophies', 1234);
  });

  it('should return 404 for invalid tag', async () => {
    const res = await request(app).get('/api/braw/player/unknown999');
    expect(res.statusCode).toBe(404);
    expect(res.body).toHaveProperty('error', 'Player not found');
  });
});
