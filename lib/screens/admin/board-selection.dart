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
          "Επιλογή Χρήσης",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: boards.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loader until data is loaded
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.teal.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: boards
                .map(
                  (boardName) => Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
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
                    padding:
                    const EdgeInsets.symmetric(vertical: 20.0),
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    boardName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }
}
