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
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onCategoryChanged("ΘΕΜΑΤΑ ΣΥΜΠΛΗΡΩΜΑΤΙΚΗΣ ΔΙΑΤΑΞΗΣ"),
                child: Container(
                  height: 55,
                  color: selectedCategory == "ΘΕΜΑΤΑ ΣΥΜΠΛΗΡΩΜΑΤΙΚΗΣ ΔΙΑΤΑΞΗΣ"
                      ? Colors.teal.shade700
                      : Colors.teal.shade300,
                  child: const Center(
                    child: Text(
                      "ΘΕΜΑΤΑ ΣΥΜΠΛΗΡΩΜΑΤΙΚΗΣ ΔΙΑΤΑΞΗΣ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onCategoryChanged("ΘΕΜΑΤΑ ΗΜΕΡΙΣΙΑΣ ΔΙΑΤΑΞΗΣ"),
                child: Container(
                  height: 55,
                  color: selectedCategory == "ΘΕΜΑΤΑ ΗΜΕΡΙΣΙΑΣ ΔΙΑΤΑΞΗΣ"
                      ? Colors.teal.shade700
                      : Colors.teal.shade300,
                  child: const Center(
                    child: Text(
                      "ΘΕΜΑΤΑ ΗΜΕΡΙΣΙΑΣ ΔΙΑΤΑΞΗΣ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        DropdownButton<String>(
          value: selectedTheme,
          isExpanded: true,
          items: themes[selectedCategory]!
              .map((theme) => DropdownMenuItem(
                    value: theme,
                    child: Text(
                      theme,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
          onChanged: (value) => onThemeChanged(value!),
        ),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            member["name"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("ΨΗΦΟΣ: "),
                          DropdownButton<String>(
                            value: member["vote"],
                            items: votingOptions
                                .map((option) => DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    ))
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
}
