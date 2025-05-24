import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/styles/accountdetails_appbar.dart';
import 'package:emeraldbank_mobileapp/features/user_auth/presentation/widgets/account_details_section.dart';
import 'package:emeraldbank_mobileapp/utils/formatting_utils.dart';
import 'package:flutter/material.dart';

class TransactionDetails extends StatefulWidget {
  final String transactionId;
  final Map<String, dynamic>? transactionData;

  const TransactionDetails({
    super.key,
    required this.transactionId,
    this.transactionData, // Optional: Pass data directly to avoid another fetch
  });

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  bool _isLoading = true;
  Map<String, dynamic>? _transaction;

  @override
  void initState() {
    super.initState();
    if (widget.transactionData != null) {
      // If data was passed directly, use it
      _transaction = widget.transactionData;
      _isLoading = false;
    } else {
      // Otherwise fetch it from Firestore
      _fetchTransactionDetails();
    }
  }

  Future<void> _fetchTransactionDetails() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('transactions')
              .doc(widget.transactionId)
              .get();

      if (doc.exists) {
        setState(() {
          _transaction = {'id': doc.id, ...doc.data()!};
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching transaction: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AccountDetailsAppbar(title: 'Transaction Details'),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF06D6A0)),
              )
              : _transaction == null
              ? const Center(child: Text('Transaction not found'))
              : _buildTransactionDetails(),
    );
  }

  Widget _buildTransactionDetails() {
    final amount = toDouble(_transaction!['amount']);
    final fee = toDouble(_transaction!['fee'] ?? 0);
    final totalAmount = amount + fee;

    final transactionDate = _transaction!['transactionDate'] as Timestamp;
    final formattedDate = formatTransactionDateAtHour(transactionDate);

    final channelType =
        _transaction!['channelDetails']?['channelType'] ?? 'Mobile Banking';
    final transactionType = _transaction!['transactionType'] ?? 'Fund Transfer';
    final status = _transaction!['status'] ?? 'completed';
    final referenceNumber = _transaction!['referenceNumber'] ?? '-';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top section with icon, amount, and type
            Column(
              children: [
                SizedBox(height: 24),

                // Circular icon with gradient background
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF044E42),
                        Color(0xFF1A685B),
                        Color(0xFF3A8175),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getTransactionIcon(transactionType),
                    color: const Color(0xFFF8FFE5),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 32),

                // Channel type badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF044E42)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    channelType,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1819),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Amount and type
                Column(
                  children: [
                    Text(
                      transactionType,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0x99044E42),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      formatCurrency(totalAmount),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Date, status, reference number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Color(0xFF4D4D4D),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate.toLowerCase(),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4D4D4D),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      status.toLowerCase() == 'completed'
                          ? Icons.check_circle
                          : Icons.pending,
                      size: 16,
                      color:
                          status.toLowerCase() == 'completed'
                              ? const Color(0xFF27AE60)
                              : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status.isNotEmpty
                          ? status[0].toUpperCase() + status.substring(1)
                          : status,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4D4D4D),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Reference number
            Center(
              child: Row(
                mainAxisSize:
                    MainAxisSize
                        .min, // Important to make the row only as wide as needed
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Reference Number: ',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF161314),
                    ),
                  ),
                  Text(
                    referenceNumber,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4D4D4D),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Additional transaction details
            AccountDetailsSection(
              sectionTitle: 'Transaction Details',
              details: {
                'Source': _getSourceName(),
                'Destination:': _getDestinationName(),
                'Amount': formatCurrency(amount),
                'Fee': formatCurrency(fee),
                'Total Amount': formatCurrency(totalAmount),
              },
              eneableToggle: false,
            ),
          ],
        ),
      ),
    );
  }

  String _getSourceName() {
    final sourceId = _transaction!['source']?['sourceid'];
    // In a real app, you might want to fetch the actual name from Firestore
    // For now, just display the ID for demonstration
    return sourceId ?? 'Unknown';
  }

  String _getDestinationName() {
    final destId = _transaction!['destination']?['destinationid'];
    // In a real app, you might want to fetch the actual name from Firestore
    return destId ?? 'Unknown';
  }
}
