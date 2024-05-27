import 'package:sans_mobile/ui/screens/DashboardPage.dart';
import 'package:sans_mobile/ui/screens/LidarPage.dart';
import 'package:sans_mobile/ui/screens/LinePage.dart';
import 'package:sans_mobile/ui/screens/LoginPage.dart';
import 'package:sans_mobile/ui/screens/SplashScreenPage.dart';

final routes = {
    '/': (context) => SplashScreenPage(),
    '/login': (context) => LoginPage(),
    '/dashboard': (context) => DashboardPage(),
    '/lidar': (context) => LidarPage(),
    '/line': (context) => LinePage(),
};

