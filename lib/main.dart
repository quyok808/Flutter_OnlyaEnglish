import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/register.dart';

import 'screens/google_sign_in_screen.dart';
import 'screens/product_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý sản phẩm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoogleSignInScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
