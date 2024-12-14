import 'dart:convert';
import 'package:flutter/services.dart'; // To load assets
import '../shared-data/voting-data.dart';

class AuthService {
  static const String assetsPath = 'lib/assets/users.json'; // Path to the JSON file

  // Register a user
  Future<Map<String, dynamic>> registerUser(String username, String password) async {
    final List<dynamic> users = await _loadUsers(); // Load users from the JSON file

    // Check if the username already exists in the mock data
    if (users.any((user) => user['name'] == username)) {
      return {'error': 'Username already taken'};
    }

    // Simulate registration by adding a new user to the list
    final newUser = {
      'id': users.length + 1,
      'name': username,
      'password': password,
      'role': 'user',  // Default role
    };
    users.add(newUser);  // Add the new user to the list

    // Simulate saving the updated list (this is just in memory for now)
    // In a real app, you'd need to persist the updated list somewhere

    return {'id': newUser['id'], 'name': newUser['name'], 'role': newUser['role']};
  }

  // Login a user
  Future<Map<String, dynamic>> login(String username, String password) async {
    final List<dynamic> users = await _loadUsers(); // Load users from the JSON file

    // Find user with matching username and password
    final user = users.firstWhere(
          (user) => user['name'] == username && user['password'] == password,
      orElse: () => null,
    );

    if (user == null) {
      return {'error': 'Invalid username or password'};
    }

    // Simulate successful login by returning user data
    VotingData().setId(user['id']);  // Save user ID

    return {
      'id': user['id'],
      'name': user['name'],
      'role': user['role'],  // Include the role field in the response
    };
  }

  Future<List<dynamic>> _loadUsers() async {
    try {
      final String jsonString = await rootBundle.loadString(assetsPath);
      final List<dynamic> users = json.decode(jsonString);
      return users;
    } catch (e) {
      print('Error loading users: $e');
      return [];
    }
  }

  // Log out a user (simulated with a print statement)
  Future<void> logoutUser() async {
    print('User logged out');
  }
}
