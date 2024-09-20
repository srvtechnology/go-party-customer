import 'package:customerapp/core/components/TramsAndConditionsCheckBox.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../views/view.dart';

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
      TextEditingController(/* text: "newagent@demo.com" */);
  final TextEditingController _passwordController =
      TextEditingController(/* text: "123456" */);
  @override
  Widget build(BuildContext context) {
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
                  /*Center(
                    child: Text(
                      "Sign In as Agent",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor, // Text color
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),*/
                  /* InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AgentSignUp.routeName);
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
                            "Sign Up as Agent",
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
                          "Already an Agent ? Sign in.",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
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
                                if (state.authState == AuthState.loggedIn) {
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  const SizedBox(
                    height: 10,
                  ),
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
                          text: 'Are you a Customer ? ',
                          style: const TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context, SignInPageRoute.routeName);
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
                                      context, SignUpPageRoute.routeName);
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Sign Up as Agent
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AgentSignUp.routeName);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(Icons.radio_button_unchecked,
                                    color: Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  "Sign Up as Agent",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),

                          // Already an Agent? Sign In
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AgentSignIn.routeName);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(Icons.radio_button_checked,
                                    color: Colors.black),
                                SizedBox(width: 10),
                                Text(
                                  "Already an Agent? Sign in.",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Email Field
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email, color: Colors.grey),
                              labelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
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

                          // Password Field
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            controller: _passwordController,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.grey),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon(
                                  obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                              labelStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
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

                          // Sign In Button
                          ElevatedButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      state
                                          .loginAgent(scaffoldKey,
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text)
                                          .whenComplete(() {
                                        if (state.authState ==
                                            AuthState.loggedIn) {
                                          Navigator.pushReplacementNamed(
                                              context, MainPageRoute.routeName);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                            ),
                            child: state.isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey),
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
                          const SizedBox(height: 10),

                          // Customer Prompt
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Are you a Customer? ',
                                style: const TextStyle(
                                  color: Colors.black, // Text color
                                  fontSize: 16,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, SignInPageRoute.routeName);
                                      },
                                    text: 'Sign in',
                                    style: const TextStyle(
                                      color: Colors.blue, // Link color
                                      fontSize: 16,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' or ',
                                    style: TextStyle(
                                      color: Colors.black, // Text color
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, SignUpPageRoute.routeName);
                                      },
                                    text: 'Sign up',
                                    style: const TextStyle(
                                      color: Colors.blue, // Link color
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
