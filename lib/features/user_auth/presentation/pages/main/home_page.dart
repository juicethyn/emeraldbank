import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/bill_screen/bills_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/customize_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/send_screen/own_account_screen/send_transfer.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/transactionPage/transaction_details.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/main/transactionPage/transactionhistory_page.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/active_investment_card.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/home_text_button_widget.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/pages/home_pages/investment/choose_investment.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/shortcut_buttons.dart';
import 'package:emeraldbank_mobileapp/global/common/shortcuts_data.dart';
import 'package:emeraldbank_mobileapp/models/user_model.dart';
import 'package:emeraldbank_mobileapp/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/transaction_overview.dart';

class HomePage extends StatefulWidget {
  final UserModel? user;
  final bool isBalanceHidden;
  final VoidCallback onToggleBalanceVisibility;
  final bool isCardHidden;
  final VoidCallback onToggleCardVisibility;
  // Pass `key` directly to the super constructor
  HomePage({
  Key? key, 
  this.user,
  required this.isBalanceHidden,
  required this.onToggleBalanceVisibility,
  required this.isCardHidden,
  required this.onToggleCardVisibility,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> selectedKeys = []; // This will hold the selected shortcut keys
  late List<Map<String, dynamic>> visibleShortcuts;
  List<Map<String, dynamic>> _activeTimeDeposits = [];
  String? savingsId;

  @override
  void initState() {
    super.initState();
    // Initialize visibleShortcuts based on selectedKeys
    selectedKeys = ['send','bills', 'invest','games'];

    visibleShortcuts = allShortcuts
        .where((item) => selectedKeys.contains(item['key']))
        .toList();
    _fetchActiveTimeDeposits();
    _fetchSavingsId();
  }

  // Callback to update selectedKeys when customization is made
  void updateSelectedKeys(List<String> updatedKeys) {
    setState(() {
      selectedKeys = updatedKeys;
      visibleShortcuts = allShortcuts
          .where((item) => selectedKeys.contains(item['key']))
          .toList();
    });
  }

  Future<void> _fetchActiveTimeDeposits() async {
    final uid = widget.user?.uid;
    if (uid == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('timeDeposit')
        .get();

    setState(() {
      _activeTimeDeposits = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'transactionType': data['transactionType'] ?? '',
          'amount': data['depositAmount'] ?? 0.0,
          'interest': data['interestRate'] ?? 0.0,
          'maturityDate': data['maturityDate'] ?? '',
          'status': 'Active', // You can enhance this with real status logic
        };
      }).toList();
    });
  }

  Future<void> _fetchSavingsId() async {
    final uid = widget.user?.uid;
    if (uid == null) return;
    final accountRefs = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('accountReferences')
        .get();
    for (var doc in accountRefs.docs) {
      final List<dynamic>? savingsAccounts = doc.data()['savingsAccounts'];
      if (savingsAccounts != null && savingsAccounts.isNotEmpty) {
        final id = savingsAccounts.first is String && savingsAccounts.first.contains('/')
            ? savingsAccounts.first.split('/').last
            : savingsAccounts.first;
        setState(() {
          savingsId = id;
        });
        break;
      }
    }
  }

  Stream<List<Map<String, dynamic>>> _getTransactionsStream(String accountId) {
    final accountRef = FirebaseFirestore.instance.doc('savings/$accountId');
    return FirebaseFirestore.instance
        .collection('transactions')
        .where('source.sourceRef', isEqualTo: accountRef)
        .orderBy('transactionDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  String formatAccountNumber(String accountCardNumber) {
    final cleaned = accountCardNumber.replaceAll(RegExp(r'\D'), ''); // Remove non-digits
    final buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      buffer.write(cleaned[i]);
      if ((i + 1) % 4 == 0 && i + 1 != cleaned.length) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }


 // naka const??
  @override
  Widget build(BuildContext context) {
    UserModel? user = widget.user;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        HomeTextButtonWidget(
                          buttonText: "Savings", 
                          onPressed: () {
                            print("This is the savings button");
                          },
                          backgroundColor: Color(0xFF028A6E),
                          textColor: Colors.white,
                          ),
                        SizedBox(width: 12),
                        HomeTextButtonWidget(
                          buttonText: "Credits", 
                          onPressed: () { 
                            showSnackbarMessage(context, "Credits under Development");
                          },
                          horizontalPadding: 35,
                          backgroundColor: Color.fromARGB(255, 237, 237, 237),
                          ),
                        SizedBox(width: 12),
                        HomeTextButtonWidget(
                          buttonText: "Loan", 
                          onPressed: () { 
                            showSnackbarMessage(context, "Loan is under Development");
                          },
                          horizontalPadding: 40,
                          backgroundColor: Color.fromARGB(255, 237, 237, 237),
                          ),
                      ],
                    ),
                  ), //Savings, Credits, Loan Buttons
              
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF06D6A0), Color(0xFF2CFFC8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                              Align(
                                alignment: Alignment(0.9, 1),
                                child: Text(
                                  "Account Savings #1",
                                  style: TextStyle(
                                    color: Color(0xFF1A1819),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Available Balance",
                                style: TextStyle(
                                  color: Color(0xFF044E42),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              StreamBuilder<DocumentSnapshot>(
                                stream: savingsId == null
                                    ? null
                                    : FirebaseFirestore.instance.collection('savings').doc(savingsId).snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text(
                                      "₱••••••",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }
                                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                                  final balance = data?['currentBalance'] ?? 0.0;
                                  return Text(
                                    widget.isBalanceHidden
                                        ? "₱••••••"
                                        : "₱${NumberFormat('#,##0.00', 'en_PH').format(balance)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Positioned(
                            left: 90,
                            top: 2,  // Adjust the top position as needed  // Adjust the right position as needed
                            child: IconButton(
                              icon: Icon(
                                widget.isBalanceHidden? Icons.visibility_off : Icons.visibility, // Eye icon
                                size: 16, // You can adjust the size of the icon
                                color: Colors.white, // Icon color (same as text color or any color you want)
                              ),
                              onPressed: () {
                                widget.onToggleBalanceVisibility();
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset('lib/assets/pictures/background_logo.png')
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
                  
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      bottom: 8,
                      ),
                    child: Container(
                      width: double.infinity,
                      height: 205, 
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6D6A6B), Color(0xFF413F40), Color(0xFF1A1819)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 18.0,
                          left: 12.00,
                          right: 24,
                          bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'lib/assets/pictures/emerald_logo_white.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    Text("EmeraldBank",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white
                                      )
                                      ,)
                                  ]
                                ),
                                SvgPicture.asset(
                                  'lib/assets/icons/visa_icon.svg',
                                  width: 53,
                                  height: 21,
                                )
                              ],
                            ),
                            SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Make the card number responsive
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.isCardHidden
                                            ? (user?.accountCardNumber != null && user!.accountCardNumber.length >= 4
                                                ? "•••• •••• •••• ${user.accountCardNumber.substring(user.accountCardNumber.length - 4)}"
                                                : "•••• •••• ••••")
                                            : user?.accountCardNumber != null
                                                ? formatAccountNumber(user!.accountCardNumber)
                                                : '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 2,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      widget.isCardHidden ? Icons.visibility_off : Icons.visibility,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      widget.onToggleCardVisibility();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("ISSUED \n ON",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white
                                    ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                    widget.isCardHidden ? "••/••/••••" : "${user?.issuedOn}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white
                                    ),
                                    ),
                                    
                                    SizedBox(width: 12,),

                                    Text("EXPIRES \n END",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white
                                    ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                    widget.isCardHidden ? "••/••/••••" : "${user?.expiresEnd}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white
                                    ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("CARD HOLDER NAME",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white
                                      ),),
                                    Text(
                                    widget.isCardHidden ? "••••••••••••••••••••" :"${user?.accountName}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white
                                      ),),
                                  ],
                                ),
                                Image.asset(
                                  'lib/assets/pictures/chip.png',
                                  width: 40,
                                  height: 40,
                                )
                              ],
                            )

                          ],
                        ),
                      ),
                    ),
                  ), // Credit Card Details
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Shortcuts",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed:
                        () async {
                      final updatedShortcuts = await Navigator.push(context, MaterialPageRoute(builder: (context) => 
                      CustomizePage(
                        selectedShortcuts: visibleShortcuts,
                        allShortcuts: allShortcuts,
                      )
                      )
                      );
                      if (updatedShortcuts != null) {
                        setState(() {
                          selectedKeys = List<String>.from(updatedShortcuts); // safely cast to List<String>
                          visibleShortcuts = allShortcuts
                              .where((item) => selectedKeys.contains(item['key']))
                              .toList();
                        });
                      }
                    },
                      child: Text("Customize",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF028A6E),
                      ),
                      ),
                    )
                  ),
                ]
              ),
          
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Always 4 per row
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.85, // Adjust for your button's shape
                ),
                itemCount: visibleShortcuts.length,
                itemBuilder: (context, index) {
                  String imagePath = visibleShortcuts[index]['image']!;
                  String text = visibleShortcuts[index]['text']!;
                  String key = visibleShortcuts[index]['key']!;
                  return ShortcutButton(
                    imagePath: imagePath,
                    text: text,
                    onTapCallback: (context) {
                      switch (key) {
                        case 'send':
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SendTransferScreen(user: widget.user)));
                          break;
                        case 'bills':
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PayBillsPage()));
                          break;
                        case 'invest':
                          Navigator.push(context, MaterialPageRoute(builder: (_) => InvestmentPage()));
                          break;
                        default:
                          showSnackbarMessage(context, "Feature is currently Under Development");
                      }
                    },
                  );
                },
              ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Active Investments",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed:
                        () => {
                          debugPrint("View all shortcuts")
                        },
                      child: Text("View all",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF028A6E),
                      ),
                      ),
                    )
                  ),
                ]
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ..._activeTimeDeposits.map((deposit) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: ActiveInvestmentCard(
                        title: deposit['transactionType'],
                        status: deposit['status'],
                        amount: "₱${NumberFormat('#,##0.00', 'en_PH').format(deposit['amount'])}",
                        interestRate: "${((deposit['interest'] as num) * 100).toStringAsFixed(2)}%",
                        maturityDate: deposit['maturityDate'],
                        onViewDetails: () {
                          // TODO: Implement view details navigation, pass referenceNumber if needed
                          showSnackbarMessage(context, "View Details is under development");
                        },
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InvestmentPage()),
                        );
                      },
                      child: Container(
                        width: 160,
                        height: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'lib/assets/icons/plus_icon.svg',
                              width: 48,
                              height: 48,
                            ),
                            Text(
                              "Create a New Investment",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            if (savingsId == null) ...[
              const Center(child: CircularProgressIndicator()),
            ] else ...[
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getTransactionsStream(savingsId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
                    return const TransactionOverview(
                      transactions: [],
                      isLoading: true,
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading transactions: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  final transactions = snapshot.data ?? [];
                  return TransactionOverview(
                    transactions: transactions,
                    isLoading: false,
                    accountId: savingsId,
                    onViewAllPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionHistoryPage(accountId: savingsId!),
                        ),
                      );
                    },
                    onTransactionTap: (transaction) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionDetails(
                            transactionId: transaction['id'],
                            transactionData: transaction,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
            const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

