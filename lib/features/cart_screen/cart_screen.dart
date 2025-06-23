import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'widgets/cart_item_widget.dart';
import 'widgets/delivery_address_widget.dart';
import 'widgets/empty_cart_widget.dart';
import 'widgets/order_summary_widget.dart';
import 'widgets/payment_method_widget.dart';
import 'widgets/promo_code_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _specialInstructionsController = TextEditingController();
  final _promoCodeController = TextEditingController();
  bool _isLoading = false;
  bool _isPromoApplied = false;
  String _promoDiscount = '';

  final List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "Margherita Pizza",
      "image":
          "https://safrescobaldistatic.blob.core.windows.net/media/2022/11/PIZZA-MARGHERITA.jpg",
      "price": 12.99,
      "quantity": 2,
      "customizations": ["Extra Cheese", "Thin Crust"],
      "restaurant": "Tony's Italian Kitchen"
    },
    {
      "id": 2,
      "name": "Caesar Salad",
      "image":
          "https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=300&fit=crop",
      "price": 8.50,
      "quantity": 1,
      "customizations": ["No Croutons"],
      "restaurant": "Tony's Italian Kitchen"
    },
    {
      "id": 3,
      "name": "Garlic Bread",
      "image":
          "https://www.ambitiouskitchen.com/wp-content/uploads/2023/02/Garlic-Bread-4.jpg",
      "price": 4.99,
      "quantity": 1,
      "customizations": [],
      "restaurant": "Tony's Italian Kitchen"
    }
  ];

  final Map<String, dynamic> _restaurantInfo = {
    "name": "Tony's Italian Kitchen",
    "estimatedDelivery": "25-35 min",
    "deliveryFee": 2.99,
    "serviceFee": 1.50,
    "tax": 3.24
  };

  final _deliveryAddress = {
    "title": "Home",
    "address": "123 Main Street, Apt 4B, New York, NY 10001",
    "instructions": "Ring doorbell twice"
  };

  final _paymentMethod = {
    "type": "Credit Card",
    "details": "**** **** **** 1234",
    "brand": "Visa"
  };

  double get _subtotal => _cartItems.fold(
      0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  double get _discount => _isPromoApplied ? _subtotal * 0.1 : 0.0;
  double get _total =>
      _subtotal +
      _restaurantInfo['deliveryFee'] +
      _restaurantInfo['serviceFee'] +
      _restaurantInfo['tax'] -
      _discount;

  void _updateQuantity(int itemId, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        _cartItems.removeWhere((item) => item['id'] == itemId);
      } else {
        final index = _cartItems.indexWhere((item) => item['id'] == itemId);
        if (index != -1) _cartItems[index]['quantity'] = newQuantity;
      }
    });
  }

  void _removeItem(int itemId) =>
      setState(() => _cartItems.removeWhere((item) => item['id'] == itemId));

  void _applyPromoCode() {
    final promoCode = _promoCodeController.text.trim().toUpperCase();
    setState(() {
      if (promoCode == 'SAVE10') {
        _isPromoApplied = true;
        _promoDiscount = '10% off';
        _showSnackBar('Promo code applied successfully!', Colors.green);
      } else {
        _isPromoApplied = false;
        _promoDiscount = '';
        _showSnackBar('Invalid promo code', Colors.red);
      }
    });
  }

  void _placeOrder() async {
    if (_cartItems.isEmpty) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
    if (!mounted) return;
    _showSnackBar('Order placed successfully!', Colors.green);
    Navigator.pushReplacementNamed(context, '/home-screen');
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title:
            Text('Your Order', style: AppTheme.lightTheme.textTheme.titleLarge),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: _cartItems.isEmpty ? const EmptyCartWidget() : _buildCartContent(),
      bottomNavigationBar:
          _cartItems.isNotEmpty ? _buildBottomCheckout() : null,
    );
  }

  Widget _buildCartContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 2.h)),
        SliverToBoxAdapter(child: _buildRestaurantHeader()),
        SliverToBoxAdapter(child: SizedBox(height: 3.h)),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Items',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 2.h),
                    ],
                  );
                }
                final item = _cartItems[index - 1];
                return Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: CartItemWidget(
                    item: item,
                    onQuantityChanged: (newQty) =>
                        _updateQuantity(item['id'], newQty),
                    onRemove: () => _removeItem(item['id']),
                  ),
                );
              },
              childCount: _cartItems.length + 1,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 2.h)),
        SliverToBoxAdapter(child: _buildAddMoreItemsButton()),
        SliverToBoxAdapter(child: SizedBox(height: 3.h)),
        SliverToBoxAdapter(
          child: PromoCodeWidget(
            controller: _promoCodeController,
            onApply: _applyPromoCode,
            isApplied: _isPromoApplied,
            discount: _promoDiscount,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 3.h)),
        SliverToBoxAdapter(child: _buildSpecialInstructions()),
        SliverToBoxAdapter(child: SizedBox(height: 3.h)),
        SliverToBoxAdapter(
          child: DeliveryAddressWidget(
              address: _deliveryAddress, onChangeAddress: () {}),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 3.h)),
        SliverToBoxAdapter(
          child: PaymentMethodWidget(
              paymentMethod: _paymentMethod, onChangePayment: () {}),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 3.h)),
        SliverToBoxAdapter(
          child: OrderSummaryWidget(
            subtotal: _subtotal,
            deliveryFee: _restaurantInfo['deliveryFee'],
            serviceFee: _restaurantInfo['serviceFee'],
            tax: _restaurantInfo['tax'],
            discount: _discount,
            total: _total,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 12.h)),
      ],
    );
  }

  Widget _buildRestaurantHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'restaurant',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_restaurantInfo['name'],
                    style: AppTheme.lightTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Delivery in ${_restaurantInfo['estimatedDelivery']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreItemsButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () =>
            Navigator.pushNamed(context, '/restaurant-detail-screen'),
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        label: Text('Add More Items',
            style: AppTheme.lightTheme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500)),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          side: BorderSide(
              color: AppTheme.lightTheme.colorScheme.primary, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildSpecialInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Special Instructions',
            style: AppTheme.lightTheme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color:
                    AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3)),
          ),
          child: TextField(
            controller: _specialInstructionsController,
            maxLines: 3,
            maxLength: 200,
            decoration: InputDecoration(
              hintText: 'Add any special instructions for your order...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(4.w),
              counterStyle: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCheckout() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                    style: AppTheme.lightTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text('\$${_total.toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    )),
              ],
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary),
                        ),
                      )
                    : Text('Place Order',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
