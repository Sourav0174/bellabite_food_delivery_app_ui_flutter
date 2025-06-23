import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class PromoCodeWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onApply;
  final bool isApplied;
  final String discount;

  const PromoCodeWidget({
    super.key,
    required this.controller,
    required this.onApply,
    required this.isApplied,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.lightTheme;
    final colors = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'local_offer',
                color: colors.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Promo Code',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Applied Promo
          if (isApplied)
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colors.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colors.tertiary,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: colors.tertiary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Promo code applied! You saved $discount',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.clear();
                    },
                    child: Text(
                      'Remove',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Enter promo code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: colors.outline.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: colors.outline.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: colors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.5.h,
                          ),
                        ),
                        style: theme.textTheme.bodyMedium,
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (_, __, ___) {
                        final isValid = controller.text.trim().isNotEmpty;
                        return ElevatedButton(
                          onPressed: isValid ? onApply : null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.5.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Apply',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Try: SAVE10 for 10% off',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
