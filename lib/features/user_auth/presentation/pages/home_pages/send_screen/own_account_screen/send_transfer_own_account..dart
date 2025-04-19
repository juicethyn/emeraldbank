import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/send_screen/own_account_screen/confirmation_ownaccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OwnAccountPage extends StatefulWidget {
  const OwnAccountPage({super.key});

  @override
  State<OwnAccountPage> createState() => OwnAccountPageState();
}

class OwnAccountPageState extends State<OwnAccountPage> {
  String? sendFrom;
  String? sendTo;
  final amountController = TextEditingController();
  final purposeController = TextEditingController();

  // ✅ Custom input formatter allowing up to 2 decimal places only
  final amountInputFormatter = TextInputFormatter.withFunction(
    (oldValue, newValue) {
      final text = newValue.text;
      if (RegExp(r'^\d*\.?\d{0,2}$').hasMatch(text)) {
        return newValue;
      }
      return oldValue;
    },
  );

  void clearFields() {
    setState(() {
      sendFrom = null;
      sendTo = null;
      amountController.clear();
      purposeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Send | Own Account',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Own Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.03),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  buildDropdownField(
                    label: "Send from",
                    value: sendFrom,
                    onChanged: (val) => setState(() => sendFrom = val),
                    items: const [
                      'Emerald Bank Savings 1',
                      'Emerald Bank Savings 2',
                    ],
                  ),
                  const SizedBox(height: 16),
                  buildDropdownField(
                    label: "Send to",
                    value: sendTo,
                    onChanged: (val) => setState(() => sendTo = val),
                    items: const [
                      'Emerald Bank Savings 1',
                      'Emerald Bank Savings 2',
                    ],
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: amountController,
                    label: "Amount",
                    hintText: "₱0.00",
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [amountInputFormatter],
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        text: 'You have a current balance of ',
                        children: [
                          TextSpan(
                            text: '₱53,501',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 95, 71),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: purposeController,
                    label: "Purpose of transaction (Optional)",
                    hintText: "",
                    maxLines: 4,
                    maxLength: 200,
                    inputFormatters: [],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: clearFields,
                        child: const Text(
                          "Clear all fields",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          if (sendFrom == null || sendTo == null || amountController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in all required fields.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmationPage(
                                amount: double.parse(amountController.text), // Pass the entered amount
                                purpose: purposeController.text,
                                fromAccount: sendFrom!,
                                toAccount: sendTo!,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Confirmation",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownField({
    required String label,
    required String? value,
    required void Function(String?) onChanged,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: value == null
              ? DropdownButtonFormField<String>(
                  value: value,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    hintText: "Select an existing account",
                  ),
                  isExpanded: true,
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Colors.teal,
                  ),
                  items: items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: onChanged,
                )
              : Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C191), Color(0xFF00E0A8)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ...items.map((item) {
                        return GestureDetector(
                          onTap: () => onChanged(item),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Emerald Bank Savings',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '4363 **** **** ****',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: const [
                                    Text(
                                      'Available Balance',
                                      style: TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                    Text(
                                      '₱53,501.25',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                if (item == value)
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    int? maxLines,
    int? maxLength,
    required List<TextInputFormatter> inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines ?? 1,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }
}

class A6E {}
