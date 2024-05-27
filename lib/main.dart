import 'package:flutter/material.dart';
import 'package:sans_mobile/routes.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artsy',
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.black),
        fontFamily: 'assets/fonts/roboto.ttf',
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16.0,
            height: 1.5,
          ),
        ),
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}
