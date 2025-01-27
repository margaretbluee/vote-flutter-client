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
  bool _showSaveButton = false; // State for SAVE button

  List<Map<String, dynamic>> members = [];
  Map<String, List<String>> themes = {};
  List<String> votingOptions = [];

  String _selectedThemeCategory = "ΘΕΜΑΤΑ ΣΥΜΠΛΗΡΩΜΑΤΙΚΗΣ ΔΙΑΤΑΞΗΣ";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final membersData = await _loadJson('lib/assets/members.json');
      final themesData = await _loadJson('lib/assets/themes.json');
      final votingOptionsData = await _loadJson(
          'lib/assets/voting_options.json');

      setState(() {
        members = List<Map<String, dynamic>>.from(membersData);
        themes = Map<String, List<String>>.from(
            themesData.map((key, value) =>
                MapEntry(
                    key as String,
                    List<String>.from(value))));
        votingOptions = List<String>.from(votingOptionsData);
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

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

  void _printResults() {
    print("Selected Theme Category: $_selectedThemeCategory");
    print("Selected Theme: $_selectedTheme");
    print("Members: $members");
  }

  Future<void> _showVotingDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("ΜΥΣΤΙΚΗ ΨΗΦΟΦΟΡΙΑ"),
          content: const Text("Θέλετε να ξεκινήσετε μυστική ψηφοφορία;"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
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
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return VotingScreen(votingOptions: votingOptions);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Συνεδρίαση: ${widget.meetingId}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Makes the back arrow white
        ),
        elevation: 5,
        backgroundColor: Colors.teal.shade600,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade300,
              Colors.teal.shade50,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedIndex == 0
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MembersWithPresence(
                    members: members,
                    onPresenceChanged: _updateMemberPresence,
                    onRemoteChanged: _updateMemberRemote,
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ThemesDropdown(
                    selectedCategory: _selectedThemeCategory,
                    selectedTheme: _selectedTheme,
                    themes: themes,
                    votingMembers: members,
                    votingOptions: votingOptions,
                    onThemeChanged: _updateTheme,
                    onCategoryChanged: _updateThemeCategory,
                    onVoteChanged: _updateVote,
                  ),
                ),
              ),
            ),
            if (_showSaveButton || _selectedIndex == 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        print("Selected Theme Category: $_selectedThemeCategory");
                        print("Selected Theme: $_selectedTheme");
                        print("Members: $members");

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        "ΥΠΟΒΟΛΗ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showVotingDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.how_to_vote, color: Colors.white),
                      label: const Text(
                        "ΜΥΣΤΙΚΗ ΨΗΦΟΦΟΡΙΑ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.teal.shade600,
          boxShadow: [
            BoxShadow(
              color: Colors.teal.shade300.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _showSaveButton = index == 1;
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.teal.shade200,
          backgroundColor: Colors.teal.shade600,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: "ΜΕΛΗ",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.topic),
              label: "ΘΕΜΑΤΑ",
            ),
          ],
        ),
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
    for (var option in widget.votingOptions) {
      _controllers[option] = TextEditingController();
    }
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade300,
            Colors.teal.shade50,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Transparent to show gradient
        appBar: AppBar(
          title: const Text(
            "Μυστική Ψηφοφορία",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24
                ,   color:Colors.white ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Makes the back arrow white
          ),
          centerTitle: true,
          elevation: 5,
          backgroundColor: Colors.teal.shade600,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Παρακαλώ εισάγετε τον αριθμό ψήφων για κάθε επιλογή:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.votingOptions.length,
                  itemBuilder: (context, index) {
                    String option = widget.votingOptions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: _controllers[option],
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    labelText: "Αριθμός",
                                    labelStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.teal,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.teal.shade300,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _controllers.forEach((option, controller) {
                      print("$option: ${controller.text}");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 6,
                  ),
                  child: const Text(
                    "Υποβολή Ψήφων",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  }