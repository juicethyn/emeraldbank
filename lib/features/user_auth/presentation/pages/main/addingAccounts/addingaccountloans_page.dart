import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/adding_account_form_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/color_style.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/text_style.dart';
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
  bool _isLoanTypesLoading = false;
  bool _accountNumberVisible = false;
  Map<String, String> _bankNameToIdMap = {};

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
          bankSnapshot.docs.map((doc) {
            return {'id': doc.id, 'name': doc['bank_name'] as String};
          }).toList();

      // Build the Mapping between bank names and IDs
      _bankNameToIdMap = {
        for (var bank in banks) bank['name'] as String: bank['id'] as String,
      };

      setState(() {
        _banks = banks.map((bank) => bank['name'] as String).toList();
        _loanTypes = [];
        _selectedBank = null;
        _selectedLoanType = null;
        _isLoading = false;
      });
    } catch (e) {
      print('Error Fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchLoanProducts(String bankName) async {
    setState(() => _isLoanTypesLoading = true);
    try {
      final bankId = _bankNameToIdMap[bankName];

      if (bankId != null) {
        final loanProductSnapshot =
            await FirebaseFirestore.instance
                .collection('banks')
                .doc(bankId)
                .collection('loanProducts')
                .get();

        final loanTypes =
            loanProductSnapshot.docs
                .map((doc) => doc['name'] as String)
                .toList();

        setState(() {
          _loanTypes = loanTypes;
          _selectedLoanType = null;
          _isLoanTypesLoading = false;
        });
      }
    } catch (e) {
      print('Error Fetching data: $e');
      setState(() {
        _loanTypes = [];
        _isLoanTypesLoading = false;
      });
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
        _dobController.text = DateFormat('MM/dd/yyyy').format(picked);
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
      appBar: const AddingAccountFormAppbar(title: 'Add Loan Account'),

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
                      // ----------------------------------------------------
                      // PERSONAL INFORMATION SECTION
                      // ----------------------------------------------------
                      _buildSectionHeader('Personal Information'),
                      const SizedBox(height: 16),

                      // Account Holder Name Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Account Holder Name (Full Name)',
                            style: FormStyles.labelStyle,
                          ),

                          const SizedBox(height: 2),

                          TextFormField(
                            controller: _nameController,
                            style: FormStyles.inputTextStyle,
                            decoration: FormStyles.textFieldDecoration(
                              hintText: 'ex. Juan Dela Cruz',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Account Holder Name';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Date of Birth Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date of Birth',
                            style: FormStyles.labelStyle,
                          ),

                          const SizedBox(height: 2),

                          TextFormField(
                            controller: _dobController,
                            style: FormStyles.inputTextStyle,
                            decoration: FormStyles.textFieldDecoration(
                              // labelText: 'Date of Birth',
                              // prefixIcon: const Icon(Icons.calendar_today),
                              //   hintText: DateFormat(
                              //     'yyyy-MM-dd',
                              //   ).format(DateTime.now()),
                              hintText: 'YYYY-MM-DD',
                              suffixIcon: IconButton(
                                onPressed: () => _selectDate(context),
                                icon: const Icon(Icons.calendar_month),
                                color: Color(0xFF044E42),
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
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Contact Number Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contact Number',
                            style: FormStyles.labelStyle,
                          ),

                          const SizedBox(height: 2),

                          TextFormField(
                            controller: _phoneController,
                            style: FormStyles.inputTextStyle,
                            decoration: FormStyles.textFieldDecoration(
                              hintText: 'Contact Number',
                              // prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter contact number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Registered Email Address Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email Address',
                            style: FormStyles.labelStyle,
                          ),

                          const SizedBox(height: 2),

                          TextFormField(
                            controller: _emailController,
                            style: FormStyles.inputTextStyle,
                            decoration: FormStyles.textFieldDecoration(
                              hintText: 'Email Address',
                              // prefixIcon: Icon(Icons.email),
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
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Registered Address Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Home Address',
                            style: FormStyles.labelStyle,
                          ),

                          const SizedBox(height: 2),

                          TextFormField(
                            controller: _addressController,
                            style: FormStyles.inputTextStyle,
                            decoration: FormStyles.textFieldDecoration(
                              hintText: 'Home Address',
                              // prefixIcon: Icon(Icons.home),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter home address';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ----------------------------------------------------
                      // LOAN ACCOUNT INFORMATION SECTION
                      // ----------------------------------------------------
                      _buildSectionHeader('Loan Account Information'),
                      const SizedBox(height: 16),

                      // Bank Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Associated Bank',
                            style: FormStyles.labelStyle,
                          ),

                          const SizedBox(height: 2),

                          // DropdownField
                          DropdownButtonFormField2<String>(
                            isExpanded: true,

                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),

                            hint: Text(
                              'Choose Associated Bank',
                              style: FormStyles.hintStyle,
                            ),

                            items:
                                _banks.map((String bank) {
                                  return DropdownMenuItem(
                                    value: bank,
                                    child: Text(
                                      bank,
                                      style: FormStyles.inputTextStyle,
                                    ),
                                  );
                                }).toList(),

                            value: _selectedBank,

                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedBank = newValue;
                                _selectedLoanType = null;
                              });

                              if (newValue != null) {
                                _fetchLoanProducts(newValue);
                              }
                            },

                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              offset: const Offset(0, -12),
                            ),

                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF044E42),
                              ),
                            ),

                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              width: double.infinity,
                            ),

                            menuItemStyleData: MenuItemStyleData(
                              selectedMenuItemBuilder: (context, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF044E42).withAlpha(51),
                                  ),
                                  child: child,
                                );
                              },
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a bank';
                              }
                              return null;
                            },

                            dropdownSearchData: DropdownSearchData(
                              searchController: _searchDataDropDownController,
                              searchInnerWidgetHeight: 70,
                              searchInnerWidget: Container(
                                height: 70,
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  style: FormStyles.inputTextStyle,
                                  expands: true,
                                  maxLines: null,
                                  controller: _searchDataDropDownController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Search Bank',
                                    hintStyle: FormStyles.hintStyle,

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF06D6A0),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              searchMatchFn: (item, searchValue) {
                                return item.value
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase());
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
                        ],
                      ),

                      SizedBox(height: 16),

                      // Loan Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Loan Type', style: FormStyles.labelStyle),

                          const SizedBox(height: 2),

                          // DropdownField
                          DropdownButtonFormField2<String>(
                            isExpanded: true,

                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),

                            hint: Text(
                              'Choose Loan Type',
                              style: FormStyles.hintStyle,
                            ),

                            items:
                                _loanTypes.map((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: FormStyles.inputTextStyle,
                                    ),
                                  );
                                }).toList(),

                            value: _selectedLoanType,

                            onChanged:
                                _isLoanTypesLoading
                                    ? null
                                    : (String? newValue) {
                                      setState(() {
                                        _selectedLoanType = newValue;
                                      });
                                    },

                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              offset: const Offset(0, -12),
                            ),

                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF044E42),
                              ),
                            ),

                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              width: double.infinity,
                            ),

                            menuItemStyleData: MenuItemStyleData(
                              selectedMenuItemBuilder: (context, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF044E42).withAlpha(51),
                                  ),
                                  child: child,
                                );
                              },
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a loan type';
                              }
                              return null;
                            },

                            dropdownSearchData: DropdownSearchData(
                              searchController: _searchDataDropDownController,
                              searchInnerWidgetHeight: 70,
                              searchInnerWidget: Container(
                                height: 70,
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: _searchDataDropDownController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Search Loan Type',
                                    hintStyle: FormStyles.hintStyle,

                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF06D6A0),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              searchMatchFn: (item, searchValue) {
                                return item.value
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchValue.toLowerCase());
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
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Loan Account Number
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Account Number', style: FormStyles.labelStyle),

                          SizedBox(height: 2),

                          TextFormField(
                            controller: _accountNumberController,
                            decoration: FormStyles.textFieldDecoration(
                              hintText: 'Loan Account Number',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _accountNumberVisible =
                                        !_accountNumberVisible;
                                  });
                                },
                                icon: Icon(
                                  _accountNumberVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0xFF044E42),
                                ),
                              ),
                            ),
                            obscureText: !_accountNumberVisible,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter account number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Loan Term (in months)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Loan Term (Months)',
                            style: FormStyles.labelStyle,
                          ),

                          SizedBox(height: 2),

                          TextFormField(
                            controller: _loanTermController,
                            decoration: FormStyles.textFieldDecoration(
                              hintText: 'Loan Term (months)',
                              //   prefixIcon: Icon(Icons.date_range),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter loan term';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Last Transaction Number Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Loan Payment ID Transaction',
                            style: FormStyles.labelStyle,
                          ),

                          SizedBox(height: 2),

                          TextFormField(
                            controller: _transactionIdController,
                            decoration: FormStyles.textFieldDecoration(
                              hintText: 'Last Loan Payment ID Transaction',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter last payment transcation ID';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: Customgradients.iconGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Add Loan Account',
                              style: FormStyles.submitFormButtonLabel,
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
        Text(title, style: FormStyles.sectionHeaderStyle),
        Divider(thickness: 1, color: const Color(0xFF1a1819).withAlpha(128)),
      ],
    );
  }
}
