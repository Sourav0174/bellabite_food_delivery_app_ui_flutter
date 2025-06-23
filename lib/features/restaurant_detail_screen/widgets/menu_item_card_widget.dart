import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:BellaBite/core/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MenuItemCardWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onAddToCart;
  final VoidCallback onToggleFavorite;

  const MenuItemCardWidget({
    super.key,
    required this.item,
    required this.onAddToCart,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = item['isAvailable'] as bool;
    final bool isFavorite = item['isFavorite'] as bool;

    return GestureDetector(
      onTap: () => _showItemDetails(context),
      onLongPress: onToggleFavorite,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Card(
          elevation: 2,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(3.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          CustomImageWidget(
                            imageUrl: item['image'] as String,
                            width: 20.w,
                            height: 20.w,
                            fit: BoxFit.cover,
                          ),
                          !isAvailable
                              ? Container(
                                  width: 20.w,
                                  height: 20.w,
                                  color: Colors.black.withValues(alpha: 0.5),
                                  child: Center(
                                    child: Text(
                                      'Unavailable',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    SizedBox(width: 3.w),
                    // Item details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['name'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isAvailable
                                        ? AppTheme
                                            .lightTheme.colorScheme.onSurface
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: onToggleFavorite,
                                icon: CustomIconWidget(
                                  iconName: isFavorite
                                      ? 'favorite'
                                      : 'favorite_border',
                                  color: isFavorite
                                      ? Colors.red
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            item['description'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: isAvailable
                                  ? AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.7)
                                  : AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${(item['price'] as double).toStringAsFixed(2)}',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isAvailable
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme.lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.5),
                                ),
                              ),
                              isAvailable
                                  ? ElevatedButton(
                                      onPressed: onAddToCart,
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(8.w, 4.h),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w),
                                      ),
                                      child: CustomIconWidget(
                                        iconName: 'add',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        size: 18,
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.w, vertical: 1.h),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme
                                              .lightTheme.colorScheme.outline
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                      child: Text(
                                        'Out of Stock',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _ItemDetailsBottomSheet(item: item, onAddToCart: onAddToCart),
    );
  }
}

class _ItemDetailsBottomSheet extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onAddToCart;

  const _ItemDetailsBottomSheet({
    required this.item,
    required this.onAddToCart,
  });

  @override
  State<_ItemDetailsBottomSheet> createState() =>
      _ItemDetailsBottomSheetState();
}

class _ItemDetailsBottomSheetState extends State<_ItemDetailsBottomSheet> {
  String selectedSize = 'Regular';
  int quantity = 1;
  final TextEditingController _instructionsController = TextEditingController();

  final List<String> sizes = ['Small', 'Regular', 'Large'];
  final Map<String, double> sizePrices = {
    'Small': -2.0,
    'Regular': 0.0,
    'Large': 3.0,
  };

  @override
  Widget build(BuildContext context) {
    final double basePrice = widget.item['price'] as double;
    final double totalPrice =
        (basePrice + (sizePrices[selectedSize] ?? 0.0)) * quantity;

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: widget.item['image'] as String,
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Item name and description
                  Text(
                    widget.item['name'] as String,
                    style: AppTheme.lightTheme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.item['description'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyLarge,
                  ),
                  SizedBox(height: 2.h),
                  // Size selection
                  Text(
                    'Size',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    children: sizes
                        .map((size) => ChoiceChip(
                              label: Text(size),
                              selected: selectedSize == size,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    selectedSize = size;
                                  });
                                }
                              },
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 2.h),
                  // Quantity selection
                  Text(
                    'Quantity',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      IconButton(
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                        icon: CustomIconWidget(
                          iconName: 'remove',
                          color: quantity > 1
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.3),
                          size: 20,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          quantity.toString(),
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => quantity++),
                        icon: CustomIconWidget(
                          iconName: 'add',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // Special instructions
                  Text(
                    'Special Instructions',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 1.h),
                  TextField(
                    controller: _instructionsController,
                    decoration: InputDecoration(
                      hintText: 'Any special requests?',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          // Add to cart button
          Container(
            padding: EdgeInsets.all(4.w),
            child: ElevatedButton(
              onPressed: () {
                widget.onAddToCart();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 6.h),
              ),
              child: Text('Add to Cart - \$${totalPrice.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }
}
