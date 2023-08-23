import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'mainpage.dart';

class SignUpPageRoute extends StatefulWidget {
  final bool comeback;
  static const String routeName = '/signup';

  const SignUpPageRoute({super.key,this.comeback=false});

  @override
  State<SignUpPageRoute> createState() => _SignUpPageRouteState();
}

class _SignUpPageRouteState extends State<SignUpPageRoute> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _signUp(AuthProvider auth)async{
    setState(() {
      _isLoading = true;
    });
    try{
      await auth.register(
          _nameController.text,
          _emailController.text,
          _phoneNumberController.text,
          _passwordController.text
      );
      if(context.mounted){
        if(widget.comeback){
          Navigator.pop(context);
        }
        else {
          Navigator.pushReplacementNamed(context, MainPageRoute.routeName);
        }
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  void _submitForm(AuthProvider auth) {
    final form = _formKey.currentState;
    if (form!.validate()) {
      _signUp(auth);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context,state,child) {
        return Scaffold(
          body: Container(
            height: double.infinity,
            color: Colors.grey[900],
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10.h),
                    Image.asset(
                      'assets/images/logo/logo-white.png',
                      height: 150.0,
                    ),
                    SizedBox(height: 32.0,child: state.authState == AuthState.Error?const Text("Something went wrong. Please try again later"):null,),
                    TextFormField(
                      style:const TextStyle(color: Colors.white),
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Colors.white),
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
                      style:const TextStyle(color: Colors.white),
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      style:const TextStyle(color: Colors.white),
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone, color: Colors.white),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Phone Number';
                        }
                        if (value.length!=10) {
                          return 'Please enter a valid Phone Number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      style:const TextStyle(color: Colors.white),
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
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
                    TextFormField(
                      style:const TextStyle(color: Colors.white),
                      controller: _confirmPasswordController,
                      obscureText: _obscureTextConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureTextConfirm = !_obscureTextConfirm;
                            });
                          },
                          child: Icon(
                            _obscureTextConfirm ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
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
                        if (value != _passwordController.text) {
                          return 'Password does not match';
                        }
                      },
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: _isLoading ? null : (){
                        _submitForm(state);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, SignInPageRoute.routeName);
                          },
                          child: const Text(
                            'Have an account? Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
