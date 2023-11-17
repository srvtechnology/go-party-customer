import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/routes/cart.dart';
import 'package:customerapp/core/routes/homepage.dart';
import 'package:customerapp/core/routes/profile.dart';

class BottomNav extends StatefulWidget {
  final Widget? child;
  final Function(int)? onTabChange;
  const BottomNav({
    Key? key,
    this.child,
    this.onTabChange,
  }) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 1;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : currentView(currentIndex),
      bottomNavigationBar: ConvexAppBar(
        height: 50,
        onTap: (index) {
          if (widget.child != null) {
            Navigator.of(context).pop();
            widget.onTabChange!(index);
          }

          setState(() {
            currentIndex = index;
          });
        },
        initialActiveIndex: currentIndex,
        backgroundColor: Colors.white,
        color: Theme.of(context).primaryColorDark,
        activeColor: Theme.of(context).primaryColorDark,
        items: [
          _navItem("assets/icons/my-orders-icon.png", "Orders"),
          _navItem("assets/icons/home.png", "Home"),
          _navItem("assets/icons/add-to-cart.png", "Cart"),
          _navItem("assets/icons/user.png", "Account"),
        ],
      ),
    );
  }

  TabItem _navItem(String path, title) {
    return TabItem(
        title: title,
        icon: Image.asset(
          path,
          width: 20,
          height: 20,
          color: primaryColor,
        ),
        activeIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            path,
            width: 16,
            height: 16,
            color: Colors.white,
          ),
        ));
  }

  Widget currentView(int index) {
    if (widget.child != null && index == 1) return widget.child!;
    switch (index) {
      case 0:
        return const Orders();
      case 1:
        return const Home();
      case 2:
        return const CartPage();
      case 3:
        return Profile(
          onTabChange: (int v) {
            setState(() => isLoading = true);
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                currentIndex = v;
                isLoading = false;
              });
            });
          },
        );
      default:
        return const Home();
    }
  }
}
