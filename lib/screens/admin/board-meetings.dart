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
        .loadString('lib/assets/meetings.json');
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
            colors: [Colors.teal.shade300, Colors.teal.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Map<String, String>>>(
          future: _meetingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return _buildErrorState();
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
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
                  child: _buildMeetingCard(meeting),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMeetingCard(Map<String, String> meeting) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 8,
      shadowColor: Colors.teal.shade200,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.teal.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              icon: Icons.numbers,
              label: "Αριθμός Συνεδρίασης:",
              value: meeting["Αριθμός Συνεδρίασης"]!,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: "Ημερομηνία:",
              value: meeting["Ημερομηνία"]!,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              icon: Icons.location_on,
              label: "Τοποθεσία:",
              value: meeting["Τοποθεσία"]!,
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              icon: Icons.info,
              label: "Τύπος:",
              value: meeting["Τύπος"]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal.shade600, size: 20),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14,color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
          const SizedBox(height: 20),
          const Text(
            "Error loading meetings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.meeting_room_outlined,
              size: 80, color: Colors.grey.shade500),
          const SizedBox(height: 20),
          const Text(
            "No meetings available",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
