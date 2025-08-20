import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';
import 'home_page.dart';
import 'list_of_ads.dart';
import 'profile.dart';
import 'customer_support_page.dart';
import 'transaction.dart';
import 'notif_page.dart';

class MainPage extends StatefulWidget {
  final String? userId;
  final String? username;
  final String? email;

  const MainPage({super.key, this.userId, this.username, this.email});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2; // 👈 Start from Home (index 2 since nav order is 0-4)
  final PageController _pageController = PageController(initialPage: 2);

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
  CustomerSupportPage(
    userId: widget.userId ?? "",
    username: widget.username ?? "",
    email: widget.email ?? "",
  ),
  TransactionPage(
    userId: widget.userId ?? "",
    username: widget.username ?? "",
    email: widget.email ?? "",
  ),
  HomePage(
    userId: widget.userId ?? "",
    username: widget.username ?? "",
    email: widget.email ?? "",
  ),
  NotifPage(
    userId: widget.userId ?? "",
    username: widget.username ?? "",
    email: widget.email ?? "",
  ),
  ProfilePage(
    userId: widget.userId ?? "",
    username: widget.username ?? "",
    email: widget.email ?? "",
  ),
];


  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // ✅ synced with PageView
      ),
    );
  }
}
