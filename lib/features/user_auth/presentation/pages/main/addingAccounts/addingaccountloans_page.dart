import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddingAccountLoansPage extends StatefulWidget {
  const AddingAccountLoansPage({super.key});

  @override
  State<AddingAccountLoansPage> createState() => _AddingAccountLoansPageState();
}

class _AddingAccountLoansPageState extends State<AddingAccountLoansPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _loanTermController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _searchDataDropDownController = TextEditingController();

  String? _selectedBank;
  String? _selectedLoanType;
  List<String> _banks = [];
  List<String> _loanTypes = [];
  bool _isLoading = true;
  bool _accountNumberVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _loanTermController.dispose();
    _transactionIdController.dispose();
    _searchDataDropDownController.dispose();
    super.dispose();
  }

  // Fetches Banks List
  // Fetches Loan Types
  // Fetches data stored in firestore
  Future<void> _fetchDropdownData() async {
    setState(() => _isLoading = true);

    try {
      // Fetch Banks Handler
      final bankSnapshot =
          await FirebaseFirestore.instance.collection('banks').get();
      final banks =
          bankSnapshot.docs.map((doc) => doc['later2'] as String).toList();

      // Fetch Loan Types Handler
      final loanTypeSnapshot =
          await FirebaseFirestore.instance.collection('loanTypes').get();
      final loanTypes =
          loanTypeSnapshot.docs.map((doc) => doc['later1'] as String).toList();

      // Default values, testing purposes
      if (banks.isEmpty || loanTypes.isEmpty) {
        // use default values
        setState(() {
          _banks = ['BANK1', 'BANK2', 'BANK3', 'BANK4', 'BANK5', 'BANK6'];
          _loanTypes = [
            'PERSONAL LOAN',
            'HOME LOAN',
            'AUTO LOAN',
            'STUDENT LOAN',
            'BUSINESS LOAN',
          ];
          _isLoading = false;
        });
        print('Using Default Values');
      } else {
        setState(() {
          _banks = banks;
          _loanTypes = loanTypes;
          _isLoading = false;
        });
        print('Using fetched values from Firestore');
      }
      print('Fetched Banks: $_banks');
      print('Fetched Loan Types: $_loanTypes');
    } catch (e) {
      // This catch block handles exceptions from Firestore
      print('Error Fetching data: $e');
      setState(() {
        _banks = ['BDO', 'METROBANK', 'SECURITY BANK', 'UNIONBANK'];
        _loanTypes = [
          'PERSONAL LOAN',
          'HOME LOAN',
          'AUTO LOAN',
          'STUDENT LOAN',
          'BUSINESS LOAN',
        ];
        _isLoading = false;
      });
      print('Fetched Banks: $_banks');
      print('Fetched Loan Types: $_loanTypes');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process later the formd data and firestore saving
      // Firestore Logic Here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loan Account Added Successfully')),
      );
      // Navigate to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Loan Account'),
        backgroundColor: Colors.green.shade700,
      ),

      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 64.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information Form Section
                      _buildSectionHeader('Personal Information'),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Account Holder Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Account Holder Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date of Birth
                      TextFormField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.calendar_today),
                          //   hintText: DateFormat(
                          //     'yyyy-MM-dd',
                          //   ).format(DateTime.now()),
                          suffixIcon: IconButton(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select date of birth';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Contact Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter contact number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email address';
                          } else if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Home Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.home),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter home address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Loan Account Form Infromation Section
                      _buildSectionHeader('Loan Account Information'),
                      const SizedBox(height: 16),

                      // Bank Dropdown
                      DropdownButtonFormField2<String>(
                        value: _selectedBank,
                        decoration: const InputDecoration(
                          labelText: 'Bank Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.account_balance),
                        ),
                        items:
                            _banks.map((String bank) {
                              return DropdownMenuItem(
                                value: bank,
                                child: Text(bank),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedBank = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a bank';
                          }
                          return null;
                        },
                        isExpanded: true,
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.green,
                          ),
                        ),
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 12),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          selectedMenuItemBuilder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withAlpha(51),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: child,
                            );
                          },
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: _searchDataDropDownController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: _searchDataDropDownController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Search Bank',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return item.value.toString().toLowerCase().contains(
                              searchValue.toLowerCase(),
                            );
                          },
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            _searchDataDropDownController.clear();
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _accountNumberController,
                        decoration: InputDecoration(
                          labelText: 'Loan Account Number',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.numbers),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _accountNumberVisible = !_accountNumberVisible;
                              });
                            },
                            icon: Icon(
                              _accountNumberVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        obscureText: !_accountNumberVisible,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter loan account number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Loan Dropdown
                      DropdownButtonFormField2<String>(
                        value: _selectedLoanType,
                        decoration: const InputDecoration(
                          labelText: 'Loan Type',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items:
                            _loanTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLoanType = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a loan type';
                          }
                          return null;
                        },
                        isExpanded: true,
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.green,
                          ),
                        ),
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 12),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          selectedMenuItemBuilder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withAlpha(51),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: child,
                            );
                          },
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: _searchDataDropDownController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: _searchDataDropDownController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                hintText: 'Search Loan Type',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return item.value.toString().toLowerCase().contains(
                              searchValue.toLowerCase(),
                            );
                          },
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            _searchDataDropDownController.clear();
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _loanTermController,
                        decoration: const InputDecoration(
                          labelText: 'Loan Term (months)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.date_range),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter loan term';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Last Transaction Number Field
                      TextFormField(
                        controller: _transactionIdController,
                        decoration: const InputDecoration(
                          labelText: 'Last Loan Payment ID Transaction',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.receipt_long),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last payment transcation ID';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Add Loan Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}
