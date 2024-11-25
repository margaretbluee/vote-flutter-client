import 'package:flutter/material.dart';
import '../../services/voting-service.dart';
import '../../shared-data/voting-data.dart';

class UserVote extends StatefulWidget {
  const UserVote({super.key});

  @override
  State<UserVote> createState() => _UserVoteState();
}

class _UserVoteState extends State<UserVote> {
  String votingQuestion = '';
  late List<Map<String, dynamic>> votingOptions = []; // store options as maps with ID and text
  late int questionId;
  final VotingService _votingService = VotingService();
  bool canVote = true; //enable voting initially
  Map<int, int> voteCounts = {}; // track realtime vote counts

  @override
  void initState() {
    super.initState();
    fetchVotingData();
  }

  // fetch question  options   and initial results
  void fetchVotingData() async {
    try {
      //  question data
      final questionResponse = await _votingService.getVotingQuestion();
      //   voting options based on the question ID
      final optionsResponse = await _votingService.getVotingOptions(questionResponse['id']);
      // voting results based on the question ID
      final resultsResponse = await _votingService.getVotingResults(questionResponse['id']);

      setState(() {
        votingQuestion = questionResponse['question'];
        questionId = questionResponse['id'];
        votingOptions = optionsResponse.cast<Map<String, dynamic>>();
        voteCounts = {
          for (var result in resultsResponse)
            result['optionId']: result['voteCount'],
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading voting data: $e')),
      );
    }
  }

  //  handle voting
  void vote(Map<String, dynamic> selectedOption) async {
    // send th votingOptionId and questionId to the backend
    int votingOptionId = selectedOption['id'];
    final userId = VotingData().getId();

    try {
      final response = await _votingService.submitVote(userId, questionId, votingOptionId);
      if (response['statusCode'] == 200) {
        //after a successful vote    voting is disabled
        setState(() {
          canVote = false; //  voting disabled after the first vote
          //  vote count ++ locally for the selected option
          voteCounts[votingOptionId] = (voteCounts[votingOptionId] ?? 0) + 1;
        });

        // fetch updated results immediately after vote submission
        fetchVotingResults();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your vote was submitted successfully!')),
        );
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit vote.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

// fetch updated voting results after a vote
  void fetchVotingResults() async {
    try {
      // API call to fetch the real-time vote counts after the vote submission
      final resultsResponse = await _votingService.getVotingResults(questionId);

      // map  response to voteCounts (map of optionId -> voteCount)
      setState(() {
        voteCounts = {
          for (var result in resultsResponse)
            result['optionId']: result['voteCount'],
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading updated results: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voting Screen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // dDisplay the voting question
            Text(
              votingQuestion,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // display the voting options dynamically
            ...votingOptions.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: canVote ? () => vote(option) : null, // disable vote button if canVote is false
                  child: Text(option['optionText']),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            //     display real-time voting results
            Text(
              "Real-Time Voting Results",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (voteCounts.isEmpty)
              const Text("No votes yet."),
            if (voteCounts.isNotEmpty)
              Column(
                children: votingOptions.map((option) {
                  final optionId = option['id']; // use 'id' from the option map
                  final voteCount = voteCounts[optionId] ?? 0; // get the vote count for the optionId
                  return Text(
                    "${option['optionText']}: $voteCount votes", // display option text and its vote count
                    style: const TextStyle(fontSize: 16),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }}
