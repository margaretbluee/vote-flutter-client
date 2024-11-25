import 'package:flutter/material.dart';
import 'admin-set-voting.dart';
import 'admin-show-attendees.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminSetVoting()),
                );
              },
              child: const Text("Set Voting Question"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminShowAttendees()),
                );
              },
              child: const Text("Show Attendees"),
            ),
          ],
        ),
      ),
    );
  }
}
