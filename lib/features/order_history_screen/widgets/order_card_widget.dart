import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class OrderCardWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onTap;
  final VoidCallback onReorder;
  final VoidCallback onLongPress;
  final VoidCallback? onReviewTap;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.onTap,
    required this.onReorder,
    required this.onLongPress,
    this.onReviewTap,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'cancelled':
        return AppTheme.lightTheme.colorScheme.error;
      case 'refunded':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hr ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = order['isExpanded'] as bool;
    final items = order['items'] as List;
    final canReorder = order['canReorder'] as bool;
    final canReview = order['canReview'] as bool;
    final status = order['status'] as String;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(3.w),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2.w),
                        child: CustomImageWidget(
                          imageUrl: order['restaurantLogo'] as String,
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['restaurantName'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              _formatDate(order['orderDate'] as DateTime),
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                        child: Text(
                          status,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Summary
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Amount',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              order['totalAmount'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Item preview
                  SizedBox(
                    height: 15.w,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length > 4 ? 4 : items.length,
                      separatorBuilder: (_, __) => SizedBox(width: 2.w),
                      itemBuilder: (context, index) {
                        if (index == 3 && items.length > 4) {
                          return Container(
                            width: 15.w,
                            height: 15.w,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Center(
                              child: Text(
                                '+${items.length - 3}',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }

                        final item = items[index] as Map<String, dynamic>;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(2.w),
                          child: CustomImageWidget(
                            imageUrl: item['image'] as String,
                            width: 15.w,
                            height: 15.w,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Expanded content
            if (isExpanded) ...[
              Container(
                width: double.infinity,
                height: 0.2.h,
                color: AppTheme.lightTheme.dividerColor,
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Items',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(height: 2.h),
                    ...items.map((item) {
                      final itemData = item as Map<String, dynamic>;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(1.5.w),
                              child: CustomImageWidget(
                                imageUrl: itemData['image'] as String,
                                width: 10.w,
                                height: 10.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(itemData['name'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium),
                                  Text('Qty: ${itemData['quantity']}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                            Text(
                              itemData['price'] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    SizedBox(height: 2.h),

                    // Delivery Info
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: AppTheme.lightTheme.dividerColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 4.w),
                              SizedBox(width: 2.w),
                              Text('Delivery Address',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(order['deliveryAddress'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(Icons.payment,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 4.w),
                              SizedBox(width: 2.w),
                              Text('Payment Method',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(order['paymentMethod'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Buttons
                    Row(
                      children: [
                        if (canReorder)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onReorder,
                              child: const Text('Reorder'),
                            ),
                          ),
                        if (canReorder &&
                            canReview &&
                            status.toLowerCase() == 'delivered')
                          SizedBox(width: 3.w),
                        if (canReview && status.toLowerCase() == 'delivered')
                          Expanded(
                            child: OutlinedButton(
                              onPressed: onReviewTap,
                              child: const Text('Rate & Review'),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
