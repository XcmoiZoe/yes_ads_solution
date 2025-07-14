import 'package:flutter/material.dart';
import 'package:yes_ads_solution/customer_support_page.dart';
import 'package:yes_ads_solution/transaction.dart';
import 'package:yes_ads_solution/notif_page.dart';
import 'package:yes_ads_solution/profile.dart';
import 'package:yes_ads_solution/home_page.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final String username;
  final BuildContext parentContext;
  final String email;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.username,
    required this.parentContext,
    required this.email,
  });

  void _handleTap(int index) {
    if (index == currentIndex) return;

    Widget page;
    switch (index) {
      case 0:
        page = CustomerSupportPage(username: username, email: email);
        break;
      case 1:
        page = TransactionPage(username: username, email: email);
        break;
      case 2:
        page = HomePage(username: username, email: email);
        break;
      case 3:
        page =  NotifPage(username: username, email: email);
        break;
      case 4:
        page = ProfilePage(username: username, email: email);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      parentContext,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.mail_outline,
      Icons.receipt_long_outlined,
      Icons.home,
      Icons.notifications_none_outlined,
      Icons.person_outline,
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF7C0ED7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: _handleTap,
          items: List.generate(5, (index) {
            return BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(bottom: 4),
                child: Icon(icons[index], size: 24),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Icon(icons[index], size: 24, color: Colors.white),
              ),
              label: '',
            );
          }),
        ),
      ),
    );
  }
}
