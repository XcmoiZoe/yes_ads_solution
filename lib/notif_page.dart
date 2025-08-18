import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_bottom_nav.dart';

class NotifPage extends StatefulWidget {
 final String username;
  final int currentIndex;
  final String email;

  const NotifPage({
    super.key,
    required this.username,
     required this.email,
    this.currentIndex = 3,
  });
  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  List<Map<String, String>> notifications = [
    {"title": "Ad Approved", "body": "Your ad was approved and is now live."},
    {"title": "New Views", "body": "Your ad gained 120 new views this week."},
    {"title": "Boost Suggestion", "body": "Try boosting your ad to reach more users."},
  ];

  late SharedPreferences prefs;
  bool allRead = false;

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      allRead = prefs.getBool('all_notifications_read') ?? false;
    });
  }

  Future<void> markAllAsRead() async {
    await prefs.setBool('all_notifications_read', true);
    setState(() {
      allRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (!allRead)
            TextButton(
              onPressed: markAllAsRead,
              child: const Text("Mark all as read", style: TextStyle(color: Colors.white)),
            )
        ],
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              allRead ? Icons.notifications_none : Icons.notifications_active,
              color: allRead ? Colors.grey : Colors.blue,
            ),
            title: Text(notifications[index]['title']!),
            subtitle: Text(notifications[index]['body']!),
            onTap: () {
              markAllAsRead();
            },
          );
        },
      ),
      

    );
  }
}
