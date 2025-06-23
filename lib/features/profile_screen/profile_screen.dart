import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/core/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'widgets/profile_header_widget.dart';
import 'widgets/profile_menu_item_widget.dart';

final Map<String, dynamic> userData = {
  "id": 1,
  "name": "Sourav",
  "email": "info.sourav174@email.com",
  "phone": "+1 (555) 123-4567",
  "avatar":
      "https://instagram.fluh1-2.fna.fbcdn.net/v/t51.2885-15/500622852_18389490748191004_7493606676095247063_n.webp?efg=eyJ2ZW5jb2RlX3RhZyI6IkNBUk9VU0VMX0lURU0uaW1hZ2VfdXJsZ2VuLjE0NDB4MTQ0MC5zZHIuZjc1NzYxLmRlZmF1bHRfaW1hZ2UifQ&_nc_ht=instagram.fluh1-2.fna.fbcdn.net&_nc_cat=104&_nc_oc=Q6cZ2QHbuX6lzwUHg2Xksmqzxj_5VdaX_tO-4jSI2f3CmOoX-ZCqy1eDnkFSQT2aZ1t1sMVqfmHhlArsInm9eXeOAvyJ&_nc_ohc=J8LoLZjatEAQ7kNvwGvbfdn&_nc_gid=ldfiFkBGNOg7iXTzYelWNA&edm=AP4sbd4BAAAA&ccb=7-5&ig_cache_key=MzY0MDUzNjk5ODk5NTc1NzczNw%3D%3D.3-ccb7-5&oh=00_AfM8vmQYYJR2oSaS4Qd_Qa1a3JFWWK7A97Vp6kNNbGgG5w&oe=685AFBF9&_nc_sid=7a9f4b",
  "memberSince": "March 2022",
  "loyaltyPoints": 1250,
  "totalOrders": 47,
  "favoriteRestaurants": 12,
  "savedAddresses": 3,
  "paymentMethods": 2,
  "notificationsEnabled": true,
  "biometricEnabled": false,
  "darkModeEnabled": false,
  "language": "English",
  "region": "United States"
};

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to sign out of your account?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/splash-screen',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Change Profile Photo',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption('camera', 'Camera'),
                  _buildImageOption('photo_library', 'Gallery'),
                  _buildImageOption('delete', 'Remove'),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageOption(String iconName, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        // Handle image selection logic here
      },
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              ProfileHeaderWidget(
                userData: userData,
                onImageTap: _showImagePickerOptions,
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Section
                    _buildSectionCard(
                      title: 'Account',
                      children: [
                        _menuItem('person', 'Edit Profile',
                            'Update your personal information',
                            onTap: () {}),
                        _menuItem('location_on', 'Delivery Addresses',
                            '${userData["savedAddresses"]} saved addresses',
                            onTap: () {}),
                        _menuItem('payment', 'Payment Methods',
                            '${userData["paymentMethods"]} cards added',
                            onTap: () {}),
                      ],
                    ),

                    SizedBox(height: 2.5.h),

                    // Preferences Section
                    _buildSectionCard(
                      title: 'Preferences',
                      children: [
                        _menuItem(
                          'notifications',
                          'Notifications',
                          userData["notificationsEnabled"]
                              ? 'Enabled'
                              : 'Disabled',
                          showSwitch: true,
                          switchValue: userData["notificationsEnabled"],
                          onSwitchChanged: (value) {
                            setState(
                                () => userData["notificationsEnabled"] = value);
                          },
                        ),
                        _menuItem('restaurant_menu', 'Dietary Restrictions',
                            'Manage your dietary preferences',
                            onTap: () {}),
                        _menuItem('language', 'Language & Region',
                            '${userData["language"]}, ${userData["region"]}',
                            onTap: () {}),
                        _menuItem(
                          'fingerprint',
                          'Biometric Authentication',
                          'Use fingerprint or face ID',
                          showSwitch: true,
                          switchValue: userData["biometricEnabled"],
                          onSwitchChanged: (value) {
                            setState(
                                () => userData["biometricEnabled"] = value);
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 2.5.h),

                    // Orders Section
                    _buildSectionCard(
                      title: 'Orders',
                      children: [
                        _menuItem('history', 'Order History',
                            '${userData["totalOrders"]} orders placed',
                            badgeCount: userData["totalOrders"], onTap: () {
                          Navigator.pushNamed(context, '/order-history-screen');
                        }),
                        _menuItem('favorite', 'Favorites',
                            '${userData["favoriteRestaurants"]} restaurants',
                            badgeCount: userData["favoriteRestaurants"],
                            onTap: () {}),
                      ],
                    ),

                    SizedBox(height: 2.5.h),

                    // Support Section
                    _buildSectionCard(
                      title: 'Support',
                      children: [
                        _menuItem(
                            'help', 'Help Center', 'FAQs and support articles',
                            onTap: () {}),
                        _menuItem('support_agent', 'Contact Support',
                            'Get help from our team',
                            onTap: () {}),
                        _menuItem(
                            'star_rate', 'Rate App', 'Share your feedback',
                            onTap: () {}),
                      ],
                    ),

                    SizedBox(height: 2.5.h),

                    // Legal Section
                    _buildSectionCard(
                      title: 'Legal',
                      children: [
                        _menuItem('description', 'Terms & Privacy',
                            'Terms of service and privacy policy',
                            onTap: () {}),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Sign Out Button
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: _showSignOutDialog,
                        icon: CustomIconWidget(
                            iconName: 'logout',
                            color: Colors.redAccent,
                            size: 5.w),
                        label: Text(
                          'Sign Out',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.redAccent, width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSectionCard(
    {required String title, required List<Widget> children}) {
  return Card(
    elevation: 4,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.5.h),
          ...children,
        ],
      ),
    ),
  );
}

Widget _menuItem(
  String iconName,
  String title,
  String subtitle, {
  bool showSwitch = false,
  bool switchValue = false,
  int? badgeCount,
  Function(bool)? onSwitchChanged,
  VoidCallback? onTap,
}) {
  return Column(
    children: [
      ProfileMenuItemWidget(
        iconName: iconName,
        title: title,
        subtitle: subtitle,
        showSwitch: showSwitch,
        switchValue: switchValue,
        badgeCount: badgeCount,
        onSwitchChanged: onSwitchChanged,
        onTap: onTap,
      ),
      Divider(height: 2.5.h, thickness: 0.5),
    ],
  );
}
