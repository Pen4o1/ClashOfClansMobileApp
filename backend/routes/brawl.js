const express = require('express');
const router = express.Router();
const { getPlayer } = require('../services/brawlApi');

router.get('/player/:tag', async (req, res) => {
  const tag = req.params.tag.toUpperCase();
  try {
    const data = await getPlayer(tag);
    res.json(data);
  } catch (error) {
    console.error('Error fetching Brawl Stars player:', error);
    res.status(error.response?.status || 500).json({
      error: 'Failed to fetch Brawl Stars player data',
      details: error.response?.data || error.message
    });
  }
});

module.exports = router; 