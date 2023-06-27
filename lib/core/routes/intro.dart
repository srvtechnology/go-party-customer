import 'dart:ui';

import 'package:customerapp/core/routes/signin.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IntroductionPageRoute extends StatefulWidget {
  static const routeName = "/intro";
  const IntroductionPageRoute({Key? key}) : super(key: key);

  @override
  State<IntroductionPageRoute> createState() => _IntroductionPageRouteState();
}

class _IntroductionPageRouteState extends State<IntroductionPageRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/login-background.jpg"),
                    fit: BoxFit.fitHeight
                )
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                    width: 60.w,
                    child: Image.asset("assets/images/logo/logo.png"),
                  ),
                  SizedBox(height: 25.h,),
                  Text("Plan your events \nwith ease !",textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme
                        .headlineSmall!
                        .copyWith(
                        color: Colors.white,
                      shadows: const [
                        Shadow(
                            offset: Offset(1,1),
                          color: Colors.grey,
                          blurRadius: 0.5
                        ),
                        Shadow(
                            offset: Offset(-1,-1),
                          color: Colors.grey,
                          blurRadius: 0.5
                        )
                      ]
                    ),),
                  const SizedBox(height: 50,),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            Navigator.pushReplacementNamed(context, SignInPageRoute.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ),
                          child: const Text("Sign in / Sign up"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


