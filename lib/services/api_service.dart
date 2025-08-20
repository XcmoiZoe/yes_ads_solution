import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://artbiglobalph.com/api/login_register.php";
  static const Duration _timeout = Duration(seconds: 30);

  /// LOGIN
  /// Returns user data and is_active status.
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "action": "login",
          "email": email.trim(),
          "password": password,
        }),
      ).timeout(_timeout);

      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          "success": true,
          "user_id": data['user_id']?.toString() ?? "",
          "username": data['username']?.toString() ?? "",
          "email": data['email']?.toString() ?? "",
          "company": data['company']?.toString() ?? "",
          "industry": data['industry']?.toString() ?? "",
          "phone_number": data['phone_number']?.toString() ?? "",
          "is_active": data['is_active']?.toString() ?? "0",  // "0" = not activated
          "message": data['message']?.toString() ?? ""
        };
      } else {
        return {
          "success": false,
          "message": data['message']?.toString() ?? "Login failed"
        };
      }
    } catch (e) {
      print('Login Error: $e');
      return {
        "success": false,
        "message": "Login error: ${e.toString()}"
      };
    }
  }

  /// REGISTER
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String company,
    required String industry,
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "action": "register",
          "username": username.trim(),
          "email": email.trim(),
          "password": password,
          "company": company.trim(),
          "industry": industry.trim(),
          "phone_number": phone.trim(),
        }),
      ).timeout(_timeout);

      print('Register Response Status: ${response.statusCode}');
      print('Register Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        return {
          "success": true,
          "message": data['message']?.toString() ?? "Registration successful",
          "user_id": data['user_id']?.toString() ?? "",
        };
      } else {
        return {
          "success": false,
          "message": data['message']?.toString() ?? "Registration failed"
        };
      }
    } catch (e) {
      print('Register Error: $e');
      return {
        "success": false,
        "message": "Register error: ${e.toString()}"
      };
    }
  }

  /// ACTIVATE ACCOUNT
  static Future<Map<String, dynamic>> activateAccount({
    required String email,
    required String activationCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "action": "activate",
          "email": email.trim(),
          "activation_code": activationCode.trim(),
        }),
      ).timeout(_timeout);

      print('Activate Response Status: ${response.statusCode}');
      print('Activate Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          "success": true,
          "message": data['message']?.toString() ?? "Account activated"
        };
      } else {
        return {
          "success": false,
          "message": data['message']?.toString() ?? "Activation failed"
        };
      }
    } catch (e) {
      print('Activate Error: $e');
      return {
        "success": false,
        "message": "Activation error: ${e.toString()}"
      };
    }
  }
}
