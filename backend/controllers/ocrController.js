const admin = require("firebase-admin");
const Tesseract = require("tesseract.js");
const fs = require("fs");
const axios = require("axios");

const predefinedCategories = [
    "Groceries",
    "Transportation",
    "Entertainment",
    "Dining",
    "Utilities",
    "Salary",
    "Gifts",
    "Friend Payment",
    "Others"
];

exports.addExpense = async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ error: "No file uploaded" });
        }

        const imagePath = req.file.path;

        if (!fs.existsSync(imagePath)) {
            return res.status(400).json({ error: "Receipt image does not exist." });
        }

        const { data: { text } } = await Tesseract.recognize(imagePath, "eng");

        const prompt = `Extract the expense details from the following receipt text and return a JSON object with keys: "total", "date", "merchant", "items", "description", and "category". The "items" key should be an array of objects, each containing "item" and "price" properties. Here is the text: ${text}. Please categorize the receipt using one of the following categories: ${predefinedCategories.join(", ")}.`;

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

        console.log("OpenAI Response:", response.data);

        if (!response.data.choices || response.data.choices.length === 0) {
            throw new Error("No response choices from OpenAI API.");
        }

        const parsedData = JSON.parse(response.data.choices[0].message.content);

        if (!parsedData.total || !parsedData.merchant || !parsedData.items || !parsedData.description || !parsedData.category) {
            return res.status(400).json({ error: "Incomplete receipt data extracted." });
        }

        if (!Array.isArray(parsedData.items)) {
            return res.status(400).json({ error: "Items should be an array." });
        }

        const userId = req.body.userId;

        const batch = admin.firestore().batch();

        const receiptData = {
            text,
            details: parsedData,
            createdAt: new Date(),
            userId, 
        };

        const receiptRef = admin.firestore()
            .collection("users")
            .doc(userId)
            .collection("receipts")
            .doc(); 
        batch.set(receiptRef, receiptData);

        const expenseData = {
            amount: parseFloat(parsedData.total), 
            category: parsedData.category, 
            createdAt: new Date(), 
            description: parsedData.description, 
            expense: true, 
            items: parsedData.items
        };

        const expenseRef = admin.firestore()
            .collection("users")
            .doc(userId)
            .collection("expenses")
            .doc(); 
        batch.set(expenseRef, expenseData);

        await batch.commit();

        const { total, merchant } = parsedData; // Ensure these keys exist in parsedData

    res.status(200).json({
      message: "Text extracted successfully.",
      text: text,
      details: {
        total,
        merchant,
      },
    });
    } catch (error) {
        console.error("Error during OCR processing:", error.message || error); // Log specific error message
        res.status(500).json({ error: error.message || "An error occurred during processing." });
    } finally {
        if (req.file) {
            fs.unlinkSync(req.file.path); 
        }
    }
};