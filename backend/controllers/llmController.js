
const admin = require('firebase-admin');
require('dotenv').config();
const axios = require("axios");

exports.addExpense = async (req, res) => {
  const { inputText, userId } = req.body; // Extract inputText and userId from request body
  const prompt = `Extract the expense details from the input '${inputText}' and return it as a JSON object with keys 'category', 'name', and 'amount'.`;

  try {
    const response = await axios.post(
      "https://api.openai.com/v1/chat/completions",
      {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: prompt }],
        temperature: 0,
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
          "Content-Type": "application/json",
        },
      }
    );
    console.log("OpenAI API Key:", process.env.OPENAI_API_KEY);

    const parsedData = JSON.parse(response.data.choices[0].message.content); // Assuming response is a JSON string

    // Save categorized expense to Firestore
    await admin
      .firestore()
      .collection("users")
      .doc(userId) // User document ID
      .collection("expenses")
      .add({
        description: inputText,
        category: parsedData.category,
        name: parsedData.name,
        amount: parsedData.amount,
        createdAt: new Date(), // Add timestamp
      });

    res
      .status(200)
      .json({
        message: "Expense categorized successfully.",
        category: parsedData.category,
      });
  } catch (error) {
    console.error("Error processing expense input:", error.message);
    res.status(500).json({ error: "Failed to categorize expense." });
  }
};
