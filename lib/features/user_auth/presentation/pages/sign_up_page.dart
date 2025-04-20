import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/sign_up_page_2.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/date_container_widget.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isSigningUp = false;
  bool isTrueCorrect = false;
  bool isTOSChecked = false;
  bool isDataPrivacy = false;

  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {
    _nickNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2003), // default date
      firstDate: DateTime(1900), // earliest DOB
      lastDate: DateTime.now(),  // today is the latest allowed
    );

    if (pickedDate != null) {
      String formattedDate = "${pickedDate.month.toString().padLeft(2, '0')}/"
                            "${pickedDate.day.toString().padLeft(2, '0')}/"
                            "${pickedDate.year}";
      setState(() {
        _birthDateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                "Enter your account \ndetails",
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF06D6A0),
                  fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
            SizedBox(height: 12,),
            Row(
                children: [
                  Text(
                    "Nickname",
                    style: TextStyle(
                      color: Color(0xFF1A1819), 
                      fontSize: 12, 
                      fontWeight: FontWeight.w700,),
                    
                  ),
                ],
              ),
              FormContainerWidget(
                controller: _nickNameController,
                hintText: "ex. Juan",
                inputType: TextInputType.text,
                inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')), // Only letters and spaces
                    ],),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "Account Holder Name (Full Name)",
                    style: TextStyle(
                      color: Color(0xFF1A1819), 
                      fontSize: 12, 
                      fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              FormContainerWidget(
                controller: _accountNameController,
                hintText: "ex. Juan Dela Cruz",
                inputType: TextInputType.text,
                inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')), // Only letters and spaces
                    ],),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "Account Number or Debit Card Number",
                    style: TextStyle(
                      color: Color(0xFF1A1819), 
                      fontSize: 12, 
                      fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              FormContainerWidget(
                controller: _accountNumberController,
                hintText: "ex. 1234456778904209 (16 digits)",
                inputType: TextInputType.number,
                inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16)],
                ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "Date of Birth",
                    style: TextStyle(
                      color: Color(0xFF1A1819), 
                      fontSize: 12, 
                      fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              DateContainerWidget(
                controller: _birthDateController,
                hintText: "MM/DD/YYYY",
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "Email Address linked to Emerald Account",
                    style: TextStyle(
                      color: Color(0xFF1A1819), 
                      fontSize: 12, 
                      fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "sample@email.com",),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "Contact Number",
                    style: TextStyle(
                      color: Color(0xFF1A1819), 
                      fontSize: 12, 
                      fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              FormContainerWidget(
                controller: _phoneController,
                hintText: "ex. 091234567890",
                inputType: TextInputType.number,
                inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11)],
                ),
              SizedBox(height: 4),
          Row(
            children: [
              Checkbox(
                value: isTrueCorrect,
                activeColor: Color(0xFF06D6A0),
                checkColor: Colors.white,
                onChanged: (bool? value) {
                  setState(() {
                    isTrueCorrect = value ?? false;
                  });
                },
              ),
              Expanded(
                child: Text(
                  "I hereby certify that the above information is true and correct.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1A1819),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: isTOSChecked,
                activeColor: Color(0xFF06D6A0),
                checkColor: Colors.white,
                onChanged: (bool? value) {
                  setState(() {
                    isTOSChecked = value ?? false;
                  });
                },
              ),
              Expanded(
                child: Text(
                  "I hereby certify that the above information is true and correct.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1A1819),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: isDataPrivacy,
                activeColor: Color(0xFF06D6A0),
                checkColor: Colors.white,
                onChanged: (bool? value) {
                  setState(() {
                    isDataPrivacy = value ?? false;
                  });
                },
              ),
              Expanded(
                child: Text(
                  "I have read and agreed to the Data Privacy Consent.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1A1819),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

              GestureDetector(
                        onTap: () async {
                        final String accountNickName = _nickNameController.text.trim();
                        final String accountName = _accountNameController.text.trim();
                        final String accountNumber = _accountNumberController.text.trim();
                        final String birthDate = _birthDateController.text.trim();
                        final String email = _emailController.text.trim();
                        final String phone = "+63${_phoneController.text.trim().replaceFirst('0', '')}";

                        if (accountName.isEmpty || accountNumber.isEmpty || birthDate.isEmpty || email.isEmpty || phone.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please complete all fields.")),
                          );
                          return;
                        }

                        if (!isTOSChecked && !isDataPrivacy && !isTrueCorrect) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please check all boxes before cont")),
                          );
                          return;
                        }

                        setState(() => isSigningUp = true);

                        try {
                          final querySnapshot = await FirebaseFirestore.instance
                              .collection('debitCardDatabase')
                              .where('accountNumber', isEqualTo: accountNumber)
                              .where('accountName', isEqualTo: accountName)
                              .where('email', isEqualTo: email)
                              .where('birthDate', isEqualTo: birthDate)
                              .get();

                          if (querySnapshot.docs.isNotEmpty) {
                            // ✅ Details matched, proceed to SignUpPage2
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage2(
                                  accountNickName: accountNickName,
                                  accountNumber: accountNumber,
                                  accountName: accountName,
                                  birthDate: birthDate,
                                  email: email,
                                  phone: phone,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Invalid Account. Please check your details.")),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error verifying account: $e")),
                          );
                        } finally {
                          setState(() => isSigningUp = false);
                        }
                      },
                      // onTap: _signUp,
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: isTOSChecked && isTrueCorrect && isDataPrivacy ?Color(0xFF06D6A0) : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: isSigningUp
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Next", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      
              ),


          ],
          
        ),
        ),
    );
  }

//   void _signUp() async {
//     String email = _emailController.text;
//     String password = _passwordController.text;
//     String phone = _phoneController.text;
//     String name = _nameController.text;

//     // Validation for phone number format
//   if (phone.isEmpty || !phone.startsWith('+')) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please enter a valid phone number with country code (e.g., +1234567890)")),
//       );
//       return;
//     }

//     setState(() => isSigningUp = true);

//     try {
//       // ✅ Only send OTP first — no account creation yet
//       await _auth.verifyPhoneNumber(
//         phoneNumber: phone,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // Optional: You can handle instant verification here if needed
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OtpVerificationPage(
//                 isSignUp: true,
//                 email: email,
//                 password: password,
//                 phone: phone,
//                 name: name,
//                 // credential: credential,
//                 verificationId: '', // not needed here
//               ),
//             ),
//           );
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Phone verification failed: ${e.message}")),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           // ✅ Proceed to OTP page with data
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OtpVerificationPage(
//                 verificationId: verificationId,
//                 isSignUp: true,
//                 email: email,
//                 password: password,
//                 phone: phone,
//                 name: name,
//               ),
//             ),
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           print("Auto retrieval timeout: $verificationId");
//         },
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign Up Error: $e")));
//     } finally {
//       setState(() => isSigningUp = false);
//     }
//   }
}
