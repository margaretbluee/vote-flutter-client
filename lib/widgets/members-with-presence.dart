import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

const List<Widget> toggleOptions = <Widget>[
  Text('ΝΑΙ'),
  Text('ΟΧΙ'),
];

class MembersWithPresence extends StatefulWidget {
  @override
  _MembersWithPresenceState createState() => _MembersWithPresenceState();
}

class _MembersWithPresenceState extends State<MembersWithPresence> {
  List<Map<String, dynamic>> members = [];

  @override
  void initState() {
    super.initState();
    _loadMembersFromFile();
  }

  Future<void> _loadMembersFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/members.json';
      final file = File(filePath);

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(jsonString);
        setState(() {
          members = List<Map<String, dynamic>>.from(jsonData);
        });
        print("✅ Members loaded from: $filePath");
      } else {
        print("⚠️ members.json not found.");
      }
    } catch (e) {
      print("❌ Error loading members: $e");
    }
  }

  Future<void> saveVotingMembersToFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final votingFilePath = '${directory.path}/votingMembers.json';

      // Filter only members where presence == true and keep only their names
      final votingMembers = members
          .where((member) => member["presence"] == true)
          .map((member) => {"name": member["name"]}) // Keep only name
          .toList();

      final votingFile = File(votingFilePath);
      await votingFile.writeAsString(jsonEncode(votingMembers));

      print("✅ Voting members saved to: $votingFilePath");
    } catch (e) {
      print("❌ Error saving voting members: $e");
    }
  }

  void updatePresence(int index, bool newValue) {
    setState(() {
      members[index]["presence"] = newValue;
    });
  }

  void updateRemote(int index, bool newValue) {
    setState(() {
      members[index]["remote"] = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ΠΑΡΟΥΣΙΕΣ'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "ΠΑΡΟΥΣΙΑ:",
                              style: TextStyle(fontSize: 13),
                            ),
                            ToggleButtons(
                              isSelected: [member["presence"], !member["presence"]],
                              onPressed: (int selectedIndex) {
                                bool newValue = selectedIndex == 0;
                                updatePresence(index, newValue);
                              },
                              borderRadius: BorderRadius.circular(10),
                              selectedColor: Colors.white,
                              fillColor: Colors.teal[800],
                              children: toggleOptions,
                            ),
                          ],
                        ),
                        if (member["presence"])
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "ΑΠΟΜΑΚΡΥΣΜΕΝΗ ΠΑΡΟΥΣΙΑ:",
                                style: TextStyle(fontSize: 12),
                              ),
                              Checkbox(
                                value: member["remote"],
                                onChanged: (value) {
                                  updateRemote(index, value!);
                                },
                                activeColor: Colors.teal[400],
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await saveVotingMembersToFile();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Η υποβολή ολοκληρώθηκε!")),
                );

              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.teal[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "ΥΠΟΒΟΛΗ ΠΑΡΟΥΣΙΩΝ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
