import 'package:flutter/material.dart';
import '../main_bill.dart';

class TravelListPage extends StatefulWidget {
  final String categoryName;

  TravelListPage({required this.categoryName});

  @override
  _TravelListPageState createState() => _TravelListPageState();
}

class _TravelListPageState extends State<TravelListPage> {
  final TextEditingController searchController = TextEditingController();

  final Map<String, List<String>> billersByCategory = {
    'Airlines / Travel Agencies': [
      'FIESTA TOURS AND TRAVELS CORP',
      'MARSMAN DRYSDALE TRAVEL INC',
      'PAPH TRAVEL AND TOURS',
      'ROYAL KITES TRAVELS AND TOURS',
    ],
  };

  final Map<String, String> billerInitials = {
    'FIESTA TOURS AND TRAVELS CORP': 'F',
    'MARSMAN DRYSDALE TRAVEL INC': 'M',
    'PAPH TRAVEL AND TOURS': 'P',
    'ROYAL KITES TRAVELS AND TOURS': 'R',
  };

  List<String> displayedBillers = [];

  @override
  void initState() {
    super.initState();
    displayedBillers = List.from(billersByCategory[widget.categoryName] ?? []);
    displayedBillers.sort();
    searchController.addListener(_filterBillers);
  }

  void _filterBillers() {
    final query = searchController.text.toLowerCase();
    final allBillers = billersByCategory[widget.categoryName] ?? [];
    setState(() {
      displayedBillers = allBillers
          .where((biller) => biller.toLowerCase().contains(query))
          .toList()
        ..sort();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        title: Text("Pay Bills"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 16),
            Expanded(child: _buildBillerList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search ${widget.categoryName}",
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildBillerList() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: ListView.builder(
        key: ValueKey(displayedBillers.length),
        itemCount: displayedBillers.length,
        itemBuilder: (context, index) {
          final biller = displayedBillers[index];
          final initial = billerInitials[biller] ?? '';

          // Group headers by initial
          bool showHeader = index == 0 ||
              billerInitials[displayedBillers[index]] !=
                  billerInitials[displayedBillers[index - 1]];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showHeader)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    initial,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              Hero(
                tag: biller,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(biller),
                    trailing: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MainBillPage(billerName: biller),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
