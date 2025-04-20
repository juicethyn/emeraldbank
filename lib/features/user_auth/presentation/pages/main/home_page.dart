

import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/bills_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/customize_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/send_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/home_text_button_widget.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/shortcut_buttons.dart';
import 'package:emeraldbank_mobileapp/global/common/shortcuts_data.dart';
import 'package:emeraldbank_mobileapp/models/user_model.dart';
import 'package:emeraldbank_mobileapp/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
class HomePage extends StatefulWidget {
  final UserModel? user;
  final bool isBalanceHidden;
  final VoidCallback onToggleBalanceVisibility;
  final bool isCardHidden;
  final VoidCallback onToggleCardVisibility;
  // Pass `key` directly to the super constructor
  HomePage({
  Key? key, 
  this.user,
  required this.isBalanceHidden,
  required this.onToggleBalanceVisibility,
  required this.isCardHidden,
  required this.onToggleCardVisibility,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> selectedKeys = []; // This will hold the selected shortcut keys
  late List<Map<String, dynamic>> visibleShortcuts;

  @override
  void initState() {
    super.initState();
    // Initialize visibleShortcuts based on selectedKeys
    selectedKeys = ['send','bills','games','more'];

    visibleShortcuts = allShortcuts
        .where((item) => selectedKeys.contains(item['key']))
        .toList();
  }

  // Callback to update selectedKeys when customization is made
  void updateSelectedKeys(List<String> updatedKeys) {
    setState(() {
      selectedKeys = updatedKeys;
      visibleShortcuts = allShortcuts
          .where((item) => selectedKeys.contains(item['key']))
          .toList();
    });
  }

  String formatAccountNumber(String accountNumber) {
    final cleaned = accountNumber.replaceAll(RegExp(r'\D'), ''); // Remove non-digits
    final buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      buffer.write(cleaned[i]);
      if ((i + 1) % 4 == 0 && i + 1 != cleaned.length) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }


 // naka const??
  @override
  Widget build(BuildContext context) {
    UserModel? user = widget.user;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        HomeTextButtonWidget(
                          buttonText: "Savings", 
                          onPressed: () {
                            print("This is the savings button");
                          },
                          backgroundColor: Color(0xFF028A6E),
                          textColor: Colors.white,
                          ),
                        SizedBox(width: 12),
                        HomeTextButtonWidget(
                          buttonText: "Credits", 
                          onPressed: () { 
                            showSnackbarMessage(context, "Credits under Development");
                          },
                          horizontalPadding: 35,
                          backgroundColor: Color.fromARGB(255, 237, 237, 237),
                          ),
                        SizedBox(width: 12),
                        HomeTextButtonWidget(
                          buttonText: "Loan", 
                          onPressed: () { 
                            showSnackbarMessage(context, "Loan is under Development");
                          },
                          horizontalPadding: 40,
                          backgroundColor: Color.fromARGB(255, 237, 237, 237),
                          ),
                      ],
                    ),
                  ), //Savings, Credits, Loan Buttons
              
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF06D6A0), Color(0xFF2CFFC8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 4,
                      ),
                      child: Stack(
                        children: [
                          // Column for text elements
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment(0.9, 1),
                                child: Text(
                                  "Account Savings #1",
                                  style: TextStyle(
                                    color: Color(0xFF1A1819),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Available Balance",
                                style: TextStyle(
                                  color: Color(0xFF044E42),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                widget.isBalanceHidden? "₱••••••" : "₱${NumberFormat('#,##0.00', 'en_PH').format(user?.balance)}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600
                                ),
                                ),
                            ],
                          ),
                          Positioned(
                            left: 90,
                            top: 2,  // Adjust the top position as needed  // Adjust the right position as needed
                            child: IconButton(
                              icon: Icon(
                                widget.isBalanceHidden? Icons.visibility_off : Icons.visibility, // Eye icon
                                size: 16, // You can adjust the size of the icon
                                color: Colors.white, // Icon color (same as text color or any color you want)
                              ),
                              onPressed: () {
                                widget.onToggleBalanceVisibility();
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset('lib/assets/pictures/background_logo.png')
                            ),
                          Positioned(
                            bottom: 18,
                            left: 140,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0),
                              child: Row(
                                children: [
                                  Text("")
                                ],
                                ),
                            )
                            )
                        ],
                      ),
                    ),
                  ), //Account Balance Card should be Stateful
                  
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      bottom: 8,
                      ),
                    child: Container(
                      width: double.infinity,
                      height: 205, 
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6D6A6B), Color(0xFF413F40), Color(0xFF1A1819)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 18.0,
                          left: 12.00,
                          right: 24,
                          bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'lib/assets/pictures/emerald_logo_white.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    Text("EmeraldBank",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white
                                      )
                                      ,)
                                  ]
                                ),
                                SvgPicture.asset(
                                  'lib/assets/icons/visa_icon.svg',
                                  width: 53,
                                  height: 21,
                                )
                              ],
                            ),
                            SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 28.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                  widget.isCardHidden ? "•••• •••• •••• ${user?.accountNumber.substring(user.accountNumber.length - 4)}" 
                                  : user?.accountNumber != null ? formatAccountNumber(user!.accountNumber) : '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2,
                                  ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      widget.isCardHidden? Icons.visibility_off : Icons.visibility, // Eye icon
                                      size: 24, // You can adjust the size of the icon
                                      color: Colors.white, // Icon color (same as text color or any color you want)
                                    ),
                                    onPressed: () {
                                      widget.onToggleCardVisibility();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("ISSUED \n ON",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white
                                    ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                    widget.isCardHidden ? "••/••/••••" : "${user?.issuedOn}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white
                                    ),
                                    ),
                                    
                                    SizedBox(width: 12,),

                                    Text("EXPIRES \n END",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white
                                    ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                    widget.isCardHidden ? "••/••/••••" : "${user?.expiresEnd}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white
                                    ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("CARD HOLDER NAME",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white
                                      ),),
                                    Text(
                                    widget.isCardHidden ? "••••••••••••••••••••" :"${user?.accountName}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white
                                      ),),
                                  ],
                                ),
                                Image.asset(
                                  'lib/assets/pictures/chip.png',
                                  width: 40,
                                  height: 40,
                                )
                              ],
                            )

                          ],
                        ),
                      ),
                    ),
                  ), // Credit Card Details
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Shortcuts",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed:
                        () async {
                      final updatedShortcuts = await Navigator.push(context, MaterialPageRoute(builder: (context) => 
                      CustomizePage(
                        selectedShortcuts: visibleShortcuts,
                        allShortcuts: allShortcuts,
                      )
                      )
                      );
                      if (updatedShortcuts != null) {
                        setState(() {
                          selectedKeys = List<String>.from(updatedShortcuts); // safely cast to List<String>
                          visibleShortcuts = allShortcuts
                              .where((item) => selectedKeys.contains(item['key']))
                              .toList();
                        });
                      }
                    },
                      child: Text("Customize",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF028A6E),
                      ),
                      ),
                    )
                  ),
                ]
              ),
          
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: List.generate(visibleShortcuts.length, (index) {
                    String imagePath = visibleShortcuts[index]['image']!;
                    String text = visibleShortcuts[index]['text']!;
                    String key = visibleShortcuts[index]['key']!;

                    return ShortcutButton(
                      imagePath: imagePath, 
                      text: text, 
                      onTapCallback: (context) {
                      switch (key) {
                        case 'send':
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SendPage(user: widget.user)));
                          break;
                        case 'bills':
                          Navigator.push(context, MaterialPageRoute(builder: (_) => BillsPage()));
                          break;
                        // add more actions here...
                        default:
                          showSnackbarMessage(context, "Feature is currently Under Development");
                          // print('Unknown shortcut key: $key');
                      }
                              }   
                      );
                  }),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: double.infinity,
                height: 220,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Transactions",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          )
                          ),
                          Text(
                            "View all",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF028A6E)
                          )
                          ),
                        ],
                      ),
                      SizedBox(height: 4,),
                      Container(
                        width: double.infinity,
                        height: 1,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      
                      // Michael Cruz
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8 
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                child: Image.asset(
                                  'lib/assets/pictures/profilepicture.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Text("Michael Cruz",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    Text("Today, at 1:43pm",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    ],
                                  ),
                                )
                                  ],
                            ),
                            Text("-₱10,000.00",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.redAccent
                              ),
                            ),
                          ],),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8 
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                child: Image.asset(
                                  'lib/assets/pictures/profilepicture.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Text("Michael Cruz",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    Text("Today, at 1:43pm",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    ],
                                  ),
                                )
                                  ],
                            ),
                            Text("-₱2,000.00",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.redAccent
                              ),
                            ),
                          ],),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8 
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                child: Image.asset(
                                  'lib/assets/pictures/profilepicture.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Text("Michael Cruz",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    Text("Today, at 1:43pm",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    ],
                                  ),
                                )
                                  ],
                            ),
                            Text("-₱5,000.00",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.redAccent
                              ),
                            ),
                          ],),
                      ),

                    ],
                  ),
                ) 
              
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

