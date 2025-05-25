import 'package:flutter/material.dart';
import '../main_bill.dart';

class RentListPage extends StatelessWidget {
  final String categoryName;

  RentListPage({required this.categoryName});

  final Map<String, List<String>> billersByCategory = {
    'Residential Dues/Rent': [
      'MODENA TOWN SQUARE CONDOMINIUM CORP',
      'THE VANTAGE CONDOMINIUM CORPORATION',
    ],
  };

  final Map<String, String> billerInitials = {
    'MODENA TOWN SQUARE CONDOMINIUM CORP': 'M',
    'THE VANTAGE CONDOMINIUM CORPORATION': 'T',
  };

  @override
  Widget build(BuildContext context) {
    // Normalize the input categoryName for comparison
    final normalizedCategory = categoryName.trim().toLowerCase();

    // Find the matching category key in the map
    final matchingCategory = billersByCategory.entries.firstWhere(
      (entry) => entry.key.trim().toLowerCase() == normalizedCategory,
      orElse: () => MapEntry('', []),
    );

    // Get the billers list (make a copy to safely sort)
    final List<String> billers = List.from(matchingCategory.value);
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
                  hintText: "Search Residential Dues/Rent",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: billers.isNotEmpty
                  ? ListView.builder(
                      itemCount: billers.length,
                      itemBuilder: (context, index) {
                        final biller = billers[index];
                        final initial = billerInitials[biller] ?? '';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0 ||
                                billerInitials[billers[index]] !=
                                    billerInitials[billers[index - 1]])
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
                                  borderRadius: BorderRadius.circular(8)),
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
                                      builder: (_) =>
                                          MainBillPage(billerName: biller),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No billers found for this category.",
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}