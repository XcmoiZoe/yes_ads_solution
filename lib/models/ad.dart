import 'ad_view.dart';

class Ad {
  final String adId;
  final String title;
  final String description;
  final String location;
  final String paymentMethod;
  final String status;
  final String createdAt;
  final String image;
  final List<AdView> views;

  Ad({
    required this.adId,
    required this.title,
    required this.description,
    required this.location,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.image,
    required this.views,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      adId: json['ad_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      image: json['image'] ?? '',
      views: (json['views'] as List<dynamic>?)
              ?.map((v) => AdView.fromJson(v))
              .toList() ??
          [],
    );
  }
}
