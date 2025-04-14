import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/creditCard/creditcard_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/loans/loans_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/savings/savings_page.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Accounts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildServiceCard(
                      context,
                      'Savings',
                      Icons.savings,
                      Colors.blue.shade100,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavingsPage(),
                        ),
                      ),
                    ),
                    _buildServiceCard(
                      context,
                      'Credit Cards',
                      Icons.credit_card,
                      Colors.purple.shade100,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreditcardPage(),
                        ),
                      ),
                    ),
                    _buildServiceCard(
                      context,
                      'Loans',
                      Icons.account_balance,
                      Colors.orange.shade100,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoansPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
