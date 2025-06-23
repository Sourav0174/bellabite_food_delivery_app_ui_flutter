import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'widgets/cart_summary_bar_widget.dart';
import 'widgets/menu_item_card_widget.dart';
import 'widgets/restaurant_header_widget.dart';
import 'widgets/restaurant_info_widget.dart';
import 'widgets/review_card_widget.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showCartBar = false;
  int _cartItemCount = 0;
  double _cartTotal = 0.0;
  final List<Map<String, dynamic>> _cartItems = [];

  // Mock restaurant data
  final Map<String, dynamic> restaurantData = {
    "id": 1,
    "name": "Cafe De Piccolo",
    "cuisine": "Italian",
    "rating": 4.5,
    "deliveryTime": "25-35 min",
    "minimumOrder": "\$15.00",
    "heroImage":
        "https://lh3.googleusercontent.com/gps-cs-s/AC9h4novzbW9jgbRz0k2BwNdULvGxfTxY_JrGCKo3MjZqvzvbwrjVgm2cIc_NcoC5k_kZNkClN7nHhBaqlkh6-DnJm4ZI_c3zEvclZbhAjvuE1JbwVTjDN7F-C5q6h3b9mSK6wym5mUTNA=w289-h312-n-k-no",
    "description":
        "Authentic Italian cuisine with fresh ingredients and traditional recipes passed down through generations.",
    "address": "SCO 61-62-63, Madhya Marg, 9-D, Sector 9, Chandigarh",
    "phone": "+91 (555) 123-4567",
    "operatingHours": {
      "monday": "11:00 AM - 10:00 PM",
      "tuesday": "11:00 AM - 10:00 PM",
      "wednesday": "11:00 AM - 10:00 PM",
      "thursday": "11:00 AM - 10:00 PM",
      "friday": "11:00 AM - 11:00 PM",
      "saturday": "10:00 AM - 11:00 PM",
      "sunday": "10:00 AM - 9:00 PM"
    }
  };

  // Mock menu data
  final List<Map<String, dynamic>> menuCategories = [
    {
      "category": "Appetizers",
      "items": [
        {
          "id": 1,
          "name": "Bruschetta",
          "description":
              "Grilled bread topped with fresh tomatoes, basil, and garlic",
          "price": 8.99,
          "image":
              "https://images.pexels.com/photos/1438672/pexels-photo-1438672.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "isAvailable": true,
          "isFavorite": false
        },
        {
          "id": 2,
          "name": "Calamari Rings",
          "description": "Crispy fried squid rings served with marinara sauce",
          "price": 12.99,
          "image":
              "https://images.pexels.com/photos/725991/pexels-photo-725991.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "isAvailable": true,
          "isFavorite": true
        }
      ]
    },
    {
      "category": "Mains",
      "items": [
        {
          "id": 3,
          "name": "Margherita Pizza",
          "description":
              "Classic pizza with fresh mozzarella, tomatoes, and basil",
          "price": 16.99,
          "image":
              "https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "isAvailable": true,
          "isFavorite": false
        },
        {
          "id": 4,
          "name": "Spaghetti Carbonara",
          "description":
              "Traditional pasta with eggs, cheese, pancetta, and black pepper",
          "price": 18.99,
          "image":
              "https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "isAvailable": false,
          "isFavorite": false
        }
      ]
    },
    {
      "category": "Desserts",
      "items": [
        {
          "id": 5,
          "name": "Tiramisu",
          "description":
              "Classic Italian dessert with coffee-soaked ladyfingers and mascarpone",
          "price": 7.99,
          "image":
              "https://images.pexels.com/photos/6880219/pexels-photo-6880219.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          "isAvailable": true,
          "isFavorite": true
        }
      ]
    }
  ];

  // Mock reviews data
  final List<Map<String, dynamic>> reviewsData = [
    {
      "id": 1,
      "userName": "Sarah Johnson",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rating": 5,
      "comment":
          "Amazing food and excellent service! The pasta was perfectly cooked and the atmosphere was wonderful.",
      "date": "2024-01-15",
      "helpful": 12,
      "notHelpful": 1,
      "photos": [
        "https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&dpr=1"
      ]
    },
    {
      "id": 2,
      "userName": "Mike Chen",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rating": 4,
      "comment":
          "Great pizza and friendly staff. Delivery was quick and food arrived hot.",
      "date": "2024-01-12",
      "helpful": 8,
      "notHelpful": 0,
      "photos": []
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      _cartItems.add(item);
      _cartItemCount++;
      _cartTotal += (item['price'] as double);
      _showCartBar = true;
    });
  }

  void _toggleFavorite(int itemId) {
    setState(() {
      for (var category in menuCategories) {
        for (var item in (category['items'] as List)) {
          if ((item as Map<String, dynamic>)['id'] == itemId) {
            item['isFavorite'] = !(item['isFavorite'] as bool);
            break;
          }
        }
      }
    });
  }

  void _shareRestaurant() {
    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Restaurant link shared!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  Future<void> _refreshData() async {
    // Mock refresh functionality
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh data here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 30.h,
                    floating: false,
                    pinned: true,
                    backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: _shareRestaurant,
                        icon: CustomIconWidget(
                          iconName: 'share',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: RestaurantHeaderWidget(
                        restaurantData: restaurantData,
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverTabBarDelegate(
                      TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Menu'),
                          Tab(text: 'Reviews'),
                          Tab(text: 'Info'),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildMenuTab(),
                  _buildReviewsTab(),
                  _buildInfoTab(),
                ],
              ),
            ),
            _showCartBar
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CartSummaryBarWidget(
                      itemCount: _cartItemCount,
                      total: _cartTotal,
                      onViewCart: () {
                        Navigator.pushNamed(context, '/cart-screen');
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: _showCartBar ? 12.h : 2.h,
      ),
      child: Column(
        children: [
          // Category quick-jump buttons
          Container(
            height: 6.h,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: menuCategories.length,
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final category = menuCategories[index];
                return Chip(
                  label: Text(category['category'] as String),
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                );
              },
            ),
          ),
          // Menu categories
          ...menuCategories.map((category) => _buildMenuCategory(category)),
        ],
      ),
    );
  }

  Widget _buildMenuCategory(Map<String, dynamic> category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Text(
            category['category'] as String,
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
        ),
        ...(category['items'] as List).map((item) => MenuItemCardWidget(
              item: item as Map<String, dynamic>,
              onAddToCart: () => _addToCart(item),
              onToggleFavorite: () => _toggleFavorite((item)['id'] as int),
            )),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildReviewsTab() {
    return ListView.separated(
      padding: EdgeInsets.all(4.w),
      itemCount: reviewsData.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        return ReviewCardWidget(
          review: reviewsData[index],
        );
      },
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: RestaurantInfoWidget(
        restaurantData: restaurantData,
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
