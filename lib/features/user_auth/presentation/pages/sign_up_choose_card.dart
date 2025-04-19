import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:emeraldbank_mobileapp/utils/snackbar_util.dart';
import 'package:flutter/material.dart';

class SignUpChooseCard extends StatelessWidget {
  const SignUpChooseCard({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Text(
                  "Please choose accounts that apply",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF06D6A0),
                    fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12,),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8 
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'lib/assets/pictures/emerald_green_logo.png',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Text("Savings or Checking account",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      ],
                                    ),
                                  )
                                    ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                ),
                              ),
                            ],),
                        ),
                      ),

                      SizedBox(height: 4,),
                      Container(
                        width: double.infinity,
                        height: 1.5,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      SizedBox(height: 4,),

                      GestureDetector(
                      onTap:  () {
                        showSnackbarMessage(context, "Credit Card Under Develoment");
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8 
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                Image.asset(
                                  'lib/assets/pictures/card.png',
                                  width: 30,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Text("Credit Card",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      ],
                                    ),
                                  )
                                    ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                ),
                              ),
                            ],),
                        ),
                      ),

                    ],
                  ),
                )
              )
              ),



          ],
        ),),
    );
  }
}