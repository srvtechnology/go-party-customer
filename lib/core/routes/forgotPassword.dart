// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:customerapp/config.dart';
import '../constant/themData.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:customerapp/core/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgotPassword extends StatefulWidget {
  static const String routeName = '/forgotPass'; //
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: "demo@customer.com");
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  int state = 1;
  bool isloading = false;

  Future sendEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isloading = true);
      try {
        Response response = await customDioClient.client
            .post("${APIConfig.baseUrl}/api/customer/forget-password", data: {
          "email": _emailController.text.trim(),
        });
        if (response.data['status'] == true) {
          setState(() {
            state = 2;
            isloading = false;
          });
          log(response.data['code'].toString(), name: "OTP");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.data['message']),
            ),
          );
          setState(() {
            isloading = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong!'),
          ),
        );
        setState(() {
          isloading = false;
        });
      }
    }
  }

  Future verifyEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isloading = true);
      try {
        Response response = await customDioClient.client.post(
            "${APIConfig.baseUrl}/api/customer/verify-code-password",
            data: {
              "email": _emailController.text.trim(),
              "code": _otpController.text.trim(),
            });
        if (response.data['status'] == true) {
          setState(() {
            state = 3;
            isloading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.data['message']),
            ),
          );
          setState(() {
            isloading = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong!'),
          ),
        );
        setState(() {
          isloading = false;
        });
      }
    }
  }

  Future resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isloading = true);
      try {
        log("${APIConfig.baseUrl}/api/customer/reset-pasword");
        Response response = await customDioClient.client
            .post("${APIConfig.baseUrl}/api/customer/reset-pasword", data: {
          "email": _emailController.text.trim(),
          "password": _confirmPasswordController.text.trim(),
        });
        // log(response.data.toString(), name: "Reset Password");
        if (response.data['status'] == true) {
          setState(() {
            isloading = false;
          });
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
              context, SignInPageRoute.routeName, (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.data['message']),
            ),
          );
          setState(() {
            isloading = false;
          });
        }
      } catch (e) {
        log(e.toString(), name: "Reset Password");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong!'),
          ),
        );
        setState(() {
          isloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8.h),
              SizedBox(
                child: Image.asset(
                  'assets/images/logo/logo-resized.png',
                ),
              ),
              SizedBox(height: 10.h),
              isloading
                  ? const Center(child: CircularProgressIndicator())
                  : buildEmailForm(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailForm(int state) {
    switch (state) {
      case 1:
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forgot Password',
                // textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 5),
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
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    sendEmail();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Send'),
                ),
              ),
            ],
          ),
        );
      case 2:
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify Email',
                // textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  // only numbers can be entered
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
                  labelText: 'Enter OTP',
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your otp';
                  }
                  // length of otp should be 6
                  if (value.length != 6) {
                    return 'Please enter a valid otp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    verifyEmail();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Verify'),
                ),
              ),
            ],
          ),
        );
      case 3:
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New Password',
                // textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _newPasswordController,
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
                  labelText: 'Enter Password',
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  // length of password should be greater than 6
                  if (value.length < 6) {
                    return 'Password should be greater than 6';
                  }

                  return null;
                },
              ),
              const Text(
                'Confirm Password',
                // textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _confirmPasswordController,
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
                  labelText: 'Enter Password',
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  // new password not empty
                  if (_newPasswordController.text.isEmpty) {
                    return 'Please enter your password';
                  }
                  // if new password and confirm password are not same or not equal
                  if (_newPasswordController.text !=
                      _confirmPasswordController.text) {
                    return 'Password does not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    resetPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }
}
