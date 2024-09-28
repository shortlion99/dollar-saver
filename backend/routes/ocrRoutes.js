const express = require('express');
const multer = require('multer');
const ocrController = require('../controllers/ocrController');

const upload = multer({ dest: 'uploads/' });

const router = express.Router();

router.post('/uploadReceipt', upload.single('receipt'), ocrController.addExpense);

module.exports = router;
