const admin = require("firebase-admin");
const Tesseract = require("tesseract.js");
const fs = require("fs");

exports.addExpense = async (req, res) => {
  try {
    // Check if the file is provided
    if (!req.file) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    const imagePath = req.file.path;
    // Use Tesseract to extract text
    const { data: { text } } = await Tesseract.recognize(
        imagePath,
        'eng'
      );

    console.log("Extracted Text:", text);
    const userId = req.body.userId;

    const batch = admin.firestore().batch();
    expenses.forEach(expense => {
      const expenseRef = admin.firestore().collection("users").doc(userId).collection("expenses").doc();
      batch.set(expenseRef, {
        description: expense.description,
        category: expense.category,
        name: expense.name,
        amount: expense.amount,
        createdAt: new Date(),
      });
    });

    res.status(200).json({
      message: "Text extracted successfully.",
      text: extractedText,
    });
  } catch (error) {
    console.error("Error during OCR processing:", error);
  }
};
