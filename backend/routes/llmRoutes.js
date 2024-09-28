const express = require('express');
const router = express.Router();
const llmController = require('../controllers/llmController');

router.post('/addExpense', llmController.addExpense);

module.exports = router;
