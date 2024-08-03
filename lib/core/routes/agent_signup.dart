import 'package:customerapp/core/components/TramsAndConditionsCheckBox.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/routes/agent_sign_in.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:customerapp/core/routes/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constant/themData.dart';

class AgentSignUp extends StatefulWidget {
  static String routeName = "/agent_signup";
  const AgentSignUp({super.key});

  @override
  State<AgentSignUp> createState() => _AgentSignUpState();
}

class _AgentSignUpState extends State<AgentSignUp> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // step 1
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // step 2
  final TextEditingController _otpController = TextEditingController();
  // step 3
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _accountHolderNameController =
      TextEditingController();

  bool _obscureTextConfirm = true;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Consumer<AuthProvider>(builder: (context, state, child) {
        switch (state.agentRegistrationStep) {
          case 1:
            return Container(
              // color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
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
                              "Sign Up as Agent",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      /*Text(
                        "Sign Up as Agent ",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),*/
                      const SizedBox(height: 16.0),

                      // SizedBox(
                      //   height: 32.0,
                      //   child: state.authState == AuthState.Error
                      //       ? const Text(
                      //           "Something went wrong. Please try again later")
                      //       : null,
                      // ),
                      TextFormField(
                        style: const TextStyle(color: Colors.grey),
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
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
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        style: const TextStyle(color: Colors.grey),
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon:
                              const Icon(Icons.phone, color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Phone Number';
                          }
                          if (value.length != 10) {
                            return 'Please enter a valid Phone Number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        style: const TextStyle(color: Colors.grey),
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
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
                      TextFormField(
                        style: const TextStyle(color: Colors.grey),
                        controller: _confirmPasswordController,
                        obscureText: _obscureTextConfirm,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureTextConfirm = !_obscureTextConfirm;
                              });
                            },
                            child: Icon(
                              _obscureTextConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                          ),
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password should be at least 6 characters long';
                          }
                          if (value != _passwordController.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32.0),
                      ElevatedButton(
                        onPressed: () {
                          final isValid = _formKey.currentState!.validate();
                          if (isValid) {
                            state.registerAgent(
                              context,
                              email: _emailController.text,
                              name: _nameController.text,
                              password: _confirmPasswordController.text,
                              phone: _phoneNumberController.text,
                              otpcontroller: _otpController,
                            );
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
                                'Sign Up',
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
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AgentSignIn.routeName);
                        },
                        child: Container(
                          height: 5.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primaryColor/*tertiaryColor*/,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Already an Agent ? SignIn',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              )),
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
              ),
            );
          case 2:
            return Container(
                // color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
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
                                  "Verify Agent Account",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                style: const TextStyle(color: Colors.grey),
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Enter OTP',
                                  prefixIcon: const Icon(Icons.lock,
                                      color: Colors.grey),
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          width: 0.5, color: Colors.grey)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          width: 0.5, color: Colors.grey)),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your OTP';
                                  }
                                  // min 6 characters
                                  if (value.length < 6) {
                                    return 'OTP should be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32.0),
                              ElevatedButton(
                                onPressed: () {
                                  final isValid =
                                      _formKey.currentState!.validate();
                                  if (isValid) {
                                    state.registerAgentOtp(
                                      scaffoldKey,
                                      email: _emailController.text.trim(),
                                      otp: _otpController.text.trim(),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                ),
                                child: state.isLoading
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.grey),
                                      )
                                    : const Text(
                                        'Validate OTP',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 16.0),
                              TextButton(
                                onPressed: () {
                                  state.resendOtp(scaffoldKey,
                                      email: _emailController.text.trim());
                                },
                                child: const Text("Resend OTP"),
                              ),
                            ]))));
          case 3:
            return Container(
              // color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
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
                          "Setup Agent Bank Details",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        style: const TextStyle(color: Colors.grey),
                        controller: _bankNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Bank Name',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your OTP';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        style: const TextStyle(color: Colors.grey),
                        controller: _accountNumberController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Account Number',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Bank Name';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // ifsc code
                      TextFormField(
                        style: const TextStyle(color: Colors.grey),
                        controller: _ifscCodeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'IFSC Code',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter IFSC Code';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // account holder name
                      TextFormField(
                        style: const TextStyle(color: Colors.grey),
                        controller: _accountHolderNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Account Holder Name',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.grey),
                          labelStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 0.5, color: Colors.grey)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Account Holder Name';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 32.0),
                      ElevatedButton(
                        onPressed: () {
                          final isValid = _formKey.currentState!.validate();
                          if (isValid) {
                            state
                                .registerAgentBankDetails(
                              context,
                              password: _passwordController.text,
                              email: _emailController.text,
                              bankName: _bankNameController.text,
                              accountNumber: _accountNumberController.text,
                              accountHolderName:
                                  _accountHolderNameController.text,
                              ifscCode: _ifscCodeController.text,
                            )
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
                                'Submit',
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
            );
          default:
            return SizedBox(
              height: 32.0,
              child: state.authState == AuthState.Error
                  ? const Text("Something went wrong. Please try again later")
                  : null,
            );
        }
      }),
    );
  }
}
