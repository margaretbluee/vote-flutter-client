import 'dart:convert';
import 'package:http/http.dart' as http;

class VotingService {
  static const String baseUrl = 'http://localhost:5000/api';

  // clear all previous questions and options
  Future<Map<String, dynamic>> clearAllQuestionsAndOptions() async {
    final url = Uri.parse('$baseUrl/votingquestions/clear-all');  // DELETE request

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'error': 'Failed to clear all questions and options'};
    }
  }

  // fetch current voting results
  Future<List<Map<String, dynamic>>> getVotingResults(int questionId) async {
    final response = await http.get(Uri.parse('http://localhost:5000/api/votingresult/results/$questionId'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load results');
    }
  }

  // admin creates a question
  Future<Map<String, dynamic>> createQuestion(String questionText) async {
    final url = Uri.parse('$baseUrl/votingquestions/create');  // POST request

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'question': questionText}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'error': 'Failed to save question'};
    }
  }


  // fetch voting question
  Future<Map<String, dynamic>> getVotingQuestion() async {
    final response = await http.get(Uri.parse('$baseUrl/votingquestions'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);


      if (responseData.isNotEmpty) {
        return {
          'id': responseData[0]['id'],
          'question': responseData[0]['question'],
        };
      } else {
        throw Exception('No voting question found');
      }
    } else {
      throw Exception('Failed to load voting question');
    }
  }



  // fetch voting options based on questionId
  Future<List<Map<String, dynamic>>> getVotingOptions(int questionId) async {
    final response = await http.get(Uri.parse('$baseUrl/votingoptions'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      // map each option with both id and optionText
      List<Map<String, dynamic>> options = [];
      for (var option in responseData) {
        options.add({
          'id': option['id'],
          'optionText': option['optionText']
        });
      }
      return options;
    } else {
      throw Exception('Failed to load voting options');
    }
  }

// user -> submit a vote
  Future<Map<String, dynamic>> submitVote(int userId, int votingQuestionId, int votingOptionId) async {
    final String endpoint = '$baseUrl/votingresult/submit-vote';

    //request body
    final Map<String, dynamic> payload = {
      'userId': userId,
      'votingQuestionId': votingQuestionId,
      'votingOptionId': votingOptionId,
    };
    final body = json.encode({
      'userId': userId,
      'votingQuestionId': votingQuestionId,
      'votingOptionId': votingOptionId,
    });


    print("Sending the following data to the API:");
    print(body);
    try {
      // Make the POST request to the server
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
       body: json.encode({
          'userId': userId,
          'votingQuestionId': votingQuestionId,
          'votingOptionId': votingOptionId,
        }),
      );

      //   if the request was successful
      if (response.statusCode == 200) {
        //   return the response body as a map
        return json.decode(response.body);
      } else {
        //   request fails
        return {'error': 'Failed to submit vote. Please try again.'};
      }
    } catch (e) {
      return {'error': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> addOptionsToQuestion(int questionId, List<String> options) async {
    final url = Uri.parse('$baseUrl/votingoptions/$questionId/add-options');  // POST request

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        options.map((option) => {'optionText': option}).toList(),
      ),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);  // sccess response for added options
    } else {
      return {'error': 'Failed to add options to question'};
    }
  }


  // fetch options for a specific question
  Future<Map<String, dynamic>> getOptionsForQuestion(int questionId) async {
    final url = Uri.parse('$baseUrl/votingoptions/questions/$questionId/options');  // GET request

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'error': 'Failed to fetch options for the question'};
    }
  }

  // remove an option
  Future<Map<String, dynamic>> removeOption(int optionId) async {
    final url = Uri.parse('$baseUrl/votingoptions/remove/$optionId');  // DELETE request

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'error': 'Failed to remove option'};
    }
  }
}
