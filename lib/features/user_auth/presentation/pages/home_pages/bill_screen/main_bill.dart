import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'confirmation_receiptbill.dart';

class MainBillPage extends StatefulWidget {
  final String billerName;

  MainBillPage({required this.billerName});

  @override
  _MainBillPageState createState() => _MainBillPageState();
}

class _MainBillPageState extends State<MainBillPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _paymentDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String? _schedule;
  String? _occurrence;
  String? _frequency;

  final List<String> _scheduleOptions = ['One-time', 'Recurring'];
  final List<String> _occurrenceOptions = ['Daily', 'Weekly', 'Monthly'];
  final List<String> _frequencyOptions = ['Once', 'Twice', 'Thrice'];

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('MM/dd/yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Color(0xFF00695c),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Pay Bills', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Biller Info
              Center(
                child: Column(
                  children: [
                    Text(
                      'YOU ARE PAYING FOR',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.receipt_long, size: 40, color: Colors.white),
                    ),
                    SizedBox(height: 12),
                    Text(
                      widget.billerName.toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(label: 'Account Holder Name (Full Name)', hint: 'ex. Juan Dela Cruz'),
                    _buildTextField(label: 'Account Number', hint: '*** *** ****'),
                    _buildTextField(label: 'Subscriber / Reference Number'),
                    _buildTextField(label: 'Amount', hint: 'Php. 0.00', inputType: TextInputType.number),

                    _buildDropdownField(
                      label: 'Schedule of Payment',
                      value: _schedule,
                      items: _scheduleOptions,
                      onChanged: (val) => setState(() => _schedule = val),
                    ),
                    _buildDropdownField(
                      label: 'Occurrence of Payment',
                      value: _occurrence,
                      items: _occurrenceOptions,
                      onChanged: (val) => setState(() => _occurrence = val),
                    ),
                    _buildDropdownField(
                      label: 'Frequency of Payment',
                      value: _frequency,
                      items: _frequencyOptions,
                      onChanged: (val) => setState(() => _frequency = val),
                    ),

                    _buildDatePickerField(
                      controller: _paymentDateController,
                      label: 'Payment Date',
                      note: 'Scheduled transactions will run from 8:30 am to 9:30 am on the selected dates.',
                    ),
                    _buildDatePickerField(
                      controller: _endDateController,
                      label: 'End Date',
                    ),

                    _buildTextField(label: 'Notes (Optional)', hint: 'Enter Notes'),

                    SizedBox(height: 16),
                    Text(
                      'Note that our billing postings are completed within 24 hours.\n\n'
                      'Pay your bills before their due date to avoid problems. If you receive a disconnection notice, '
                      'please pay at a ________ Center.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),

                    // Proceed Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00695c),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConfirmationReceiptBillPage(
                                  billerName: widget.billerName,
                                  accountHolder: '', // Hook this up later
                                  amount: '', // Hook this up later
                                  paymentDate: _paymentDateController.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('Proceed', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) {
          if (label.contains('(Optional)')) return null;
          return (value == null || value.isEmpty) ? 'This field is required' : null;
        },
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Please select an option' : null,
      ),
    );
  }

  Widget _buildDatePickerField({
    required TextEditingController controller,
    required String label,
    String? note,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            readOnly: true,
            onTap: () => _selectDate(context, controller),
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Please select a date' : null,
          ),
          if (note != null) ...[
            SizedBox(height: 4),
            Text(
              note,
              style: TextStyle(fontSize: 10, color: Colors.black54),
            )
          ]
        ],
      ),
    );
  }
}
