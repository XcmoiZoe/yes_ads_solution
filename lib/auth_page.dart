import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
   const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool isLogin = true;
  String _message = '';

  void _submit() async {
    final username = _username.text.trim();
    final password = _password.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _message = "All fields are required.");
      return;
    }

    var result = isLogin
        ? await ApiService.login(username, password)
        : await ApiService.register(username, password);

    if (result['success']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(username: username)),
      );
    } else {
      setState(() => _message = result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Register")),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _username,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _password,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(isLogin ? "Login" : "Register"),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? "Create an account" : "Already have an account?"),
            ),
            SizedBox(height: 10),
            Text(_message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
