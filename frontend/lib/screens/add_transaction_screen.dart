import 'package:ai_expense_app/components/budget_provider.dart';
import 'package:ai_expense_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';


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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(),
            const SizedBox(height: 10),
            _buildReceiptPreview(),
            const SizedBox(height: 10),
            _isProcessing ? _buildLoadingIndicator() : Container(),
            const SizedBox(height: 10),
            _buildCategorizedExpenses(),
          ],
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
                    hintText: 'E.g. \$10 on lunch, \$100 on flight tickets',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12), // Adjust padding here
                  ),
                  minLines: 1, // Set minimum lines for height
                  maxLines: null, // Allow the field to grow vertically
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
    final response = await _processUserInput(message);
    
    final transaction = Transaction(
      category: response['category']!,
      amount: 10.0, // Adjust the amount as needed based on your logic
      date: DateTime.now(), // Use the current date for the transaction
      isIncome: false, // Set this according to your needs
    );

    Provider.of<BudgetProvider>(context, listen: false).addTransaction(transaction);
    setState(() {
      categorizedExpenses.add(response);
    });
    expenseController.clear();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully added: ${response['message']} under ${response['category']}'),
    ));
  }
}



  Future<Map<String, String>> _processUserInput(String input) async {
    await Future.delayed(const Duration(seconds: 1));
    return {"category": "Food & Drink", "message": "Spent \$10 on food"};
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
    return {"category": "Groceries", "message": "Spent \$20 on groceries"};
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
        const Text('Your Expenses:', style: TextStyle(fontWeight: FontWeight.bold)),
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


