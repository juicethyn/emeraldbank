import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/investment/time_deposit.dart';
import 'package:flutter/material.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invest",
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
                  "Choose an Investment",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF06D6A0),
                    fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                  "Grow your money by choosing an investment that fits your goals and timeline.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24,),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimeDeposit()),
                );
              },
              child: Container(
                height: 88,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'lib/assets/pictures/time_deposit.png',
                        width: 50,
                        height: 50,
                        color: Color(0xFF06D6A0),
                        colorBlendMode: BlendMode.srcIn,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Time Deposit",
                              style: TextStyle(
                                fontSize: 16 ,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              "Earn guaranteed returns by locking your savings for a set period.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Add your investment options here
          ],
        ),
      ),
    );
  }
}
