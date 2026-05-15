import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/api_service.dart';
import 'create_new_trip.dart';
import 'trip_detail.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  int _selectedTab = 0; // 0: Current, 1: Next, 2: Past, 3: Wish List
  final List<String> _tabs = ['Current Trips', 'Next Trips', 'Past Trips', 'Wish List'];
  List<dynamic> _trips = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await ApiService.getMyTrips();
      if (mounted) {
        setState(() {
          _trips = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: primaryColor))
                : RefreshIndicator(
                    onRefresh: _fetchTrips,
                    color: primaryColor,
                    child: _buildListContent(),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewTripScreen())).then((_) => _fetchTrips()),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Image.network('https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=800', height: 140, width: double.infinity, fit: BoxFit.cover),
        Container(height: 140, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent]))),
        SafeArea(bottom: false, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('My Trips', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.search, color: Colors.white, size: 28), onPressed: () {})]))),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            bool isActive = _selectedTab == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(color: isActive ? primaryColor : Colors.transparent, borderRadius: BorderRadius.circular(20)),
                child: Text(_tabs[index], style: TextStyle(color: isActive ? Colors.white : hintColor, fontWeight: isActive ? FontWeight.bold : FontWeight.w600, fontSize: 13)),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildListContent() {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchTrips,
                child: const Text('Thử lại'),
              )
            ],
          ),
        ),
      );
    }

    if (_trips.isEmpty) {
      return const Center(child: Text('Chưa có chuyến đi nào', style: TextStyle(color: hintColor)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _trips.length,
      itemBuilder: (context, index) {
        final trip = _trips[index];
        return Column(
          children: [
            _buildTripCard(
              title: trip['title'],
              date: trip['date'].toString().split('T')[0],
              time: trip['time'] ?? 'All day',
              guideName: 'Fellow4U Guide',
              location: trip['location'] ?? 'Vietnam',
              imgUrl: trip['imageUrl'] ?? 'https://picsum.photos/seed/trip/600/400',
              buttons: [
                _buildOutlineButton('Detail', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TripDetailScreen()))),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildTripCard({required String title, required String date, required String time, required String guideName, required String location, required String imgUrl, required List<Widget> buttons}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), child: Image.network(imgUrl, height: 140, width: double.infinity, fit: BoxFit.cover)),
              Positioned(bottom: 10, left: 15, child: Row(children: [const Icon(Icons.location_on, color: Colors.white, size: 14), const SizedBox(width: 4), Text(location, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))])),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.calendar_today, date),
                const SizedBox(height: 5),
                _buildInfoRow(Icons.access_time, time),
                const SizedBox(height: 5),
                _buildInfoRow(Icons.person_outline, guideName),
                if (buttons.isNotEmpty) ...[
                  const Divider(height: 24),
                  Row(children: buttons.map((btn) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: btn))).toList()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(children: [Icon(icon, size: 14, color: hintColor), const SizedBox(width: 8), Text(text, style: const TextStyle(color: hintColor, fontSize: 13))]);
  }

  Widget _buildOutlineButton(String text, {VoidCallback? onTap}) {
    return OutlinedButton(
      onPressed: onTap ?? () {},
      style: OutlinedButton.styleFrom(side: const BorderSide(color: primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Text(text, style: const TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
