import 'package:flutter/material.dart';
import 'package:proyecto_moviles/login/login_google.dart';
import 'package:proyecto_moviles/theme/AppTheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "UPeU",
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: MainLogin(),
    );
  }
}
