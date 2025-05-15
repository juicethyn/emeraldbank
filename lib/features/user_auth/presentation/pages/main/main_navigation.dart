import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart';
import 'account_page.dart';
import 'profile_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  UserModel? currentUser;
  bool isBalanceHidden = false;
  bool isCardHidden = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _getCurrentUser(); // Will be removing and only used for testing, reason: inffecient way of updating user balance.
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  // Fetch the current user's data from Firestore
Future<void> _getCurrentUser() async {
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  if (uid.isNotEmpty) {
    try {
      // Step 1: Fetch the user's document from the `users` collection
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        setState(() {
          currentUser = UserModel.fromFirestore(userDocSnapshot.data()!);
        });
      } else {
        debugPrint("No user found with the given UID in the `users` collection.");
      }

      // Step 2: Fetch the user's accountReferences and get the first savings account ID
      final accountRefsSnapshot = await userDocRef.collection('accountReferences').get();
      String? firstSavingsId;
      for (var doc in accountRefsSnapshot.docs) {
        final List<dynamic>? savingsAccounts = doc.data()['savingsAccounts'];
        if (savingsAccounts != null && savingsAccounts.isNotEmpty) {
          // Extract only the document ID if a path is given
          final id = savingsAccounts.first is String && savingsAccounts.first.contains('/')
              ? savingsAccounts.first.split('/').last
              : savingsAccounts.first;
          firstSavingsId = id;
          break;
        }
      }

      if (firstSavingsId != null) {
        // Step 3: Fetch only the first savings account
        final savingsDoc = await FirebaseFirestore.instance
            .collection('savings')
            .doc(firstSavingsId)
            .get();

        if (savingsDoc.exists) {
          final savingsData = savingsDoc.data()!;
          setState(() {
            currentUser = UserModel(
              email: currentUser?.email ?? '',
              phoneNumber: currentUser?.phoneNumber ?? '',
              balance: savingsData['currentBalance']?.toDouble() ?? 0.0,
              accountNickName: currentUser?.accountNickName ?? '',
              accountName: savingsData['accountHolderName'] ?? '',
              accountNumber: savingsData['savingsAccountInformation']['accountNumber'] ?? '',
              accountCardNumber: savingsData['savingsAccountInformation']['cardNumber'] ?? '',
              accountCVC: savingsData['savingsAccountInformation']['cvv_cvc'] ?? '',
              birthDate: currentUser?.birthDate ?? '',
              issuedOn: savingsData['issuedDate'] ?? '',
              expiresEnd: savingsData['expiryDate'] ?? '',
              uid: uid,
            );
          });
        } else {
          debugPrint("No savings account found for the first ID in the user's savingsAccounts array.");
        }
      } else {
        debugPrint("No savingsAccounts found in the user's accountReferences.");
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }
}

  void toggleBalanceVisibility() {
    setState(() {
      isBalanceHidden = !isBalanceHidden;
    });
  }

  void toggleCardVisibility() {
    setState(() {
      isCardHidden = !isCardHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Loading...',
              style: TextStyle(
                color: Color(0xFF1A1819),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: Center(child: CircularProgressIndicator()),  // Loading state
        ),
      );
    }

    // Once currentUser is available, initialize pages
    final List<Widget> _pages = [
      HomePage(
        user: currentUser, 
        isBalanceHidden: isBalanceHidden,
        onToggleBalanceVisibility: toggleBalanceVisibility,
        isCardHidden: isCardHidden,
        onToggleCardVisibility: toggleCardVisibility),  // Pass currentUser to HomePage
      AccountPage(),
      // InvestmentPage(),
      ProfilePage(),
    ];

    final bool isDarkMode = _selectedIndex == 3;

    return PopScope(
      canPop: false, // Prevents back navigation
      child: Scaffold(
        backgroundColor: isDarkMode ? Color(0xFF181818) : Colors.white, // Dark background for portfolio
        appBar: AppBar(
          backgroundColor: isDarkMode ? Color(0xFF181818) : Colors.white,
          elevation: 0,
          title: Text(
            'Hello, ${currentUser?.accountNickName ?? "User"}!',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Color(0xFF1A1819),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'lib/assets/icons/update_notification_icon.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isDarkMode ? Color(0xFF06D6A0) : Color(0xFF1A1819),
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: SvgPicture.asset(
                'lib/assets/icons/transaction_notification_icon.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isDarkMode ? Color(0xFF06D6A0) : Color(0xFF1A1819),
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: isDarkMode ? Color(0xFF181818) : Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Color(0xFF06D6A0),
          unselectedItemColor: isDarkMode ? Colors.white70 : Color(0xFF1A1819),
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white70 : Colors.black,
          ),
          items: <BottomNavigationBarItem>[
            _navItem('Home', 'lib/assets/icons/home_icon.svg', 0, isDarkMode),
            _navItem('Accounts', 'lib/assets/icons/account_icon.svg', 1, isDarkMode),
            // _navItem('Portfolio', 'lib/assets/icons/investment_icon.svg', 2, isDarkMode),
            _navItem('Profile', 'lib/assets/icons/profile_icon.svg', 2, isDarkMode),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(String label, String asset, int index, bool isDarkMode) {
    return BottomNavigationBarItem(
      icon: SizedBox(
        width: 30,
        height: 30,
        child: SvgPicture.asset(
          asset,
          colorFilter: ColorFilter.mode(
            _selectedIndex == index ? Color(0xFF06D6A0) : (isDarkMode ? Colors.white : Color(0xFF1A1819)),
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label,
    );
  }
}