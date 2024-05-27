import 'package:flutter/material.dart';
import 'package:sans_mobile/services/AuthService.dart';
import 'package:sans_mobile/ui/widgets/ButtonWidget.dart';
import 'package:sans_mobile/ui/widgets/TextFieldWidget.dart';

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
    setState(() => _errorMessage = ''); 
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Username and password are required.');
      return;
    }

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Login to SANS", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30)),
                Text("Enter your username and password to sign in ", style: TextStyle(color: Color.fromARGB(193, 26, 9, 178), fontSize: 15)),
                SizedBox(height: 20,),
                Image.asset('assets/images/login.png', width: 300, height: 200,),
                SizedBox(height: 20.0),
                TextFieldWidget(
                  controller: _usernameController,
                  labelText: 'Username',
                ),
                SizedBox(height: 10.0),
                TextFieldWidget(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 30.0),
                ButtonWidget(
                  onPressed: _login,
                  buttonText: 'Login',
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
