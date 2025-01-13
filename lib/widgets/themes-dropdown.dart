import 'package:flutter/material.dart';

class ThemesDropdown extends StatelessWidget {
  final String selectedCategory;
  final String selectedTheme;
  final Map<String, List<String>> themes;
  final List<Map<String, dynamic>> votingMembers;
  final List<String> votingOptions;
  final Function(String) onThemeChanged;
  final Function(String) onCategoryChanged;
  final Function(int, String) onVoteChanged;

  const ThemesDropdown({
    Key? key,
    required this.selectedCategory,
    required this.selectedTheme,
    required this.themes,
    required this.votingMembers,
    required this.votingOptions,
    required this.onThemeChanged,
    required this.onCategoryChanged,
    required this.onVoteChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
       children: [
        // Category Selection
        Row(
          children: [
            _buildCategoryButton(
              context: context,
              label: "ΘΕΜΑΤΑ ΣΥΜΠΛΗΡΩΜΑΤΙΚΗΣ ΔΙΑΤΑΞΗΣ",
              isSelected:
              selectedCategory == "ΘΕΜΑΤΑ ΣΥΜΠΛΗΡΩΜΑΤΙΚΗΣ ΔΙΑΤΑΞΗΣ",
              onTap: () => onCategoryChanged(
                  "ΘΕΜΑΤΑ ΣΥΜΠΛΗΡΩΜΑΤΙΚΗΣ ΔΙΑΤΑΞΗΣ"),
            ),
            _buildCategoryButton(
              context: context,
              label: "ΘΕΜΑΤΑ ΗΜΕΡΙΣΙΑΣ ΔΙΑΤΑΞΗΣ",
              isSelected: selectedCategory == "ΘΕΜΑΤΑ ΗΜΕΡΙΣΙΑΣ ΔΙΑΤΑΞΗΣ",
              onTap: () => onCategoryChanged("ΘΕΜΑΤΑ ΗΜΕΡΙΣΙΑΣ ΔΙΑΤΑΞΗΣ"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Theme Dropdown
        DropdownButton<String>(
          value: selectedTheme,
          isExpanded: true,
          items: themes[selectedCategory]!
              .map(
                (theme) => DropdownMenuItem(
              value: theme,
              child: Text(
                theme,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
              .toList(),
          onChanged: (value) => onThemeChanged(value!),
          underline: const SizedBox(),
          dropdownColor: Colors.blueGrey,
        ),
        const SizedBox(height: 20),
        // Voting Members List
        Expanded(
          child: ListView.builder(
            itemCount: votingMembers.length,
            itemBuilder: (context, index) {
              final member = votingMembers[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Member Name
                      Text(
                        member["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Voting Dropdown
                      Row(
                        children: [
                          const Text(
                            "ΨΗΦΟΣ:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: member["vote"],
                            items: votingOptions
                                .map(
                                  (option) => DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              ),
                            )
                                .toList(),
                            onChanged: (value) =>
                                onVoteChanged(index, value!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper Widget for Category Buttons
  Widget _buildCategoryButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal.shade700 : Colors.teal.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
