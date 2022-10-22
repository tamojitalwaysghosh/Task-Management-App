import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import '../screens/homescreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color(0x021124),
        body: AnimatedSplashScreen(
      //centered: false,
      splashIconSize: 11900,
      splash: Image.asset('assets/images/ajk.png'),
      duration: 1495,
      // backgroundColor: Color(0x021124),

      nextScreen: HomePage(),
      //backgroundColor: Colors.black,
      splashTransition: SplashTransition.fadeTransition,
    ));
  }
}
