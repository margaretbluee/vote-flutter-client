import 'package:flutter/material.dart';
import '../../services/voting-service.dart';
import '../../shared-data/voting-data.dart';

class AdminSetVoting extends StatefulWidget {
  const AdminSetVoting({super.key});

  @override
  State<AdminSetVoting> createState() => _AdminSetVotingState();
}

class _AdminSetVotingState extends State<AdminSetVoting> {
  final TextEditingController optionController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final VotingService _votingService = VotingService();

  //   new voting option
  void addOption() {
    setState(() {
      if (optionController.text.isNotEmpty) {
        VotingData().addOption(optionController.text); // dynamically adding options
        optionController.clear();
      }
    });
  }

  //remove a voting option
  void removeOption(int index) {
    setState(() {
      VotingData().removeOption(index); // remove option by index
    });
  }

  //set the voting question
  void setQuestion() {
    setState(() {
      if (questionController.text.isNotEmpty) {
        VotingData().setVotingQuestion(questionController.text); // set the voting question
        questionController.clear();
      }
    });
  }

  // save the question and options to the backend
  void saveQuestionAndOptions() async {
    final question = VotingData().votingQuestion;
    final options = VotingData().votingOptions;

    if (question.isEmpty || options.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question and options cannot be empty')),
      );
      return;
    }

    //  1: clear all previous questions and options
    final clearResponse = await _votingService.clearAllQuestionsAndOptions();
    if (clearResponse.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(clearResponse['error'])),
      );
      return;
    }


    //   2: create the new question on the server
    final createResponse = await _votingService.createQuestion(question);
    print('Created question response: $createResponse');
    if (createResponse.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(createResponse['error'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question created successfully')),
      );

      // get the questionId from the response after creating the question
      final questionId = createResponse['questionId'];
      if (questionId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to retrieve question ID')),
        );
        return;
      }

      //   3: add options for the newly created question
      final addOptionsResponse = await _votingService.addOptionsToQuestion(questionId, options);

      if (addOptionsResponse.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(addOptionsResponse['error'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Options added successfully')),
        );

        setState(() {
          // cear the current voting data after successful creation
        //  VotingData().clearData();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Screen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // input for setting the voting question
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: 'Set Voting Question',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: setQuestion,
              child: const Text("Set Question"),
            ),
            const SizedBox(height: 20),
            // display the current voting question
            Text(
              'Current Question: ${VotingData().votingQuestion}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // input for adding a new voting option
            TextField(
              controller: optionController,
              decoration: const InputDecoration(
                labelText: 'New Voting Option',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addOption,
              child: const Text("Add Option"),
            ),
            const SizedBox(height: 20),
            // list of current voting options
            Expanded(
              child: ListView.builder(
                itemCount: VotingData().votingOptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(VotingData().votingOptions[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeOption(index), // Remove option
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Save question and options
            ElevatedButton(
              onPressed: saveQuestionAndOptions,
              child: const Text("Save Question and Options"),
            ),
          ],
        ),
      ),
    );
  }
}
