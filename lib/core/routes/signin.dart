// ignore_for_file: use_build_context_synchronously

import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:customerapp/core/routes/signup.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
                  Container(
                    height: 20.h,
                    color: Theme.of(context).primaryColor,
                    child: Image.asset(
                      'assets/images/logo/logo-white.png',
                      height: 150.0,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "LOG IN",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account ?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPageRoute(
                                        comeback: widget.comeBack,
                                      ))).then((value) {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          });
                        },
                        child: Text(
                          'Create Here',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
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
                  const SizedBox(height: 32.0),
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
                            'Log in',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
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
