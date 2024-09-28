const admin = require("firebase-admin");
require("dotenv").config();
const axios = require("axios");

const PREDEFINED_CATEGORIES = [
  "Groceries",
  "Transportation",
  "Entertainment",
  "Dining",
  "Tuition",
  "Utilities",
  "Salary",
  "Gifts",
  "Friend payment",
  "Others",
];

const parseExpenseInput = async (inputText) => {
    const expensesArray = inputText.split(',').map(expense => expense.trim());
    const expensePattern = /(?:\$\s*([\d,]+(?:\.\d{1,2})?)|(\d+\.?\d?))\s*(.*)/; 
    const categorizedExpenses = [];
  
    for (const expenseText of expensesArray) {
      const matches = expensePattern.exec(expenseText);
  
      if (!matches || (!matches[1] && !matches[2])) {
        console.warn(`Skipping invalid entry: "${expenseText}" - No matches found.`);
        continue; 
      }
  
      // Use defensive checks
      const amountString = matches[1] ? matches[1].replace(/,/g, '') : matches[2];
      const amount = parseFloat(amountString);
      const description = matches[3]?.trim() || "No description";
  
      if (isNaN(amount) || amount <= 0) {
        console.warn(`Invalid amount specified for entry: "${expenseText}"`);
        continue; 
      }
  
      const { category, isExpense } = await categorizeExpense(description);
      
      categorizedExpenses.push({
        name: description, // Changed from description to name
        category,
        total: amount, // Changed from amount to total
        date: new Date(), 
        expense: isExpense,
      });
    }
  
    return categorizedExpenses;
  };

  
const categorizeExpense = async (description) => {
  const prompt = `Categorize the following entry: "${description}". Is it an expense or an income? Available categories are: ${PREDEFINED_CATEGORIES.join(
    ", "
  )}. Please respond with the category only from the predefined list and whether it's an expense (true) or income (false).`;

  try {
    const response = await axios.post(
      "https://api.openai.com/v1/chat/completions",
      {
        model: "gpt-4-turbo",
        messages: [{ role: "user", content: prompt }],
        max_tokens: 50,
        temperature: 0,
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
          "Content-Type": "application/json",
        },
      }
    );

    const result = response.data.choices[0].message.content.trim();
    const [category, isExpense] = result.split(",").map((item) => item.trim());

    const validCategory = PREDEFINED_CATEGORIES.includes(category)
      ? category
      : "Others";

    return {
      category: validCategory,
      isExpense: isExpense === "true",
    };
  } catch (error) {
    console.error("Error calling OpenAI API for categorization:", error);
    return {
      category: "Others",
      isExpense: true,
    };
  }
};

const saveDataToFirestore = async (expenses, userId) => {
    const batch = admin.firestore().batch();
  
    expenses.forEach((entry) => {
      const expenseRef = admin.firestore()
        .collection("users")
        .doc(userId)
        .collection("expenses")
        .doc(); // Create a new document reference
  
      // Set the data for the document
      batch.set(expenseRef, entry);
    });
  
    try {
        console.log("Expenses to save:", expenses);
        await batch.commit();
        console.log("Data saved successfully.");
      } catch (error) {
        console.error("Error committing batch to Firestore:", error.message);
        throw new Error("Failed to save data.");
      }
    };

exports.addExpense = async (req, res) => {
  const { inputText, userId } = req.body;

  if (!inputText || !userId) {
    return res
      .status(400)
      .json({ error: "Input text and user ID are required." });
  }

  const categorizedExpenses = await parseExpenseInput(inputText);

  if (categorizedExpenses.length === 0) {
    return res.status(400).json({ error: "No valid entries found." });
  }

  try {
    await saveDataToFirestore(categorizedExpenses, userId);
    return res.status(200).json({
      message: "Entries categorized and saved successfully.",
      expenses: categorizedExpenses,
    });
  } catch (error) {
    console.error(`Error saving expenses: ${error.message}`);
    return res
      .status(500)
      .json({ error: "Failed to save expenses. Please try again." });
  }
};
