import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/adding_account_form_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/color_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/text_style.dart';

class AddingAccountCreditCardsPage extends StatefulWidget {
  const AddingAccountCreditCardsPage({super.key});

  @override
  State<AddingAccountCreditCardsPage> createState() =>
      _AddingAccountCreditCardsPage();
}

class _AddingAccountCreditCardsPage
    extends State<AddingAccountCreditCardsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _creditCardNumberController = TextEditingController();
  final _cvvcvc = TextEditingController();
  final _searchDataDropDownController = TextEditingController();

  String? _selectedBank;
  String? _selectedCardType;
  List<String> _banks = [];
  List<String> _creditCardTypes = [];
  bool _isLoading = true;
  bool _isCardTypesLoading = false;
  bool _cvvVisible = false;
  bool _accountNumberVisible = false;
  bool _creditCardNumberVisible = false;
  Map<String, String> _bankNameToIdMap = {};

  @override
  void initState() {
    super.initState();
    _fetchDropDownData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _accountNumberController.dispose();
    _creditCardNumberController.dispose();
    _cvvcvc.dispose();
    _searchDataDropDownController.dispose();
    super.dispose();
  }

  // Fetches Bnnk List
  // Fetches Card Types
  // Fetches data stored in Firstore
  Future<void> _fetchDropDownData() async {
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
        _creditCardTypes = [];
        _selectedBank = null;
        _selectedCardType = null;
        _isLoading = false;
      });
    } catch (e) {
      print('Error Fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCreditCardProducts(String bankName) async {
    setState(() => _isCardTypesLoading = true);

    try {
      final bankId = _bankNameToIdMap[bankName];
      print('Fetching credit card products for bank: $bankName, ID: $bankId');

      if (bankId != null) {
        final creditCardProductSnapshot =
            await FirebaseFirestore.instance
                .collection('banks')
                .doc(bankId)
                .collection('creditCardsProducts')
                .get();

        print(
          'Found ${creditCardProductSnapshot.docs.length} credit card products',
        );

        creditCardProductSnapshot.docs.forEach((doc) {
          print('Product: ${doc['name']}');
        });

        final creditCardTypes =
            creditCardProductSnapshot.docs
                .map((doc) => doc['name'] as String)
                .toList();

        setState(() {
          _creditCardTypes = creditCardTypes;
          _selectedCardType = null;
          _isCardTypesLoading = false;
        });
      }
    } catch (e) {
      print('Error Fetching data: $e');
      setState(() {
        _creditCardTypes = [];
        _isCardTypesLoading = false;
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
      // Process later the forms data and firsastore savings
      // Firestore logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credit Card Account Added Successfully')),
      );
      // Navigate to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AddingAccountFormAppbar(title: 'Add Credit Card Account'),

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
                      // CREDIT CARD INFORMATION SECTION
                      // ----------------------------------------------------
                      _buildSectionHeader('Credit Card Account Information'),
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
                                _selectedCardType = null;
                              });

                              if (newValue != null) {
                                _fetchCreditCardProducts(newValue);
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

                      const SizedBox(height: 16),

                      // Credit Card Type Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Credit Card Type',
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
                              'Choose Credit Card Type',
                              style: FormStyles.hintStyle,
                            ),

                            items:
                                _creditCardTypes.map((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: FormStyles.inputTextStyle,
                                    ),
                                  );
                                }).toList(),

                            value: _selectedCardType,

                            onChanged:
                                _isCardTypesLoading
                                    ? null
                                    : (String? newValue) {
                                      setState(() {
                                        _selectedCardType = newValue;
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
                                    hintText: 'Search Credit Card Type',
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

                      // Account Number Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Account Number', style: FormStyles.labelStyle),

                          SizedBox(height: 2),

                          TextFormField(
                            controller: _accountNumberController,
                            decoration: FormStyles.textFieldDecoration(
                              hintText: 'Account Number',
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

                      // Credit Card Number Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Credit Card Number',
                            style: FormStyles.labelStyle,
                          ),

                          SizedBox(height: 2),

                          TextFormField(
                            controller: _creditCardNumberController,
                            decoration: FormStyles.textFieldDecoration(
                              hintText: 'Credit Card Number',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _creditCardNumberVisible =
                                        !_creditCardNumberVisible;
                                  });
                                },
                                icon: Icon(
                                  _creditCardNumberVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0xFF044E42),
                                ),
                              ),
                            ),
                            obscureText: !_creditCardNumberVisible,
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

                      // CVV/CVC
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CVV/CVC Code', style: FormStyles.labelStyle),

                          SizedBox(height: 2),

                          TextFormField(
                            controller: _cvvcvc,
                            decoration: FormStyles.textFieldDecoration(
                              hintText: 'CVV / CVC',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _cvvVisible = !_cvvVisible;
                                  });
                                },
                                icon: Icon(
                                  _cvvVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0xFF044E42),
                                ),
                              ),
                            ),
                            obscureText: !_cvvVisible,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid cvv/cvc code';
                              }
                              if (value.length < 3 || value.length > 4) {
                                return 'CVV/CVC must be 3 or 4 digits';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: Customgradients.iconGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Add Credit Card Account',
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
