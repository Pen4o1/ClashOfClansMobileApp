const express = require('express');
const router = express.Router();
const { getPlayer } = require('../services/cocApi');

router.get('/:tag', async (req, res) => {
  const tag = req.params.tag.toUpperCase();
  try {
    const data = await getPlayer(tag);
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch player data' });
  }
});

module.exports = router;
