import 'package:flutter/material.dart';
import 'package:my_pocket_wallet/screens/pages/account.dart';
import 'package:my_pocket_wallet/screens/pages/mobile_recharge.dart';
import 'package:my_pocket_wallet/screens/pages/pay_bill.dart';
import 'package:my_pocket_wallet/screens/pages/transfer.dart';
import 'package:my_pocket_wallet/screens/pages/withdraw.dart';

class Homecontent extends StatelessWidget {
  const Homecontent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _upperText(),
            _materCardSection(),
            const SizedBox(height: 30),
            _middleScreenButtons(context),
          ],
        ),
      ),
    );
  }

  // Grid Menu Section
  Widget _middleScreenButtons(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          _buildMenuItem(
            Icons.account_balance_wallet,
            'Account\nand Card',
            () => _navigateWithTransition(context, const AccountAndCardPage()),
          ),
          _buildMenuItem(
            Icons.swap_horiz,
            'Transfer',
            () => _navigateWithTransition(context, const TransferPage()),
          ),
          _buildMenuItem(
            Icons.attach_money,
            'Withdraw',
            () => _navigateWithTransition(context, const WithdrawPage()),
          ),
          _buildMenuItem(
            Icons.phone_android,
            'Mobile\nrecharge',
            () => _navigateWithTransition(context, const MobileRechargePage()),
          ),
          _buildMenuItem(
            Icons.receipt,
            'Pay the bill',
            () => _navigateWithTransition(context, const PayTheBillPage()),
          ),
        ],
      ),
    );
  }

  // Menu Item Widget
  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade800,
            child: Icon(icon, color: Colors.orangeAccent, size: 30),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // Greeting Section
  Widget _upperText() {
    return const Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning,',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            'Gega!',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Card Section
  Widget _materCardSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue.shade800,
        border: Border.all(color: Colors.orangeAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gega Smith',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'OverBridge Expert',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '4756 •••• •••• 9018',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '\$3,469.52',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'VISA',
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable navigation function with fade transition
  void _navigateWithTransition(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
