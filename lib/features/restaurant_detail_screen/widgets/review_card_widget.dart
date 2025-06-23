import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:BellaBite/core/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReviewCardWidget extends StatefulWidget {
  final Map<String, dynamic> review;

  const ReviewCardWidget({
    super.key,
    required this.review,
  });

  @override
  State<ReviewCardWidget> createState() => _ReviewCardWidgetState();
}

class _ReviewCardWidgetState extends State<ReviewCardWidget> {
  bool _isHelpful = false;
  bool _isNotHelpful = false;

  @override
  Widget build(BuildContext context) {
    final int rating = widget.review['rating'] as int;
    final List<dynamic> photos = widget.review['photos'] as List<dynamic>;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and rating
            Row(
              children: [
                CircleAvatar(
                  radius: 5.w,
                  backgroundImage:
                      NetworkImage(widget.review['userAvatar'] as String),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.review['userName'] as String,
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          ...List.generate(
                              5,
                              (index) => CustomIconWidget(
                                    iconName:
                                        index < rating ? 'star' : 'star_border',
                                    color: index < rating
                                        ? Colors.amber
                                        : AppTheme
                                            .lightTheme.colorScheme.outline,
                                    size: 16,
                                  )),
                          SizedBox(width: 2.w),
                          Text(
                            widget.review['date'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Review comment
            Text(
              widget.review['comment'] as String,
              style: AppTheme.lightTheme.textTheme.bodyLarge,
            ),
            // Review photos
            if (photos.isNotEmpty) ...[
              SizedBox(height: 2.h),
              SizedBox(
                height: 15.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  separatorBuilder: (context, index) => SizedBox(width: 2.w),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: photos[index] as String,
                        width: 20.w,
                        height: 15.h,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 2.h),
            // Helpful buttons
            Row(
              children: [
                Text(
                  'Was this helpful?',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(width: 4.w),
                _buildHelpfulButton(
                  icon: 'thumb_up',
                  count: widget.review['helpful'] as int,
                  isSelected: _isHelpful,
                  onTap: () {
                    setState(() {
                      _isHelpful = !_isHelpful;
                      if (_isHelpful && _isNotHelpful) {
                        _isNotHelpful = false;
                      }
                    });
                  },
                ),
                SizedBox(width: 2.w),
                _buildHelpfulButton(
                  icon: 'thumb_down',
                  count: widget.review['notHelpful'] as int,
                  isSelected: _isNotHelpful,
                  onTap: () {
                    setState(() {
                      _isNotHelpful = !_isNotHelpful;
                      if (_isNotHelpful && _isHelpful) {
                        _isHelpful = false;
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpfulButton({
    required String icon,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              count.toString(),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
