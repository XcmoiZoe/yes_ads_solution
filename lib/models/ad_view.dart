class AdView {
  final DateTime viewDate;
  final int views;

  AdView({required this.viewDate, required this.views});

  factory AdView.fromJson(Map<String, dynamic> json) {
    return AdView(
      viewDate: DateTime.parse(json['view_date']),
      views: int.parse(json['views'].toString()),
    );
  }
}
