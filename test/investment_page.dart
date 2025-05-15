import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/shortcut_buttons_dark.dart';
import 'package:emeraldbank_mobileapp/global/common/shortcuts_data.dart';
import 'package:flutter/material.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white, // Applies to default text color
              displayColor: Colors.white, // Applies to larger headings
            ),
      ),
      child: Scaffold(
        backgroundColor: Color(0xFF181818),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFF191919),
                      // gradient: LinearGradient(
                      //   colors: [Color(0xFF06D6A0), Color(0xFF2CFFC8)],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
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
                              SizedBox(height: 18),
                              Text(
                                "Total Investment Balance",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "₱53,250.00",
                                // widget.isBalanceHidden? "₱••••••" : "₱${NumberFormat('#,##0.00', 'en_PH').format(user?.balance)}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600
                                ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF06D6A0).withAlpha(50),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                  "   ₱2,756.25 this month   ",
                                  // widget.isBalanceHidden? "₱••••••" : "₱${NumberFormat('#,##0.00', 'en_PH').format(user?.balance)}",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 49, 222, 121).withAlpha(255),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500
                                  ),
                                  ),
                                ),
                            ],
                          ),
                          Positioned(
                            left: 135,
                            top: 2,  // Adjust the top position as needed  // Adjust the right position as needed
                            child: IconButton(
                              icon: Icon(
                                // widget.isBalanceHidden? Icons.visibility_off : Icons.visibility, // Eye icon
                                Icons.visibility,
                                size: 16, // You can adjust the size of the icon
                                color: Colors.white, // Icon color (same as text color or any color you want)
                              ),
                              onPressed: () {
                                // widget.onToggleBalanceVisibility();
                                debugPrint("This is the eye Icon");
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset('lib/assets/pictures/investment_logo.png')
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

                  SizedBox(
                    height: 12 ,
                  ),

                SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: List.generate(investmentShortcuts.length, (index) {
                    String imagePath = investmentShortcuts[index]['image']!;
                    String text = investmentShortcuts[index]['text']!;
                    final onTapCallback = investmentShortcuts[index]['onTap']
                    as void Function(BuildContext);

                    return ShortcutButtonDark(
                      imagePath: imagePath, 
                      text: text, 
                      onTapCallback: onTapCallback);
                  }),
                ),
              ),
              SizedBox(height: 12,),
              Row(
                children: [
                  Text("My Portfolio",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),),
                ],
              ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: double.infinity,
                height: 270,
                decoration: BoxDecoration(
                  color: Color(0xFF191919) ,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12),
                  child: Column(
                    children: [
                      // Stocks
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
                                  'lib/assets/pictures/stocks_oval.png',
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            SizedBox(width: 12,),
                            Text("Stocks",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                              ),
                            ),
                            ],
                            ),
                            SizedBox(width: 4,),
                            Image.asset(
                              'lib/assets/pictures/charts.png',
                              width: 90,
                              height: 40,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                  Text("₱22,264.86",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text("+2.08 %",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF27AE60),
                                    ),
                                  ),
                                  ],
                                ),
                              )
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
                                  'lib/assets/pictures/funds_oval.png',
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            SizedBox(width: 12,),
                            Text("Funds",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                              ),
                            ),
                            ],
                            ),
                            SizedBox(width: 4,),
                            Image.asset(
                              'lib/assets/pictures/charts.png',
                              width: 90,
                              height: 40,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                  Text("₱16,698.65",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text("+1.56 %",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF27AE60),
                                    ),
                                  ),
                                  ],
                                ),
                              )
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
                                  'lib/assets/pictures/crypto_oval.png',
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            SizedBox(width: 12,),
                            Text("Crypto",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                              ),
                            ),
                            ],
                            ),
                            SizedBox(width: 4,),
                            Image.asset(
                              'lib/assets/pictures/charts.png',
                              width: 90,
                              height: 40,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                  Text("₱11,132.43",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text("+1.04 %",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF27AE60),
                                    ),
                                  ),
                                  ],
                                ),
                              )
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
                                  'lib/assets/pictures/insurance_oval.png',
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            SizedBox(width: 12,),
                            Text("Insurance",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                              ),
                            ),
                            ],
                            ),
                            SizedBox(width: 4,),
                            Image.asset(
                              'lib/assets/pictures/charts.png',
                              width: 90,
                              height: 40,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                  Text("₱5,566.22",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text("+0.52 %",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF27AE60),
                                    ),
                                  ),
                                  ],
                                ),
                              )
                          ],),
                      ),

                    ],
                  ),
                ) 
              ),
            ),

            // TRANSACTION HERE
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Color(0xFF191919),
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

            ], // Will now be white by default
          ),
        ),
      ),
    );
  }
}
