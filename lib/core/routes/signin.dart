// ignore_for_file: use_build_context_synchronously

import 'package:customerapp/core/components/TramsAndConditionsCheckBox.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/routes/forgotPassword.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:customerapp/core/routes/profile.dart';
import 'package:customerapp/core/routes/signup.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../views/view.dart';
import '../constant/themData.dart';

class SignInPageRoute extends StatefulWidget {
  static const String routeName = '/signin';
  final bool comeBack;

  const SignInPageRoute({super.key, this.comeBack = false});

  @override
  State<SignInPageRoute> createState() => _SignInPageRouteState();
}

class _SignInPageRouteState extends State<SignInPageRoute> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm(AuthProvider state) async {
    setState(() {
      _isLoading = true;
    });
    final form = _formKey.currentState;
    if (form!.validate()) {
      try {
        await state.login(_emailController.text, _passwordController.text);
        if (state.status == 'I') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User is not active'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        if (state.status == 'B') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User has blocked '),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        if (context.mounted) {
          if (widget.comeBack) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacementNamed(context, MainPageRoute.routeName);
          }
        }
      } catch (e) {
        CustomLogger.error(e);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, state, child) {
      return Scaffold(
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8.h),
                  SizedBox(
                    child: Image.asset(
                      'assets/images/logo/Utsavlife full logo.png',
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Welcome ",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // radio
                      Radio(
                        value: true,
                        onChanged: (v) {
                          Navigator.pushNamed(
                              context, SignUpPageRoute.routeName);
                        },
                        groupValue: false,
                      ),
                      const Text("Create an account. New to Utsavlife?"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // radio
                      Radio(
                        value: true,
                        onChanged: (v) {},
                        groupValue: true,
                      ),
                      const Text("Sign in. Already a customer?"),
                    ],
                  ),
                  if (state.authState == AuthState.Error)
                    const Text(
                      "Incorrect username or password",
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffe5e5e5),
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey)),
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffe5e5e5),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey)),
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password should be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ForgotPassword.routeName);
                      },
                      child: const Text(
                        "Forgot Password?",
                      )),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            _submitForm(state);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                 const  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Are you an agent ? ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context, AgentSignIn.routeName);
                                  // navigate to desired screen
                                },
                              text: 'Sign in',
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                            const TextSpan(
                              text: ' or ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context, AgentSignUp.routeName);
                                  // navigate to desired screen
                                },
                              text: 'Sign up',
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TramsAndConditionsCheckBox(
                    value: false,
                    onChanged: (value) {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, TermsAndCondition.routeName);
                          },
                          child: const Text(
                            "Terms & Condition",
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, PrivacyPolicy.routeName);
                          },
                          child: const Text(
                            "Privacy & policy",
                          )),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '© 2023 - UTSAVLIFE. All Rights Reserved.',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
