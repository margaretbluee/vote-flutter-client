import 'package:flutter/material.dart';
import '../../services/attendees-service.dart';
import '../../shared-data/voting-data.dart';

class UserMarkAttendance extends StatelessWidget {
  UserMarkAttendance({super.key});


  final AttendeesService _attendeesService = AttendeesService();


  void _markAttendance(BuildContext context) async {
    try {

      final userId = VotingData().getId();


      // call the service to mark attendance as 'yes'
      final response = await _attendeesService.markAttendance(userId);

      // success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance marked successfully!')),
      );
    } catch (e) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error marking attendance: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mark Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _markAttendance(context),
              child: const Text("Mark as Present"),
            ),
          ],
        ),
      ),
    );
  }
}
