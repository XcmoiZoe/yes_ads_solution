import 'package:flutter/material.dart';

class AddAdPage extends StatefulWidget {
  const AddAdPage({super.key});

  @override
  State<AddAdPage> createState() => _AddAdPageState();
}

class _AddAdPageState extends State<AddAdPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();

  final List<String> _selectedLocations = [];
  final List<String> _allLocations = [
    "Malaya's Cafe",
    "BDO Pasay",
    "AUB Branch",
    "Sunkist Market",
    "Nestlé Office",
    "SM MOA",
    "NAIA Terminal 3",
  ];
  String _paymentMethod = 'GCash';

  List<String> get _filteredLocations {
    final query = _searchController.text.toLowerCase();
    return _allLocations
        .where((loc) => loc.toLowerCase().contains(query) && !_selectedLocations.contains(loc))
        .toList();
  }

  void _addLocation(String location) {
    setState(() {
      _selectedLocations.add(location);
      _searchController.clear();
    });
  }

  void _removeLocation(String location) {
    setState(() {
      _selectedLocations.remove(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Advertisement")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Ad Title"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Ad Description"),
                maxLines: 3,
              ),

              const SizedBox(height: 20),
              const Text("Target Locations", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              // Selected chips
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _selectedLocations.map((location) {
                  return Chip(
                    label: Text(location),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => _removeLocation(location),
                    backgroundColor: Colors.blue[50],
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Search bar
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: "Search Locations",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),

              // Search results
              ..._filteredLocations.map((location) => ListTile(
                    title: Text(location),
                    trailing: const Icon(Icons.add),
                    onTap: () => _addLocation(location),
                  )),

              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(labelText: "Payment Method"),
                items: const [
                  DropdownMenuItem(value: "GCash", child: Text("GCash")),
                  DropdownMenuItem(value: "Maya", child: Text("Maya")),
                  DropdownMenuItem(value: "Cash", child: Text("Cash")),
                ],
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Image (placeholder)"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Image upload coming soon")),
                  );
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedLocations.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select at least one location."),
                        ),
                      );
                      return;
                    }

                    // Submit summary
                    final summary = '''
Title: ${_titleController.text}
Description: ${_descriptionController.text}
Locations: ${_selectedLocations.join(', ')}
Payment: $_paymentMethod
                    ''';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Submitted:\n$summary")),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Submit Advertisement"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
