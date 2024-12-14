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
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
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
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("ΠΑΡΟΥΣΙΑ: "),
                    Switch(
                      value: member["presence"],
                      onChanged: (value) =>
                          onPresenceChanged(index, value),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("ΑΠΟΜΑΚΡΥΣΜΕΝΗ ΠΑΡΟΥΣΙΑ: "),
                    Checkbox(
                      value: member["remote"],
                      onChanged: (value) =>
                          onRemoteChanged(index, value!),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
