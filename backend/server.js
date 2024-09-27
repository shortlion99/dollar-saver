require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');
const multer = require('multer');
const vision = require('@google-cloud/vision');

const app = express();
const upload = multer({ storage: multer.memoryStorage() });

const port = 3000;

admin.initializeApp({
    credential: admin.credential.cert(require('./config/serviceAccountKey.json'))
});

app.use(express.json()); // Add this line


app.get('/', (req, res) => {
  res.send('Hello, World!');
});


const db = admin.firestore();


db.collection('testConnection').add({ test: 'Connection test' })
    .then(() => {
        console.log('Firebase initialized and connected successfully.');
    })
    .catch((error) => {
        console.error('Error connecting to Firebase:', error);
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