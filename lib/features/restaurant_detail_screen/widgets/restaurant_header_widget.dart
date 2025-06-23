import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:BellaBite/core/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class RestaurantHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> restaurantData;

  const RestaurantHeaderWidget({
    super.key,
    required this.restaurantData,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Hero image
        CustomImageWidget(
          imageUrl: restaurantData['heroImage'] as String,
          width: double.infinity,
          height: 30.h,
          fit: BoxFit.cover,
        ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
        // Restaurant info overlay
        Positioned(
          bottom: 2.h,
          left: 4.w,
          right: 4.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurantData['name'] as String,
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                restaurantData['cuisine'] as String,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  _buildInfoChip(
                    CustomIconWidget(
                      iconName: 'star',
                      color: Colors.amber,
                      size: 16,
                    ),
                    '${restaurantData['rating']}',
                  ),
                  SizedBox(width: 3.w),
                  _buildInfoChip(
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: Colors.white,
                      size: 16,
                    ),
                    restaurantData['deliveryTime'] as String,
                  ),
                  SizedBox(width: 3.w),
                  _buildInfoChip(
                    CustomIconWidget(
                      iconName: 'attach_money',
                      color: Colors.white,
                      size: 16,
                    ),
                    'Min ${restaurantData['minimumOrder']}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(Widget icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 1.w),
          Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
