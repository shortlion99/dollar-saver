import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TextEditingController expenseController = TextEditingController();
  File? _receiptImage;
  List<String> categorizedExpenses = []; // Store categorized expenses
  bool _isProcessing = false; // To track processing state

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      elevation: 0,
      title: Row(
        children: [
          const Text('Add Transaction', style: TextStyle(color: Colors.black)),
        ],
      ),
      // Aligning title to the left
      toolbarHeight: 60, // Adjust height if necessary
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeMessage(),
            const SizedBox(height: 16),
            _buildInputField(),
            const SizedBox(height: 16),
            _buildReceiptPreview(),
            const SizedBox(height: 16),
            _isProcessing ? _buildLoadingIndicator() : Container(),
            const SizedBox(height: 16),
            _buildCategorizedExpenses(),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildWelcomeMessage() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.grey[100], // Slightly different background color for contrast
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: const Text(
          'Easily log your expenses. Type your expense or upload a receipt, and let AI categorize it for you!',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                  hintText: 'Type your expense here...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
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
    );
  }

  void _logExpense() async {
    final message = expenseController.text.trim();
    if (message.isNotEmpty) {
      final response = await _processUserInput(message);
      setState(() {
        categorizedExpenses.add(response);
      });
      expenseController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Expense logged: $response')));
    }
  }

  Future<String> _processUserInput(String input) async {
    await Future.delayed(const Duration(seconds: 1));
    return "Categorized as Food & Drink, amount: \$10"; // Example response
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Receipt uploaded: $response')));
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
        const Text('Categorized Expenses:', style: TextStyle(fontWeight: FontWeight.bold)),
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
