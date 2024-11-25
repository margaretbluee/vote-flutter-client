import 'dart:convert';
import 'package:http/http.dart' as http;

import '../shared-data/voting-data.dart';
 class AuthService {
  static const String baseUrl = 'http://localhost:5000/api';
// Register a user
   Future<Map<String, dynamic>> registerUser(String username, String password) async {
     final response = await http.post(
       Uri.parse('http://localhost:5000/api/users/register'),
       headers: {'Content-Type': 'application/json'},
       body: json.encode({
         'name': username,
         'password': password,
       }),
     );

     if (response.statusCode == 201) {
       return json.decode(response.body); //return the response if registration is successful
     } else {
       throw Exception('Failed to register user');
     }
   }

   // Log out a user (e.g., by removing the token from storage)
 //   Future<void> logoutUser() async {
 //
 //
 //     print('User logged out');
 //      }
 // }
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
