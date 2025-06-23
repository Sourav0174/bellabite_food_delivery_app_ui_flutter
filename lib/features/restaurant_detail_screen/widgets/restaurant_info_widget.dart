import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RestaurantInfoWidget extends StatelessWidget {
  final Map<String, dynamic> restaurantData;

  const RestaurantInfoWidget({
    super.key,
    required this.restaurantData,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> operatingHours =
        restaurantData['operatingHours'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Restaurant description
        _buildSection(
          'About',
          Text(
            restaurantData['description'] as String,
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
        ),
        SizedBox(height: 3.h),
        // Contact information
        _buildSection(
          'Contact Information',
          Column(
            children: [
              _buildInfoRow(
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                'Address',
                restaurantData['address'] as String,
              ),
              SizedBox(height: 2.h),
              _buildInfoRow(
                CustomIconWidget(
                  iconName: 'phone',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                'Phone',
                restaurantData['phone'] as String,
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        // Operating hours
        _buildSection(
          'Operating Hours',
          Column(
            children: operatingHours.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _capitalizeFirst(entry.key),
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    Text(
                      entry.value as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 3.h),
        // Delivery area map placeholder
        _buildSection(
          'Delivery Area',
          Container(
            width: double.infinity,
            height: 25.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'map',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 48,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Delivery Area Map',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  'We deliver within 5km radius',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 3.h),
        // Additional info
        _buildSection(
          'Additional Information',
          Column(
            children: [
              _buildInfoRow(
                CustomIconWidget(
                  iconName: 'delivery_dining',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                'Delivery Fee',
                '\$2.99',
              ),
              SizedBox(height: 2.h),
              _buildInfoRow(
                CustomIconWidget(
                  iconName: 'access_time',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                'Average Delivery Time',
                restaurantData['deliveryTime'] as String,
              ),
              SizedBox(height: 2.h),
              _buildInfoRow(
                CustomIconWidget(
                  iconName: 'attach_money',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                'Minimum Order',
                restaurantData['minimumOrder'] as String,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        content,
      ],
    );
  }

  Widget _buildInfoRow(Widget icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
