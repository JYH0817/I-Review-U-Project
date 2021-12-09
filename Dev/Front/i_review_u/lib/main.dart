import 'package:flutter/material.dart';
import 'page/app.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {  
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData( // 최상위 테마 (전체 적용)
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: App(),
    );
  }
}
