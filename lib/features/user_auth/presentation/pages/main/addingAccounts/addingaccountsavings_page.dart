import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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

        final savingsTypes =
            savingsProductSnapshot.docs
                .map((doc) => doc['name'] as String)
                .toList();

        setState(() {
          _savingsTypes = savingsTypes;
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process later the formd data and firestore saving
      // Firestore Logic Here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Savings Account Added Successfully')),
      );
      // Navigate to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Savings Account'),
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

                      // Date of Birth Field
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

                      // Savings Account Form Information Section
                      _buildSectionHeader('Savings Account Information'),
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
                            _selectedSavingsType = null;
                          });

                          if (newValue != null) {
                            _fetchSavingsProducts(newValue);
                          }
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

                      // Savings Dropdown
                      DropdownButtonFormField2<String>(
                        value: _selectedSavingsType,
                        decoration: const InputDecoration(
                          labelText: 'Savings Type',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items:
                            _savingsTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                        onChanged:
                            _isSavingsTypeLoading
                                ? null
                                : (String? newValue) {
                                  setState(() {
                                    _selectedSavingsType = newValue;
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
                                hintText: 'Search Savings Type',
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

                      // Account Number Field
                      TextFormField(
                        controller: _accountNumberController,
                        decoration: InputDecoration(
                          labelText: 'Account Number',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.tag),
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
                            return 'Please enter account number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // CVV/CVC
                      TextFormField(
                        controller: _cvvcvc,
                        decoration: InputDecoration(
                          labelText: 'CVV / CVC',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.tag),
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
                              color: Colors.grey,
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

                      const SizedBox(height: 32),

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
                            'Add Savings Account',
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
