import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/send_screen/other_local_emerald/confirmation_otherbanks.dart';

import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/send_screen/own_account_screen/send_transfer_own_account..dart';
import 'package:emeraldbank_mobileapp/models/user_model.dart';
import 'package:flutter/material.dart';

class SendTransferScreen extends StatefulWidget {
  const SendTransferScreen({
    super.key,
    required this.user,
  });

  final UserModel? user;

  @override
  State<SendTransferScreen> createState() => _SendTransferScreenState();
}

class _SendTransferScreenState extends State<SendTransferScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = widget.user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Send Money',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00C191),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFEFFEEC), // Light greenish background
              ),
              child: Column(
                children: [
                  _buildOption(
                    title: 'Own Account',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OwnAccountPage(user: user),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildOption(
                    title: 'Other Emerald Accounts',
                    onTap: () {
                      try {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OwnAccountConfirmationPage(user: user),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error navigating: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildOption(
                    title: 'Other banks & E-wallets',
                    onTap: () {
                      // Navigate to Banks & E-wallets screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Color(0xFF00C191),
            ),
          ],
        ),
      ),
    );
  }
}