import 'dart:convert';
import 'package:http/http.dart' as http;

import '../shared-data/voting-data.dart';
 class AuthService {
  static const String baseUrl = 'http://localhost:5000/api';

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('http://localhost:5000/api/users/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // parse the response
      final responseData = json.decode(response.body);

      // save the user ID to the shared VotingData singleton
      VotingData().setId(responseData['id']);  // save user ID


      return responseData;
    } else if (response.statusCode == 401) {
      //   invalid credentials
      return {'error': 'Invalid username or password'};
    } else {
      //   other errors
      return {'error': 'Something went wrong, please try again later.'};
    }
  }
}
