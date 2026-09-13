import 'package:flutter/material.dart';
import 'map_booking_screen.dart';
import 'parts_catalog_screen.dart';
import 'vip_dashboard.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int _currentIndex = 0;
  bool _isOnline = true;
  bool _isVehiclePowerOn = true;

  // ডাইনামিক এবং রিয়েল-টাইম আপডেটযোগ্য ড্রাইভার ডেটা
  final Map<String, dynamic> _driverStats = {
    'driverName': 'সোনু মন্ডল',
    'todayEarnings': 1450,
    'totalTrips': 12,
    'walletBalance': 350,
    'rating': '4.8 ⭐',
  };

  final List<Map<String, dynamic>> _incomingRequests = [
    {
      'passenger': 'রহিম মন্ডল',
      'pickup': 'স্টেশন রোড',
      'drop': 'বাস স্ট্যান্ড',
      'fare': '₹ ৬০',
      'seats': 1,
    },
  ];

  // ওয়ালেটে তাৎক্ষণিক টাকা যোগ করার উইন্ডো (Add Money Popup)
  void _showAddMoneyDialog() {
    final TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF161B22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.amberAccent, width: 1.5),
            ),
            title: const Text(
              'ওয়ালেটে ক্যাশ যোগ করুন',
              style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'টাকার পরিমাণ লিখুন (যেমন: ৫০০)',
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'বাতিল',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                ),
                onPressed: () {
                  if (amountController.text.isNotEmpty) {
                    setState(() {
                      int addedAmount =
                          int.tryParse(amountController.text) ?? 0;
                      _driverStats['walletBalance'] += addedAmount;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('সফলভাবে ওয়ালেটে টাকা যোগ করা হয়েছে!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text(
                  'নিশ্চিত করুন',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // পুরো স্ক্রিন জুড়ে লাল, হলুদ ও সবুজের প্রিমিয়াম গ্রেডিয়েন্ট লুক
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A2E12), // ডিপ সবুজ শেড
              Color(0xFF38100A), // ডিপ লাল শেড
              Color(0xFF2E2B05), // ডিপ হলুদ/গোল্ডেন শেড
              Color(0xFF090D16), // ডার্ক ফিনিশিং
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _getSelectedPage(_currentIndex),
                ),
              ),
            ],
          ),
        ),
      ),
      // কাস্টম বটম নেভিগেশন বার
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1E1E), Color(0xFF0A0A0A)],
          ),
          border: Border(
            top: BorderSide(
              color: Colors.amberAccent.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.amberAccent,
          unselectedItemColor: Colors.white60,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.speed_rounded, color: Colors.greenAccent),
              activeIcon: Icon(Icons.speed_rounded, color: Colors.amberAccent),
              label: 'ড্যাশবোর্ড',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.navigation_rounded, color: Colors.greenAccent),
              activeIcon: Icon(
                Icons.navigation_rounded,
                color: Colors.amberAccent,
              ),
              label: 'লাইভ ম্যাপ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build_circle_rounded, color: Colors.greenAccent),
              activeIcon: Icon(
                Icons.build_circle_rounded,
                color: Colors.amberAccent,
              ),
              label: 'পার্টস ক্যাটালগ',
            ),
          ],
        ),
      ),
    );
  }

  // রিয়েল-টাইম টপ বার
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade800, Colors.red.shade800],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amberAccent.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amberAccent, width: 2.5),
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.airline_seat_recline_extra_rounded,
                  size: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _driverStats['driverName'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.directions_car_filled_rounded,
                      color: Colors.amberAccent,
                      size: 16,
                    ),
                  ],
                ),
                const Text(
                  '🛺 টোটো প্রো ড্রাইভার ককপিট',
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                _isOnline ? 'অনলাইন' : 'অফলাইন',
                style: TextStyle(
                  color: _isOnline ? Colors.greenAccent : Colors.yellowAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: _isOnline,
                activeThumbColor: Colors.greenAccent,
                activeTrackColor: Colors.green.shade900,
                inactiveThumbColor: Colors.redAccent,
                inactiveTrackColor: Colors.red.shade900,
                onChanged: (val) {
                  setState(() {
                    _isOnline = val;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return _buildDashboardHome();
      case 1:
        return const MapBookingScreen();
      case 2:
        return const PartsCatalogScreen();
      default:
        return _buildDashboardHome();
    }
  }

  // মূল ড্যাশবোর্ড হোম পেজ
  Widget _buildDashboardHome() {
    return SingleChildScrollView(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ইগনিশন ও পাওয়ার স্ট্যাটাস বক্স
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade900.withValues(alpha: 0.85),
                  Colors.red.shade900.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amberAccent, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '⚡ টোটো পাওয়ার ও ইগনিশন সিস্টেম',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.bolt, color: Colors.amberAccent, size: 20),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isOnline ? '🟢 জিপিএস ব্রডকাস্ট সচল' : '🔴 সিগন্যাল অফ',
                      style: TextStyle(
                        color:
                            _isOnline ? Colors.greenAccent : Colors.redAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _isVehiclePowerOn ? 'ফিউজ: ওকে' : 'কাটআউট',
                          style: TextStyle(
                            color:
                                _isVehiclePowerOn
                                    ? Colors.greenAccent
                                    : Colors.yellowAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: _isVehiclePowerOn,
                          activeThumbColor: const Color.fromARGB(242, 247, 223, 4),
                          onChanged: (val) {
                            setState(() {
                              _isVehiclePowerOn = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // স্ট্যাটাস ও আয়ের গ্রিড (সঠিক ও ত্রুটিমুক্ত কোড)
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.4,
            children: [
              _buildStatCard(
                'আজকের মোট আয়',
                '₹ ${_driverStats['todayEarnings']}',
                Icons.account_balance_wallet_rounded,
                Colors.greenAccent,
                Colors.green,
              ),
              _buildStatCard(
                'সম্পন্ন ট্রিপ',
                '${_driverStats['totalTrips']} টি',
                Icons.alt_route_rounded,
                Colors.amberAccent,
                Colors.orange,
              ),

              // ওয়ালেট কার্ড (ক্লিক করলেই অ্যাড মানি পপআপ ওপেন হবে)
              GestureDetector(
                onTap: _showAddMoneyDialog,
                child: _buildStatCard(
                  'ওয়ালেট ব্যালেন্স (+)',
                  '₹ ${_driverStats['walletBalance']}',
                  Icons.account_balance_rounded,
                  Colors.yellowAccent,
                  Colors.amber,
                ),
              ),

              _buildStatCard(
                'ড্রাইভার রেটিং',
                _driverStats['rating'],
                Icons.stars_rounded,
                Colors.redAccent,
                Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // লাইভ প্যাসেঞ্জার রিকোয়েস্ট সেকশন
          if (_isOnline &&
              _isVehiclePowerOn &&
              _incomingRequests.isNotEmpty) ...[
            const Text(
              '🔥 নতুন লাইভ প্যাসেঞ্জার বুকিং',
              style: TextStyle(
                color: Colors.yellowAccent,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ..._incomingRequests.map(
              (req) => Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade900, Colors.black],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.greenAccent, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_taxi_rounded,
                      color: Colors.amberAccent,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req['passenger'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'রুট: ${req['pickup']} ➔ ${req['drop']}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            'ভাড়া: ${req['fare']} (${req['seats']} সিট)',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          _incomingRequests.remove(req);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('রাইড সফলভাবে গ্রহণ করা হয়েছে!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text(
                        'গ্রহণ করুন',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          const Text(
            '⚙️ কুইক এক্সেস নেভিগেশন',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.map_rounded,
            title: 'লাইভ ম্যাপ ও নেভিগেশন',
            subtitle: 'ম্যাপ খুলে রিয়েল-টাইম প্যাসেঞ্জার ট্র্যাকিং করুন',
            color: Colors.greenAccent,
            onTap: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
          const SizedBox(height: 10),
          _buildActionTile(
            icon: Icons.store_rounded,
            title: 'পার্টস ক্যাটালগ ও প্রাইজ লিস্ট',
            subtitle: 'টোটো পার্টস, কন্ট্রোলার ও ব্যাটারির স্পেসিফিকেশন',
            color: Colors.amberAccent,
            onTap: () {
              setState(() {
                _currentIndex = 2;
              });
            },
          ),
          const SizedBox(height: 10),
          _buildActionTile(
            icon: Icons.star_rounded,
            title: 'ভিআইপি ক্লাব ও ডিসকাউন্ট অফার',
            subtitle: 'বিশেষ ছাড় ও ক্যাশব্যাক সুবিধা দেখুন',
            color: Colors.redAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VipDashboard()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color textColor,
    MaterialColor bgGlow,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            bgGlow.shade900.withValues(alpha: 0.7),
            Colors.black.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 9),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white38,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
