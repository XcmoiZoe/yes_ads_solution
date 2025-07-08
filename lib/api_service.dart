class ApiService {
  static final List<Map<String, String>> _users = [
    {"username": "admin", "password": "admin123"},
  ];

  static Future<Map<String, dynamic>> login(String username, String password) async {
    await Future.delayed(Duration(seconds: 1)); // simulate network delay

    final user = _users.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      return {"success": true, "message": "Login successful"};
    } else {
      return {"success": false, "message": "Invalid username or password"};
    }
  }

  static Future<Map<String, dynamic>> register(String username, String password) async {
    await Future.delayed(Duration(seconds: 1)); // simulate delay

    bool userExists = _users.any((u) => u['username'] == username);

    if (userExists) {
      return {"success": false, "message": "Username already exists"};
    } else {
      _users.add({"username": username, "password": password});
      return {"success": true, "message": "Registered successfully"};
    }
  }
}
