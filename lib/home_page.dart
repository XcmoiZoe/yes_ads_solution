import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/ads_api_service.dart';
import '../models/ad.dart';
import 'add_ad_page.dart';
import 'auth_page.dart';
import '../widgets/ad_card.dart';

class HomePage extends StatefulWidget {
  final String userId;
  final String username;
  final String email;

  const HomePage({
    super.key,
    required this.userId,
    required this.username,
    required this.email,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Ad> ads = [];
  bool isLoading = true;
  String _selectedRange = 'Weekly';
  String? _selectedAdId;
  String? fetchError;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    if (widget.userId.isEmpty) {
      setState(() {
        fetchError = 'Invalid user ID';
        isLoading = false;
      });
      return;
    }

    try {
      final fetchedAds = await AdsApiService.fetchAds(widget.userId);
      setState(() {
        ads = fetchedAds;
        isLoading = false;
        if (ads.isNotEmpty) _selectedAdId = ads.first.adId;
      });
    } catch (e) {
      setState(() {
        fetchError = e.toString();
        isLoading = false;
      });
    }
  }

  List<FlSpot> getChartData() {
    if (_selectedAdId == null) return [];

    final ad = ads.firstWhere(
      (ad) => ad.adId == _selectedAdId,
      orElse: () => Ad(
        adId: '',
        title: '',
        description: '',
        location: '',
        paymentMethod: '',
        status: '',
        createdAt: '',
        image: '',
        views: [],
      ),
    );

    if (ad.views.isEmpty) return [];

    final views = List.from(ad.views);
    views.sort((a, b) => a.viewDate.compareTo(b.viewDate));

    final count = _selectedRange == 'Weekly' ? 7 : 30;
    final lastViews = views.takeLast(count).toList();

    return lastViews.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.views.toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chartData = getChartData();

    final minY = chartData.isNotEmpty
        ? chartData.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 10
        : 0.0;
    final maxY = chartData.isNotEmpty
        ? chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 10
        : 100.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : fetchError != null
                ? Center(child: Text("Error: $fetchError"))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Welcome Back!",
                                    style: GoogleFonts.poppins(fontSize: 18)),
                                Text(widget.username,
                                    style: GoogleFonts.poppins(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple)),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AuthPage()),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8)),
                              child: const Text("Logout"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Ads Views Chart
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Chart header
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Ads Views",
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        if (ads.isNotEmpty)
                                          DropdownButton<String>(
                                            value: _selectedAdId,
                                            hint: const Text("Select Ad"),
                                            items: ads.map((ad) {
                                              return DropdownMenuItem(
                                                value: ad.adId,
                                                child: Text(ad.title,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              );
                                            }).toList(),
                                            onChanged: (id) =>
                                                setState(() => _selectedAdId = id),
                                          ),
                                        const SizedBox(width: 12),
                                        DropdownButton<String>(
                                          value: _selectedRange,
                                          underline: const SizedBox(),
                                          icon: const Icon(Icons.arrow_drop_down,
                                              color: Colors.deepPurple),
                                          style: GoogleFonts.poppins(
                                              color: Colors.deepPurple,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                          items: ['Weekly', 'Monthly']
                                              .map((value) => DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value)))
                                              .toList(),
                                          onChanged: (newValue) => setState(
                                              () => _selectedRange = newValue!),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Chart container
                                SizedBox(
                                  height: 220,
                                  child: chartData.isNotEmpty
                                      ? _selectedRange == 'Monthly'
                                          ? SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: SizedBox(
                                                width: chartData.length * 40.0,
                                                child: LineChart(
                                                  buildLineChart(
                                                      chartData, minY, maxY),
                                                ),
                                              ),
                                            )
                                          : LineChart(
                                              buildLineChart(chartData, minY, maxY))
                                      : const Center(
                                          child: Text("No chart data")),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Ads Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Advertisements",
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AddAdPage()),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Add"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Ads List
                        if (ads.isNotEmpty)
                          ...ads.map((ad) => AdCard(
                                ad: ad,
                                onView: () => print("View ${ad.title}"),
                                onEdit: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AddAdPage()),
                                ),
                                onDelete: () {
                                  setState(() {
                                    ads.remove(ad);
                                    if (_selectedAdId == ad.adId &&
                                        ads.isNotEmpty) {
                                      _selectedAdId = ads.first.adId;
                                    }
                                  });
                                },
                              ))
                        else
                          const Center(child: Text("No ads found")),
                      ],
                    ),
                  ),
      ),
    );
  }

  LineChartData buildLineChart(
      List<FlSpot> spots, double minY, double maxY) {
    return LineChartData(
      minY: minY,
      maxY: maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 10,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, _) {
              if (_selectedRange == 'Weekly') {
                const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                int index = value.toInt();
                if (index >= 0 && index < weekdays.length) {
                  return Text(weekdays[index], style: const TextStyle(fontSize: 12));
                }
              } else if (_selectedRange == 'Monthly') {
                return Text((value.toInt() + 1).toString(),
                    style: const TextStyle(fontSize: 12));
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, _) => Text(value.toInt().toString()),
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          color: Colors.deepOrange,
          barWidth: 3,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.deepPurple.withOpacity(0.2), Colors.deepPurple.withOpacity(0.05)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          spots: spots,
        ),
      ],
    );
  }
}

// Extension to take last n elements of a list
extension TakeLast<T> on List<T> {
  List<T> takeLast(int n) {
    if (length <= n) return List.from(this);
    return sublist(length - n);
  }
}
