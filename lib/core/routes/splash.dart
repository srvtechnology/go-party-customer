import 'package:flutter/material.dart';

import 'mainpage.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "splash";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.pushReplacementNamed(context, MainPageRoute.routeName);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: Theme.of(context).primaryColorDark,
        padding: const EdgeInsets.all(60),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: Image.asset("assets/images/logo/logo-white.png"),
      ),
    );
  }
}