import 'package:flutter/material.dart';
import 'package:sans_mobile/services/AuthService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  final authService = AuthService();
Future<void> _login() async {
  setState(() => _errorMessage = ''); // Clear previous errors
  final username = _usernameController.text;
  final password = _passwordController.text;

  if (username.isEmpty || password.isEmpty) {
    setState(() => _errorMessage = 'Username and password are required.');
    return;
  }

  // Show loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => Center(child: CircularProgressIndicator()),
  );

  try {
    final accessToken = await authService.login(username, password);
    Navigator.pop(context); // Hide loading indicator
    if (accessToken != null) {
      Navigator.pushReplacementNamed(context, "/dashboard");
    } else {
      setState(() => _errorMessage = 'Invalid username or password.');
    }
  } on Exception catch (error) {
    Navigator.pop(context); // Hide loading indicator
    setState(() => _errorMessage = error.toString());
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
