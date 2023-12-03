import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/categoryProvider.dart';
import 'package:customerapp/core/providers/networkProvider.dart';
import 'package:customerapp/core/routes/addressPage.dart';
import 'package:customerapp/core/routes/cart.dart';
import 'package:customerapp/core/routes/homepage.dart';
import 'package:customerapp/core/routes/intro.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/profile.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:customerapp/core/routes/signup.dart';
import 'package:customerapp/core/routes/splash.dart';
import 'package:customerapp/core/routes/view_all_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, aspectRatio) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeData(context),
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => const SplashScreen(),
            IntroductionPageRoute.routeName: (context) =>
                const IntroductionPageRoute(),
            SignInPageRoute.routeName: (context) => const SignInPageRoute(),
            SignUpPageRoute.routeName: (context) => const SignUpPageRoute(),
            HomePageScreen.routeName: (context) => const HomePageScreen(),
            ProductPageRoute.routeName: (context) => const ProductPageRoute(),
            ViewAllServiceRoute.routeName: (context) =>
                const ViewAllServiceRoute(),
            MainPageRoute.routeName: (context) => const MainPageRoute(),
            EditProfilePage.routeName: (context) => const EditProfilePage(),
            FeedbackPage.routeName: (context) => const FeedbackPage(),
            CartPage.routeName: (context) => const CartPage(),
            AddressPage.routeName: (context) => const AddressPage(),
            AddressAddPage.routeName: (context) => const AddressAddPage(),
            PrivacyPolicy.routeName: (context) => const PrivacyPolicy(),
            TermsAndCondition.routeName: (context) => const TermsAndCondition(),
          },
        ),
      );
    });
  }
}
