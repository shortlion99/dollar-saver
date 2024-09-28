import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TextEditingController chatbotController = TextEditingController();
  File? _receiptImage;
  List<String> chatMessages = []; // To store chat messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Add Transaction', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildChatbotInput(),
            _buildReceiptPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptPreview() {
    return _receiptImage == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Image.file(_receiptImage!),
          );
  }

  Widget _buildChatbotInput() {
    return Expanded(
      child: Container(
        // Remove the grey border by not setting the background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
        IconButton(
          icon: const Icon(Icons.upload_file, color: Colors.deepPurple),
          onPressed: _pickImage,
          tooltip: 'Upload Receipt',
        ),
        Expanded(
          child: TextField(
            controller: chatbotController,
            decoration: const InputDecoration(
              hintText: 'Type your message...',
              border: InputBorder.none, // Remove the border
              filled: true,
              fillColor: Color(0xFFF0F0F0), // Light grey background
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
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return "Categorized as Food & Drink, amount: \$10"; // Example response
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return "Receipt processed: Spent \$20 on groceries"; // Example response
  }

  @override
  void dispose() {
    chatbotController.dispose();
    super.dispose();
  }
}
