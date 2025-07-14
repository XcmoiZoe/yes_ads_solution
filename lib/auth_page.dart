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
  final _email = TextEditingController();
  final _company = TextEditingController();
  final _industry = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool isLogin = true;
  String _message = '';

  void _submit() async {
    final email = _email.text.trim();
    final password = _password.text.trim();

    if (isLogin) {
      if (email.isEmpty || password.isEmpty) {
        setState(() => _message = "Email and password are required.");
        return;
      }

      final result = await ApiService.login(email, password);
      if (result['success']) {
        final prefs = await SharedPreferences.getInstance();
        final username = (result['username'] ?? email).toString();

        await prefs.setString('user', username);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              username: username,
              email: result['email'] ?? email,
            ),
          ),
        );
      } else {
        setState(() => _message = result['message']);
      }
    } else {
      final username = _username.text.trim();
      final company = _company.text.trim();
      final industry = _industry.text.trim();
      final phone = _phone.text.trim();
      final confirmPassword = _confirmPassword.text.trim();

      if ([username, email, company, industry, phone, password, confirmPassword]
          .any((e) => e.isEmpty)) {
        setState(() => _message = "All fields are required.");
        return;
      }

      if (password != confirmPassword) {
        setState(() => _message = "Passwords do not match.");
        return;
      }

      final result = await ApiService.register(
        username: username,
        email: email,
        password: password,
        company: company,
        industry: industry,
        phone: phone,
      );

      if (result['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', username);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              username: username,
              email: email,
            ),
          ),
        );
      } else {
        setState(() => _message = result['message']);
      }
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _company.dispose();
    _industry.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (!isLogin)
              TextField(
                controller: _username,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            if (!isLogin) ...[
              TextField(
                controller: _company,
                decoration: const InputDecoration(labelText: 'Company'),
              ),
              TextField(
                controller: _industry,
                decoration: const InputDecoration(labelText: 'Industry'),
              ),
              TextField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
            ],
            TextField(
              controller: _password,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (!isLogin)
              TextField(
                controller: _confirmPassword,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(isLogin ? "Login" : "Register"),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? "Create an account" : "Already have an account?"),
            ),
            const SizedBox(height: 10),
            if (_message.isNotEmpty)
              Text(_message, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
