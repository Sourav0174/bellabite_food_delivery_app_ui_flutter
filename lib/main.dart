import 'package:BellaBite/core/app_theme.dart';
import 'package:BellaBite/features/cart_screen/cart_screen.dart';
import 'package:BellaBite/features/home_screen/home_screen.dart';
import 'package:BellaBite/features/order_history_screen/order_history_screen.dart';
import 'package:BellaBite/features/profile_screen/profile_screen.dart';
import 'package:BellaBite/features/restaurant_detail_screen/restaurant_detail_screen.dart';
import 'package:BellaBite/features/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'core/widgets/custom_error_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'foodieexpress',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
      );
    });
  }
}

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String homeScreen = '/home-screen';
  static const String restaurantDetailScreen = '/restaurant-detail-screen';
  static const String cartScreen = '/cart-screen';
  static const String orderHistoryScreen = '/order-history-screen';
  static const String profileScreen = '/profile-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    homeScreen: (context) => const HomeScreen(),
    restaurantDetailScreen: (context) => const RestaurantDetailScreen(),
    cartScreen: (context) => CartScreen(),
    orderHistoryScreen: (context) => const OrderHistoryScreen(),
    profileScreen: (context) => const ProfileScreen(),
  };
}
