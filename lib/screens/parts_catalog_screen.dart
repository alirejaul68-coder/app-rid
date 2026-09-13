import 'package:flutter/material.dart';

class PartsCatalogScreen extends StatefulWidget {
  const PartsCatalogScreen({super.key});

  @override
  State<PartsCatalogScreen> createState() => _PartsCatalogScreenState();
}

class _PartsCatalogScreenState extends State<PartsCatalogScreen> {
  // ধরুন আপনি অ্যাডমিন কিনা তা যাচাই করার ফ্ল্যাগ (আসল অ্যাপে এটি SharedPreferences বা Login থেকে আসবে)
  bool _isAdmin = true; 

  // হাজার পিস বা পার্টস লিস্টের ডেটাসেম্পল (যেখানে ছবি, নাম, বিক্রয়মূল্য এবং গোপন কেনার দাম থাকবে)
  final List<Map<String, dynamic>> _allParts = [
    {
      'name': 'টোটো ব্যাটারি (48V)',
      'sellingPrice': '₹ ৬,৫০০',
      'costPrice': '₹ ৫,৮০০', // শুধুমাত্র অ্যাডমিন দেখতে পাবে
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'টোটো কন্ট্রো্লার (Controller)',
      'sellingPrice': '₹ ১,৮০০',
      'costPrice': '₹ ১,৪০০',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'হেডলাইট এলইডি',
      'sellingPrice': '₹ ৩৫০',
      'costPrice': '₹ ২৫০',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'ব্রেক শো (Brake Shoe)',
      'sellingPrice': '₹ ১২০',
      'costPrice': '₹ ৮০',
      'image': 'https://via.placeholder.com/150',
    },
  ];

  List<Map<String, dynamic>> _filteredParts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredParts = _allParts;
  }

  // সার্চ করার ফাংশন
  void _filterParts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredParts = _allParts;
      } else {
        _filteredParts = _allParts
            .where((part) => part['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // দাম পরিবর্তনের ফাংশন (শুধুমাত্র অ্যাডমিনের জন্য)
  void _editPrice(int index) {
    if (!_isAdmin) return;

    TextEditingController sellController = TextEditingController(text: _filteredParts[index]['sellingPrice']);
    TextEditingController costController = TextEditingController(text: _filteredParts[index]['costPrice']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B2230),
          title: Text('${_filteredParts[index]['name']} এর দাম পরিবর্তন', style: const TextStyle(color: Colors.white, fontSize: 14)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: sellController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'বিক্রয় মূল্য (ড্রাইভার দেখবে)', labelStyle: TextStyle(color: Colors.cyanAccent)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: costController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'কেনার দাম (শুধু অ্যাডমিন)', labelStyle: TextStyle(color: Colors.greenAccent)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বাতিল', style: TextStyle(color: Colors.redAccent)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
              onPressed: () {
                setState(() {
                  _filteredParts[index]['sellingPrice'] = sellController.text;
                  _filteredParts[index]['costPrice'] = costController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('সেভ করুন', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('পার্টস ক্যাটালগ ও প্রাইস লিস্ট', style: TextStyle(color: Colors.cyanAccent, fontSize: 16)),
        actions: [
          // অ্যাডমিন ও ড্রাইভার মোড বদলানোর সুইচ (টেস্টিংয়ের জন্য)
          Row(
            children: [
              Text(_isAdmin ? 'অ্যাডমিন মোড' : 'ড্রাইভার মোড', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Switch(
                value: _isAdmin,
                activeThumbColor: Colors.cyanAccent,
                onChanged: (val) {
                  setState(() {
                    _isAdmin = val;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // সার্চ বক্স
            TextField(
              controller: _searchController,
              onChanged: _filterParts,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'পার্টস বা আইটেম সার্চ করুন...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
                filled: true,
                fillColor: const Color(0xFF161B22),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 14),

            // আইটেম বা পার্টসের লিস্ট (GridView বা ListView)
            Expanded(
              child: ListView.builder(
                itemCount: _filteredParts.length,
                itemBuilder: (context, index) {
                  var part = _filteredParts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      children: [
                        // ছবির জায়গা
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.image, color: Colors.white54),
                        ),
                        const SizedBox(width: 12),

                        // নাম ও দামের বিবরণ
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(part['name'], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('দাম: ${part['sellingPrice']}', style: const TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                              
                              // যদি ইউজার অ্যাডমিন হয় তবেই গোপন কেনার দাম দেখতে ও এডিট করতে পারবে
                              if (_isAdmin) ...[
                                const SizedBox(height: 2),
                                Text('কেনার দাম (গোপন): ${part['costPrice']}', style: const TextStyle(color: Colors.greenAccent, fontSize: 11)),
                              ],
                            ],
                          ),
                        ),

                        // এডিট বাটন (শুধু অ্যাডমিনের জন্য)
                        if (_isAdmin)
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.amber, size: 20),
                            onPressed: () => _editPrice(index),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}