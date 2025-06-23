import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class QuickFiltersWidget extends StatelessWidget {
  final List<Map<String, dynamic>> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const QuickFiltersWidget({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Quick Filters',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 6.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              final filterName = filter["name"] as String;
              final isSelected = selectedFilter == filterName ||
                  (selectedFilter.isEmpty && filterName == 'All');

              return Container(
                margin: EdgeInsets.only(right: 3.w),
                child: FilterChip(
                  selected: isSelected,
                  onSelected: (selected) {
                    onFilterSelected(filterName);
                  },
                  avatar: CustomIconWidget(
                    iconName: filter["icon"] as String,
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                  label: Text(
                    filterName,
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  backgroundColor: isSelected
                      ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  selectedColor:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  side: BorderSide(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
