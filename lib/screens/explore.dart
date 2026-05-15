import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/api_service.dart';
import 'guide_detail.dart';
import 'tour_detail.dart';
import 'search_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<dynamic> _news = [];
  List<dynamic> _tours = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final newsData = await ApiService.getNews();
      final toursData = await ApiService.getTours();
      if (mounted) {
        setState(() {
          _news = newsData;
          _tours = toursData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : RefreshIndicator(
              onRefresh: _fetchData,
              color: primaryColor,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeaderSection(),
                    const SizedBox(height: 10),
                    _TopJourneysSection(tours: _tours),
                    const _BestGuidesSection(),
                    const _TopExperiencesSection(),
                    _FeaturedToursSection(tours: _tours),
                    _TravelNewsSection(news: _news),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}

// 1. Header & Thanh tìm kiếm
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://picsum.photos/seed/explore-header/800/420',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withValues(alpha: 0.2),
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Explore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Da Nang',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.cloud, color: Colors.white, size: 24),
                        SizedBox(width: 5),
                        Text(
                          '26°C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -25,
          left: 20,
          right: 20,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: hintColor),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              const SearchScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'Hi, where do you want to explore?',
                      hintStyle: TextStyle(color: hintColor, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 2. Top Journeys (Dùng data Tour từ API)
class _TopJourneysSection extends StatelessWidget {
  final List<dynamic> tours;
  const _TopJourneysSection({required this.tours});

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Journeys',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tours.length,
              itemBuilder: (context, index) {
                final tour = tours[index];
                return _buildJourneyCard(
                  tour['title'],
                  '\$${tour['price']}',
                  tour['imageUrl'],
                  tour['duration'] ?? '3 days',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard(String title, String price, String imgUrl, String duration) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imgUrl,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 38,
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 12, color: hintColor),
                    const SizedBox(width: 4),
                    const Text('Jan 30, 2026', style: TextStyle(fontSize: 11, color: hintColor)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: hintColor),
                    const SizedBox(width: 4),
                    Text(duration, style: const TextStyle(fontSize: 11, color: hintColor)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 3. Best Guides
class _BestGuidesSection extends StatelessWidget {
  const _BestGuidesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Best Guides', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text('SEE MORE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildGuideCard(context, 'Tuan Tran', 'Danang, Vietnam', 'https://picsum.photos/seed/guide-tuan/220/220'),
                _buildGuideCard(context, 'Emmy', 'Hanoi, Vietnam', 'https://picsum.photos/seed/guide-emmy/220/220'),
                _buildGuideCard(context, 'Linh Hana', 'Danang, Vietnam', 'https://picsum.photos/seed/guide-linh/220/220'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(BuildContext context, String name, String location, String imgUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => GuideDetailScreen(name: name, location: location, avatar: imgUrl)));
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(imgUrl, height: 140, width: double.infinity, fit: BoxFit.cover)),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: primaryColor),
                Text(location, style: const TextStyle(fontSize: 11, color: primaryColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 4. Top Experiences
class _TopExperiencesSection extends StatelessWidget {
  const _TopExperiencesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Experiences', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          SizedBox(
            height: 270,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildExpCard('2 Hour Bicycle Tour...', 'Tuan Tran', 'https://picsum.photos/seed/exp-bike/320/220', 'https://picsum.photos/seed/avatar-tuan/120/120'),
                _buildExpCard('1 day at Bana Hill', 'Linh Hana', 'https://picsum.photos/seed/exp-bana/320/220', 'https://picsum.photos/seed/avatar-linh/120/120'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpCard(String title, String guideName, String bgImg, String avatarImg) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(bgImg, height: 150, width: double.infinity, fit: BoxFit.cover)),
              Positioned(bottom: -18, child: Column(children: [CircleAvatar(backgroundImage: NetworkImage(avatarImg), radius: 20, backgroundColor: Colors.white), const SizedBox(height: 2), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3), decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)), child: Text(guideName, style: const TextStyle(color: Colors.white, fontSize: 11)))]))
            ],
          ),
          const SizedBox(height: 30),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

// 5. Featured Tours (Dùng data Tour từ API)
class _FeaturedToursSection extends StatelessWidget {
  final List<dynamic> tours;
  const _FeaturedToursSection({required this.tours});

  @override
  Widget build(BuildContext context) {
    if (tours.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Featured Tours', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('SEE MORE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 15),
          ...tours.map((tour) => Column(
                children: [
                  _buildFeatureCard(context, tour['title'], '\$${tour['price']}', tour['imageUrl']),
                  const SizedBox(height: 15),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String price, String imgUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TourDetailScreen(title: title, price: price, imgUrl: imgUrl)));
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), child: Image.network(imgUrl, height: 160, width: double.infinity, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 5),
                      Row(children: const [Icon(Icons.calendar_today, size: 12, color: hintColor), SizedBox(width: 5), Text('Jan 30, 2026', style: TextStyle(fontSize: 12, color: hintColor))]),
                    ],
                  ),
                  Text(price, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. Travel News (Dùng data News từ API)
class _TravelNewsSection extends StatelessWidget {
  final List<dynamic> news;
  const _TravelNewsSection({required this.news});

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Travel News', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('SEE MORE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 15),
          ...news.map((item) => Column(
                children: [
                  _buildNewsCard(item['title'], item['date'].toString().split('T')[0], item['imageUrl']),
                  const SizedBox(height: 15),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String title, String date, String imgUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(date, style: const TextStyle(fontSize: 12, color: hintColor)),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(imgUrl, height: 120, width: double.infinity, fit: BoxFit.cover)),
      ],
    );
  }
}
