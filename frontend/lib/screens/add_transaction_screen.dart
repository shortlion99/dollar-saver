import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController expenseController = TextEditingController();
  File? _receiptImage;
  final List<String> categorizedExpenses = []; // Store categorized expenses
  bool _isProcessing = false; // To track processing state

  static const TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Add Transaction', style: titleStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(),
              const SizedBox(height: 10),
              _buildReceiptPreview(),
              const SizedBox(height: 10),
              if (_isProcessing) _buildLoadingIndicator(),
              const SizedBox(height: 10),
              _buildCategorizedExpenses(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter your expenses or upload a receipt',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.upload_file, color: Colors.black),
                  onPressed: _pickImage,
                  tooltip: 'Upload Receipt',
                ),
                Expanded(
                  child: TextField(
                    controller: expenseController,
                    decoration: InputDecoration(
                      hintText: 'E.g. \$10 on lunch, \$100 on flight tickets',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    ),
                    minLines: 1,
                    maxLines: null,
                    onSubmitted: (_) => _logExpense(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: _logExpense,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _logExpense() async {
    final message = expenseController.text.trim();
    if (message.isNotEmpty) {
      print('Sending request with message: $message'); // Debug log
      final response = await _processUserInput(message);
      if (response.isNotEmpty) {
        setState(() {
          categorizedExpenses.add(response);
        });
        expenseController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Expense logged: $response')),
        );
      } else {
        print('Received empty response'); // Debug log
      }
    }
  }

  Future<String> _processUserInput(String input) async {
    final url = Uri.parse('http://localhost:3000/addExpense'); // Update to your server URL
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'inputText': input,
          'userId': 'Etvdsmu2c0NCjwLr40FI',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Parse the response
        final expenses = data['expenses'] as List; // Ensure it's a list
        String result = '';

        for (var expense in expenses) {
          result += 'Category: ${expense['category']}\n'
                    'Total: \$${expense['total']}\n'
                    'Description: ${expense['name']}\n'
                    'Date: ${expense['date']}\n\n';
        }

        return result; // Return formatted string of all categorized expenses
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        return 'Error processing expense';
      }
    } catch (e) {
      print('Exception: $e'); // Debug log
      return 'Failed to get a valid response';
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _receiptImage = File(pickedFile.path);
          _isProcessing = true; // Start processing
        });

        final response = await _processReceipt(_receiptImage!);
        setState(() {
          categorizedExpenses.add(response);
          _isProcessing = false; // Stop processing
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receipt uploaded: $response')),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false; // Stop processing in case of error
      });
      print('Error picking image: $e');
    }
  }

  Future<String> _processReceipt(File receiptImage) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate longer network delay
    return "Receipt processed: Spent \$20 on groceries"; // Example response
  }

  Widget _buildReceiptPreview() {
    return _receiptImage == null
        ? Container()
        : Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _receiptImage!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(color: Colors.black),
          SizedBox(height: 8),
          Text('Scanning receipt...', style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildCategorizedExpenses() {
    if (categorizedExpenses.isEmpty) {
      return const Text('No categorized expenses yet.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Categorized Expenses:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categorizedExpenses.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(categorizedExpenses[index]),
                leading: const Icon(Icons.attach_money, color: Colors.black),
                tileColor: Colors.grey[100],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    expenseController.dispose();
    super.dispose();
  }
}
