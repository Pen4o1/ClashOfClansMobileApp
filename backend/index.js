require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();

const cocRoutes = require('./routes/player');
const brawlRoutes = require('./routes/brawl');

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/coc', cocRoutes);
app.use('/api/brawl', brawlRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Something went wrong!',
    details: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log('Available routes:');
  console.log('- /api/coc/player/:tag');
  console.log('- /api/brawl/player/:tag');
  console.log('- /health');
});
