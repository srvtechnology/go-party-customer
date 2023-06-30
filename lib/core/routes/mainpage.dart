import 'package:customerapp/core/components/loading.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/routes/homepage.dart';
import 'package:customerapp/core/routes/intro.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPageRoute extends StatefulWidget {
  static const routeName = "/main";
  const MainPageRoute({Key? key}) : super(key: key);

  @override
  State<MainPageRoute> createState() => _MainPageRouteState();
}

class _MainPageRouteState extends State<MainPageRoute> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context,state,child) {
        CustomLogger.debug(state.authState);
        if(state.isLoading || state.authState == AuthState.Waiting)
          {
            return LoadingWidget(willRedirect: true,);
          }
        if(state.authState == AuthState.LoggedOut)
          {
            return const IntroductionPageRoute();
          }
        else if (state.authState == AuthState.LoggedIn){
          return const HomePageScreen();

        }
        return const SignInPageRoute();
      }
    );
  }
}
