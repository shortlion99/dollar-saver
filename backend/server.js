require('dotenv').config();
const cors = require('cors');
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
app.use(cors());


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
    res.send('API is running'); // Simple text response
});

const db = admin.firestore();

// Example endpoint to test adding user data
app.post('/addUser', async (req, res) => {
    try {
        console.log(req.body); 
        const { name, email } = req.body; // Get data from request body
        const userRef = await db.collection('users').add({
            name: name, // Use the name from the request
            email: email // Use the email from the request
        });
        res.status(201).send(`User added with ID: ${userRef.id}`);
    } catch (error) {
        console.error('Error adding user:', error);
        res.status(500).send('Error adding user.');
    }
});


const ipAddress = '192.168.0.121'; // Replace with your actual IP address
app.listen(port, ipAddress, () => {
    console.log(`Server is running at http://${ipAddress}:${port}`);
});