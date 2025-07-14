import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'add_ad_page.dart';
import 'auth_page.dart';
import 'list_of_ads.dart';
import 'transaction.dart';
import 'customer_support_page.dart';
import 'notif_page.dart';
import 'profile.dart';
import 'custom_bottom_nav.dart';
class HomePage extends StatefulWidget {
  final String username;
  final String email; // 👈 Add this

  const HomePage({
    super.key,
    required this.username,
    required this.email, // 👈 Add this
  });

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  String _selectedRange = 'Weekly';
  int _selectedIndex = 2;

  final List<String> ads = [
    'Good Life Video Ads',
    'Good Life Survey Ads',
    'Good Life Coffee Ads',
  ];

  final List<String> images = [
    'assets/coffee.jpg',
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              color: Colors.deepPurple,
                            )),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const AuthPage()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text("Logout"),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Ads Views Chart Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ads Views",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: _selectedRange,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                      style: GoogleFonts.poppins(
                        color: Colors.deepPurple,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      items: ['Weekly', 'Monthly'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRange = newValue!;
                        });
                      },
                    ),
                  ],
                ),

                // Chart
                Container(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  days[value.toInt() % 7],
                                  style: const TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) => Text('${value.toInt()}'),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.orange,
                          barWidth: 3,
                          spots: _selectedRange == 'Weekly'
                              ? [FlSpot(0, 50), FlSpot(1, 90), FlSpot(2, 70), FlSpot(3, 130), FlSpot(4, 200), FlSpot(5, 100), FlSpot(6, 100)]
                              : [FlSpot(0, 250), FlSpot(1, 280), FlSpot(2, 300), FlSpot(3, 320), FlSpot(4, 350), FlSpot(5, 370), FlSpot(6, 390)],
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
                                builder: (context) => const AddAdPage()));
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),

                // Ads List
                ...List.generate(ads.length, (index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.asset(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                      title: Text(ads[index],
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                      subtitle: Text('Due date: ${dates[index]}',
                          style: GoogleFonts.poppins(fontSize: 12)),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'view':
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Ad Details"),
                                  content: Text("Viewing details for: ${ads[index]}"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Close"),
                                    ),
                                  ],
                                ),
                              );
                              break;
                            case 'edit':
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddAdPage()),
                              );
                              break;
                            case 'delete':
                              setState(() {
                                ads.removeAt(index);
                                images.removeAt(index);
                                dates.removeAt(index);
                              });
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'view', child: Text('View Page')),
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  );
                }),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdvertisementListPage(
                            ads: ads,
                            images: images,
                            dates: dates,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "See all",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, color: Colors.deepPurple),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Boost Card
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.shade100),
                    color: const Color(0xFFF9F5FF),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/boost.png",
                        height: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.bolt, color: Colors.deepPurple),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Boost ad visibility near Good Life Coffee",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            Text("Get up to 5x more views",
                                style: GoogleFonts.poppins(fontSize: 12)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE94848),
                        ),
                        child: const Text("Boost"),
                      ),
                    ],
                  ),
                ),

                // Extra space so BottomNavBar doesn't overlap content
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),

 bottomNavigationBar: CustomBottomNav(
  currentIndex: _selectedIndex,
  username: widget.username,
  email: widget.email, // 👈 Add this
  parentContext: context,
),


    );
  }
}