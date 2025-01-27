import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'board-meetings.dart';

class BoardSelection extends StatefulWidget {
  const BoardSelection({super.key});

  @override
  _BoardSelectionState createState() => _BoardSelectionState();
}

class _BoardSelectionState extends State<BoardSelection> {
  List<String> boards = [];

  @override
  void initState() {
    super.initState();
    _loadBoards();
  }

  Future<void> _loadBoards() async {
    // Load JSON data from the file
    final String response = await rootBundle.loadString('lib/assets/boards.json');
    final List<dynamic> data = json.decode(response);

    // Update the boards list
    setState(() {
      boards = data.map((item) => item['name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Επιλογή Συνεδρίου",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Makes the back arrow white
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: boards.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loader until data is loaded
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.teal.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: boards.length,
                  itemBuilder: (context, index) {
                    final boardName = boards[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BoardMeetingsScreen(boardName: boardName),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          backgroundColor: Colors.teal.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
                          shadowColor: Colors.teal.shade200,
                        ),
                        child: Text(
                          boardName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
