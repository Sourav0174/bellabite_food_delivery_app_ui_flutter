import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class PaymentMethodWidget extends StatelessWidget {
  final Map<String, dynamic> paymentMethod;
  final VoidCallback onChangePayment;

  const PaymentMethodWidget({
    super.key,
    required this.paymentMethod,
    required this.onChangePayment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.lightTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'payment',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Payment Method',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: onChangePayment,
                child: Text(
                  'Change',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // Card Info Box
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                // Payment Icon
                Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getPaymentIcon(paymentMethod['type']),
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 3.w),

                // Payment Info Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paymentMethod['type'] ?? 'Payment Method',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          if (paymentMethod['brand'] != null) ...[
                            Text(
                              paymentMethod['brand'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 2.w),
                          ],
                          Text(
                            paymentMethod['details'] ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Selected Icon
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: colorScheme.tertiary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentIcon(String? paymentType) {
    switch (paymentType?.toLowerCase()) {
      case 'credit card':
      case 'debit card':
        return 'credit_card';
      case 'paypal':
        return 'account_balance_wallet';
      case 'apple pay':
      case 'google pay':
        return 'phone_android';
      case 'cash':
        return 'money';
      default:
        return 'payment';
    }
  }
}
