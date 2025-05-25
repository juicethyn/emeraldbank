import 'package:flutter/material.dart';
import 'biller_lists/travel_list.dart';
import 'biller_lists/club_list.dart';
import 'biller_lists/creditcard_list.dart';
import 'biller_lists/dealers_list.dart';
import 'biller_lists/ewallet_list.dart';
import 'biller_lists/foundation_list.dart';
import 'biller_lists/franchise_list.dart';
import 'biller_lists/government_list.dart';
import 'biller_lists/healthcare_list.dart';
import 'biller_lists/insurance_list.dart';
import 'biller_lists/investment_list.dart';
import 'biller_lists/loan_list.dart';
import 'biller_lists/logistics_list.dart';
import 'biller_lists/media_list.dart';
import 'biller_lists/realty_list.dart';
import 'biller_lists/rent_list.dart';
import 'biller_lists/school_list.dart';
import 'biller_lists/telecom_list.dart';
import 'biller_lists/utilities_list.dart';
import 'biller_lists/others_list.dart';

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

 // Replace the whole build method inside _PayBillsPageState with this:
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
          // App Bar (Center-aligned title)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: Color(0xFF004d40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Pay Bills',
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Opacity(opacity: 0.0, child: Icon(Icons.arrow_back)), // dummy to balance layout
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
                              'lib/assets/biller_icon/meralco.png',
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
                    colors: [Color(0xFF00d2ff), Color.fromARGB(255, 33, 145, 120)],
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
                              fontSize: 17,
                            ),
                          ),
                        ),


                        
                        SizedBox(
                          width: 160,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                searchTerm = value;
                              });
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.white54),
                              prefixIcon: Icon(Icons.search, color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
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
                                  builder: (_) => getBillerListPage(category['label']!),
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
                                    fontSize: 11, // +1 font size
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


  // This function maps category labels to their corresponding page widgets
  Widget getBillerListPage(String categoryName) {
    switch (categoryName) {
      case 'Airlines / Travel Agencies':
        return TravelListPage(categoryName: categoryName);
      case 'Club Memberships':
        return ClubListPage(categoryName: categoryName);
      case 'Credit Cards':
        return CreditCardListPage(categoryName: categoryName);
      case 'Dealers':
        return DealersListPage(categoryName: categoryName);
      case 'E-Wallets / Online Shopping':
        return EWalletListPage(categoryName: categoryName);
      case 'Foundations':
        return FoundationListPage(categoryName: categoryName);
      case 'Franchises':
        return FranchiseListPage(categoryName: categoryName);
      case 'Government':
        return GovernmentListPage(categoryName: categoryName);
      case 'Healthcare':
        return HealthcareListPage(categoryName: categoryName);
      case 'Healthcare and Insurance':
        return InsuranceListPage(categoryName: categoryName);
      case 'Investments':
        return InvestmentListPage(categoryName: categoryName);
      case 'Loans and Cooperatives':
        return LoanListPage(categoryName: categoryName);
      case 'Logistics':
        return LogisticsListPage(categoryName: categoryName);
      case 'Media and Publishing':
        return MediaListPage(categoryName: categoryName);
      case 'Properties and Realty':
        return RealtyListPage(categoryName: categoryName);
      case 'Residential Dues / Rent':
        return RentListPage(categoryName: categoryName);
      case 'School':
        return SchoolListPage(categoryName: categoryName);
      case 'Telecommunications':
        return TelecomListPage(categoryName: categoryName);
      case 'Utilities':
        return UtilitiesListPage(categoryName: categoryName);
      case 'Others':
        return OthersListPage(categoryName: categoryName);
      default:
        return CategoryScreen(categoryName: categoryName);
    }
  }
}
