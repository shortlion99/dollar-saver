import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String selectedCategory = 'Food & Drink';
  TextEditingController amountController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController chatbotController = TextEditingController();
  TextEditingController transactionInputController = TextEditingController();
  File? _receiptImage;
  List<String> chatMessages = []; // To store chat messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Transaction', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          _buildTransactionInputField(),
          _buildChatbotInput(),
          _buildUploadReceiptButton(),
          _buildReceiptPreview(),
          
        ],
      ),
    );
  }

  Widget _buildTransactionInputField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: transactionInputController,
        decoration: const InputDecoration(
          labelText: 'Enter transaction (e.g., "Spent \$10 on coffee")',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadReceiptButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: _pickImage,
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload Receipt'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }


  Widget _buildReceiptPreview() {
    return _receiptImage == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.file(_receiptImage!),
          );
  }

  Widget _buildChatbotInput() {
    return Expanded(
      child: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chat with ExpenseBot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final message = chatMessages[index];
                  return _buildChatMessage(message);
                },
              ),
            ),
            _buildChatInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildChatInputField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: chatbotController,
            decoration: const InputDecoration(
              hintText: 'Enter your expense here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send, color: Colors.blue),
          onPressed: _sendChatMessage,
        ),
      ],
    );
  }

  void _sendChatMessage() async {
    final message = chatbotController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        chatMessages.add("You: $message"); // Add user message
      });
      chatbotController.clear();

      // Call your AI processing function here
      final response = await _processUserInput(message);
      setState(() {
        chatMessages.add("ExpenseBot: $response"); // Add AI response
      });
    }
  }

  Future<String> _processUserInput(String input) async {
    // Here you would implement your logic to process the user input or receipt
    // This could involve calling an external API that performs NLP and OCR

    // Example: You might send the input to your AI service and get a response
    // For now, return a mock response
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return "Categorized as Food & Drink, amount: \$10"; // Example response
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _receiptImage = File(pickedFile.path);
      });

      // Call your OCR processing function here
      final response = await _processReceipt(_receiptImage!);
      setState(() {
        chatMessages.add("ExpenseBot: $response"); // Add AI response
      });
    }
  }

  Future<String> _processReceipt(File receiptImage) async {
    // Implement OCR extraction and AI processing here
    // This function should return a string with categorized data

    // Example: Simulate a response
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return "Receipt processed: Spent \$20 on groceries"; // Example response
  }

  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    chatbotController.dispose();
    transactionInputController.dispose();
    super.dispose();
  }
}
