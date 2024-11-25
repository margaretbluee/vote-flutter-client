import 'package:flutter/material.dart';
import 'user-mark-attendance.dart'; //  attendance screen
import 'user-vote.dart' ;    //   voting screen

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserMarkAttendance()),
                );
              },
              child: const Text("Mark Attendance"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserVote()),
                );
              },
              child: const Text("Vote"),
            ),
          ],
        ),
      ),
    );
  }
}
