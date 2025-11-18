import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Transfer App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TransferPage(),
    );
  }
}

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  int _currentPage = 0;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  String recipientName = '';
  String amount = '';
  String selectedPaymentMethod = 'Bank';
  bool isFavorite = false;
  bool isProcessing = false;

  final List<String> paymentMethods = ['Bank', 'Mobile Wallet', 'Card'];

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _navigateNext() => setState(() => _currentPage < 2 ? _currentPage++ : null);
  void _navigateBack() => setState(() => _currentPage > 0 ? _currentPage-- : null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        title: const Text('Transfer Money', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
        centerTitle: true,
        leading: _currentPage > 0
            ? IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: _navigateBack)
            : null,
      ),
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 400), child: _buildPage(_currentPage)),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildSearchScreen();
      case 1:
        return _buildConfirmationScreen();
      case 2:
        return _buildSuccessScreen();
      default:
        return const Center(child: Text('Invalid page'));
    }
  }

  Widget _buildSearchScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Transfer money to', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        const Text('Enter name, phone number, or account number', style: TextStyle(fontSize: 16, color: Colors.white70)),
        const SizedBox(height: 20),
        TextField(controller: _searchController, style: const TextStyle(color: Colors.white), decoration: _inputDecoration('Recipient Name / Phone / Account')),
        const SizedBox(height: 16),
        TextField(controller: _amountController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: _inputDecoration('Enter Amount')),
        const SizedBox(height: 16),

        // Payment Method Dropdown
        DropdownButtonFormField<String>(
          value: selectedPaymentMethod,
          decoration: _inputDecoration('Select Payment Method'),
          dropdownColor: Colors.blue.shade800,
          style: const TextStyle(color: Colors.white),
          items: paymentMethods.map((method) => DropdownMenuItem(value: method, child: Text(method, style: const TextStyle(color: Colors.white)))).toList(),
          onChanged: (value) => setState(() => selectedPaymentMethod = value!),
        ),

        const SizedBox(height: 16),

        // Favorite toggle
        Row(
          children: [
            Switch(
              value: isFavorite,
              onChanged: (val) => setState(() => isFavorite = val),
              activeColor: Colors.orangeAccent,
            ),
            const Text('Add to Favorites', style: TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),

        const SizedBox(height: 20),
        ElevatedButton(onPressed: _continueFromSearch, style: _buttonStyle(), child: const Text('Continue')),
      ]),
    );
  }

  void _continueFromSearch() {
    if (_searchController.text.isEmpty || _amountController.text.isEmpty) {
      _showErrorSnackbar('Please fill all fields');
    } else {
      setState(() {
        recipientName = _searchController.text;
        amount = '\$${_amountController.text}';
      });
      _navigateNext();
    }
  }

  Widget _buildConfirmationScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Confirm Transfer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 20),
        ListTile(
          leading: const CircleAvatar(backgroundColor: Colors.orangeAccent, child: Icon(Icons.person, color: Colors.white)),
          title: Text(recipientName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          subtitle: Text('Amount: $amount\nMethod: $selectedPaymentMethod', style: const TextStyle(fontSize: 16, color: Colors.white70)),
        ),
        const SizedBox(height: 20),
        TextField(controller: _pinController, obscureText: true, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: _inputDecoration('Enter PIN')),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: _confirmTransfer,
            style: _buttonStyle(),
            child: isProcessing ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirm Transfer')),
      ]),
    );
  }

  void _confirmTransfer() {
    if (_pinController.text.length < 4) {
      _showErrorSnackbar('Invalid PIN');
    } else {
      _navigateNext();
    }
  }

  Widget _buildSuccessScreen() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
        const SizedBox(height: 20),
        Text('Success! $amount sent to $recipientName', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 30),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _currentPage = 0;
                _searchController.clear();
                _amountController.clear();
                _pinController.clear();
                isFavorite = false;
                selectedPaymentMethod = 'Bank';
              });
            },
            style: _buttonStyle(),
            child: const Text('Done')),
      ]),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.blue.shade800,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.orangeAccent)),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.orangeAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red));
  }
}
