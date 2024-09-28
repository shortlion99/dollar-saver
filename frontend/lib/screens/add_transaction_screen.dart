import 'package:ai_expense_app/components/budget_provider.dart';
import 'package:ai_expense_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TextEditingController expenseController = TextEditingController();
  File? _receiptImage;
  List<Map<String, String>> categorizedExpenses = [];
  bool _isProcessing = false;

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
      body: Container(
        color: Colors.white, // Ensure the body background is white
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Increased vertical padding
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
        ),
      ],
    );
  }

  void _logExpense() async {
    final message = expenseController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _isProcessing = true;
      });
      final response = await _processUserInput(message);
      if (response.isNotEmpty) {
        final transaction = Transaction(
          category: response['category']!,
          amount: double.tryParse(response['total'] ?? '0') ?? 0.0,
          date: DateTime.now(), // Use the current date for the transaction
          isIncome: false, // Set this according to your needs
        );

        Provider.of<BudgetProvider>(context, listen: false).addTransaction(transaction);
        setState(() {
          categorizedExpenses.add(response);
          expenseController.clear();
          _isProcessing = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Successfully added: ${response['message']} under ${response['category']}'),
        ));
      } else {
        setState(() {
          _isProcessing = false;
        });
        // Handle empty response case
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to log expense')));
      }
    }
  }

  Future<Map<String, String>> _processUserInput(String input) async {
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
        final expenses = data['expenses'];

        if (expenses.isNotEmpty) {
          // Return the first categorized expense for simplicity
          return expenses[0];
        }
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e'); // Debug log
    }
    return {};
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _receiptImage = File(pickedFile.path);
          _isProcessing = true;
        });

        final response = await _processReceipt(_receiptImage!);
        setState(() {
          categorizedExpenses.add(response);
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Receipt uploaded: ${response['message']}')));
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      print('Error picking image: $e');
    }
  }

  Future<Map<String, String>> _processReceipt(File receiptImage) async {
    await Future.delayed(const Duration(seconds: 2));
    return {"category": "Groceries", "message": "Spent \$20 on groceries"}; // Simulated response
  }

  Widget _buildReceiptPreview() {
    return _receiptImage == null
        ? Container()
        : Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
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
            final expense = categorizedExpenses[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: _getCategoryColor(expense['category']!),
              child: ListTile(
                title: Text(expense['message']!, style: const TextStyle(color: Colors.black)),
                leading: const Icon(Icons.attach_money, color: Colors.black),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Food & Drink":
        return Colors.green[100]!;
      case "Groceries":
        return Colors.blue[100]!;
      case "Entertainment":
        return Colors.orange[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  @override
  void dispose() {
    expenseController.dispose();
    super.dispose();
  }
}
