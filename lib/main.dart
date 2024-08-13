import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/categoryProvider.dart';
import 'package:customerapp/core/providers/networkProvider.dart';
import 'package:customerapp/core/providers/orderProvider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../views/view.dart';
import './core/constant/themData.dart';

GetIt getIt = GetIt.asNewInstance();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  serviceLocator();
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
          ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
            create: (context) => OrderProvider(context.read<AuthProvider>()),
            update: (context, authProvider, orderProvider) =>
                OrderProvider(authProvider),
          ),
          /*ChangeNotifierProvider(create: (_) => OrderProvider(context.read<AuthProvider>())),*/
          ChangeNotifierProvider(
              create: (_) => NetworkProvider()), // CartProvider
          // ChangeNotifierProvider(create: (_) => CartProvider()),
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
            RefundPolicy.routeName: (context) => const RefundPolicy(),
            TermsAndCondition.routeName: (context) => const TermsAndCondition(),
            ForgotPassword.routeName: (context) => const ForgotPassword(),
            SettingsPage.routeName: (context) => const SettingsPage(),
            AgentSignUp.routeName: (context) => const AgentSignUp(),
            AgentSignIn.routeName: (context) => const AgentSignIn(),
            AgentWallet.routeName: (context) => const AgentWallet(),
          },
        ),
      );
    });
  }
}

void serviceLocator() {
  /*getIt.registerLazySingleton<LoginRepository>(() => LoginHttpRepository());
  getIt.registerLazySingleton<MoviesRepository>(() => MoviesHttpRepository());*/
}
