import 'package:emeraldbank_mobileapp/models/user_model.dart';
import 'package:flutter/material.dart';

class SendPage extends StatelessWidget {
  final UserModel? user;

  const SendPage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send Page")),
      body: Center(child: Text("User email: ${user?.email ?? 'No user'}")),
    );
  }
}
