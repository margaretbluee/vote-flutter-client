import 'package:flutter/material.dart';
import 'package:meet_app/services/attendees-service.dart';


class AdminShowAttendees extends StatefulWidget {
  const AdminShowAttendees({super.key});

  @override
  State<AdminShowAttendees> createState() => _AdminShowAttendeesState();
}

class _AdminShowAttendeesState extends State<AdminShowAttendees> {
  //  store attendee names fetched from the API
  List<String> attendees = [];
  bool isLoading = true;  // Loading state


  @override
  void initState() {
    super.initState();
    _fetchAttendees();
  }

  //  fetch attendees
  Future<void> _fetchAttendees() async {
    try {
      final service = AttendeesService();
      final fetchedAttendees = await service.fetchAttendees();
      setState(() {
        attendees = fetchedAttendees;
        isLoading = false;
      });
    } catch (e) {

      setState(() {
        isLoading = false;
      });
      print("Error fetching attendees: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendees List")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            //   loading indicator while data is being fetched
            if (isLoading)
              const CircularProgressIndicator(),

            //  list of attendees once fetched
            if (!isLoading && attendees.isEmpty)
              const Text("No attendees found."),

         
            if (!isLoading && attendees.isNotEmpty)
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
