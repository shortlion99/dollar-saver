const express = require('express');
const multer = require('multer');
const { uploadReceipt } = require('../controllers/ocrController');

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

router.post('/upload-receipt', upload.single('receipt'), uploadReceipt);

module.exports = router;
