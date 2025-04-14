import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/addingAccounts/addingaccountloans_page.dart';
import 'package:flutter/material.dart';

class LoansPage extends StatelessWidget {
  const LoansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddingAccountLoansPage(),
              ),
            ),
        backgroundColor: Colors.green.shade600,
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: const Icon(Icons.add, size: 32.0, color: Colors.white),
      ),
      appBar: AppBar(title: const Text('Loans')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Loans Accounts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add your savings account details here
          ],
        ),
      ),
    );
  }
}
