import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://artbiglobalph.com/api/login_register.php";
  static const Duration _timeout = Duration(seconds: 30);

  /// LOGIN
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

      // Debug logging
      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {
            "success": true,
            "user_id": data['user_id']?.toString() ?? "",
            "username": data['username']?.toString() ?? email,
            "email": data['email']?.toString() ?? "",
            "company": data['company']?.toString() ?? "",
            "industry": data['industry']?.toString() ?? "",
            "phone_number": data['phone_number']?.toString() ?? "",
          };
        } else {
          return {
            "success": false,
            "message": data['message']?.toString() ?? "Login failed. Please try again."
          };
        }
      } else {
        // Try to parse error response
        try {
          final errorData = jsonDecode(response.body);
          return {
            "success": false,
            "message": errorData['message'] ?? "Server error: ${response.statusCode}"
          };
        } catch (e) {
          return {
            "success": false,
            "message": "Server error: ${response.statusCode}"
          };
        }
      }
    } catch (e) {
      print('Login Error: $e');
      return {
        "success": false,
        "message": "Connection error: ${e.toString()}"
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

      // Debug logging
      print('Register Response Status: ${response.statusCode}');
      print('Register Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {
            "success": true,
            "message": data['message']?.toString() ?? "Registration successful"
          };
        } else {
          return {
            "success": false,
            "message": data['message']?.toString() ?? "Registration failed."
          };
        }
      } else {
        // Try to parse error response
        try {
          final errorData = jsonDecode(response.body);
          return {
            "success": false,
            "message": errorData['message'] ?? "Server error: ${response.statusCode}"
          };
        } catch (e) {
          return {
            "success": false,
            "message": "Server error: ${response.statusCode}"
          };
        }
      }
    } catch (e) {
      print('Register Error: $e');
      return {
        "success": false,
        "message": "Connection error: ${e.toString()}"
      };
    }
  }
}