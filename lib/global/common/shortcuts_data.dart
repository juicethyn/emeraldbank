import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/bills_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/send_page.dart';
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> allShortcuts = [
  {
    'key': 'send',
    'image': 'lib/assets/shortcuts_icon/send.png',
    'text': 'Send',
    'onTap': (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SendPage()));
    },
  },
  {
    'key': 'bills',
    'image': 'lib/assets/shortcuts_icon/bills.png',
    'text': 'Bills',
    'onTap': (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => BillsPage()));
    },
  },
  {
    'key': 'games',
    'image': 'lib/assets/shortcuts_icon/games.png',
    'text': 'Games',
    'onTap': (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => BillsPage())); // Change this one soon
    },
  },
  {
    'key': 'load',
    'image': 'lib/assets/shortcuts_icon/load.png',
    'text': 'Load',
    'onTap': (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => BillsPage())); // Change this one soon
    },
  },
  {
    'key': 'topup',
    'image': 'lib/assets/shortcuts_icon/topup.png',
    'text': 'Topup',
    'onTap': (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => BillsPage())); // Change this one soon
    },
  },
  {
    'key': 'support',
    'image': 'lib/assets/shortcuts_icon/support.png',
    'text': 'Support',
    'onTap': (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => BillsPage())); // Change this one soon
    },
  },
    {
    'key': 'more',
    'image': 'lib/assets/shortcuts_icon/more.png',
    'text': 'More',
    'onTap': (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SendPage()));
    },
  },
  // Add more as needed
];

final List<Map<String, dynamic>> investmentShortcuts = [
    {
    'key': 'stocks',
    'image': 'lib/assets/shortcuts_icon/stocks.png',
    'text': 'Stocks',
    'onTap': (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SendPage()));
    },
  },
  {
    'key': 'funds',
    'image': 'lib/assets/shortcuts_icon/funds.png',
    'text': 'Funds',
    'onTap': (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SendPage()));
    },
  },

    {
    'key': 'crypto',
    'image': 'lib/assets/shortcuts_icon/crypto.png',
    'text': 'Crypto',
    'onTap': (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SendPage()));
    },
  },
    {
    'key': 'insurance',
    'image': 'lib/assets/shortcuts_icon/insurance.png',
    'text': 'Insurance',
    'onTap': (BuildContext context) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SendPage()));
    },
  },



];