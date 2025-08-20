import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ad.dart';

class AdsApiService {
  static const String _adsUrl = "https://artbiglobalph.com/api/ads_api.php";
  static const Duration _timeout = Duration(seconds: 30);

  /// FETCH ADS WITH VIEWS
  static Future<List<Ad>> fetchAds(String userId) async {
    if (userId.isEmpty) throw Exception("userId is empty");

    try {
      final response = await http
          .post(
            Uri.parse(_adsUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"action": "get_ads", "user_id": userId}),
          )
          .timeout(_timeout);

      print('Fetch Ads Status: ${response.statusCode}');
      print('Fetch Ads Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['ads'] as List<dynamic>)
              .map((adJson) => Ad.fromJson(adJson))
              .toList();
        } else {
          throw Exception("Fetch Ads Error: ${data['message']}");
        }
      } else {
        throw Exception("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print('Fetch Ads Error: $e');
      rethrow;
    }
  }
}
