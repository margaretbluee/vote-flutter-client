import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:meet_app/widgets/members-with-presence.dart';

import '../../widgets/themes-dropdown.dart';

class BoardMeetingDetailsScreen extends StatefulWidget {
  final String meetingId;
  final String location;

  const BoardMeetingDetailsScreen({
    super.key,
    required this.meetingId,
    required this.location,
  });

  @override
  _BoardMeetingDetailsScreenState createState() =>
      _BoardMeetingDetailsScreenState();
}

class _BoardMeetingDetailsScreenState extends State<BoardMeetingDetailsScreen> {
  int _selectedIndex = 0;
  String _selectedTheme = "Έγκριση Προϋπολογισμού";
  List<Map<String, dynamic>> members = [];
 // late List<Map<String, dynamic>> members;
   Map<String, List<String>> themes = {};
    List<String> votingOptions = [];

  String _selectedThemeCategory = "ΘΕΜΑΤΑ ΣΥΜΠΛΗΡΩΜΑΤΙΚΗΣ ΔΙΑΤΑΞΗΣ";


  @override
  void initState() {
    super.initState();
    _loadData();  // Load data when the widget is initialized
  }

  Future<void> _loadData() async {
    try {
      final membersData = await _loadJson('lib/assets/members.json');
      final themesData = await _loadJson('lib/assets/themes.json');
      final votingOptionsData = await _loadJson('lib/assets/voting_options.json');

      // Print the loaded data for debugging
      print("Members Data: $membersData");
      print("Themes Data: $themesData");
      print("Voting Options Data: $votingOptionsData");

      // Initialize the members, themes, and votingOptions from the loaded data
      setState(() {
        members = List<Map<String, dynamic>>.from(membersData);

        // Explicitly cast the values of themesData to List<String> to fix the type error
        themes = Map<String, List<String>>.from(
            themesData.map((key, value) => MapEntry(
                key as String,
                List<String>.from(value) // Ensure it's a List<String>
            ))
        );

        // Explicitly cast the votingOptionsData to List<String> to fix the type error
        votingOptions = List<String>.from(votingOptionsData);
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }


  // Load JSON from assets
  Future<dynamic> _loadJson(String path) async {
    try {
      final String response = await rootBundle.loadString(path);
      return json.decode(response);
    } catch (e) {
      print("Error loading JSON: $e");
      rethrow;
    }
  }




  void _updateMemberPresence(int index, bool value) {
    setState(() {
      members[index]["presence"] = value;
    });
  }

  void _updateMemberRemote(int index, bool value) {
    setState(() {
      members[index]["remote"] = value;
    });
  }

  void _updateVote(int index, String value) {
    setState(() {
      members[index]["vote"] = value;
    });
  }

  void _updateThemeCategory(String category) {
    setState(() {
      _selectedThemeCategory = category;
      _selectedTheme = themes[category]!.first;
    });
  }

  void _updateTheme(String theme) {
    setState(() {
      _selectedTheme = theme;
    });
  }


  Future<void> _showDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("ΜΥΣΤΙΚΗ ΨΗΦΟΦΟΡΙΑ"),
          content: const Text("Θέλετε να ξεκινήσετε μυστική ψηφοφορία;"),
          actions: [
            TextButton(
              onPressed: () {
                // Act as if "ΘΕΜΑΤΑ" was clicked
                Navigator.of(context).pop(false);
                setState(() {
                  _selectedIndex = 1; // Switch to the "ΘΕΜΑΤΑ" screen
                });
              },
              child: const Text("ΟΧΙ"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("ΝΑΙ"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // Display voting screen
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return VotingScreen(votingOptions: votingOptions);
      }));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meeting: ${widget.meetingId}")),
      body: _selectedIndex == 0
          ? MembersWithPresence(
        members: members,
        onPresenceChanged: _updateMemberPresence,
        onRemoteChanged: _updateMemberRemote,
      )
          : ThemesDropdown(
        selectedCategory: _selectedThemeCategory,
        selectedTheme: _selectedTheme,
        themes: themes,
        votingMembers: members, // Assuming members vote
        votingOptions: votingOptions,
        onThemeChanged: _updateTheme,
        onCategoryChanged: _updateThemeCategory,
        onVoteChanged: _updateVote,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            _showDialog(context);
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "ΜΕΛΗ"),
          BottomNavigationBarItem(icon: Icon(Icons.topic), label: "ΘΕΜΑΤΑ"),
        ],
      ),
    );
  }
}

class VotingScreen extends StatefulWidget {
  final List<String> votingOptions;

  const VotingScreen({super.key, required this.votingOptions});

  @override
  _VotingScreenState createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each voting option
    for (var option in widget.votingOptions) {
      _controllers[option] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Μυστική Ψηφοφορία")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display input for each voting option
            Expanded(
              child: ListView.builder(
                itemCount: widget.votingOptions.length,
                itemBuilder: (context, index) {
                  String option = widget.votingOptions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Text(option), // Display the voting option
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controllers[option],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Αριθμός",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle submission logic here (e.g., storing values, sending data)
                _controllers.forEach((option, controller) {
                  print("$option: ${controller.text}");
                });
              },
              child: const Text("Υποβολή Ψήφων"),
            ),
          ],
        ),
      ),
    );
  }
}
