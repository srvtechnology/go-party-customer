import 'package:customerapp/core/components/TramsAndConditionsCheckBox.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:customerapp/core/routes/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgentSignIn extends StatefulWidget {
  static String routeName = "/agent_signIn";
  const AgentSignIn({super.key});

  @override
  State<AgentSignIn> createState() => _AgentSignInState();
}

class _AgentSignInState extends State<AgentSignIn> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: "newagent@demo.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "123456");
  final bool _obscureTextConfirm = true;
  final bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    bool obscureTextConfirm = true;
    bool obscureText = true;
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        // color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AuthProvider>(builder: (context, state, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  SizedBox(
                    child: Image.asset(
                      'assets/images/logo/Utsavlife full logo.png',
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Container(
                    // alignment: Alignment.center,
                    child: Text(
                      "Sign In as Agent ",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    style: const TextStyle(color: Colors.grey),
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email, color: Colors.grey),
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey)),
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
                    style: const TextStyle(color: Colors.grey),
                    controller: _passwordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey)),
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
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              state
                                  .loginAgent(scaffoldKey,
                                      email: _emailController.text,
                                      password: _passwordController.text)
                                  .whenComplete(() {
                                if (state.authState == AuthState.LoggedIn) {
                                  Navigator.pushReplacementNamed(
                                      context, MainPageRoute.routeName);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Something went wrong. Please try again later"),
                                    ),
                                  );
                                }
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: state.isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.grey),
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
                  const SizedBox(height: 16.0),
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
          );
        }),
      ),
    );
  }
}
