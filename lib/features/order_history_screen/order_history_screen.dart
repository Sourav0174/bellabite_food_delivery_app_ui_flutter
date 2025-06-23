import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'widgets/empty_state_widget.dart';
import 'widgets/filter_chip_widget.dart';
import 'widgets/order_card_widget.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _filteredOrders = [];
  bool _isLoading = false;
  bool _isSearching = false;

  // Mock order data
  final List<Map<String, dynamic>> _orderHistory = [
    {
      "id": "ORD001",
      "restaurantName": "Pizza Palace",
      "restaurantLogo":
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=100&h=100&fit=crop",
      "orderDate": DateTime.now().subtract(const Duration(hours: 2)),
      "status": "Delivered",
      "totalAmount": "\$24.99",
      "items": [
        {
          "name": "Margherita Pizza",
          "image":
              "https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=80&h=80&fit=crop",
          "quantity": 1,
          "price": "\$18.99"
        },
        {
          "name": "Garlic Bread",
          "image":
              "https://www.ambitiouskitchen.com/wp-content/uploads/2023/02/Garlic-Bread-4.jpg",
          "quantity": 1,
          "price": "\$6.00"
        }
      ],
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "Credit Card ending in 4532",
      "canReorder": true,
      "canReview": true,
      "isExpanded": false
    },
    {
      "id": "ORD002",
      "restaurantName": "Burger Barn",
      "restaurantLogo":
          "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=100&h=100&fit=crop",
      "orderDate": DateTime.now().subtract(const Duration(days: 1)),
      "status": "Delivered",
      "totalAmount": "\$19.50",
      "items": [
        {
          "name": "Classic Cheeseburger",
          "image":
              "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=80&h=80&fit=crop",
          "quantity": 1,
          "price": "\$12.99"
        },
        {
          "name": "French Fries",
          "image":
              "https://images.unsplash.com/photo-1576107232684-1279f390859f?w=80&h=80&fit=crop",
          "quantity": 1,
          "price": "\$4.99"
        },
        {
          "name": "Coke",
          "image":
              "https://images.unsplash.com/photo-1629203851122-3726ecdf080e?w=80&h=80&fit=crop",
          "quantity": 1,
          "price": "\$1.52"
        }
      ],
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "PayPal",
      "canReorder": true,
      "canReview": false,
      "isExpanded": false
    },
    {
      "id": "ORD003",
      "restaurantName": "Sushi Zen",
      "restaurantLogo":
          "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=100&h=100&fit=crop",
      "orderDate": DateTime.now().subtract(const Duration(days: 3)),
      "status": "Cancelled",
      "totalAmount": "\$45.00",
      "items": [
        {
          "name": "Salmon Roll",
          "image":
              "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=80&h=80&fit=crop",
          "quantity": 2,
          "price": "\$22.50"
        }
      ],
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "Credit Card ending in 4532",
      "canReorder": true,
      "canReview": false,
      "isExpanded": false
    },
    {
      "id": "ORD004",
      "restaurantName": "Taco Fiesta",
      "restaurantLogo":
          "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=100&h=100&fit=crop",
      "orderDate": DateTime.now().subtract(const Duration(days: 5)),
      "status": "Delivered",
      "totalAmount": "\$16.75",
      "items": [
        {
          "name": "Chicken Tacos",
          "image":
              "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=80&h=80&fit=crop",
          "quantity": 3,
          "price": "\$14.25"
        },
        {
          "name": "Guacamole",
          "image":
              "https://images.unsplash.com/photo-1553729459-efe14ef6055d?w=80&h=80&fit=crop",
          "quantity": 1,
          "price": "\$2.50"
        }
      ],
      "deliveryAddress": "123 Main St, Apt 4B, New York, NY 10001",
      "paymentMethod": "Apple Pay",
      "canReorder": true,
      "canReview": true,
      "isExpanded": false
    }
  ];

  final List<String> _filterOptions = [
    'All',
    'Delivered',
    'Cancelled',
    'Refunded'
  ];

  @override
  void initState() {
    super.initState();
    _filteredOrders = List.from(_orderHistory);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreOrders();
    }
  }

  void _loadMoreOrders() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading more orders
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredOrders = _getFilteredOrders();
      } else {
        _filteredOrders = _orderHistory.where((order) {
          final restaurantName =
              (order['restaurantName'] as String).toLowerCase();
          final items = order['items'] as List;
          final itemNames = items
              .map((item) => (item['name'] as String).toLowerCase())
              .join(' ');
          return restaurantName.contains(query.toLowerCase()) ||
              itemNames.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  List<Map<String, dynamic>> _getFilteredOrders() {
    if (_selectedFilter == 'All') {
      return List.from(_orderHistory);
    }
    return _orderHistory
        .where((order) => order['status'] == _selectedFilter)
        .toList();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filteredOrders = _getFilteredOrders();
    });
  }

  void _toggleOrderExpansion(String orderId) {
    setState(() {
      final orderIndex =
          _filteredOrders.indexWhere((order) => order['id'] == orderId);
      if (orderIndex != -1) {
        _filteredOrders[orderIndex]['isExpanded'] =
            !(_filteredOrders[orderIndex]['isExpanded'] as bool);
      }
    });
  }

  void _reorderItems(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Items from ${order['restaurantName']} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Navigator.pushNamed(context, '/cart-screen'),
        ),
      ),
    );
  }

  void _showOrderContextMenu(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'receipt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('View Receipt',
                  style: AppTheme.lightTheme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Receipt downloaded')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'support_agent',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Contact Support',
                  style: AppTheme.lightTheme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connecting to support...')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Share Order',
                  style: AppTheme.lightTheme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order shared')),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _filteredOrders = _getFilteredOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Order History',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ),
      body: _filteredOrders.isEmpty && !_isSearching
          ? const EmptyStateWidget()
          : Column(
              children: [
                // Search Bar
                Container(
                  padding: EdgeInsets.all(4.w),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search restaurants or food items...',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                              icon: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 5.w,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),

                // Filter Chips
                if (!_isSearching)
                  Container(
                    height: 6.h,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filterOptions.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 2.w),
                      itemBuilder: (context, index) {
                        return FilterChipWidget(
                          label: _filterOptions[index],
                          isSelected: _selectedFilter == _filterOptions[index],
                          onTap: () => _onFilterChanged(_filterOptions[index]),
                        );
                      },
                    ),
                  ),

                SizedBox(height: 1.h),

                // Orders List
                Expanded(
                  child: _filteredOrders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'search_off',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 15.w,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No orders found',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Try adjusting your search or filters',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.separated(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                            itemCount:
                                _filteredOrders.length + (_isLoading ? 1 : 0),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 2.h),
                            itemBuilder: (context, index) {
                              if (index == _filteredOrders.length) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(4.w),
                                    child: CircularProgressIndicator(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                    ),
                                  ),
                                );
                              }

                              final order = _filteredOrders[index];
                              return OrderCardWidget(
                                order: order,
                                onTap: () => _toggleOrderExpansion(
                                    order['id'] as String),
                                onReorder: () => _reorderItems(order),
                                onLongPress: () =>
                                    _showOrderContextMenu(context, order),
                                onReviewTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Review ${order['restaurantName']}'),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
