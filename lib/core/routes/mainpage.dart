import 'package:flutter/material.dart';

class MainPageRoute extends StatefulWidget {
  static const routeName = "/home";
  const MainPageRoute({Key? key}) : super(key: key);

  @override
  State<MainPageRoute> createState() => _MainPageRouteState();
}

class _MainPageRouteState extends State<MainPageRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
