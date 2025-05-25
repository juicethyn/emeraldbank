import 'package:flutter/material.dart';

class CustomizePage extends StatefulWidget {
  final List<Map<String, dynamic>> allShortcuts;
  final List<Map<String, dynamic>> selectedShortcuts;

  const CustomizePage({
    Key? key,
    required this.allShortcuts,
    required this.selectedShortcuts,
  }) : super(key: key);

  @override
  State<CustomizePage> createState() => _CustomizePageState();
}

class _CustomizePageState extends State<CustomizePage> {
  late List<Map<String, dynamic>> selectedShortcuts;

  @override
  void initState() {
    super.initState();
    selectedShortcuts = List.from(widget.selectedShortcuts);
  }

  bool isSelected(String key) {
    return selectedShortcuts.any((item) => item['key'] == key);
  }

  void toggleShortcut(Map<String, dynamic> shortcut) {
    setState(() {
      if (isSelected(shortcut['key'])) {
        selectedShortcuts.removeWhere((item) => item['key'] == shortcut['key']);
      } else {
        selectedShortcuts.add(shortcut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customize",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text("Choose which shortcuts appear on your home screen. Use the checkboxes to select or unselect features for quick access.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  
                  ),),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: GridView.builder(
                itemCount: widget.allShortcuts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Always 4 per row
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.1, // Adjust for your button's shape
                ),
                itemBuilder: (context, index) {
                  final shortcut = widget.allShortcuts[index];
                  final isChecked = isSelected(shortcut['key']);

                  return GestureDetector(
                    onTap: () => toggleShortcut(shortcut),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isChecked ? const Color(0xFF06D6A0).withOpacity(0.2) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isChecked ? const Color(0xFF06D6A0) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF06D6A0),
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              shortcut['image'],
                              width: 30,
                              height: 30,
                            ),
                          ),
                          Text(
                            shortcut['text'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16), // 👈 Add bottom margin here
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                List<String> updatedKeys = selectedShortcuts.map((item) => item['key'] as String).toList();
                Navigator.pop(context, updatedKeys);
              },
              label: const Text(
                "Save Changes",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06D6A0),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
