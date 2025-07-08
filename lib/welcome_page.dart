import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(24),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 3);
          },
          children: [
            buildPage(
              imageAsset: 'assets/yesadsolution.png',
              title: "Advertise Smarter with Yes Ad Solution",
              description:
                  "Take full control of your ads – create, manage, and track all in one place. Designed to help businesses grow through targeted advertising.",
            ),
            buildPage(
              imageAsset: 'assets/audience.png',
              title: "Target the Right Audience",
              description:
                  "Set your ad location, choose your media type (image, video, survey, etc.), and let Yes Ad Solution do the rest. Maximum reach, minimum effort.",
            ),
            buildPage(
              imageAsset: 'assets/realtime.png',
              title: "Monitor Your Ads in Real Time",
              description:
                  "Track daily views, spot performance trends, choose your target location, and unlock personalized tips to boost your ads.",
            ),
            buildPage(
              imageAsset: 'assets/verified-business.png',
              title: "Easy Setup, Verified Business",
              description:
                  "Create your account, verify your business, and upload your first ad in just a few steps. Secure, fast, and hassle-free.",
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('seen', true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => AuthPage()),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFE94848),
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Get Started",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text("Skip", style: GoogleFonts.poppins()),
                    onPressed: () => _controller.jumpToPage(3),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Color(0xFFE94848),
                      dotColor: Colors.grey.shade300,
                    ),
                  ),
                  TextButton(
                    child: Text("Next", style: GoogleFonts.poppins()),
                    onPressed: () => _controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildPage({
    required String imageAsset,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imageAsset,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.bebasNeue(
            fontSize: 36,
            color: Color(0xFFE94848),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
