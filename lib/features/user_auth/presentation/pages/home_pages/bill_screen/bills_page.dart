import 'package:flutter/material.dart';
import 'biller_list.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: Center(child: Text("Welcome to $categoryName")),
    );
  }
}

class PayBillsPage extends StatefulWidget {
  const PayBillsPage({super.key});

  @override
  _PayBillsPageState createState() => _PayBillsPageState();
}

class _PayBillsPageState extends State<PayBillsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> recentBillers = ['Meralco', 'Meralco', 'Meralco'];

 final List<Map<String, String>> categories = [
    {'icon': 'lib/assets/biller_icon/travel.png', 'label': 'Airlines / Travel Agencies'},
    {'icon': 'lib/assets/biller_icon/club.png', 'label': 'Club Memberships'},
    {'icon': 'lib/assets/biller_icon/credit_card.png', 'label': 'Credit Cards'},
    {'icon': 'lib/assets/biller_icon/dealers.png', 'label': 'Dealers'},
    {'icon': 'lib/assets/biller_icon/ewallet.png', 'label': 'E-Wallets / Online Shopping'},
    {'icon': 'lib/assets/biller_icon/foundation.png', 'label': 'Foundations'},
    {'icon': 'lib/assets/biller_icon/franchise.png', 'label': 'Franchises'},
    {'icon': 'lib/assets/biller_icon/government.png', 'label': 'Government'},
    {'icon': 'lib/assets/biller_icon/healthcare.png', 'label': 'Healthcare'},
    {'icon': 'lib/assets/biller_icon/insurance.png', 'label': 'Healthcare and Insurance'},
    {'icon': 'lib/assets/biller_icon/investment.png', 'label': 'Investments'},
    {'icon': 'lib/assets/biller_icon/loan.png', 'label': 'Loans and Cooperatives'},
    {'icon': 'lib/assets/biller_icon/logistics.png', 'label': 'Logistics'},
    {'icon': 'lib/assets/biller_icon/media.png', 'label': 'Media and Publishing'},
    {'icon': 'lib/assets/biller_icon/realty.png', 'label': 'Properties and Realty'},
    {'icon': 'lib/assets/biller_icon/rent.png', 'label': 'Residential Dues / Rent'},
    {'icon': 'lib/assets/biller_icon/school.png', 'label': 'School'},
    {'icon': 'lib/assets/biller_icon/telecom.png', 'label': 'Telecommunications'},
    {'icon': 'lib/assets/biller_icon/utilities.png', 'label': 'Utilities'},
    {'icon': 'lib/assets/biller_icon/others.png', 'label': 'Others'},
  ];


  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    final filteredCategories = categories.where((category) {
      return category['label']!.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: Color(0xFF004d40),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Pay Bills',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Recent Billers
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00d2ff), Color.fromARGB(255, 33, 145, 120)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECENT BILLERS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: recentBillers.map((biller) {
                        return Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/icons/meralco.png',
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, color: Colors.red);
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                biller,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),

            // Categories
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00d2ff), Color(0xFF3a7bd5)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Categories header with search
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'CATEGORIES',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  searchTerm = value;
                                });
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Search',
                                hintStyle: TextStyle(color: Colors.white54),
                                prefixIcon: Icon(Icons.search, color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      // Grid of categories
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 4,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: filteredCategories.map((category) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BillerListPage(
                                      categoryName: category['label']!,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        category['icon']!,
                                        fit: BoxFit.contain,
                                        width: 30,
                                        height: 30,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.error, color: Colors.red);
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    category['label']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
