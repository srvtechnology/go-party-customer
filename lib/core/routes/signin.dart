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

  const SignInPageRoute({super.key,this.comeBack=false});

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

  void _submitForm(AuthProvider state) async{
    setState(() {
      _isLoading = true ;
    });
    final form = _formKey.currentState;
    if (form!.validate()) {
      try {
        await state.login(_emailController.text, _passwordController.text);
        if(context.mounted){
          if(widget.comeBack) {
            Navigator.pop(context);
          }else{
            Navigator.pushReplacementNamed(context, MainPageRoute.routeName);
          }
        }
      }
      catch(e){
       CustomLogger.error(e);
      }
      }
    setState(() {
      _isLoading = false ;
    });
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
                    const SizedBox(height: 32.0),
                    if(state.authState==AuthState.Error)
                      const Text("Incorrect username or password",style: TextStyle(color: Colors.red),),
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
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: _isLoading ? null : (){
                        _submitForm(state);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
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
                        'Sign In',
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
                        // Handle forgot password logic
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, SignUpPageRoute.routeName);
                          },
                          child: const Text(
                            'Create an account',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
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
