import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'widgets/promotional_banner_widget.dart';
import 'widgets/quick_filters_widget.dart';
import 'widgets/restaurant_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isLoading = false;
  String _selectedFilter = '';
  final ScrollController _scrollController = ScrollController();

  // Mock data for restaurants
  final List<Map<String, dynamic>> _restaurants = [
    {
      "id": 1,
      "name": "Pizza Palace",
      "cuisine": "Italian",
      "image":
          "https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg",
      "rating": 4.5,
      "reviewCount": 250,
      "deliveryTime": "25-30 min",
      "deliveryFee": "\$2.99",
      "isFavorite": false,
      "hasOrderedBefore": true,
      "description": "Authentic Italian pizzas with fresh ingredients",
    },
    {
      "id": 2,
      "name": "Dragon Wok",
      "cuisine": "Chinese",
      "image":
          "https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg",
      "rating": 4.2,
      "reviewCount": 180,
      "deliveryTime": "20-25 min",
      "deliveryFee": "\$1.99",
      "isFavorite": true,
      "hasOrderedBefore": false,
      "description": "Traditional Chinese cuisine with modern twist",
    },
    {
      "id": 3,
      "name": "Green Bowl",
      "cuisine": "Healthy",
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg",
      "rating": 4.7,
      "reviewCount": 320,
      "deliveryTime": "15-20 min",
      "deliveryFee": "\$3.49",
      "isFavorite": false,
      "hasOrderedBefore": true,
      "description": "Fresh salads and healthy bowls for wellness",
    },
    {
      "id": 4,
      "name": "Burger Junction",
      "cuisine": "American",
      "image":
          "https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg",
      "rating": 4.3,
      "reviewCount": 195,
      "deliveryTime": "30-35 min",
      "deliveryFee": "\$2.49",
      "isFavorite": true,
      "hasOrderedBefore": false,
      "description": "Juicy burgers and crispy fries",
    },
    {
      "id": 5,
      "name": "Spice Route",
      "cuisine": "Indian",
      "image":
          "https://images.pexels.com/photos/1640772/pexels-photo-1640772.jpeg",
      "rating": 4.6,
      "reviewCount": 280,
      "deliveryTime": "25-30 min",
      "deliveryFee": "\$2.99",
      "isFavorite": false,
      "hasOrderedBefore": true,
      "description": "Authentic Indian spices and flavors",
    },
  ];

  // Mock data for promotional banners
  final List<Map<String, dynamic>> _promotionalBanners = [
    {
      "id": 1,
      "title": "50% Off First Order",
      "subtitle": "Use code WELCOME50",
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg",
      "backgroundColor": "0xFFFF6B35",
    },
    {
      "id": 2,
      "title": "Free Delivery Weekend",
      "subtitle": "No delivery fees this weekend",
      "image":
          "https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg",
      "backgroundColor": "0xFF27AE60",
    },
    {
      "id": 3,
      "title": "New Restaurant Alert",
      "subtitle": "Dragon Wok now delivering",
      "image":
          "https://images.pexels.com/photos/1410235/pexels-photo-1410235.jpeg",
      "backgroundColor": "0xFF2C3E50",
    },
  ];

  // Mock data for quick filters
  final List<Map<String, dynamic>> _quickFilters = [
    {"name": "All", "icon": "restaurant"},
    {"name": "Pizza", "icon": "local_pizza"},
    {"name": "Chinese", "icon": "ramen_dining"},
    {"name": "Healthy", "icon": "eco"},
    {"name": "Burgers", "icon": "lunch_dining"},
    {"name": "Indian", "icon": "curry"},
    {"name": "Desserts", "icon": "cake"},
    {"name": "Coffee", "icon": "coffee"},
  ];

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRestaurants() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    await _loadRestaurants();
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter == 'All' ? '' : filter;
    });
  }

  void _toggleFavorite(int restaurantId) {
    setState(() {
      final restaurant = _restaurants.firstWhere(
        (r) => (r["id"] as int) == restaurantId,
      );
      restaurant["isFavorite"] = !(restaurant["isFavorite"] as bool);
    });
  }

  void _navigateToRestaurantDetail(Map<String, dynamic> restaurant) {
    Navigator.pushNamed(context, '/restaurant-detail-screen');
  }

  List<Map<String, dynamic>> get _filteredRestaurants {
    if (_selectedFilter.isEmpty) {
      return _restaurants;
    }
    return _restaurants
        .where(
          (restaurant) => (restaurant["cuisine"] as String)
              .toLowerCase()
              .contains(_selectedFilter.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppTheme.backgroundDark,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Sticky Header with Location and Notifications
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 2,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                title: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deliver to',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          Text(
                            'Sec 38(w), Chandigarh',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: CustomIconWidget(
                      iconName: 'notifications_outlined',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 2.w),
                ],
              ),

              // Promotional Banner
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  child: PromotionalBannerWidget(banners: _promotionalBanners),
                ),
              ),

              // Quick Filters
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: QuickFiltersWidget(
                    filters: _quickFilters,
                    selectedFilter: _selectedFilter,
                    onFilterSelected: _onFilterSelected,
                  ),
                ),
              ),

              // Restaurant List
              _isLoading
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildSkeletonCard(),
                        childCount: 5,
                      ),
                    )
                  : _filteredRestaurants.isEmpty
                      ? SliverFillRemaining(child: _buildEmptyState())
                      : SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            final restaurant = _filteredRestaurants[index];
                            return RestaurantCardWidget(
                              restaurant: restaurant,
                              onTap: () =>
                                  _navigateToRestaurantDetail(restaurant),
                              onFavoriteToggle: () =>
                                  _toggleFavorite(restaurant["id"] as int),
                            );
                          }, childCount: _filteredRestaurants.length),
                        ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              // Already on Home
              break;
            case 1:
              // Navigate to Search (not implemented)
              break;
            case 2:
              Navigator.pushNamed(context, '/order-history-screen');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile-screen');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'receipt_long',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cart-screen');
        },
        child: CustomIconWidget(
          iconName: 'shopping_cart',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                width: 60.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                width: 40.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'restaurant',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No restaurants in your area',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Try expanding your delivery area or check back later',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
