import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatelessWidget {
  final String username;

  HomePage({super.key, required this.username});

  final List<String> ads = [
    'Good Life Video Ads',
    'Good Life Survey Ads',
    'Good Life Coffee Ads',
  ];

  final List<String> images = [
    'assets/video.jpg',
    'assets/survey.jpg',
    'assets/coffee.jpg',
  ];

  final List<String> dates = [
    'Nov. 20, 2025',
    'Nov. 21, 2025',
    'Nov. 22, 2025',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
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
                        Text(username,
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            )),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text("Logout"),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Ads Views Chart Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ads Views",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text("Weekly"),
                    ),
                  ],
                ),

                // Dummy Chart
                Container(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = [
                                'Sun',
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat'
                              ];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(days[value.toInt() % 7],
                                    style: TextStyle(fontSize: 10)),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) =>
                                Text('${value.toInt()}'),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.deepPurple,
                          barWidth: 3,
                          spots: [
                            FlSpot(0, 50),
                            FlSpot(1, 90),
                            FlSpot(2, 70),
                            FlSpot(3, 130),
                            FlSpot(4, 200),
                            FlSpot(5, 100),
                            FlSpot(6, 100),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),
                Text("Advertisements",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),

                // Ad List
                ...List.generate(ads.length, (index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.asset(images[index], width: 50),
                      title: Text(ads[index],
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500)),
                      subtitle: Text('Due date: ${dates[index]}',
                          style: GoogleFonts.poppins(fontSize: 12)),
                    ),
                  );
                }),

                Center(
                  child: Text("See all",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple)),
                ),

                SizedBox(height: 16),

                // Boost Card
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 80),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.shade100),
                    color: Color(0xFFF9F5FF),
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/boost.png", height: 40),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Boost ad visibility near Good Life Coffee",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            Text("Get up to 5x more views",
                                style: GoogleFonts.poppins(fontSize: 12)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE94848),
                        ),
                        child: Text("Boost"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
bottomNavigationBar: Padding(
  padding: const EdgeInsets.all(16),
  child: Container(
    height: 60,
    decoration: BoxDecoration(
      color: Color(0xFFF7C0ED7),
      borderRadius: BorderRadius.circular(30),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    ),
  ),
),
    );
  }
}
