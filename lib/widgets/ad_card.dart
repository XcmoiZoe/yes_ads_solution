import 'package:flutter/material.dart';
import '../models/ad.dart';

class AdCard extends StatelessWidget {
  final Ad ad;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdCard({
    super.key,
    required this.ad,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ad.image != null && ad.image!.isNotEmpty
              ? Image.network(
                  ad.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                )
              : const Icon(Icons.image),
        ),
        title: Text(ad.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(ad.description ?? ""),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view':
                onView();
                break;
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'view', child: Text('View')),
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
