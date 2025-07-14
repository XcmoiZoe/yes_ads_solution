import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_page.dart';
import 'custom_bottom_nav.dart';

class ProfilePage extends StatelessWidget {
 final String username;
 final int currentIndex;
 final String email;

  const ProfilePage({
    super.key,
    required this.username,
    required this.email,
    this.currentIndex = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.png'), // replace with your image
            ),
            const SizedBox(height: 16),
            Text(
              username,
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Advertiser Account",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profile"),
              onTap: () {
                // Future: Add edit profile functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                // Future: Add settings page
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
 bottomNavigationBar: CustomBottomNav(
  currentIndex: currentIndex,
  username: username,
  parentContext: context,
  email: email,
),


    );
  }
}
