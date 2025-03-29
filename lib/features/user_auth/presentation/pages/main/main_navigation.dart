import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart';
import 'account_page.dart';
import 'investment_page.dart';
import 'profile_page.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    AccountPage(),
    InvestmentPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hi User',
          style: TextStyle(
            color: Color(0xFF1A1819),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          // Notifications Icon
          IconButton(
            icon: SvgPicture.asset(
              'lib/assets/icons/update_notification_icon.svg',   // Use your custom SVG
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Color(0xFF1A1819), BlendMode.srcIn),
            ),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          const SizedBox(width: 8),

          // Updates Icon
          IconButton(
            icon: SvgPicture.asset(
              'lib/assets/icons/transaction_notification_icon.svg',   // Use your custom SVG
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Color(0xFF1A1819), BlendMode.srcIn),
            ),
            onPressed: () {
              // Navigate to updates
            },
          ),
          const SizedBox(width: 16),
        ],
      ),


      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF06D6A0),
        unselectedItemColor: Color(0xFF1A1819),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black
        ),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                'lib/assets/icons/home_icon.svg',
                colorFilter: _selectedIndex == 0 ? 
                ColorFilter.mode(Color(0xFF06D6A0), BlendMode.srcIn) : 
                ColorFilter.mode(Color(0xFF1A1819), BlendMode.srcIn),
                ),
            ),
            label: 'Home',
          ),
                    BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                'lib/assets/icons/account_icon.svg',
                colorFilter: _selectedIndex == 1 ? 
                ColorFilter.mode(Color(0xFF06D6A0), BlendMode.srcIn) : 
                ColorFilter.mode(Color(0xFF1A1819), BlendMode.srcIn),
                ),
            ),
            label: 'Accounts',
          ),
                    BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                'lib/assets/icons/investment_icon.svg',
                colorFilter: _selectedIndex == 2 ? 
                ColorFilter.mode(Color(0xFF06D6A0), BlendMode.srcIn) : 
                ColorFilter.mode(Color(0xFF1A1819), BlendMode.srcIn),
                ),
            ),
            label: 'Investment',
          ),
                    BottomNavigationBarItem(
            icon: SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                'lib/assets/icons/profile_icon.svg',
                colorFilter: _selectedIndex == 3 ? 
                ColorFilter.mode(Color(0xFF06D6A0), BlendMode.srcIn) : 
                ColorFilter.mode(Color(0xFF1A1819), BlendMode.srcIn),
                ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
