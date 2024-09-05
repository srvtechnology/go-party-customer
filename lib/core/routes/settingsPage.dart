import 'package:customerapp/core/routes/mainpage.dart';
import 'package:customerapp/core/routes/signin.dart';

import '../constant/themData.dart';
import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/components/divider.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/routes/addressPage.dart';
import 'package:customerapp/core/routes/agent_wallet.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = "/settings";
  final Function(int)? onTabChange;
  const SettingsPage({super.key, this.onTabChange});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, state, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar:
            CommonHeader.headerMain(context, isShowLogo: false, onSearch: () {
          Navigator.pushNamed(context, ProductPageRoute.routeName);
        }),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              if (state.user?.name != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Theme.of(context).primaryColorLight,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      "Hello, ${state.user?.name ?? " "}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              if (state.user?.name != null)
                const Divider(
                  thickness: 1,
                ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return tiles(context, state)[index];
                  },
                  itemCount: tiles(context, state).length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const DashedDivider();
                  },
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  List<Widget> tiles(context, AuthProvider state) {
    return [
      // _roundedButton(
      //   title: 'Your Orders',
      //   onTap: () {
      //     widget.onTabChange!(0);
      //     Navigator.pop(context);
      //   },
      // ),
      _roundedButton(
        title: 'Your Addresses',
        onTap: () {
          Navigator.pushNamed(context, AddressPage.routeName);
        },
      ),
      if (state.isAgent) ...[
        _roundedButton(
          title: 'Agent Wallet',
          onTap: () {
            Navigator.pushNamed(context, AgentWallet.routeName);
          },
        ),
      ],
      _roundedButton(
        title: 'Manage Your Profile',
        onTap: () {
          Navigator.pushNamed(context, EditProfilePage.routeName);
        },
      ),
      _roundedButton(
        title: 'Terms and Conditions',
        onTap: () {
          // Navigator.pushNamed(context, FeedbackPage.routeName);
          Navigator.pushNamed(context, TermsAndCondition.routeName);
        },
      ),
      _roundedButton(
        title: 'Privacy Policy',
        onTap: () {
          Navigator.pushNamed(context, PrivacyPolicy.routeName);
        },
      ),
      _roundedButton(
        title: 'Sign Out',
        onTap: () {
          state.logout();
          Navigator.pop(context);
        },
      ),
      _roundedButton(
        title: 'De-activate Your Account',
        onTap: () {
          // state.deActivateAccount();
          //open dialog having two options
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  titlePadding: const EdgeInsets.all(0),
                  // icon: const Icon(Icons.warning),
                  actionsPadding:
                      EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 4.w),
                  title: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4)),
                      color: primaryColor,
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                    child: const Text(
                        "Are you sure you want to de-activate your account?",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  content: const Text(
                      "Once de-activate your account , you won't be able to login again"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No")),
                    TextButton(
                        onPressed: () async {
                          await state.deActivateAccount();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              SignInPageRoute.routeName,
                            );
                          }
                          /* Navigator.pop(context); */
                        },
                        child: const Text("Yes")),
                  ],
                );
              });
        },
      ),
    ];
  }

  Widget _roundedButton({required String title, required Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 4.h,
        decoration: const BoxDecoration(),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColorDark,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
