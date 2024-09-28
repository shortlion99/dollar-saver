const admin = require("firebase-admin");
const Tesseract = require("tesseract.js");
const fs = require("fs");

exports.addExpense = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    const imagePath = req.file.path;
    const { data: { text } } = await Tesseract.recognize(
        imagePath,
        'eng'
      );

    const userId = req.body.userId;

    await admin.firestore().collection("receipts").add({
        text: text,
        createdAt: new Date(),
    });

    res.status(200).json({
      message: "Text extracted successfully.",
      text: extractedText,
    });
  } catch (error) {
    console.error("Error during OCR processing:", error);
  }
};
