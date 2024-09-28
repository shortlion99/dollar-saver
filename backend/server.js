require('dotenv').config();
console.log('OpenAI API Key:', process.env.OPENAI_API_KEY);
const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');
const multer = require('multer');
const path = require('path');
const vision = require('@google-cloud/vision');
const { OpenAIApi, Configuration } = require('openai');
const axios = require('axios');
require('dotenv').config();
const llmRouter = require('./routes/llmRoutes');
const ocrRouter = require('./routes/ocrRoutes');



const app = express();



const upload = multer({ storage: multer.memoryStorage() });

const port = 3000;

admin.initializeApp({
    credential: admin.credential.cert(require('./config/serviceAccountKey.json'))
});

app.use(express.json()); // Add this line
app.use(bodyParser.json());
app.use('/', llmRouter);
app.use('/', ocrRouter);


app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../frontend/index.html'));
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
