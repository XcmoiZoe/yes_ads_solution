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
  final _budgetController = TextEditingController(text: "500");

  final List<String> _selectedLocations = [];
  bool _showAllLocations = false;
  String _paymentMethod = 'GCash';
  String _adType = 'Image';

  final List<String> _allLocations = [
    "Malaya's Cafe",
    "BDO Pasay",
    "AUB Branch",
    "Sunkist Market",
    "Nestlé Office",
    "SM MOA",
    "NAIA Terminal 3",
  ];

  final Map<String, int> _locationFootTraffic = {
    "Malaya's Cafe": 70000,
    "BDO Pasay": 120000,
    "AUB Branch": 90000,
    "Sunkist Market": 85000,
    "Nestlé Office": 100000,
    "SM MOA": 800000,
    "NAIA Terminal 3": 1000000,
  };

  final Map<String, double> _locationMultiplier = {
    "Malaya's Cafe": 1.4,
    "BDO Pasay": 1.7,
    "AUB Branch": 1.5,
    "Sunkist Market": 1.6,
    "Nestlé Office": 2.0,
    "SM MOA": 2.5,
    "NAIA Terminal 3": 2.3,
  };

  List<String> get _filteredLocations {
    final query = _searchController.text.toLowerCase();
    return _allLocations
        .where((loc) =>
            loc.toLowerCase().contains(query) &&
            !_selectedLocations.contains(loc))
        .toList();
  }

  double get _estimatedReach {
    final budget = double.tryParse(_budgetController.text) ?? 0;
    if (budget < 500 || _selectedLocations.isEmpty) return 0;

    int totalTraffic = _selectedLocations.fold(
      0,
      (sum, loc) => sum + (_locationFootTraffic[loc] ?? 0),
    );
    return totalTraffic * 0.01 * (budget / 500);
  }

  Color _multiplierColor(double multiplier) {
    if (multiplier >= 2.0) return Colors.red;
    if (multiplier >= 1.5) return Colors.orange;
    return Colors.green;
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
    final displayedLocations = _showAllLocations
        ? _filteredLocations
        : _filteredLocations.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("New Advertisement")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Ad Information", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Campaign Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Campaign Description"),
                maxLines: 3,
              ),

              const SizedBox(height: 20),
              const Text("Advertisement Type", style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _adType,
                items: const [
                  DropdownMenuItem(value: "Image", child: Text("Image")),
                  DropdownMenuItem(value: "Video", child: Text("Video")),
                ],
                onChanged: (value) => setState(() => _adType = value!),
                decoration: const InputDecoration(labelText: "Select Ad Type"),
              ), const SizedBox(height: 20),
            ElevatedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: Text("Upload $_adType Ad (placeholder)"),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$_adType upload coming soon")),
              );
            },
          ),

              const SizedBox(height: 20),
              const Text("Target Locations", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedLocations.map((loc) {
                  return Chip(
                    label: Text(loc),
                    onDeleted: () => _removeLocation(loc),
                    backgroundColor: Colors.blue[50],
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: "Search Locations",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),

              ...displayedLocations.map((loc) {
                final traffic = _locationFootTraffic[loc] ?? 0;
                final multiplier = _locationMultiplier[loc] ?? 1;
                final isHot = loc == "SM MOA" || loc == "NAIA Terminal 3";
                return ListTile(
                  onTap: () => _addLocation(loc),
                  title: Text(loc),
                  subtitle: Text("Foot traffic: $traffic"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isHot) const Text("🔥"),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _multiplierColor(multiplier),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "x${multiplier.toStringAsFixed(1)}",
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const Icon(Icons.add, color: Colors.grey),
                    ],
                  ),
                );
              }),

              if (_filteredLocations.length > 3 && !_showAllLocations)
                TextButton(
                  onPressed: () => setState(() => _showAllLocations = true),
                  child: const Text("See More Locations"),
                ),

              const SizedBox(height: 20),
              const Text("Ad Budget (Min ₱500)", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Enter budget", prefixText: "₱"),
                validator: (value) {
                  final amount = double.tryParse(value ?? "") ?? 0;
                  if (amount < 500) return "Minimum budget is ₱500";
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 20),
              const Text("Estimated Reach", style: TextStyle(fontWeight: FontWeight.bold)),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.people, color: Colors.deepPurple),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _estimatedReach == 0
                              ? "Enter valid budget and select location(s)"
                              : "${_estimatedReach.round()} estimated people reached per day",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

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
            label: Text("Upload Screenshot"),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Screenshot upload coming soon")),
              );
            },
          ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedLocations.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select at least one location.")),
                      );
                      return;
                    }

                    final summary = '''
Title: ${_titleController.text}
Description: ${_descriptionController.text}
Type: $_adType
Locations: ${_selectedLocations.join(', ')}
Budget: ₱${_budgetController.text}
Reach Estimate: ${_estimatedReach.round()} people/day
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
