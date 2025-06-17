require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();

const cocApi = require('./routes/cocPlayer');
const brawApi = require('./routes/brawPlayer');

app.use(cors());
app.use(express.json());
app.use('/api/braw/player', brawApi);
app.use('/api/coc/player', cocApi);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
