import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_ad_page.dart';

class AdvertisementListPage extends StatefulWidget {
  final List<String> ads;
  final List<String> images;
  final List<String> dates;

  const AdvertisementListPage({
    super.key,
    required this.ads,
    required this.images,
    required this.dates,
  });

  @override
  State<AdvertisementListPage> createState() => _AdvertisementListPageState();
}

class _AdvertisementListPageState extends State<AdvertisementListPage> {
  late List<String> ads;
  late List<String> images;
  late List<String> dates;

  @override
  void initState() {
    super.initState();
    ads = List.from(widget.ads);
    images = List.from(widget.images);
    dates = List.from(widget.dates);
  }

  void _handlePopup(String value, int index) {
    switch (value) {
      case 'view':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Ad Details"),
            content: Text("Ad: ${ads[index]}\nDue: ${dates[index]}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
        );
        break;

      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddAdPage()),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.deepPurple,
        title: Text(
          "List of Advertisement",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAdPage()),
              );
            },
            icon: Icon(Icons.add),
            label: Text("Add"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: ads.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    images[index],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image),
                  ),
                ),
                title: Text(
                  ads[index],
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Due date: ${dates[index]}",
                        style: GoogleFonts.poppins(fontSize: 12)),
                    Text("Status: Active",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.green)),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) => _handlePopup(value, index),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(value: 'view', child: Text('View Page')),
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
