const axios = require('axios');

const api = axios.create({
  baseURL: 'https://api.clashofclans.com/v1',
  headers: {
    Authorization: `${process.env.COC_API_KEY}`,
  },
});

module.exports = {
  getPlayer: async (tag) => {
    try {
      const response = await api.get(`/players/%23${tag}`);
      return response.data;
    } catch (error) {
      if (error.response && (error.response.status === 404 || error.response.status === 400)) {
        const notFoundError = new Error('Player not found');
        notFoundError.reason = 'notFound';
        throw notFoundError;
      }
      throw error;
    }
  },
};
