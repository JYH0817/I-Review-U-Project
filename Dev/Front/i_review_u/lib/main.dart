// @dart=2.9
import 'package:flutter/material.dart';
import 'page/app.dart';
import 'package:get/get.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I Review U',
      home: AnimatedSplashScreen(
        splashIconSize: double.maxFinite,
        splash: Image.asset('assets/images/main.jpg'),
        nextScreen: GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData( // 최상위 테마 (전체 적용)
            primaryColor: Colors.white,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: App(),
        ),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Color(0xFFC0CB), // 메인 이미지 색상
        duration: 3000,
        
      ),
    );  
    // return GetMaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData( // 최상위 테마 (전체 적용)
    //     primaryColor: Colors.white,
    //     primarySwatch: Colors.blue,
    //     visualDensity: VisualDensity.adaptivePlatformDensity,
    //   ),
    //   home: App(),
    // );
  }
}
