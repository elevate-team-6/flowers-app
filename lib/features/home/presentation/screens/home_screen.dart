import 'package:flowers_app/features/home/presentation/widgets/best_seller_card.dart';
import 'package:flowers_app/features/home/presentation/widgets/category_card.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_common_section_header.dart';
import 'package:flowers_app/features/home/presentation/widgets/occasion_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ── Sample data ──────────────────────────────────────────────────────────────

  static const List<Map<String, dynamic>> _categories = [
    {'icon': Icons.local_florist, 'label': 'Flowers'},
    {'icon': Icons.card_giftcard, 'label': 'Gift'},
    {'icon': Icons.credit_card, 'label': 'Card'},
    {'icon': Icons.diamond_outlined, 'label': 'Jewellery'},
    {'icon': Icons.cake_outlined, 'label': 'Cake'},
  ];

  static const List<Map<String, String>> _bestSellers = [
    {
      'image':
          'https://images.unsplash.com/photo-1490750967868-88df5691cc52?w=400',
      'title': 'Sunny',
      'price': '600 EGP',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1534710961216-75c88202f43e?w=400',
      'title': 'Red roses',
      'price': '600 EGP',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1462275646964-a0e3386b89fa?w=400',
      'title': 'Spring vase',
      'price': '600 EGP',
    },
  ];

  static const List<Map<String, String>> _occasions = [
    {
      'image':
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
      'label': 'Wedding',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=400',
      'label': 'Birthday',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=400',
      'label': 'Graduation',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  // Logo
                  const Row(
                    children: [
                      Icon(
                        Icons.local_florist,
                        color: Color(0xFFE8637A),
                        size: 22,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Flowery',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE8637A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Search bar
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 12),
                          Icon(
                            Icons.search,
                            color: Color(0xFF999999),
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Search',
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Delivery address ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: const [
                  Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF666666),
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Deliver to 2XVP+XC · Sheikh Zayed',
                    style: TextStyle(fontSize: 13, color: Color(0xFF444444)),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF444444),
                    size: 16,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // ── Scrollable body ────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                //لما بتعمل سكرول لفوق بيعمل كانه بيخبط فالسقف ويرتد
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Categories ─────────────────────────────────────────────
                    HomeCommonSectionHeader(
                      title: 'Categories',
                      onViewAll: () {},
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 16),
                        itemBuilder: (context, i) {
                          final category = _categories[i];
                          return CategoryCard(
                            icon: category['icon'],
                            label: category['label'],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Best Sellers ───────────────────────────────────────────
                    HomeCommonSectionHeader(
                      title: 'Best seller',
                      onViewAll: () {},
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 210,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _bestSellers.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final b = _bestSellers[i];
                          return BestSellerCard(
                            imageUrl: b['image']!,
                            title: b['title']!,
                            price: b['price']!,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Occasions ──────────────────────────────────────────────
                    HomeCommonSectionHeader(
                      title: 'Occasion',
                      onViewAll: () {},
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 130,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _occasions.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final o = _occasions[i];
                          return OccasionCard(
                            imageUrl: o['image']!,
                            label: o['label']!,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
