import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _subscriberRefController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _schedule;
  String? _occurrence;
  String? _frequency;

  final List<String> _scheduleOptions = ['Immediate', 'Later'];
  final List<String> _occurrenceOptions = ['One-time', 'Repeating'];
  final List<String> _frequencyOptions = ['Once', 'Twice', 'Thrice'];

  // Permanent account info stored in app
  final String fixedAccountHolderName = 'Juzzthyn Perez';
  final String fixedAccountNumber = '3690 1234 5678 1630';

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

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Fixed, non-editable account holder name
                    _buildFixedInfoField(
                      label: 'Account Holder Name (Full Name)',
                      value: fixedAccountHolderName,
                    ),

                    // Fixed, non-editable account number
                    _buildFixedInfoField(
                      label: 'Account Number',
                      value: fixedAccountNumber,
                    ),

                    // Editable subscriber/reference number
                    _buildTextField(
                      label: 'Subscriber / Reference Number',
                      controller: _subscriberRefController,
                    ),

                    // Editable amount field
                    _buildTextField(
                      label: 'Amount',
                      hint: '0.00',
                      inputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      controller: _amountController,
                    ),

                    _buildDropdownField(
                      label: 'Schedule of Payment',
                      value: _schedule,
                      items: _scheduleOptions,
                      onChanged: (val) {
                        setState(() {
                          _schedule = val;
                          _occurrence = null;
                          _frequency = null;
                          _paymentDateController.clear();
                          _endDateController.clear();
                        });
                      },
                    ),

                    if (_schedule == 'Later')
                      _buildDropdownField(
                        label: 'Occurrence of Payment',
                        value: _occurrence,
                        items: _occurrenceOptions,
                        onChanged: (val) {
                          setState(() {
                            _occurrence = val;
                            _frequency = null;
                            _paymentDateController.clear();
                            _endDateController.clear();
                          });
                        },
                      ),

                    if (_schedule == 'Later' && _occurrence == 'Repeating')
                      _buildDropdownField(
                        label: 'Frequency of Payment',
                        value: _frequency,
                        items: _frequencyOptions,
                        onChanged: (val) => setState(() => _frequency = val),
                      ),

                    if (_schedule == 'Later' &&
                        (_occurrence == 'One-time' || _occurrence == 'Repeating'))
                      _buildDatePickerField(
                        controller: _paymentDateController,
                        label: 'Payment Date',
                        note:
                            'Scheduled transactions will run from 8:30 am to 9:30 am on the selected dates.',
                      ),

                    if (_schedule == 'Later' && _occurrence == 'Repeating')
                      _buildDatePickerField(
                        controller: _endDateController,
                        label: 'End Date',
                      ),

                    _buildTextField(
                      label: 'Notes (Optional)',
                      hint: 'Enter Notes',
                      controller: _notesController,
                      isOptional: true,
                    ),

                    SizedBox(height: 16),
                    Text(
                      'Note that our billing postings are completed within 24 hours.\n\n'
                      'Pay your bills before their due date to avoid problems. If you receive a disconnection notice, '
                      'please pay at a Service Center.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),

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
                                  accountHolder: fixedAccountHolderName,
                                  amount: _amountController.text,
                                  paymentDate: _paymentDateController.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Proceed',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
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
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) {
          if (isOptional) return null;
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
        validator: (val) {
          if (label.contains('(Optional)')) return null;
          return val == null ? 'Please select an option' : null;
        },
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

  // New widget to display fixed info fields (non-editable)
  Widget _buildFixedInfoField({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: value,
        enabled: false, // disables editing and grays out the field
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade300,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}