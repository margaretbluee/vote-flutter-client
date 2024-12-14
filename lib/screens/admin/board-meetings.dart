import 'dart:convert';
import 'package:flutter/material.dart';

import 'board-meeting-details.dart';

class BoardMeetingsScreen extends StatefulWidget {
  final String boardName;

  const BoardMeetingsScreen({super.key, required this.boardName});

  @override
  State<BoardMeetingsScreen> createState() => _BoardMeetingsScreenState();
}

class _BoardMeetingsScreenState extends State<BoardMeetingsScreen> {
  late Future<List<Map<String, String>>> _meetingsFuture;

  @override
  void initState() {
    super.initState();
    _meetingsFuture = _loadMeetings();
  }

  Future<List<Map<String, String>>> _loadMeetings() async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/meetings.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Map<String, String>.from(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.boardName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Map<String, String>>>(
          future: _meetingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading meetings"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No meetings available"));
            }

            final meetings = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: meetings.length,
              itemBuilder: (context, index) {
                final meeting = meetings[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoardMeetingDetailsScreen(
                          meetingId: meeting["Αριθμός Συνεδρίασης"]!,
                          location: meeting["Τοποθεσία"]!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Αριθμός Συνεδρίασης:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                meeting["Αριθμός Συνεδρίασης"]!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                "Ημερομηνία:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                meeting["Ημερομηνία"]!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                "Τοποθεσία:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                meeting["Τοποθεσία"]!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                "Τύπος:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                meeting["Τύπος"]!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
