// index.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const listEndpoints = require('express-list-endpoints');

const app = express();

const brawApi = require('./routes/brawPlayer');
const cocApi = require('./routes/cocPlayer');

app.use(cors());
app.use(express.json());
app.use('/api/braw/player', brawApi);
app.use('/api/coc/player', cocApi);

// Export only the app for testing and server import
module.exports = app;
