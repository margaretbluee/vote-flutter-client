import 'package:flutter/material.dart';
import 'package:meet_app/screens/register-screen.dart';
import 'admin/board-selection.dart';
import 'user/user-dashboard.dart';
import '../services/auth-service.dart'; //  AuthService

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = "";
  final AuthService _authService = AuthService();

  void _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Παρακαλώ συμπληρώστε όλα τα πεδία.";
      });
      return;
    }

    final response = await _authService.login(username, password);

    if (response.containsKey('error')) {
      setState(() {
        _errorMessage = response['error'];
      });
    } else {
      setState(() {
        _errorMessage = "";
      });

      if (response['role'] == 'admin') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BoardSelection()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserDashboard()),
        );
      }
    }
  }

  void _clearErrorMessage() {
    setState(() {
      _errorMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade300, Colors.teal.shade50],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                const Icon(
                  Icons.lock_outline,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                // Title
                const Text(
                  'Σύνδεση',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle
                const Text(
                  "Καλώς ήρθατε! Συνδεθείτε για να συνεχίσετε.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Username Field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Colors.teal),
                    labelText: "Όνομα Χρήστη",
                    labelStyle: const TextStyle(color: Colors.teal),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => _clearErrorMessage(),
                ),
                const SizedBox(height: 16),
                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.teal),
                    labelText: "Κωδικός",
                    labelStyle: const TextStyle(color: Colors.teal),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => _clearErrorMessage(),
                ),
                const SizedBox(height: 20),
                // Login Button
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Σύνδεση",
                    style: TextStyle(fontSize: 18, color: Colors.white),

                  ),
                ),
                const SizedBox(height: 16),
                // Error Message
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 24),
                // Register Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Δεν έχετε λογαριασμό;",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      child: const Text(
                        "Εγγραφή",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
