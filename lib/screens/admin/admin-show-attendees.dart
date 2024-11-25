import 'package:flutter/material.dart';

class AdminShowAttendees extends StatefulWidget {
  const AdminShowAttendees({super.key});


  @override
  State<AdminShowAttendees> createState() => _AdminShowAttendeesState();
}


class _AdminShowAttendeesState extends State<AdminShowAttendees> {
  // simulated list of attendees
  //TODO:  replace this with an actual API call later
  final List<String> attendees = [
    'John Doe',
    'Jane Smith',
    'Mark Johnson',
    'Emily Davis',
    'Michael Brown',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendees List")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // sisplay the list of attendees
            Expanded(
              child: ListView.builder(
                itemCount: attendees.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(attendees[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



