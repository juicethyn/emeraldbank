import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/adding_account_form_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/color_style.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/text_style.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/services/account_verification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddingAccountSavingsPage extends StatefulWidget {
  const AddingAccountSavingsPage({super.key});

  @override
  State<AddingAccountSavingsPage> createState() =>
      _AddingAccountSavingsPageState();
}

class _AddingAccountSavingsPageState extends State<AddingAccountSavingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _cvvcvc = TextEditingController();
  final _searchDataDropDownController = TextEditingController();

  String? _selectedBank;
  String? _selectedSavingsType;
  List<String> _banks = [];
  List<String> _savingsTypes = [];
  bool _isLoading = true;
  bool _isSavingsTypeLoading = false;
  bool _accountNumberVisible = false;
  bool _cvvVisible = false;
  bool _isVerifying = false;
  Map<String, String> _bankNameToIdMap = {};
  Map<String, String> _savingsTypeToIdMap = {};
  final _accountVerificationService = AccountVerificationService();

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
    _accountNumberController.dispose();
    _cvvcvc.dispose();
    _searchDataDropDownController.dispose();
    super.dispose();
  }

  // Fetches Bank List
  // Fetches Savings Type
  // Fetches data stored in Firestore
  Future<void> _fetchDropdownData() async {
    setState(() => _isLoading = true);

    try {
      // fetch Banks handler
      final bankSnapshot =
          await FirebaseFirestore.instance.collection('banks').get();

      final banks =
          bankSnapshot.docs.map((doc) {
            return {'id': doc.id, 'name': doc['bank_name'] as String};
          }).toList();

      _bankNameToIdMap = {
        for (var bank in banks) bank['name'] as String: bank['id'] as String,
      };

      setState(() {
        _banks = banks.map((bank) => bank['name'] as String).toList();
        _savingsTypes = [];
        _selectedBank = null;
        _selectedSavingsType = null;
        _isLoading = false;
      });
    } catch (e) {
      print('Error Fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchSavingsProducts(String bankName) async {
    setState(() => _isSavingsTypeLoading = true);
    try {
      final bankId = _bankNameToIdMap[bankName];

      if (bankId != null) {
        final savingsProductSnapshot =
            await FirebaseFirestore.instance
                .collection('banks')
                .doc(bankId)
                .collection('savingsProducts')
                .get();

        // Store both name and ID
        final savingsTypes =
            savingsProductSnapshot.docs.map((doc) {
              return {'id': doc.id, 'name': doc['name'] as String};
            }).toList();

        // Create a map from name to ID for verification
        _savingsTypeToIdMap = {
          for (var type in savingsTypes)
            type['name'] as String: type['id'] as String,
        };

        setState(() {
          _savingsTypes =
              savingsTypes.map((type) => type['name'] as String).toList();
          _selectedSavingsType = null;
          _isSavingsTypeLoading = false;
        });
      }
    } catch (e) {
      print('Error Fetching data: $e');
      setState(() {
        _savingsTypes = [];
        _isSavingsTypeLoading = false;
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
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Show verification in progress
      setState(() {
        _isVerifying = true;
      });

      try {
        final selectedBankId =
            _selectedBank != null ? _bankNameToIdMap[_selectedBank!] : null;
        final selectedSavingsTypeId =
            _selectedSavingsType != null && selectedBankId != null
                ? _savingsTypeToIdMap[_selectedSavingsType!]
                : null;

        // Attempt to verify the account
        final verificationResult = await _accountVerificationService
            .verifySavingsAccount(
              accountNumber: _accountNumberController.text,
              accountHolderName: _nameController.text,
              dateOfBirth: _dobController.text,
              contactNumber: _phoneController.text,
              emailAddress: _emailController.text,
              bankId: selectedBankId,
              savingsTypeId: selectedSavingsTypeId,
            );

        setState(() {
          _isVerifying = false;
        });

        if (verificationResult.isValid &&
            verificationResult.accountData != null) {
          // Add the verified account to user's profile
          final accountPath = verificationResult.accountData!['path'] as String;
          final success = await _accountVerificationService
              .addVerifiedAccountToUser(
                accountType: 'savings',
                accountPath: accountPath,
              );

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Savings Account Added Successfully'),
              ),
            );

            // Return true to indicate success
            Navigator.pop(context, true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to add account to your profile'),
              ),
            );
            // Don't pop or return false
          }
        } else {
          // Show verification error
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(verificationResult.message)));
        }
      } catch (e) {
        setState(() {
          _isVerifying = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AddingAccountFormAppbar(title: 'Add Savings Account'),

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
                      // SAVINGS ACCOUNT INFORMATION SECTION
                      // ----------------------------------------------------
                      _buildSectionHeader('Savings Account Information'),
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
                                _selectedSavingsType = null;
                              });

                              if (newValue != null) {
                                _fetchSavingsProducts(newValue);
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

                      // Savings account Type
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Savings Account Type',
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
                              'Choose Savings Account Type',
                              style: FormStyles.hintStyle,
                            ),

                            items:
                                _savingsTypes.map((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: FormStyles.inputTextStyle,
                                    ),
                                  );
                                }).toList(),

                            value: _selectedSavingsType,

                            onChanged:
                                _isSavingsTypeLoading
                                    ? null
                                    : (String? newValue) {
                                      setState(() {
                                        _selectedSavingsType = newValue;
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
                            onPressed: _isVerifying ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                _isVerifying
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      'Add Savings Account',
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
