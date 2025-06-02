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
      console.error(error.response?.data || error.message);
      throw error;
    }
  },
};
