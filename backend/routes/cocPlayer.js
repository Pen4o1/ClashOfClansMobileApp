const express = require('express');
const router = express.Router();
const { getPlayer } = require('../services/cocApi');

router.get('/:tag', async (req, res) => {
  const tag = req.params.tag.toUpperCase();
  try {
    const data = await getPlayer(tag);
    res.json(data);
  } catch (error) {
    if (error.reason === 'notFound') {
      res.status(404).json({ error: 'Player not found' });
    } else {
      res.status(500).json({ error: error.message });
    }
  }
});

module.exports = router;
