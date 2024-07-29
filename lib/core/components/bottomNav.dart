import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/cartProvider.dart';
import 'package:flutter/material.dart';

import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/routes/cartPage.dart';
import 'package:customerapp/core/routes/homepage.dart';
import 'package:customerapp/core/routes/profile.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  final Widget? child;
  final int? index;
  final Function(int)? onTabChange;
  const BottomNav({
    Key? key,
    this.child,
    this.onTabChange,
    this.index,
  }) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Provider.of<AuthProvider>(context, listen: false).init();

    if (widget.index != null) {
      currentIndex = widget.index!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: currentView(currentIndex),
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
          _navItem("assets/icons/user.png", "Account"),
          _navItem("assets/icons/home.png", "Home"),
          _navItem("assets/icons/add-to-cart.png", "Cart"),
          _navItem("assets/icons/my-orders-icon.png", "Orders"),
        ],
      ),
    );
  }

  TabItem _navItem(String path, title) {
    return TabItem(
        title: title,
        icon: title == "Cart"
            ? cartIcon(path, title, color: primaryColor)
            : Image.asset(
                path,
                width: 20,
                height: 20,
                color: primaryColor,
              ),
        activeIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: title == "Cart"
              ? cartIcon(path, title, isActive: true, color: Colors.white)
              : Image.asset(
                  path,
                  width: 16,
                  height: 16,
                  color: Colors.white,
                ),
        ));
  }

  Widget cartIcon(String path, title, {bool isActive = false, Color? color}) {
    return ListenableProvider(
        create: (_) => CartProvider(auth: context.read<AuthProvider>()),
        child: Consumer2<CartProvider, AuthProvider>(
            builder: (context, cart, auth, child) {
          return SizedBox(
            width: 20,
            height: 20,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    path,
                    width: 30,
                    height: 30,
                    color: color,
                  ),
                ),
                if (auth.authState == AuthState.LoggedIn &&
                    auth.user != null &&
                    cart.data.isNotEmpty) ...[
                  if (!isActive)
                    Positioned(
                      top: 12.5,
                      left: 12.5,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            cart.data.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (isActive)
                    Positioned(
                      bottom: 8,
                      right: 15.5,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            cart.data.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          );
        }));
  }

  Widget currentView(int index) {
    if (widget.child != null && index == 1) return widget.child!;
    switch (index) {
      case 0:
        return Profile(
          onTabChange: (int v) {
            setState(() => isLoading = true);
            Future.delayed(const Duration(milliseconds: 100), () {
              setState(() {
                currentIndex = v;
                isLoading = false;
              });
            });
          },
        );

      case 1:
        return const Home();
      case 2:
        return const CartPage();
      case 3:
        return const Orders();
      default:
        return const Home();
    }
  }
}
