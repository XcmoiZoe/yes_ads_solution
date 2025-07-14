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
            "username": (data['username'] != null && data['username'].toString().isNotEmpty)
                ? data['username']
                : email,
            "email": data['email'],
            "company": data['company'],
            "industry": data['industry'],
            "phone_number": data['phone_number'],
          };
        }

        return {"success": false, "message": data['message'] ?? "Login failed."};
      } else {
        return {"success": false, "message": "Server error: ${response.statusCode}"};
      }
    } catch (e) {
      return {"success": false, "message": "Failed to connect to server."};
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
            "username": (data['username'] != null && data['username'].toString().isNotEmpty)
                ? data['username']
                : username,
            "message": data['message'] ?? "Registration successful",
          };
        }

        return {"success": false, "message": data['message'] ?? "Registration failed."};
      } else {
        return {"success": false, "message": "Server error: ${response.statusCode}"};
      }
    } catch (e) {
      return {"success": false, "message": "Failed to connect to server."};
    }
  }
}
