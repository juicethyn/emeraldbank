import 'package:flutter/material.dart';
import '../main_bill.dart'; // Make sure this import is correct

class InsuranceListPage extends StatelessWidget {
  final String categoryName;

  InsuranceListPage({required this.categoryName});

  final Map<String, List<String>> billersByCategory = {
    'Healthcare and Insurance': [
      'AIA PHILIPPINES',
      'COMMONWEALTH INSURANCE COMPANY',
      'FAMILY VACCINE AND SPECIALTY',
      'INSULAR LIFE ASSURANCE',
      'MANILA DOCTORS HOSPITAL',
    ],
  };

  final Map<String, String> billerInitials = {
    'AIA PHILIPPINES': 'A',
    'COMMONWEALTH INSURANCE COMPANY': 'C',
    'FAMILY VACCINE AND SPECIALTY': 'F',
    'INSULAR LIFE ASSURANCE': 'I',
    'MANILA DOCTORS HOSPITAL': 'M',
  };

  @override
  Widget build(BuildContext context) {
    final List<String> billers = List.from(billersByCategory[categoryName] ?? []);

    // Debug print
    print("Category received: $categoryName");
    print("Number of billers: ${billers.length}");

    // Sort billers alphabetically
    billers.sort((a, b) => a.compareTo(b));

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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Healthcare and Insurance",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                // You can later implement search functionality
              ),
            ),
            SizedBox(height: 16),
            if (billers.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    "No billers found for '$categoryName'",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: billers.length,
                  itemBuilder: (context, index) {
                    final biller = billers[index];
                    final initial = billerInitials[biller] ?? '';

                    // Add initial header if it's the first or new group
                    final showHeader = index == 0 ||
                        billerInitials[biller] != billerInitials[billers[index - 1]];

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
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(biller),
                            trailing: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.arrow_forward_ios,
                                  size: 12, color: Colors.white),
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
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}