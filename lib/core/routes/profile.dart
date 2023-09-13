import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/repo/customer.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'addressPage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (context,state,child) {
          if(state.authState != AuthState.LoggedIn){
            return Scaffold(
              appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                centerTitle: false,
                title: Image.asset("assets/images/logo/logo-resized.png",width: 120,),
                actions: [
                  Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(5),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, ProductPageRoute.routeName);
                      },
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffe5e5e5),
                            labelText: "Search ...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                      ),
                    ),
                  )
                ],
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: const Center(
                      child: CircleAvatar(
                        radius: 50.0,
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                  const Text("Please Sign in to view"),
                  SizedBox(height: 5.h,),
                  ElevatedButton(onPressed: (){
                    Navigator.pushNamed(context, SignInPageRoute.routeName);
                  }, child: const Text("Sign in / Sign up"))
                ],
              ),
            );
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: Image.asset("assets/images/logo/logo-resized.png",width: 120,),
              actions: [
                Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, ProductPageRoute.routeName);
                    },
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffe5e5e5),
                          labelText: "Search ...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius:15,
                        backgroundColor:Theme.of(context).primaryColorLight,
                        child: Icon(Icons.person,color: Theme.of(context).primaryColorDark,size: 10,),
                      ),
                      const SizedBox(width: 10,),
                      Text("Hello, ${state.user!.name}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,color: Theme.of(context).primaryColor),),
                    ],
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: GridView(
                      gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 30,
                      childAspectRatio: 3.5

                    ),
                    children: [
                      _roundedButton(
                        title: 'Edit Profile',
                        onTap: () {
                          Navigator.pushNamed(context, EditProfilePage.routeName);
                        },
                      ),
                      _roundedButton(
                        title: 'Manage Addresses',
                        onTap: () {
                          Navigator.pushNamed(context, AddressPage.routeName);
                        },
                      ),
                      _roundedButton(
                        title: 'Feedback',
                        onTap: () {
                          Navigator.pushNamed(context, FeedbackPage.routeName);
                        },
                      ),
                      _roundedButton(
                        title: 'Contact',
                        onTap: () {
                        },
                      ),
                      _roundedButton(
                        title: 'Logout',
                        onTap: () {
                          state.logout();
                        },
                      ),
                    ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }
  Widget _roundedButton({required String title,required Function onTap}){
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        height: 10,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Theme.of(context).primaryColorDark,
              width: 0.5),
        ),
        child: Text(title,style: TextStyle(color: Theme.of(context).primaryColorDark),),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  static const String routeName = '/edit_profile'; // Add route name

  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _emailController.text = context.read<AuthProvider>().user?.email??"" ;
    _nameController.text = context.read<AuthProvider>().user?.name??"" ;
    _phoneController.text = context.read<AuthProvider>().user?.mobile??"" ;
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context,state,child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!isValidEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded rectangle border
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded rectangle border
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded rectangle border
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed with saving the data
                        _saveProfile();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  void _saveProfile() async{
    final String email = _emailController.text;
    final String name = _nameController.text;
    final String phoneNumber = _phoneController.text;
    final auth = context.read<AuthProvider>();
    try{
      await editProfile(auth, {
        "user_id":auth.user?.id,
        "mobile":phoneNumber,
        "name":name,

      });
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The verification mail has been sent to you registered email , please verify the mail to reflect the changes you have made.'),
        ),
      );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

  }

  bool isValidEmail(String email) {
    const emailRegex =
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    final regExp = RegExp(emailRegex);
    return regExp.hasMatch(email);
  }
}

class FeedbackPage extends StatefulWidget {
  static const String routeName = '/feedback'; // Add route name

  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20,),
              TextFormField(
                controller: _feedbackController,
                maxLines: 5,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, process the feedback
                    _sendFeedback();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendFeedback() {
    final String feedback = _feedbackController.text;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your feedback!'),
      ),
    );
  }
}
