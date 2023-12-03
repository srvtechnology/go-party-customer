import 'package:customerapp/core/providers/networkProvider.dart';
import 'package:customerapp/core/routes/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/errors.dart';

class MainPageRoute extends StatefulWidget {
  static const routeName = "/main";
  final int? index;
  const MainPageRoute({Key? key, this.index}) : super(key: key);

  @override
  State<MainPageRoute> createState() => _MainPageRouteState();
}

class _MainPageRouteState extends State<MainPageRoute> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(builder: (context, state, child) {
      if (!state.isOnline) {
        return CustomErrorWidget(
          backgroundColor: Colors.grey[300]!,
          message: "Looks like you are not connected to the internet",
          icon: Icons.wifi,
        );
      }
      return HomePageScreen(
        index: widget.index,
      );
    });
  }
}
