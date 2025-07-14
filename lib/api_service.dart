import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://web.focad.ph/api/login_register.php";

  /// LOGIN
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": "login",
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          return {
            "success": true,
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
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
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
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": "register",
          "username": username,
          "email": email,
          "password": password,
          "company": company,
          "industry": industry,
          "phone_number": phone,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          return {
            "success": true,
            "username": data['username']?.toString() ?? username,
            "message": data['message']?.toString() ?? "Registration successful"
          };
        } else {
          return {
            "success": false,
            "message": data['message']?.toString() ?? "Registration failed."
          };
        }
      } else {
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Connection error: ${e.toString()}"
      };
    }
  }
}
