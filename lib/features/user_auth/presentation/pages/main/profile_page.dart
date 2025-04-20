import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 40, 
          horizontal: 16),
          child: Column(
          
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.tealAccent[700],
              child: Icon(
                Icons.account_box_outlined, 
                size: 50, 
                color: Colors.white
              ),
            ),
            
            SizedBox(height: 12),
            Text(
              'John Mark Magsaysay', 
              style: TextStyle(
                fontSize: 20, 
                color: Colors.black
              ),
            ),

            SizedBox(height: 0),
            Text(
              '4363 1234 5678 9101', 
              style: TextStyle(
                fontSize: 13, 
                color: Colors.black, 
                letterSpacing: 3
              ),
            ),

            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PROFILE MENU', 
                style: TextStyle(
                  fontSize: 10, 
                  color: Colors.grey[700], 
                  letterSpacing: 1,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12),
              child: Container(
                width: double.infinity,
                height: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey, 
                      offset: Offset(0, 3), 
                      blurRadius: 5,
                      spreadRadius: 0.5, 
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12),
                  child: Column(
                    children:[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Row(
                              children: [
                                  SvgPicture.asset(
                                    'lib/assets/icons/edit_profile_icon.svg',
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  ),
                                SizedBox(width: 15),
                                const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          const Icon(
                            Icons.arrow_right,
                            color: Colors.black,
                          ), 
                        ]      
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 1,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),


                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              children: [
                                SvgPicture.asset(
                                    'lib/assets/icons/account_limit_icon.svg',
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Account Limits',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          const Icon(
                            Icons.arrow_right,
                            color: Colors.black,
                          ), 
                        ], 
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 1,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),


                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              children: [
                                SvgPicture.asset(
                                    'lib/assets/icons/ticket_icon.svg',
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Sumbit a ticket',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          const Icon(
                            Icons.arrow_right,
                            color: Colors.black,
                          ), 
                        ], 
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 1,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      

                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              FirebaseAuth.instance.signOut();
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    'lib/assets/icons/settings_icon.svg',
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Settings',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_right,
                            color: Colors.black,
                          ), 
                        ], 
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 1,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),


                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              children: [
                                SvgPicture.asset(
                                    'lib/assets/icons/get_help_icon.svg',
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Get Help',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          const Icon(
                            Icons.arrow_right,
                            color: Colors.black,
                          ), 
                        ], 
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 1,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),

                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              FirebaseAuth.instance.signOut();
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    'lib/assets/icons/logout_icon.svg',
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Sign Out',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_right,
                            color: Colors.black,
                          ), 
                        ], 
                      ),
                    ],
                  ),
                ),
              ), 
            ),
          ] //child
        ),
      ) 
    );
  }
}