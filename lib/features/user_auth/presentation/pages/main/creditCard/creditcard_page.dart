import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/addingAccounts/addingaccountcreditcards_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/accountspage_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/color_style.dart';
import 'package:flutter/material.dart';

class CreditcardPage extends StatefulWidget {
  const CreditcardPage({super.key});

  @override
  _CreditcardPageState createState() => _CreditcardPageState();
}

class _CreditcardPageState extends State<CreditcardPage> {
  bool _eyeEnabled = false;

  void _toggleEye() {
    setState(() {
      _eyeEnabled = !_eyeEnabled;
    });
    // Implementation Here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AccountsPageAppbar(
        title: 'Credit Card',
        onEyeToggle: _toggleEye,
        eyeEnabled: _eyeEnabled,
      ),

      floatingActionButton: Material(
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(gradient: Customgradients.iconGradient),
          child: InkWell(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddingAccountCreditCardsPage(),
                  ),
                ),
            child: const SizedBox(
              width: 56,
              height: 56,
              child: Icon(Icons.add, size: 32.0, color: Colors.white),
            ),
          ),
        ),
      ),

      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Credit Card Accounts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add your savings account details here
          ],
        ),
      ),
    );
  }
}
