import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MembersWithPresence extends StatelessWidget {
  final List<Map<String, dynamic>> members;
  final Function(int, bool) onPresenceChanged;
  final Function(int, bool) onRemoteChanged;

  const MembersWithPresence({
    Key? key,
    required this.members,
    required this.onPresenceChanged,
    required this.onRemoteChanged,
  }) : super(key: key);

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
                            Checkbox(
                              value: member["presence"],
                              onChanged: (value) {
                                onPresenceChanged(index, value!);
                              },
                              activeColor: Colors.teal[800],
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
                                  onRemoteChanged(index, value!);
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
              onPressed: () {
                print("Members Data: $members");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data saved!")),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
 backgroundColor: Colors.teal[700],
                 shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
              child: const Text(
                "ΥΠΟΒΟΛΗ ΠΑΡΟΥΣΙΩΝ",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: Colors.white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
