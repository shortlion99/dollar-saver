require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');
const multer = require('multer');
const vision = require('@google-cloud/vision');
const { OpenAIApi, Configuration } = require('openai');
const axios = require('axios');


const app = express();
const upload = multer({ storage: multer.memoryStorage() });

const port = 3000;

admin.initializeApp({
    credential: admin.credential.cert(require('./config/serviceAccountKey.json'))
});

app.use(express.json()); // Add this line
app.use(bodyParser.json());


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

app.post('/addExpense', async (req, res) => {
    const { inputText, userId } = req.body; // Extract inputText and userId from request body
    const prompt = `Extract the expense details from the input '${inputText}' and return it as a JSON object with keys 'category', 'name', and 'amount'.`;

    try {
        const response = await axios.post('https://api.openai.com/v1/chat/completions', {
            model: 'gpt-3.5-turbo',
            messages: [{ role: 'user', content: prompt }],
            temperature: 0,
        }, {
            headers: {
                'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
                'Content-Type': 'application/json'
            }
        });

        const parsedData = JSON.parse(response.data.choices[0].message.content); // Assuming response is a JSON string

        // Save categorized expense to Firestore
        await admin.firestore().collection('users')
            .doc(userId) // User document ID
            .collection('expenses')
            .add({
                description: inputText,
                category: parsedData.category,
                name: parsedData.name,
                amount: parsedData.amount,
                createdAt: new Date(), // Add timestamp
            });

        res.status(200).json({ message: 'Expense categorized successfully.', category: parsedData.category });

    } catch (error) {
        console.error('Error processing expense input:', error.message);
        res.status(500).json({ error: 'Failed to categorize expense.' });
    }
});


// Start the server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
