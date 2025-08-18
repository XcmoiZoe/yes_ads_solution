import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yes_ads_solution/main_page.dart';
import 'api_service.dart';
import 'main_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  final _username = TextEditingController();
  final _email = TextEditingController();
  final _company = TextEditingController();
  final _industry = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool isLogin = true;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _message = '';

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Min 8 characters required';
    final pattern = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (!pattern.hasMatch(value)) {
      return 'Use letters and numbers';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone is required';
    final pattern = RegExp(r'^\+?[0-9]{10,15}$');
    if (!pattern.hasMatch(value)) return 'Enter a valid phone number';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _message = '';
      _isLoading = true;
    });

    final email = _email.text.trim();
    final password = _password.text.trim();

    if (isLogin) {
      final result = await ApiService.login(email, password);
      if (result['success']) {
        if (result['is_active'] == "1") {
          final prefs = await SharedPreferences.getInstance();
          final username = (result['username'] ?? email).toString();
          await prefs.setString('user', username);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MainPage(
                username: username,
                email: result['email'] ?? email,
              ),
            ),
          );
        } else {
          _showDialog(
            title: "Account Not Activated",
            message: "Please activate your account first. Check your email.",
          );
        }
      } else {
        setState(() => _message = _parseError(result['message']));
      }
    } else {
      final username = _username.text.trim();
      final company = _company.text.trim();
      final industry = _industry.text.trim();
      final phone = _phone.text.trim();
      final confirmPassword = _confirmPassword.text.trim();

      if (password != confirmPassword) {
        setState(() {
          _message = "Passwords do not match.";
          _isLoading = false;
        });
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
        _showDialog(
          title: "Registration Successful",
          message: "Please check your email to activate your account before logging in.",
          onConfirm: () {
            setState(() {
              isLogin = true;
              _formKey.currentState?.reset();
              _username.clear();
              _email.clear();
              _password.clear();
              _confirmPassword.clear();
              _company.clear();
              _industry.clear();
              _phone.clear();
            });
          },
        );
      } else {
        setState(() => _message = _parseError(result['message']));
      }
    }

    setState(() => _isLoading = false);
  }

  void _showDialog({
    required String title,
    required String message,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onConfirm != null) onConfirm();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String _parseError(String message) {
    if (message.contains('Duplicate')) return 'Email already exists.';
    if (message.contains('Invalid')) return 'Invalid credentials.';
    return message.isNotEmpty ? message : 'Something went wrong. Please try again.';
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Image.asset(
                            'assets/logo.png',
                            height: 100,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          isLogin ? "Login Account" : "Create Account",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              if (!isLogin)
                                TextFormField(
                                  controller: _username,
                                  maxLength: 100,
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty ? 'Username required' : null,
                                ),
                              TextFormField(
                                controller: _email,
                                maxLength: 100,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: _validateEmail,
                              ),
                              if (!isLogin) ...[
                                TextFormField(
                                  controller: _company,
                                  maxLength: 100,
                                  decoration: const InputDecoration(
                                    labelText: 'Company',
                                    prefixIcon: Icon(Icons.business),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty ? 'Company required' : null,
                                ),
                                TextFormField(
                                  controller: _industry,
                                  maxLength: 100,
                                  decoration: const InputDecoration(
                                    labelText: 'Industry',
                                    prefixIcon: Icon(Icons.work),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty ? 'Industry required' : null,
                                ),
                                TextFormField(
                                  controller: _phone,
                                  maxLength: 15,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number',
                                    prefixIcon: Icon(Icons.phone),
                                  ),
                                  validator: _validatePhone,
                                ),
                              ],
                              TextFormField(
                                controller: _password,
                                obscureText: _obscurePassword,
                                maxLength: 50,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                validator: _validatePassword,
                              ),
                              if (!isLogin)
                                TextFormField(
                                  controller: _confirmPassword,
                                  obscureText: _obscurePassword,
                                  decoration: const InputDecoration(
                                    labelText: 'Confirm Password',
                                    prefixIcon: Icon(Icons.lock_outline),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty ? 'Please confirm password' : null,
                                ),
                              if (isLogin)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("Forgot your password?"),
                                  ),
                                ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _submit,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : Text(isLogin ? "Login" : "Register"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    setState(() => isLogin = !isLogin),
                                child: Text(
                                  isLogin
                                      ? "Don't have an account? Sign up now!"
                                      : "Already have an account? Login",
                                ),
                              ),
                              if (_message.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Text(
                                    _message,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  'assets/footer.png',
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
