import 'package:flutter/material.dart';

class UserMarkAttendance extends StatelessWidget {
  const UserMarkAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mark Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                //TODO: call API
                // Logic to mark attendance
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Attendance Marked Successfully')),
                );
              },
              child: const Text("Mark as Present"),
            ),
          ],
        ),
      ),
    );
  }
}
