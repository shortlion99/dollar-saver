const admin = require("firebase-admin");
const Tesseract = require("tesseract.js");
const fs = require("fs");
const axios = require("axios");

exports.addExpense = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    const imagePath = req.file.path;
    const {
      data: { text },
    } = await Tesseract.recognize(imagePath, "eng");

    const prompt = `Extract the expense details from the following receipt text and return a JSON object with keys: "total", "date", "merchant", and "items". The "items" key should be an array of objects, each containing "item" and "price" properties. Here is the text: ${text}`;

    // Step 3: Call OpenAI API
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

    const parsedData = JSON.parse(response.data.choices[0].message.content); // Assuming response is a JSON string
    const userId = req.body.userId;

    await admin.firestore().collection("receipts").add({
      text: text,
      details: parsedData,
      createdAt: new Date(),
    });

    res.status(200).json({
      message: "Text extracted successfully.",
      text: text,
    });
  } catch (error) {
    console.error("Error during OCR processing:", error);
  }
};
