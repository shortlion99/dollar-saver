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
  TextEditingController expenseController = TextEditingController();
  File? _receiptImage;
  List<String> categorizedExpenses = []; // Store categorized expenses
  bool _isProcessing = false; // To track processing state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Transaction', style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  )),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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
      color:
          Colors.grey[100], // Slightly different background color for contrast
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
    print('Sending request with message: $message'); // Debug log
    final response = await _processUserInput(message);
    if (response.isNotEmpty) {
      setState(() {
        categorizedExpenses.add(response);
      });
      expenseController.clear();
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

  // Now handle the array of expenses
  final expenses = data['expenses'];
  String result = '';

  for (var expense in expenses) {
    String type = expense['expense'] ? 'Expense' : 'Income';
    result += 'Type: $type\n'
              'Category: ${expense['category']}\n'
              'Total: \$${expense['total']}\n';
              // 'Date: ${expense['date']}\n\n';
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
        if (response != null) {
          setState(() {
            categorizedExpenses.add(response);
            _isProcessing = false; // Stop processing
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Receipt uploaded: $response')));
        }
      }
    } catch (e) {
      setState(() {
        _isProcessing = false; // Stop processing in case of error
      });
      print('Error picking image: $e');
    }
  }
  Future<String?> _processReceipt(File receiptImage) async {
    final url = Uri.parse('http://localhost:3000/uploadReceipt'); // Your server URL
    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['userId'] = 'Etvdsmu2c0NCjwLr40FI' // Add your user ID here
        ..files.add(await http.MultipartFile.fromPath(
          'receipt',
          receiptImage.path,
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);

        // Extract total and merchant from the response
        final total = jsonData['details']['total'];
        final merchant = jsonData['details']['merchant'];

        return 'Total: \$${total}, Merchant: $merchant';
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
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

  // Widget _buildCategorizedExpenses() {
  //   if (categorizedExpenses.isEmpty) {
  //     return const Text('No categorized expenses yet.');
  //   }

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text('Categorized Expenses:',
  //           style: TextStyle(fontWeight: FontWeight.bold)),
  //       ListView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemCount: categorizedExpenses.length,
  //         itemBuilder: (context, index) {
  //           return Card(
  //             elevation: 2,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             margin: const EdgeInsets.symmetric(vertical: 8),
  //             child: ListTile(
  //               title: Text(categorizedExpenses[index]),
  //               leading: const Icon(Icons.attach_money, color: Colors.black),
  //               tileColor: Colors.grey[100],
  //             ),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildCategorizedExpenses() {
  if (categorizedExpenses.isEmpty) {
    return const Text('No categorized expenses yet.');
  }

  return Container(
    decoration: BoxDecoration(
      color: Colors.green[100], // Set the background color to a light green
      borderRadius: BorderRadius.circular(12), // Add rounded corners
    ),
    padding: const EdgeInsets.all(16.0), // Optional padding for better spacing
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Entries:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categorizedExpenses.length,
          itemBuilder: (context, index) {
            final expense = categorizedExpenses[index];
            return ListTile(
              title: Text(expense), // Display the entire expense string
            );
          },
        ),
      ],
    ),
  );
}


  @override
  void dispose() {
    expenseController.dispose();
    super.dispose();
  }
}
