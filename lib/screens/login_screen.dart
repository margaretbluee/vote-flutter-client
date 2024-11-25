import 'package:flutter/material.dart';
import 'admin/admin-dashboard.dart';
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

  //   login request
  void _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    //   if username and password are empty
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Username and Password cannot be empty";
      });
      return;
    }

    //     AuthService ->  attempt login
    final response = await _authService.login(username, password);

    // check the response
    if (response.containsKey('error')) {

      setState(() {
        _errorMessage = response['error'];
      });
    } else {
      //  login is successful, navigate to the respective screen depending on the role
      setState(() {
        _errorMessage = ""; // empty error message after successful login
      });

      if (response['role'] == 'admin') {
        // navigate to Admin Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else {
        // nvigate to User Dashboard Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserDashboard()),
        );
      }
    }
  }

  //  clear error message when the user starts typing
  void _clearErrorMessage() {
    setState(() {
      _errorMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login to Continue',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _clearErrorMessage(); // clear error when user types
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _clearErrorMessage(); // cear error when user types
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text("Login"),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
