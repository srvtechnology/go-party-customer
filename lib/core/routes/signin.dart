// ignore_for_file: use_build_context_synchronously

import 'package:customerapp/core/components/TramsAndConditionsCheckBox.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../views/view.dart';

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
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User is not active'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        if (state.status == 'B') {
          setState(() {
            _isLoading = false;
          });
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
                      width: 60.w,
                      height: 12.h,
                    ),
                  ),
                  // Container(
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     "Welcome ",
                  //     style: TextStyle(
                  //         color: Theme.of(context).primaryColor,
                  //         fontSize: 26,
                  //         fontWeight: FontWeight.w600),
                  //   ),
                  // ),
                  const SizedBox(height: 16.0),
                  /*Row(
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
                  ),*/
                  /*Row(
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
                  ),*/
                  /* InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpPageRoute.routeName);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          // Icon or leading element (can be a radio button icon)
                          Icon(Icons.radio_button_unchecked,
                              color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Create an account. New to Utsavlife?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        // Icon or leading element (can be a radio button icon)
                        Icon(Icons.radio_button_checked, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Sign in. Already a customer?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state.authState == AuthState.error)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Incorrect username or password",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor, // Background color for the button
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Are you an agent? ',
                          style: const TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context, AgentSignIn.routeName);
                                },
                              text: 'Sign in',
                              style: const TextStyle(
                                color: Colors.yellow, // Link color
                                fontSize: 16,
                              ),
                            ),
                            const TextSpan(
                              text: ' or ',
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context, AgentSignUp.routeName);
                                },
                              text: 'Sign up',
                              style: const TextStyle(
                                color: Colors.yellow, // Link color
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), */

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Rounded corners
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align items to the start
                        children: [
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.pushNamed(
                          //         context, SignUpPageRoute.routeName);
                          //   },
                          //   child: Row(
                          //     children: const [
                          //       Icon(Icons.radio_button_unchecked,
                          //           color: Colors.black),
                          //       SizedBox(width: 10),
                          //       Text(
                          //         "Create an account. New to Utsavlife?",
                          //         style: TextStyle(color: Colors.black),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(height: 10.0),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.pushNamed(
                          //         context, SignInPageRoute.routeName);
                          //   },
                          //   child: Row(
                          //     children: const [
                          //       Icon(Icons.radio_button_checked,
                          //           color: Colors.black),
                          //       SizedBox(width: 10),
                          //       Text(
                          //         "Sign in. Already a customer?",
                          //         style: TextStyle(color: Colors.black),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(height: 20.0),
                          if (state.authState == AuthState.error)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Incorrect username or password",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.email, color: Colors.grey),
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
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.grey),
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.grey),
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
                          const SizedBox(height: 16.0),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, ForgotPassword.routeName);
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              onTap:
                                  _isLoading ? null : () => _submitForm(state),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  // color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.8),
                                      Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.4),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // or
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              )
                              //
                            ],
                          ),
                          // const SizedBox(height: 16.0),
                          // Textbutton new to utsav life
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "New to Utsav Life?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // create your
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, SignUpPageRoute.routeName);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                              ),
                              child: const Text(
                                'Create Your Account',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Are you an agent? ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, AgentSignIn.routeName);
                                      },
                                    text: 'Sign in',
                                    style: const TextStyle(
                                      color: Colors.blue,
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
                                      },
                                    text: 'Sign up',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  /* Row(
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
                  ),*/
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
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, PrivacyPolicy.routeName);
                          },
                          child: const Text(
                            "Privacy & policy",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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
