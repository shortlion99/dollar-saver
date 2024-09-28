require('dotenv').config();
const cors = require('cors');
const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');
const llmRouter = require('./routes/llmRoutes');
const ocrRouter = require('./routes/ocrRoutes');

const app = express();
const port = 3000;

// Initialize Firebase Admin SDK
admin.initializeApp({
    credential: admin.credential.cert(require('./config/serviceAccountKey.json'))
});

// Initialize Firestore
const db = admin.firestore();

// Middleware
app.use(cors());
app.use(express.json()); // Ensure express can parse JSON
app.use(bodyParser.json()); // Optional: can be removed if not needed

// Define routes
app.use('/', llmRouter);
app.use('/', ocrRouter);

// Test endpoint
app.get('/', (req, res) => {
    res.send('API is running');
});

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

// Start the server
app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});
