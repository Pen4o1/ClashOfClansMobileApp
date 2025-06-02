require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();

const playerRoutes = require('./routes/player');

app.use(cors());
app.use(express.json());
app.use('/api/player', playerRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
