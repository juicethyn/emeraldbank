import 'package:flutter/material.dart';

class AccountDetailsSection extends StatefulWidget {
  final String sectionTitle;
  final Map<String, String> details;
  final bool initiallyExpanded;
  final bool eneableToggle;

  const AccountDetailsSection({
    super.key,
    required this.sectionTitle,
    required this.details,
    this.initiallyExpanded = true,
    this.eneableToggle = true,
  });

  @override
  State<AccountDetailsSection> createState() => _AccountDetailsSectionState();
}

class _AccountDetailsSectionState extends State<AccountDetailsSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowExpanded = !widget.eneableToggle || _isExpanded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.sectionTitle,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.black,
              ),
            ),

            if (widget.eneableToggle)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Hide' : 'Show',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 10),
            ],
          ),
          child:
              shouldShowExpanded
                  ? Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...widget.details.entries.map((entry) {
                          final isLastEntry =
                              entry.key == widget.details.keys.last;
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: isLastEntry ? 0 : 14,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Color(0xFF044E42),
                                  ),
                                ),
                                Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xFF1A1819),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }), // Added .toList() for clarity
                      ],
                    ),
                  )
                  : Container(
                    height: 43,
                    padding: const EdgeInsets.all(14),
                    child: const Center(
                      child: Text(
                        'Hidden',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Color(0xFF1A1819),
                        ),
                      ),
                    ),
                  ),
        ),
      ],
    );
  }
}
