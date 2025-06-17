const axios = require('axios');

const api = axios.create({
  baseURL: 'https://api.brawlstars.com/v1',
  headers: {
    Authorization: `${process.env.BRAW_STARS_API_KEY}`,
  },
});

module.exports = {
  getPlayer: async (tag) => {
    try {
      const response = await api.get(`/players/%23${tag}`);
      return response.data;
    } catch (error) {
      console.error(error.response?.data || error.message);
      throw error;
    }
  },
};
