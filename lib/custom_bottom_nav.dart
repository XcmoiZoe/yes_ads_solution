import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap; // 🔥 callback to MainPage

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.mail_outline,                // Customer Support
      Icons.receipt_long_outlined,       // Transactions
      Icons.home,                        // Home
      Icons.notifications_none_outlined, // Notifications
      Icons.person_outline,              // Profile
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF7C0ED7), // purple background
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
          backgroundColor: const Color(0xFF7C0ED7),
          elevation: 0,
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: onTap, // ✅ delegate to MainPage
          items: List.generate(5, (index) { // 👈 now 5 items
            return BottomNavigationBarItem(
              icon: Icon(icons[index], size: 24),
              activeIcon: Container(
                padding: const EdgeInsets.all(6),
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
