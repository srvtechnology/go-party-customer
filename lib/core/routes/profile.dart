import 'dart:io';

import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/routes/addressPage.dart';
import 'package:customerapp/core/routes/agent_sign_in.dart';
import 'package:customerapp/core/routes/agent_signup.dart';
import 'package:customerapp/core/routes/cartPage.dart';
import 'package:customerapp/core/routes/settingsPage.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:customerapp/core/routes/signup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/repo/customer.dart';
import 'package:customerapp/core/routes/product.dart';

class Profile extends StatefulWidget {
  final Function(int) onTabChange;

  const Profile({
    Key? key,
    required this.onTabChange,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, state, child) {
      if (state.authState != AuthState.LoggedIn || state.user == null) {
        return Scaffold(
          // appBar:
          //     CommonHeader.headerMain(context, isShowLogo: false, onSearch: () {
          //   Navigator.pushNamed(context, ProductPageRoute.routeName);
          // }),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Image.asset(
                  'assets/images/logo/Utsavlife full logo.png',
                  // height: 20,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View services in your Utsavlife cart,',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Find & rebook your required services,',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Track your booked Services',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SignInPageRoute.routeName);
                  },
                  child: Container(
                    height: 6.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Already a customer ? Sign in',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        )),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpPageRoute.routeName);
                    },
                    child: const Text(
                      "New to Utsavlife? Create an account",
                      style: TextStyle(color: Colors.black),
                    )),
                // TextButton(
                //     onPressed: () {
                //       Navigator.pushNamed(context, SignUpPageRoute.routeName);
                //     },
                //     child: const Text(
                //       "New to Utsavlife? Create an account",
                //       style: TextStyle(color: Colors.black),
                //     )),
                // rich Text for sign and sign up  as a business Agent
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
                            Navigator.pushNamed(context, AgentSignIn.routeName);
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
                            Navigator.pushNamed(context, AgentSignUp.routeName);
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
                SizedBox(
                  height: 10.h,
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 4.w),
                //   height: 50,
                //   width: double.infinity,
                //   child: ElevatedButton(
                //       style: ButtonStyle(
                //           backgroundColor: MaterialStateProperty.all<Color>(
                //               Theme.of(context).primaryColor.withOpacity(0.5))),
                //       onPressed: () {
                //         Navigator.pushNamed(context, SignInPageRoute.routeName);
                //       },
                //       child: const Text("Already a customer ? Sign in")),
                // )
              ],
            ),
          ),
        );
      }
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHeader.headerMain(context, elevation: 0, onSearch: () {
          Navigator.pushNamed(context, ProductPageRoute.routeName);
        }),
        body: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              color: primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    "Hello, ${state.user!.name}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: primaryColor),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      widget.onTabChange(3);
                                    },
                                    child: const Text(
                                      'Your Orders',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: primaryColor),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, AddressPage.routeName);
                                    },
                                    child: const Text(
                                      'Manage Address',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: primaryColor),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, SettingsPage.routeName);
                                    },
                                    child: const Text(
                                      'Settings',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: primaryColor),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, FeedbackPage.routeName);
                                    },
                                    child: const Text(
                                      'Feedback',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    const ExtraDetails(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
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

  Uint8List? imageFile;
  image_picker.ImagePicker imagePicker = image_picker.ImagePicker();
  String? profileImageUrl;

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
    _emailController.text = context.read<AuthProvider>().user?.email ?? "";
    _nameController.text = context.read<AuthProvider>().user?.name ?? "";
    _phoneController.text = context.read<AuthProvider>().user?.mobile ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, state, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),
                  Center(child: imageProfile()),
                  const SizedBox(height: 16.0),
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
                        borderRadius: BorderRadius.circular(
                            10.0), // Rounded rectangle border
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
                        borderRadius: BorderRadius.circular(
                            10.0), // Rounded rectangle border
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
                        borderRadius: BorderRadius.circular(
                            10.0), // Rounded rectangle border
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
        ),
      );
    });
  }

  Widget imageProfile() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80.0,
          backgroundImage: (imageFile != null
                  ? MemoryImage(imageFile!)
                  : profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : const AssetImage("assets/icons/avatar_default.png"))
              as ImageProvider<Object>,
        ),
        Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) => bottomSheet(),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Theme.of(context).primaryColor,
                size: 40.0,
              ),
            ))
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 120.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          const Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  takePhoto(image_picker.ImageSource.camera);
                },
                child: Column(
                  children: const [Icon(Icons.camera), Text("Camera")],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  takePhoto(image_picker.ImageSource.gallery);
                },
                child: Column(
                  children: const [Icon(Icons.image), Text("Gallery")],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> takePhoto(image_picker.ImageSource source) async {
    final image_picker.XFile? pickedFile =
        await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      final Uint8List imgBytes = await pickedFile.readAsBytes();
      setState(() {
        imageFile = imgBytes;
      });
    } else {
      if (kDebugMode) {
        print('No image selected');
      }
    }
  }

  void _saveProfile() async {
    final String email = _emailController.text;
    final String name = _nameController.text;
    final String phoneNumber = _phoneController.text;
    final auth = context.read<AuthProvider>();
    try {
      await editProfile(auth, {
        "user_id": auth.user?.id,
        "mobile": phoneNumber,
        "name": name,
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'The verification mail has been sent to you registered email , please verify the mail to reflect the changes you have made.'),
          ),
        );
      }
    } catch (e) {
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
              const SizedBox(
                height: 20,
              ),
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

class PrivacyPolicy extends StatelessWidget {
  static const String routeName = '/privacy_policy'; // Add route name

  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Privacy Policy',
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: HtmlWidget(
            """
           <div class="modal-body" >
                <h2 class="modal-heading">Utsavlife Privacy Policy</h2> 
                <h4 class="modal-heading2">Table of contents:</h4>
                <ul>
                  <li><a href="#general">A. General Privacy Terms</a></li>
                  <li><a href="#applicability">B. Applicability</a></li>
                  <li><a href="#access">C. Access</a></li>
                  <li><a href="#use_of_platform">D. Use of the Platform/Services by Children</a></li>
                  <li><a href="#controllers">E. Controllers</a></li>
                  <li><a href="#personal_information">F. Personal Information</a></li>
                  <li><a href="#info_collect">G. Information We Collect</a></li>
                  <li><a href="#basis_of_collection">H. Basis of Collection and Processing of Your Personal Information</a></li>
                  <li><a href="#use_share_info">I. How we Use and Share the Information Collected</a></li>
                  <li><a href="#cross_border_data">J. Cross-Border Data Transfer</a></li>
                  <li><a href="#duration_info">K. Duration for which your Information is Stored</a></li>
                  <li><a href="#your_choice">L. Your Choices</a></li>
                  <li><a href="#your_rights">M. Your Rights</a></li>
                  <li><a href="#info_sec">N. Information Security</a></li>
                  <li><a href="#personal_comm">O. Promotional Communications</a></li>
                  <li><a href="#interest_based_ads">P. Interest-Based Ads</a></li>
                  <li><a href="#mod-privacy-policy">Q. Modification to Privacy Policy</a></li>
                  <li><a href="#grievances">R. Privacy Grievances</a></li>
                </ul>
                <h4 class="modal-heading" id="general">A. General</h4> 
                <p class="modal-para">In addition to our <a href="#" data-bs-toggle="modal" data-bs-target="#terms" data-bs-dismiss="modal">Terms and conditions</a> Service, Utsavlife respects your privacy and is committed to protecting it. This Privacy Policy (the “Policy”) explains the types of information collected by Utsavlife when you use the Platform (as defined in <a href="#" data-bs-toggle="modal" data-bs-target="#terms" data-bs-dismiss="modal">Terms and conditions</a>) that references this Policy, how we collect, use, share and store such information collected and also explains the rationale for collection of such information, the privacy rights and choices you have regarding your information submitted to us when you use the Services.</p>
                <p class="modal-para">For ease of reference, use of the terms “Utsavlife”, “we”, “us, and/or “our” refer to SRV Technology – a company incorporated in India and all of its affiliates which have license to host the Platform and offer Services. Similarly, use of the terms “you”, “yours” and/or “User(s)” refer to all users of the Platform and includes all customers and Content Providers (as more particularly defined under our <a href="#" data-bs-toggle="modal" data-bs-target="#terms" data-bs-dismiss="modal">Terms and conditions</a>).</p>
                <p class="modal-para">The Services are governed by this Policy, <a href="#" data-bs-toggle="modal" data-bs-target="#terms" data-bs-dismiss="modal">Terms and conditions</a>, and any other rules, policies or guidelines published on the Platform as applicable to you. Please read this Policy carefully prior to accessing our Platform and using the Services. By accessing and using the Platform, providing your Personal Information (defined below), or by otherwise signalling your agreement when the option is presented to you, you consent to the collection, use, disclosure, sharing and storing of information described in this Policy, Terms of Service and any other rules, policies or guidelines published on the Platform as applicable to you (collectively referred to as the “Platform Terms''), and Utsavlife disclaims all the liabilities arising therefrom. If you have inadvertently submitted any Personal Information to Utsavlife prior to reading this Policy statements set out herein, or you do not agree with the way your Personal Information is collected, stored, or used, then you may access, modify and/or delete your Personal Information in accordance with this Policy (refer to the sections about Your Choices and Your Rights).</p>
                <p class="modal-para">If any information you have provided or uploaded on the Platform violates the Platform Terms, Utsavlife may be required to delete such information upon informing you of the same and revoke your access to the Platform if required.</p>
                <p class="modal-para">Capitalized terms used but not defined in this Policy can be found in our <a href="#" data-bs-toggle="modal" data-bs-target="#terms" data-bs-dismiss="modal">Terms and conditions</a></p>
                <p class="modal-para">If you have any questions about this Policy, please contact us at <a href="mailto:info@utsavlife.com">info@utsavlife.com</a></p>
                <h4 class="modal-heading" id="applicability">B. Applicability</h4> 
                <p class="modal-para">This Policy applies to all Users of the Platform.</p>
                <p class="modal-para">Utsavlife owns and/or manages several platforms (other than the Platform) that offer a range of services including services related to technology solutions in the space of e-service, either by itself or through its affiliates and subsidiaries (“Utsavlife Group Platforms”). Each of the Utsavlife Group Platforms have published their own privacy policies. Accordingly, this Policy does not apply to information collected through the Utsavlife Group Platforms and only applies to the collection of your information through the Platform. Please visit the relevant Utsavlife Group Platform to know the privacy practices undertaken by them.</p>
                <p class="modal-para">Utsavlife has taken reasonable precautions as per applicable laws and implemented industry standards to treat Personal Information as confidential and to protect it from unauthorized access, improper use or disclosure, modification and unlawful destruction or accidental loss of the Personal Information.</p>
                <h4 class="modal-heading" id="access">C. Access</h4>
                <p class="modal-para">You may be allowed to access and view the Platform as a guest and without creating an account on the Platform or providing any Personal Information; Utsavlife does not validate or takes no responsibility towards information, if any, provided by you as a guest, except as otherwise required under any law, regulation, or an order of competent authority. However, to have access to all the features and benefits on our Platform, you are required to first create an account on our Platform. To create an account, you are required to provide certain Personal Information as may be required during the time of registration and all other information requested on the registration page, including the ability to receive promotional offers from Utsavlife, is optional. Utsavlife may, in future, include other optional requests for information from you to help Utsavlife to customize the Platform to deliver personalized information to you. Utsavlife may keep records of telephone calls or emails received from or made by you for making enquiries, feedback, or other purposes for the purpose of rendering Services effectively and efficiently.</p>
                <h4 class="modal-heading" id="use_of_platform">D. Use of the Platform/Services by Children</h4>
                <p class="modal-para">As stated in our <a href="#" data-bs-toggle="modal" data-bs-target="#terms" data-bs-dismiss="modal">Terms and conditions</a>, to register on the Platform you must meet the ‘Age Requirements’ (as defined in our <a href="#" data-bs-toggle="modal" data-bs-target="#terms" data-bs-dismiss="modal">Terms and conditions</a>). If you are a “Minor” or “Child” i.e., an individual who does not meet the Age Requirements, then you may not register on the Platform, and only your Parent (defined below) can register on the Platform on your behalf, agree to all Platform Terms and enable access to you under their guidance and supervision.</p>
                <p class="modal-para">While some of our Services may require collection of a Child’s Personal Information, we do not knowingly collect such Personal Information from a Child and assume that information has been provided with consent of the Parent. If you are a Parent and you are aware that your Child has provided us with any Personal Information without your consent, please contact us at <a href="mailto:info@utsavlife.com">info@utsavlife.com</a> If we become aware that we have collected Personal Information from a Child in the absence of consent of the Parent, we will take steps to remove such information from our servers.</p>
                <p class="modal-para">The information in the relevant parts of this notice applies to Children as well as adults. If your Child faces any form of abuse or harassment while availing our Services, you must write to us at <a href="mailto:info@utsavlife.com">info@utsavlife.com</a>, so that necessary actions could be considered.</p>
                <h4 class="modal-heading" id="controllers">E. Controllers</h4>
                <p class="modal-para">Utsavlife is the controller of Personal Information that it collects and processes in connection with the use of the Platform and the provision of the Services on the Platform. The kind of Personal Information we collect in connection with such use is detailed below.
                </p>
                <h4 class="modal-heading" id="personal_information">F. Personal Information</h4>
                <p class="modal-para">“Personal Information” shall mean the information which identifies a User i.e., first and last name, identification number, email address, age, gender, location, photograph and/or phone number provided at the time of registration or any time thereafter on the Platform.</p>
                <p class="modal-para">“Sensitive Personal Information” shall include (i) passwords and financial data (except the truncated last four digits of credit/debit card), (ii) health data, (iii) official identifier (such as biometric data, aadhar number, social security number, driver’s license, passport, etc.,), (iv) information about sexual life, sexual identifier, race, ethnicity, political or religious belief or affiliation, (v) account details and passwords, or (vi) other data/information categorized as ‘sensitive personal data’ or ‘special categories of data’ under the Information Technology (Reasonable Security Practices and Procedures and Sensitive Personal Data or Information) Rules, 2011, General Data Protection Regulation (GDPR) and / or the California Consumer Privacy Act (CCPA) (“Data Protection Laws”) and in context of this Policy or other equivalent / similar legislations.</p>
                <p class="modal-para">Usage of the term ‘Personal Information’ shall include ‘Sensitive Personal Information’ as may be applicable to the context of its usage.</p>
                <p class="modal-para">We request you to not provide Utsavlife with any Personal Information unless specifically requested by us. In the event you share with Utsavlife any Personal Information without us having specifically requested for the same, then we bear no liability in respect of such Personal Information provided by you.</p>
                <h4 class="modal-heading" id="info_collect">G. Information We Collect</h4>
                <p class="modal-para">We only collect information about you if we have a reason to do so — for example, to provide our Services on the Platform, to communicate with you, or to make our Services better.</p>
                <p class="modal-para">We collect this information from the following sources:</p>
                <h4 class="modal-heading2">Information we collect from You:</h4>
                <p class="modal-para"><b>Basic account information:</b> In order to access certain features of the Platform, you will need to create an account and register with us. We ask for basic information which may include your name, an email address, state of residence, and password, along with a username and phone/mobile number.</p>
                <p class="modal-para"><b>Know Your Customer ('KYC') information:</b> If you are a service Provider registered with us, then, we also collect the KYC information, which may include information pertaining to your PAN number, aadhaar number, driver’s license, passport, your entity details such as name, MOU/AOA, certificate of incorporation, list of directors/partners, social security number etc., along with the relevant documents. We collect this information and documents from you to complete our verification process including pursuant to any other arrangement / agreement executed with you.</p>
                <p class="modal-para"><b>Public profile information:</b> If you are a service Provider, we may also collect certain additional information from you to enable creation of your public profile, if any, on the Platform to help Customers and other Users know you better. We do not share your KYC information, documents or any such Personal Information on these public profiles. Your public profile will only contain Personal Information that are required for Customers or Users to know you (as applicable) viz., your username, a brief description of any service you have made available on the Platform, your photo, and such similar information that may enable a customer or other User to know you better. The information in your public profile will be based on the information you provide to us or as updated by you on such applicable sections.</p>
                <p class="modal-para"><b>Information when you communicate with us:</b> When you write to us with a question or to ask for help, we will keep that correspondence, and the email address, for future reference; this may also include any phone/ mobile numbers if you have provided us the same as part of your communication either in writing (emails included), over a phone call or otherwise. When you browse pages on our Platform, we will track that for statistical purposes which may be to improve the Platform and the Services. You may also provide us your Personal Information or other information when you respond to surveys, enter any form of contests, tests, events, competitions, webinars, etc., hosted by Utsavlife, either on the Platform or otherwise, or when you otherwise communicate with us via form, e-form, email, phone, or otherwise, we store a copy of our communications (including any call recordings or emails, if any, as permitted by applicable law).</p>
                <p class="modal-para"><b>Information related to location:</b> You may also choose to provide location related information, including but not limited to access to GPS, which will enable us, with your consent, to offer customized offerings for specific services where location data is relevant and/or applicable such as informing you whether services on the Platform that you have expressed interest in may be availed of at or near your location.</p>
                <h4 class="modal-heading2">Information we collect automatically:</h4>
                <p class="modal-para"><b>Device and Log information:</b> When you access our Platform, we collect information that web browsers, mobile devices, and servers typically make available, including the browser type, IP address, unique device identifiers, language preference, referring site, the date and time of access, operating system, and mobile network information. We collect log information when you use our Platform — for example, when you create or make changes to your account information on the Platform.</p>
                <p class="modal-para"><b>Usage information:</b> We collect information about your usage of our Platform. We also collect information about what happens when you use our Platform (e.g., page views, support document searches, features enabled for your account, interactions with other parts of our Services) along with information about your Supported Device (e.g., screen size, name of cellular network, and mobile device manufacturer). We use this information to provide our Platform to you, get insights on how people use our Platform so that we can make our Platform better, and understand and make predictions about User retention.</p>
                <p class="modal-para"><b>Location information:</b> We may determine the approximate location of your Supported Device from your Internet Protocol (IP) address. We may collect and use this information to calculate how many people visit from certain geographic regions or to improve our Platform Services.</p>
                <p class="modal-para"><b>Information from cookies &amp; other technologies:</b> We may collect information about you through the use of cookies and other similar technologies. A cookie is a string of information that a website stores on a visitor’s computer, and that the visitor’s browser provides to the website each time the visitor returns. For more information on our use of cookies and similar technologies, please refer to our <a href="#" data-bs-toggle="modal" data-bs-target="#contact" data-bs-dismiss="modal">Cookie Policy.</a></p>
                <h4 class="modal-heading2">Information we collect from other sources:</h4>
                <p class="modal-para">We might receive and collect information about you from other sources in the course of their services to us or from publicly available sources, as permitted by law, which we may combine with other information we receive from or about you. For example, we may receive information about you from a social media site or a Google service if you connect to the Services through that site or if you use the Google sign-in.</p>
                <h4 class="modal-heading" id="basis_of_collection">H. Basis of Collection and Processing of Your Personal Information</h4>
                <h4 class="modal-heading2">Basis for collection:</h4>
                <p class="modal-para">We collect and process your Personal Information based on the following legal parameters depending upon the nature of Personal Information and the purposes for which it is processed:</p>
                <p class="modal-para"><b>Consent:</b> We rely on your consent to process your Personal Information in certain situations. If we require your consent to collect and process certain Personal Information, as per the requirements under the applicable Data Protection Laws, your consent is sought at the time of collection of your Personal Information and such processing will be performed where consent is secured.</p>
                <p class="modal-para"><b>Compliance with a legal obligation:</b> Your Personal Information may be processed by us, to the extent that such processing is necessary to comply with a legal obligation.</p>
                <h4 class="modal-heading2">Processing of your Personal Information:</h4>
                <p class="modal-para">We may process your Personal Information in connection with any of the purposes and uses set out in this Policy on one or more of the following legal grounds:</p>
                <p class="modal-para">Because it is necessary to perform the Services you have requested or to comply with your instructions or other contractual obligations between you and us;</p>
                <p class="modal-para">To comply with our legal obligations as well as to keep records of our compliance processes;</p>
                <p class="modal-para">Because our legitimate interests, or those of a third-party recipient of your Personal Information, make the processing necessary, provided those interests are not overridden by your interests or fundamental rights and freedoms;</p>
                <p class="modal-para">Because you have chosen to publish or display your Personal Information on a public area of the Platform, such as a comment area;</p>
                <p class="modal-para">Because it is necessary to protect your vital interests;</p>
                <p class="modal-para">Because it is necessary in the public interest; or</p>
                <p class="modal-para">Because you have expressly given us your consent to process your Personal Information in a particular manner.</p>
                <p class="modal-para">We do not use Personal Information for making any automated decisions affecting or creating profiles other than what is described in this Policy.</p>
                <p class="modal-para">Where the processing of your Personal Information is based on your consent, you have the right to withdraw your consent at any point in time in accordance with this Policy. Please note that should the withdrawal of consent result in us not being able to continue offering our Services to you, we reserve the right to withdraw or cease from offering our Services to you upon your consent withdrawal. You may withdraw consent by contacting us with a written request to the contact details provided in the <a href="#grievances">‘Grievances’</a> section below. Upon receipt of your request to withdraw your consent, the consequences of withdrawal may be communicated to you. Upon your agreement to the same, your request for withdrawal will be processed.</p>
                <h4 class="modal-heading" id="use_share_info">I. How we Use and Share the Information Collected</h4>
                <h4 class="modal-heading2">We use/process your information in the following manner:</h4>
                <p class="modal-para"><b>To provide Services on our Platform:</b>We use your information as collected by us to allow you to access the Platform and the Services offered therein, including without limitation to set-up and maintain your account, provide customer service, fulfil purchases through the Platform, verify User information and to resolve any glitches with our Platform. The legal basis for this processing is consent or, where applicable, our legitimate interests in the proper administration of our Platform, and/or the performance of a contract between you and us.
                </p><p class="modal-para"><b>To improve our Platform and maintain safety:</b>We use your information to improve and customize the Platform and Services offered by us, including providing automatic updates to newer versions of our Platform and creating new features based on the Platform usage analysis. Further, we also use your information to prevent, detect, investigate, and take measures against criminal activity, fraud, misuse of or damage to our Platform or network, and other threats and violations to Utsavlife’s or a third party's rights and property, or the safety of Utsavlife, its users, or others. The legal basis for this processing is consent or, where applicable, our legitimate interests in the proper administration of our Platform, and/or the performance of a contract between you and us.</p><p></p>
                <p class="modal-para"><b>To market our Platform and communicate with You:</b> We will use your information to develop a more targeted marketing of our Platform, to communicate with you about our offers, new products, services or even receive your feedback on the Platform. The legal basis for this processing is consent or, where applicable, our legitimate interests in the proper administration of our Platform, and/or the performance of a contract between you and us.</p>
                <p class="modal-para"><b>To establish, exercise, or defend legal claims:</b> We may process any Personal Information identified in this Policy when necessary for establishing, exercising, or defending legal claims, whether in court, administrative, or other proceedings. The legal basis for this processing is our legitimate interest in the protection and assertion of our legal rights, your legal rights, and the legal rights of others.</p>
                <p class="modal-para"><b>To manage risk and obtain professional advice:</b> We may process any of the Personal Information identified in this Policy to manage risk or obtain professional advice. The legal basis for this processing is our legitimate interest in the proper protection of our business and Platform</p>
                <p class="modal-para"><b>Consent:</b> We may otherwise use your information with your consent or at your direction.</p>
                <p class="modal-para"><b>To Better Understand Our Users:</b> We may use information we gather to determine which areas of the Services are most frequently visited to understand how to enhance the Services.</p>
                <p class="modal-para">We share the information collected as per terms of this Policy only in the manner specified hereinbelow. We do not sell or otherwise disclose Personal Information we collect about you for monetary or other valuable consideration. Further, only authorized representatives of Utsavlife and on a need-to-know basis use any information received from you and as consented by you. In the event of any identified unauthorized use or disclosure of information or upon your complaint as stated under the <a href="#grievances">‘Grievances’</a> section below, we will investigate any such complaint and take the appropriate action as per the applicable Data Protection Laws.</p>
                <p class="modal-para"><b>Affiliates and Subsidiaries:</b> We may disclose information about you to our affiliates, subsidiaries and other businesses under the same control and ownership, and their respective officers, directors, employees, accountants, attorneys, or agents, who need the information to help us provide the Services or process the information on our behalf. We require our affiliate, subsidiaries and other businesses under the same control and ownership to follow this Privacy Policy for any Personal Information that we share with them. Further, if you have availed any Service that is offered by Utsavlife in collaboration with one or more Utsavlife Group Platforms, then we may share your Personal Information with the relevant Utsavlife Group Platform, who may also communicate with you regarding certain other products/services offered by them separately via email, phone, SMS and/or such other mode of communication; you will always have an option to opt out of receiving some or all of such promotional communications from an Utsavlife Group Platform through the unsubscribe link in the email or such other option that may be communicated to you.</p>
                <p class="modal-para"><b>Third-party vendors/service providers including integrated services on the Platform:</b> We may share information about you with third-party vendors or service providers (including consultants, payment processors, and other service providers and integrated services) who need the information to provide their support services to us or you, or to provide their services to you on our behalf either directly or through the Platform. These services may include providing customer support, performing business and sales analysis, supporting our website functionality, facilitating payment processing, and supporting contests, surveys, and other features offered on our Platform. Such third-party vendors are not allowed to use the information for any purpose other than what it was provided for, and they are required to process and use the information in accordance with this Privacy Policy.</p>
                <p class="modal-para"><b>Third-party platforms to facilitate the additional offerings:</b> We may share information about you with third-party platforms that are used to create interactive forums between Service Providers and Customers to enable the Customers a more conducive environment to extend their take our service. The information shared with these platforms are limited to the information required to facilitate your participation in the forums and is based on your consent. However, the privacy practices of these platforms are independent of this Policy, and we suggest that you read through the privacy policies and terms and condition of the platforms relevant to you prior to consenting to being a part of any forums made available on these third-party platforms.</p>
                <p class="modal-para"><b>Legal Disclosures:</b> We may disclose information about you in response to a court order, or other governmental request. Without limitation to the foregoing, we reserve the right to disclose such information where we believe in good faith that such disclosure is necessary to:</p>
                <p class="modal-para ml-2">comply with applicable laws, regulations, court orders, government and law enforcement agencies’ requests;</p>
                <p class="modal-para ml-2">protect and defend Utsavlife’s or a third party's rights and property, or the safety of Utsavlife, our users, our employees, or others; or</p>
                <p class="modal-para ml-2">prevent, detect, investigate and take measures against criminal activity, fraud and misuse or unauthorized use of our Platform and/or to enforce our Terms and Conditions or other agreements or policies.</p>
                <p class="modal-para">To the extent permitted by law, we will attempt to give you prior notice before disclosing your information in response to such a request.</p>
                <p class="modal-para"><b>Business transfers:</b> In the event Utsavlife undergoes any merger, acquisition, or sale of company assets, in part or in full, with another company, or in the unlikely event that Utsavlife goes out of business or enters bankruptcy, user information would likely be one of the assets that is transferred or acquired by a third party. If any of these events were to happen, this Privacy Policy would continue to apply to your information and the party receiving your information may continue to use your information, but only consistent with this Privacy Policy.</p>
                <p class="modal-para"><b>Advertising and Analytics Partners:</b> We may share usage data with third-party advertisers, advertisement networks, and analytics providers through cookies and other similar technologies.</p>
                <p class="modal-para"><b>With Your Consent:</b> We may share and disclose information with your consent or at your direction.</p>
                <p class="modal-para"><b>Your information may be shared for reasons not described in this Policy; however, we will seek your consent before we do the same or share information upon your direction.</b></p>
                <h4 class="modal-heading" id="cross_border_data">J. Cross-Border Data Transfer</h4>
                <p class="modal-para">Your information including any Personal Information is stored, processed, and transferred in and to the Amazon Web Service (AWS) servers and databases located in Singapore, India and the USA. Utsavlife may also store, process, and transfer information in and to servers in other countries depending on the location of its affiliates and service providers.</p>
                <p class="modal-para">Please note that these countries may have differing (and potentially less stringent) privacy laws and that Personal Information can become subject to the laws and disclosure requirements of such countries, including disclosure to governmental bodies, regulatory agencies, and private persons, as a result of applicable governmental or regulatory inquiry, court order or other similar process.</p>
                <p class="modal-para">If you use our Platform from outside India, including in the USA, EU, EEA, and UK, your information may be transferred to, stored, and processed in India. By accessing our Platform or otherwise giving us information, you consent to the transfer of information to India and other countries outside your country of residence. If you are located in the EU and applicable law specifies relevant legal grounds for processing personal data, the legal grounds for our processing activities are to perform our contract(s) with you; to meet our legal obligations; and for our legitimate business purposes, including to improve our operation and Services and to detect and prevent fraud.</p>
                <p class="modal-para">We rely on legal bases to transfer information outside the EU, EEA and UK, and any Personal Information that we transfer will be protected in accordance with this Policy as well as with adequate protections in place in compliance with applicable Data Protection Laws and regulations.</p>
                <h4 class="modal-heading" id="duration_info">K. Duration for which your Information is Stored</h4>
                <p class="modal-para">Mostly, when you delete any of the information provided by you or when you delete your account, on the Platform, the same will be deleted from our servers too. However, in certain cases, we will retain your information for as long as it is required for us to retain for the purposes stated hereinabove, including for the purpose of complying with legal obligation or business compliances.</p>
                <p class="modal-para">Further, please note that we may not be able to delete all communications or photos, files, or other documents publicly made available by you on the Platform (for example: comments, feedback, etc.), however, we shall anonymize your Personal Information in such a way that you can no longer be identified as an individual in association with such information made available by you on the Platform. We will never disclose aggregated or de-identified information in a manner that could identify you as an individual.</p>
                <p class="modal-para">Note: If you wish to exercise any of your rights (as specified in <a href="#your_rights">‘Your Rights’</a> section below) to access, modify and delete any or all information stored about you, then you may do so by using the options provided within the Platform. You can always write to us at <a href="mailto:info@utsavlife.com">info@utsavlife.com</a> for any clarifications needed.</p>
                <h4 class="modal-heading" id="your_choice">L. Your Choices</h4>
                <p class="modal-para">Limit the information You provide: You always have an option to choose the information you provide to us, including the option to update or delete your information. However, please note that lack of certain information may not allow you the access to the Platform or any of its features, in part or in full.</p>
                <p class="modal-para">Limit the communications You receive from us: Further, you will also have the option to choose what kind of communication you would like to receive from us and whether you would like to receive such communication at all or not. However, there may be certain communications that are required for legal or security purposes, including changes to various legal agreements, that you may not be able to limit.</p>
                <p class="modal-para">Reject Cookies and other similar technologies: You may reject or remove cookies from your web browser; you will always have the option to change the default settings on your web browser if the same is set to ‘accept cookies’. However, please note that some Services offered on the Platform may not function or be available to you, when the cookies are rejected, removed, or disabled.</p>
                <h4 class="modal-heading" id="your_rights">M. Your Rights</h4>
                <p class="modal-para">In general, all Users have the rights specified herein this section. However, depending on where you are situated, you may have certain specific rights in respect of your Personal Information accorded by the laws of the country you are situated in. To understand <a href="#your_rights">Your rights</a></p>
                <p class="modal-para">If you are a User, you may exercise any of these rights by using the options provided to you within the Platform upon your login. If, however, you are facing any issues or require any clarifications, you can always write to us at the address noted in the <a href="#grievances">‘Grievances’</a> section below, and we will address your concerns to the extent required by the applicable law.</p>
                <p class="modal-para"><b>Right to Confirmation and Access:</b>You have the right to get confirmation and access to your Personal Information that is with us along with other supporting information.</p>
                <p class="modal-para"><b>Right to Correction:</b> You have the right to ask us to rectify your Personal Information that is with us that you think is inaccurate. You also have the right to ask us to update your Personal Information that you think is incomplete or out-of-date.</p>
                <p class="modal-para"><b>Right to be Forgotten:</b> You have the right to restrict or prevent the continuing disclosure of your Personal Information under certain circumstances.</p>
                <p class="modal-para"><b>Right to Erasure:</b> If you wish to withdraw/remove your Personal Information from our Platform, you have the right to request erasure of your Personal Information from our Platform. However, please note that such erasure will remove all your Personal Information from our Platform (except as specifically stated in this Policy) and may result in deletion of your account on the Platform permanently, and the same will not be retrievable.</p>
                <p class="modal-para">Remember, you are entitled to exercise your rights as stated above only with respect to your information, including Personal Information, and not that of other Users. Further, when we receive any requests or queries over email or physically to the address specified in the <a href="#grievances"> ‘Grievances’ </a> section below, then, as per the applicable Data Protection Laws, we may need to ask you a few additional information to verify your identity in association with the Platform and the request received.</p>
                <h4 class="modal-heading" id="info_sec">N. Information Security</h4>
                <p class="modal-para">We work to protect the security of your information during transmission by using Transport Layer Security (TLS) or Secure Sockets Layer (SSL) software (depending on your browser/Supported Device), which encrypts information you input in addition to maintaining security of your information as required under applicable laws.</p>
                <p class="modal-para">We maintain electronic, and procedural safeguards in connection with the collection, storage, and disclosure of Personal Information (including Sensitive Personal Information). Our security procedures mean that we may occasionally request proof of identity before we disclose Personal Information to you that belongs to you.</p>
                <p class="modal-para">However, no form or method of data storage or transmission system is fully secure, and we cannot guarantee that security provided by such system(s) is absolute and that your information will not be accessed, disclosed, or destroyed in the event of a breach of any of our security measures.</p>
                <p class="modal-para">It is important for you to protect your account against unauthorized access to or use of your password and to your computer and if you have any reason to believe that your password has become known to anyone else, or if the password is being, or is likely to be, used in an unauthorized manner, you must immediately change your password or inform us, so that we are able to help you stop or prevent such unauthorized access. Be sure to sign off when you finish using a shared computer.</p>
                <p class="modal-para">All KYC information collected in accordance with this Policy are fully encrypted and cannot be accessed by any person other than the designated authority in Utsavlife.</p>
                <p class="modal-para">We try to ensure that the third parties who provide services to us under appropriate contracts take appropriate security measures to protect Personal Information in line with our policies.</p>
                <h4 class="modal-heading" id="personal_comm">O. Promotional Communications</h4>
                <p class="modal-para">You will always have the option to opt out of receiving some or all of our promotional communications through the setting provided within the Platform upon your login, by using the unsubscribe link in any email communications sent to you or by emailing <a href="mailto:info@utsavlife.com">info@utsavlife.com</a></p>
                <p class="modal-para">If you opt out of promotional communications, we may still send you transactional communications, such as service announcements, administrative and legal notices, and information about your account, without offering you the opportunity to opt out of these communications. If you no longer wish to use our Platform or receive any communications from us (except for those that are legally required), then you may delete your account by using the option enabled within the Platform or by writing to us at <a href="mailto:info@utsavlife.com">info@utsavlife.com</a>.</p>
                <p class="modal-para">Advertisers or ad companies working on their behalf sometimes use technology to serve the ads that appear on our sites directly to Your browser. They automatically receive Your IP address when this happens. They may also use cookies to measure the effectiveness of their ads and to personalize ad content. We do not have access to or control over cookies or other features that advertisers and third-party sites may use, and the information practices of these advertisers and third-party websites are not covered by our Policy. Please contact them directly for more information about their privacy practices.</p>
                <p class="modal-para">Please note that opting out of promotional email communications only affects future communications from us. If we have already provided your information to a third party (as stated in this Policy) before you changed your preferences or updated your information, you may have to change your preferences directly with that third party.</p>
                <p class="modal-para">We do not sell your Personal Information to third parties, and we do not use your name or name of your company in marketing statements without your consent.</p>
                <h4 class="modal-heading" id="interest_based_ads">P. Interest-Based Ads</h4>
                <p class="modal-para">On unaffiliated sites, Utsavlife may display interest-based advertising using information you make available to us when you interact with our Platform and Services. Interest-based ads, also sometimes referred to as personalised or targeted ads, are displayed to you based on information from activities such as registering with our Platform, visiting sites that contain Utsavlife content or ads. In providing interest-based ads, we follow applicable laws, as well as the Code for Self-Regulation in Advertising by the Advertising Standards Council of India and the Self-Regulatory Principles for Online Behavioural Advertising developed by the Digital Advertising Alliance (a coalition of marketing, online advertising, and consumer advocacy organizations) and other rules and guidelines issued by the Federal Trade Commission in respect of digital advertising.</p>
                <p class="modal-para">We do not provide any Personal Information to advertisers or to third party sites that display our interest-based ads. However, advertisers and other third-parties (including the ad networks, ad-serving companies, and other service providers they may use) may assume that users who interact with or click on a personalized ad or content are part of the group that the ad or content is directed towards. Also, some third-parties may provide us information about you (such as the sites where you have been shown ads or demographic information) from offline and online sources that we may use to provide you with more relevant and useful advertising.</p>
                <p class="modal-para">Advertisers or ad companies working on their behalf sometimes use technology to serve the ads that appear on our sites directly to your browser. They automatically receive your IP address when this happens. They may also use cookies to measure the effectiveness of their ads and to personalise ad content. We do not have access to or control over cookies or other features that advertisers and third-party sites may use, and the information practices of these advertisers and third-party websites are not covered by our Policy. Please contact them directly for more information about their privacy practices.</p>
                <h4 class="modal-heading" id="mod-privacy-policy">Q. Modification to Privacy Policy</h4>
                <p class="modal-para">Our business changes constantly and our Policy may change from time to time. We may, at our discretion (unless required by applicable laws to mandatorily do so), email periodic reminders of our notices and conditions, unless you have instructed us not to, but we encourage you to check our Platform frequently to see the recent changes. Unless stated otherwise, our current Policy applies to all information that we have about you and your account. We stand behind the promises we make, however, and will not materially change our policies and practices making them less protective of customer information collected in the past without your consent.</p>
                <h4 class="modal-heading" id="grievances">R. Privacy Grievances</h4>
                <p class="modal-para">If you have any questions about this Policy, wish to exercise your rights, have concerns about privacy of your data or any privacy related grievances in respect of the Platform, then please register your complaint with a thorough description via email to <a href="mailto:info@utsavlife.com">info@utsavlife.com</a> addressed to our grievance officer Mr. Vikrant Singh (Associate General Counsel) or via a registered post to the below address-</p>
                <p class="modal-para">Utsavlife Pvt. Ltd.</p>
                <p class="modal-para">R-16, Uttam Nagar west metro station, Gate Number 1 </p>
                <p class="modal-para">Metro pillar Number 690</p>
                <p class="modal-para">Bikaner wali Gali</p>
                <p class="modal-para">New Delhi 110059</p>
                <p class="modal-para">Privacy Policy – Version 1.0</p>
                <p class="modal-para">Last Updated on 16th JANUARY 2023</p>
              </div>
         """,
            // remove padding margin from h1 and h4
            customStylesBuilder: (e) {
              if (e.classes.contains("modal-heading")) {
                return {
                  "margin": "0px",
                  "padding": "0px",
                };
              }
              if (e.classes.contains("modal-heading2")) {
                return {
                  "margin": "0px",
                  "padding": "0px",
                };
              }
              if (e.classes.contains("modal-para")) {
                return {
                  "margin": "0px",
                  "padding": "0px",
                };
              }
              if (e.classes.contains("modal-para")) {
                return {
                  "margin": "0px",
                  "padding": "0px",
                };
              }
              if (e.classes.contains("modal-heading2")) {
                return {
                  "margin": "0px",
                  "padding": "0px",
                };
              }
              if (e.classes.contains("modal-heading")) {
                return {
                  "margin": "0px",
                  "padding": "0px",
                };
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}

class TermsAndCondition extends StatelessWidget {
  static const String routeName = '/TermsAndCondition'; // Add route name

  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Terms and Condition',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: HtmlWidget(
          """
        <div class="modal-body">
        <h2 class="modal-heading">Utsavlife Platform - Terms and Conditions</h2>
        <h4 class="modal-heading2">Table of Services:</h4>
      <ul class="ml-2">
        <li><a href="#about">A. About Utsavlife and the Platform</a></li>
        <li><a href="#platform">B. Platform Services</a></li>
        <li><a href="#rights_to_accounts">C. Right to Access and Account Creation</a></li>
        <li><a href="#booking_terms">D. Booking Terms</a></li>
        <li><a href="#pricing">E. Pricing, Payments and Refund</a></li>
        <li><a href="#use_of_platform2">F. Use of the Platform</a></li>
        <li><a href="#content_conduct">G. Service and Conduct</a></li>
        <li><a href="#communications">H. Communications</a></li>
        <li><a href="#processing_personal_information">I. Processing of Personal Information</a></li>
        <li><a href="#intellectual_property_license">J. Intellectual Property and License to User-generated Service</a></li>
        <li><a href="#feedback">K. Pricedback</a></li>
        <li><a href="#copyrights">L. Copyrights, Trademarks and other Intellectual Property Rights</a></li>
        <li><a href="#claims_against_user_content">M. Claims Against User-generated Service</a></li>
        <li><a href="#unacademy_rights">N. Utsavlife’s Rights</a></li>
        <li><a href="#platform_availability">O. Platform Availability</a></li>
        <li><a href="#deletion_of_account">P. Deletion of Account</a></li>
        <li><a href="#disclaimer">Q. Disclaimer</a></li>
        <li><a href="#limitation_of_liability">R. Limitation of Liability</a></li>
        <li><a href="#indemnity_and_release">S. Indemnity and Release</a></li>
        <li><a href="#governing_laws">T. Applicable Laws and Jurisdiction</a></li>
        <li><a href="#general_provisions">U. General Provisions</a></li>
        <li><a href="#user_support">V. Contact for User Support/Queries</a></li>
        <li><a href="#contact_us">W. Contact Us</a></li>
      </ul>    
      <p class="modal-para mt-2">Welcome to Utsavlife! We hope that you have a great experience using our Platform.</p>
      <p class="modal-para">These Terms and Conditions (“Terms and Conditions”) set out the terms and conditions for use of <a href="http://utsavlife.com/">http://www.utsavlife.com/</a> (the “Site”), the mobile application(s) (the “Application”) and any features, subdomains, Service (except as specified hereunder), functionality, products, services (including the Services), media, applications, or solutions offered on or through the Site and/or the Application and/or through any modes, medium, platform or format, including through Secure Digital (‘SD’) cards, tablets or other storage/transmitting device (hereinafter collectively referred to as the “Platform”/ “Utsavlife Platform”).</p>
      <p class="modal-para">These Terms and Conditions apply to all users of the Platform, including without limitation, all persons who create and / or make available Services (as defined under the ‘Intellectual Property’ section below) on the Platform (referred to as “Service providers'') and users who access the Platform to Buy service or sell service (referred to as “Customers'') or users who access the Platform otherwise (collectively referred to as “you”, “your”, or “User(s)”). These Terms and Conditions along with the Privacy Policy, Refund Policy, Cookies Policy, Accessibility Statement, the User Guidelines and any other terms and conditions, rules, policies or guidelines included in these Terms and Conditions or Privacy Policy by reference and/or as updated on the Platform or otherwise communicated to you from time to time (including terms and conditions of other third party platforms that may be used or accessed for gaining access to the Platform or using the Services on the Platform (collectively referred to as the “Platform Term(s)”), defines the relationship between you and Utsavlife, and they shall govern your use of the Platform and the Services (defined below) offered therein. Your access to the Platform is subject to your acceptance of the Platform Terms and such acceptance of the Platform Terms forms a legally binding agreement between you and Utsavlife (“Agreement”). Hence, please take your time to read the Platform Terms in their entirety.</p>
      <p class="modal-para">From time-to-time, updated versions of the Platform Terms may be made available as aforesaid for your reference. By visiting and accessing the Platform, providing your Personal Information (as defined in the Privacy Policy), using the Services offered or by otherwise signalling your agreement when the option is presented to you, you hereby expressly accept and agree to the Platform Terms. If you do not agree to any of the terms or do not wish to be bound by them, then please do not use the Platform in any manner.</p>
      <p class="modal-para">When we speak of “Utsavlife”, “we”, “us”, and “our”, we collectively mean Royal Utsavlife Private Limited – a company incorporated in India and all of its affiliates which have license to host the Platform and offer Services. Kindly refer to the ‘About Utsavlife and the Platform’ section of these Terms and Conditions to know which Utsavlife entity your Agreement will be with.</p>
      <p class="modal-para">All capitalized terms are defined/have the meaning assigned to it under these Terms and Conditions. In other words, if you find any word herein that has its first letter capitalized, then it means that we have explained the meaning such word has in the context of these Terms and Conditions and/or the Platform Terms; if not here, then it will be provided in the relevant Platform Terms – when we refer to any such term in these Terms and Conditions, we will try and specify where in the Platform Terms you can find the meaning/definition.</p>
      <h4 class="modal-heading" id="about">A. About Utsavlife and the Platform</h4>
      <p class="modal-para">In India, the Platform is owned, managed, operated and offered by Royal Utsavlife Private Limited, a company incorporated under the (Indian) Companies Act, 2013, having its registered office at R -16 Uttam Nagar west metro station Gate Number -1, Metro pillar Number -690 Bikaner wali Gali Delhi 110059, India (“Utsavlife India”). In any jurisdiction other than India, wherever Services are rendered through the Platform, the same is offered by Utsavlife India and / or its affiliates (as relevant pursuant to appropriate intra group contractual arrangements). For knowing with which entity of Utsavlife your Agreement will be, please refer the list in Annexure A below.</p>
      <h4 class="modal-heading" id="platform">B. Platform Services:</h4>
      <p class="modal-para">Utsavlife Platform is an online service platform enabling Service providers to create and offer Services in various Event including Tent, Decorators, Event planner, Marriage Hall, Catrine, Photographer, Videographer, Musical Group, DJ, Stage Show, Dance Show, Bollywood Dance, Singing Show, Designer, Decorator, etc in a diverse range of categories through various modes and means (“Service Provider Service'') and publish and make available such Service Provider Service to the Customers. Utsavlife acts as an intermediary between the Service providers and Customers [in accordance with the Information Technology Act, 2000, or the Digital Millennium Copyright Act (as amended from time to time)] or other equivalent / similar legislations and makes available the Service Provider Service to the Customers, including through Booking offerings (refer to the Booking Terms below to know more). </p>
      <p class="modal-para">Further, Utsavlife may offer certain products/services to you in collaboration with one or more of the Utsavlife Group Platforms (as defined under the Privacy Policy). In such cases, to the extent that such product/services are made available to you through the Platform, the Platform Terms shall continue to apply to you.</p>
      <p class="modal-para">For the purpose of the Platform Terms, usage of the terms “Platform Services”/ “Services” shall mean and include all the services referred to in this section and such other products or services as may be offered by Utsavlife.</p>
      <p class="modal-para">You agree and acknowledge that Utsavlife has no control over and assumes no responsibility for, the User-generated Service (as defined under the ‘Intellectual Property’ section below) and by using the Platform, you expressly relieve Utsavlife from any and all liability arising from the User-generated Service.</p>
      <p class="modal-para">You agree and acknowledge that Utsavlife shall have the right at any time to change or discontinue any Service, product, aspect, or feature of the Platform, including without limitation to, the User-generated Service (to the extent it is permitted to, or required, by virtue of being an ‘intermediary’), its availability and Supported/Compatible device required to access or use the Services. Utsavlife reserves the right to terminate your Booking and / or restrict your access to the Platform, if you choose not to provide / partially provide the requested information.</p>
      <h4 class="modal-heading" id="rights_to_accounts">C. Right to Access and Account Creation</h4>
      <p class="modal-para">As a customer, to access the Platform and use certain Services, you will be required to register and create an account on the Platform by providing the requested details.</p>
      <p class="modal-para">To register on the Utsavlife Platform you must meet the ‘Age Requirements’ specified hereinbelow. By using the Utsavlife Platform, you, through your actions, affirm that the Age Requirements are met.</p>
      <p class="modal-para">You can register on the Platform for free however, certain Services offered on the Platform may be chargeable. Please review the Service offerings on our Site or Application(s). You are not obligated to Booking any product or use any Service offered on the Platform.</p>
      <p class="modal-para"><b> Age Requirements to register and use on the Platform (“Age Requirements”):</b></p>
      <ul class="ml-2">
        <li>If you are a resident of India or any other country (except USA, UK or EU countries), then you must have attained at least 18 (eighteen) years of age to register and use the Utsavlife Platform;</li>
        <li>If you are a resident of the European Union (EU) country and have attained at least 16 (sixteen) years of age, then you are permitted to register and use the Utsavlife Platform; and</li>
        <li>If you are a resident of the United States of America (USA) or United Kingdom (UK) and have attained at least 13 (thirteen) years of age, then you can register and use the Utsavlife Platform.</li>
        <li>If you are a resident of the US, UK or EU countries and are between the ages 13 and 18/ 16 and 18 respectively or if you are resident of any other country and are considered to be of any age determined for use of internet services but are less than the contractual age determined by the applicable laws of such country, then by using the Platform, you confirm to us that your use of the Platform is with the permission of your Parent(s) (as defined below), and your Parent has read, agreed and accepted to the Agreement; and in the event of any dispute between you and Utsavlife pursuant to your Agreement with us, the terms of our Agreement shall be applicable to and enforceable against your Parent.</li>
      </ul>
      <p class="modal-para">A Customer who does not fulfil the Age Requirements mentioned above (as may be revised as per applicable laws from time to time) and is desirous of registering on the Platform i.e., if a customer is a “Minor”/ “Child”, then the Customer may use the Platform with the consent of, and under the supervision of, their parent or legal guardian (“Parent”). Accordingly, in such a case, the Parent must agree to the Platform Terms at the time of their registration on the Platform. Please note that minors/children are not by themselves eligible to register on the Platform. When a Minor/Child uses the Platform, we assume that the Parent of such Minor/Child has enabled the Minor/Child’s usage of the Platform by agreeing to the Platform Terms and that such usage is under the supervision of their Parent.</p>
      <p class="modal-para">Utsavlife reserves the right to terminate your Booking and / or restrict your access to the Platform, if it is discovered that you do not meet the Age Requirements and/or the consent to register and use the Platform is not obtained as above. You acknowledge that Utsavlife does not have the responsibility to ensure that You conform to the aforesaid Age Requirements. It shall be Your sole responsibility to ensure that the required qualifications are met.</p>
      <p class="modal-para">If you are a Service Provider, your access and use of the Platform may additionally be subject to separate agreement(s) with Utsavlife and shall be collectively governed by the terms of such agreement, the Terms and Conditions, other Platform Terms, and such other terms as may be communicated or agreed with the Service Provider from time to time.</p>
      <p class="modal-para">Further, the permission given by Utsavlife to access and use the Platform under these Terms and Conditions is subject to the following conditions:</p>
      <p class="modal-para">1. You agree not to distribute in any medium any part of the Platform, Service Provider Service or the Utsavlife Service (as defined below) without Utsavlife’s prior written authorization.</p>
      <p class="modal-para">2. You agree not to alter or modify any part of the Platform.</p>
      <p class="modal-para">3. You agree not to access User-generated Service of any other User through any technology or means other than the User-generated Service you have legitimate access to.</p>
      <p class="modal-para">4. You agree not to use the Platform for any of the following commercial uses unless you obtain Utsavlife’s prior written approval:</p>
      <p class="modal-para ml-2">the sale of access to the Platform;</p>
      <p class="modal-para ml-2">the sale of advertising, sponsorships, or promotions placed on or within the Platform or Service Provider Service; or</p>
      <p class="modal-para ml-2">the sale of advertising, sponsorships, or promotions of any third-party page or website.</p>
      <p class="modal-para">5. You agree to receive installs and updates from time to time from Utsavlife. These updates are designed to improve, enhance, and further develop the Platform and may take the form of bug fixes, enhanced functions, new software modules and completely new versions. You agree to receive such updates (and permit Utsavlife to deliver these to you) as part of your use of the Platform.</p>
      <p class="modal-para">6. You agree not to use or launch any automated system, including without limitation, “robots,” “spiders,” or “offline readers,” that accesses the Platform in a manner that sends more request messages to Utsavlife’s servers in a given period of time than a human can reasonably produce in the same period by using a conventional on-line web browser. Notwithstanding the foregoing, Utsavlife grants the operators of public search engines permission to use spiders to copy materials from the Site for the sole purpose of and solely to the extent necessary for creating publicly available searchable indices of the materials, but not caches or archives of such materials. Utsavlife reserves the right to revoke these exceptions either generally or in specific cases at any time with or without providing any notice in this regard. You agree not to collect or harvest any personally identifiable information, including account names, from the Platform, nor to use the communication systems provided by the Platform, unless otherwise mentioned herein.</p>
      <p class="modal-para">7. You may post reviews, comments and other Service; send other communications; and submit suggestions, ideas, comments, questions or other information as long as the Service is not illegal, obscene, threatening, defamatory, invasive of privacy, infringement of intellectual property rights, or otherwise injurious to third parties or objectionable and does not consist of or contain software viruses, political campaigning, commercial solicitation, chain letters, mass mailings or any other form of spam. In other words, ensure that your conduct on the Platform is in accordance with the Platform Terms, including the User Guidelines.</p>
      <p class="modal-para">8. In your use of the Platform, you will, at all times, comply with all applicable laws and regulations.</p>
      <p class="modal-para">9. Utsavlife reserves the right to discontinue any aspect of the Platform at any time with or without notice at its sole discretion.</p>
      <p class="modal-para">You are responsible for maintaining the confidentiality of your account and password to access the Platform. You acknowledge that your account is personal to you and agree not to provide any other person with access to the Platform and to restrict access to your device to prevent any unauthorized access to your account. You agree to accept responsibility for all activities that occur under your account. You should use particular caution when accessing your account from a public or shared computer so that others are not able to view or record your username, password, or other Personal Information. You should take all necessary steps to ensure that the password is kept confidential and secure at all times, and if you have any reason to believe that your password has become known to anyone else, or if the password is being, or is likely to be, used in an unauthorized manner, you agree to immediately change your password or inform us of any unauthorized access to or use of your username or password, so that we are able to help you stop or prevent such unauthorized access. Please ensure that the details you provide us are correct and complete.</p>
      <p class="modal-para">You represent that the information provided by you at the time of the registration is correct, true and accurate, and you agree to update the same as and when there is any change in the said information. Please read our Privacy Policy to understand how we handle your information.</p>
      <p class="modal-para">Please note that we reserve the right to reject or put on-hold your registration on the Platform as may be required to comply with any legal and regulatory provisions, and also reserve the right to refuse access to the Platform, terminate accounts, remove Service at any time without providing any notice to you, and/or reserve the right to disable any account, feature, or identifiers, whether chosen by you or provided by us, at any time if, in our opinion, the said identifiers or you have violated any provision of the Platform Terms.</p>
      <p class="modal-para">Further, to access the Platform, create, publish and/or view the User-generated Service on the Platform, you will need to use a “Supported/Compatible Device” which means a personal computer, mobile phone, portable media player, or other electronic device that meets the system and compatibility requirements and on which you are authorized to operate the Platform. The Supported/Compatible Devices to access the Platform and/or avail the Services may change from time to time and, in some cases, whether a device is (or remains) a Supported/Compatible Device may depend on software or systems provided or maintained by the device manufacturer or other third parties. Accordingly, devices that are Supported/Compatible Devices at one time may cease to be Supported/Compatible Devices in the future. Thus, kindly make sure that the device that you use is compatible with our system/software to use the Platform and avail the Services offered therein.</p>
      <h4 class="modal-heading" id="booking_terms">D. Booking terms</h4>
      <p class="modal-para">For Customers, Utsavlife does not charge any price for Booked Service creation. However, certain Services offered by Utsavlife may be chargeable. Accordingly, access to certain Services and features is offered by Utsavlife through a multi- tiered paid Booking plan(s) or purchases; the details of the Services and applicable features along with their corresponding prices can be found on our Site and/or Application (“Booking”/ “Booking Service''). You can Book service by following the instructions you encounter as you navigate through the Platform.</p>
      <p class="modal-para">The terms that are applicable to Your Booking of Service(s) -</p>
      <p class="modal-para">Booking of a Service will allow you access only to the Service available under the category of Service for which you have Booked the Service.</p>
      <p class="modal-para">The Services offered, and the validity/term of your Service (“Booking Period”) may vary depending on the plan you may Booking. Hence, before you proceed to Book any Service, please read and understand the details of the Service(s) you intend to Booking on the Platform. If you are unclear about any part of the Service offering or need further clarification, then please feel free to write to us prior to your Booking at the email address provided in the ‘Contact for User Support/Queries’ section below.</p>
      <p class="modal-para">We may personalize Services and feature them as part of Bookings, including showing you recommendations on Service in the subscribed category, and other related categories that might be of interest to you. We also endeavour to continuously improve the Booking offerings to improve your Platform experience.</p>
      <p class="modal-para">The Service is of a personal nature and is solely for the benefit of the person and is not allowed to be resold by you or transferred to or shared with any other person for consideration or otherwise. In the event we get to know that any User has resold / transferred / shared Booking with another person, then Utsavlife retains the right to cancel/terminate the Booking forthwith.</p>
      <p class="modal-para">Due to the limitations, if any, imposed on us by our Service providers (who own the Service Provider), the Service Provider we make available to you under any Booking offering are subject to restrictions on viewing access and on the length of time we make them available to you. These restrictions may change over time as we add new features, devices and Service to our Booking Service. Illustratively, following are some of the restrictions that are applicable to your access to the Service (made available through Booking Service or otherwise):</p>
      <p class="modal-para">Depending on the Booking Service you have Booked, you may be given access to certain additional Services and features. The additional terms applicable to each of these additional Services may be made available to you on the Platform in the form of terms and conditions or FAQs (Frequently Asked Questions) for that specific Service or may be otherwise communicated to you. Hence, please be sure to go through the Platform Terms to understand the additional services, if any made available to you, and how you can avail the same.</p>
      <h4 class="modal-heading" id="pricing">E. Pricing, Payments and Refunds</h4>
      <p class="modal-para">1. Pricing and Payments: You can Book a Service of your choice for any category(ies) of Service by following instructions on the Platform and making the payment applicable for the Booking you intend to Book.</p>
      <p class="modal-para">Please read the below terms applicable for the Book of your Platform Booking. The below terms are to be read with any other terms communicated to you at the time of Booking of your Booking:</p>
      <p class="modal-para">a. You agree to pay all Booking prices and charges that are attributable to your account on the Platform and that you are solely responsible for payment of these prices and charges. The Bookings are payable in full and in advance and are valid until the completion of the applicable Booking Period or until otherwise cancelled or terminated in accordance with the terms of this Agreement.</p>
      <p class="modal-para">b. If you have specifically authorized us, then the payments for the applicable Bookings are automatically charged at the beginning of each billing period, unless you withdraw your authorization or submit a cancellation request to us directly through your account prior to the start of the billing period or in writing via email to the address specified in the ‘Contact for User Support/Queries’ section below. The payment for your Booking will be charged upon the anniversary of its billing period if the payments for Booking are in more than a single tranche. Subject to your specific authorization and applicable laws, you agree that Utsavlife may charge any recurring service to the credit card or debit card or account that you provide/link at the time of your first Booking of the Booking or as updated by you through your account on the Platform, provided such updating takes place prior to upcoming billing period.</p>
      <p class="modal-para">c. If you have not completed payments for your Bookings, we may restrict / suspend your booked service(s). until it becomes current and paid in full.</p>
      <p class="modal-para">d. We reserve the right to pursue the price owed to us using collection methods which may include charging other payment methods on file with us and/or retaining collection agencies or legal counsel.</p>
      <p class="modal-para">e. The entity within the Utsavlife group to which your payments will be made will be on the basis of Annexure 1.</p>
      <p class="modal-para">f. Your payments to Utsavlife shall be subject to applicable taxes including without limitation Goods and Service Taxes (GST) and Value Added Taxes (VAT) or other similar taxes as may be applicable in your country of residence/from where you have created your account on the Platform/ Booking the underlying Bookings.</p>
      <p class="modal-para">g. We reserve the right to change/revise the pricing of the Bookings. For existing Bookings for which the applicable prices have been already received by us, we will implement the price changes during the next billing period.</p>
      <p class="modal-para">h. We further reserve the right to offer custom plans and pricing (including discounts and / or special offers) in addition to what is offered on the Platform, which include offering custom billing and payment terms, that are different from our standard terms.</p>
      <p class="modal-para">i. We use third-party payment gateways and/or aggregators to process payments applicable to the Services offered by us. Third-party payment gateway(s) made available to you may vary depending on the Booking you choose. Similarly, we have also enabled integration of third-party payment providers to facilitate better payment options to you, which may vary depending on your territory or the Booking you choose. Third-party payment gateways/aggregators and third- party payment providers shall collectively be referred to as “Third-Party Service Providers”.</p>
      <p class="modal-para">Third-Party Service Providers may also charge you prices to use or access their services and may require your Personal Information to complete any transaction for the Platform. Further, to facilitate completion of your payments to us through the Platform or avail the payment options provided to you, you may be redirected to an external website operated by the Third-Party Service Provider. We cannot and do not (i) guarantee the adequacy of the privacy and security practices employed by or the Service and media provided by the Third-Party Service Provider or its respective websites or (ii) control collection or use of your Personal Information by such Third-Party Service Provider. Hence, prior to using any services offered by a Third-Party Service Provider, we suggest that you read their terms and conditions, privacy policy and other policies that may apply, to understand their terms of usage and to understand how your Personal information is being processed. Utsavlife is not affiliated to any Third-Party Service Provider and neither Utsavlife nor any of the Third-Party Service Providers are agents or employees of the other.</p>
      <p class="modal-para">Further, pursuant to the payment option you may choose, you may be required to enter into a separate agreement with the relevant Third-Party Service Provider. This agreement with the Third-Party Service Provider is an independent contract/agreement between you and such Third-Party Service Provider and Utsavlife shall in no manner be a party to the same. Utsavlife is only facilitating various payment options to you and is not offering the payment by itself in any manner.</p>
      <p class="modal-para">j. You agree that you are solely responsible for all charges that occur through such Third-Party Service Providers and acknowledge and agree to indemnify, defend, and hold harmless Utsavlife, its licensors, their affiliates, and their respective officers, directors, employees, and agents from any loss arising out of or related to the use of the Platform or any Bookings made through the Platform. This obligation will survive your use of the Platform and termination of your Agreement with us. For purposes of the Platform Terms, “Loss” means all losses, liabilities, damages, awards, settlements, claims, suits, proceedings, costs, and expenses (including reasonable legal prices and disbursements and costs of investigation, litigation, settlement, judgment, interest, and penalties). Utsavlife shall not be liable to you for any claims arising out of any act or omission on the part of the Third-Party Service Provider(s) including, but not limited to, any lost, stolen, or incorrectly processed payments. Utsavlife expressly disclaims any responsibility and liability for all services provided by the Third-Party Service Provider(s).</p>
      <p class="modal-para">k. Please note that all Booking payments are collected by Utsavlife only through the Platform and not through any third parties (except Third-Party Service Provider(s)). We do not usually authorize any third party (except Third-Party Service Provider(s)) to collect monies on our behalf; however, if we have authorized any third party then such third party will have received a written authorization from Utsavlife either by way of any agreement or an authorization letter. Kindly verify with such a third party before you make any payments to them, alternatively, you can always check with us by writing to us at the email address provided under the ‘Contact for User Support/Queries’ section below.</p>
      <p class="modal-para">l. Further, Utsavlife is solely authorized to offer discounts / offers, if any, on the Booking prices. These discounts / offers are communicated on the Platform or via direct communication to you from Utsavlife via email, SMS, phone, or such other means of communication, and can be availed only through the Platform, unless otherwise specifically communicated by Utsavlife. Other than Utsavlife, no person, including without limitation, Service providers or any third-party platform, are allowed to offer any discounts on the Booking prices offered on the Platform. Utsavlife shall not be liable for any claims arising from such unauthorized discounts / offers offered by any person (including any third- party platform or Service Provider), other than Utsavlife.</p>
      <p class="modal-para"><b>2. Cancellation and Refund Policy:</b></p>
      <p class="modal-para">You may cancel your booked service through your account on the Platform. However, please note that the cancellation will become effective at the end of the then-current billing period; in other words, we will not renew your booked Service, but the existing Booked service  will continue until the end of its billing period and there shall be no refund of the price already paid for the same, unless otherwise specified in the Refund Policy. So, please read these terms and conditions and the <a href="#" data-bs-toggle="modal" data-bs-target="#refund" data-bs-dismiss="modal">Refund Policy</a> carefully before purchasing any Service.</p>
      <p class="modal-para">When you cancel your Booking, Utsavlife may disable access to features made available to you upon your Booked service, while your account may continue to exist on the Platform.</p>
      <h4 class="modal-heading" id="use_of_platform2">F. Use of the Platform</h4>
      <p class="modal-para">Subject to the Platform Terms, Utsavlife hereby grants you a non- exclusive, non-transferable, non-sublicensable, limited license to access and use the Utsavlife Platform for your own personal, non-commercial and private use on an ‘as is’ basis in accordance with these Terms and Conditions and other Platform Terms.</p>
      <p class="modal-para">Subject to payment of the Booking price, and your compliance (as a customer) with all Platform Terms, Utsavlife and the Service providers grant you (as a customer) a non- exclusive, non-transferable, non-sublicensable, limited license, during the applicable Booking Period, to access and view the Service, non-commercial, private use only, in accordance with the Platform Terms. </p>
      <p class="modal-para">If you are a Service Provider, Utsavlife grants you a limited, non-exclusive, non- transferable, non-sublicensable license to access and use the Platform for Your own personal and commercial use in accordance with these Platform Terms and any other agreement(s) that may be executed between you (as a Service Provider) and Utsavlife (as applicable). Except as expressly permitted by Utsavlife under these Platform Terms or otherwise in writing to you, you will not reproduce, duplicate, copy, sell, redistribute, create derivative works or otherwise exploit the Platform or any portion of the Platform (including but not limited to any copyrighted material, trademarks, or other proprietary information).</p>
      <p class="modal-para">Except as expressly permitted under any of the Platform Terms or otherwise in writing, you will not reproduce, duplicate, copy, sell, redistribute, create derivative works or otherwise exploit the Platform or any portion of the Platform (including but not limited to any copyrighted material, trademarks, or other proprietary information).</p>
      <h4 class="modal-heading" id="content_conduct">G. Service and Conduct</h4>
      <p class="modal-para">1. As a User, you may submit User-generated Service (as defined under the ‘Intellectual Property’ section below) on the Platform. However, you must understand that Utsavlife does not guarantee any confidentiality with respect to any User-generated Service you submit.</p>
      <p class="modal-para">2. You shall be solely responsible for your own User-generated Service and the consequences of submitting and publishing such Service on the Platform. You affirm, represent, and warrant that you own or have the necessary licenses, rights, consents, and permissions to publish the User-generated Service that you submit. You further agree that User-generated Service you submit on the Utsavlife Platform will not contain third party copyrighted material, or material that is subject to other third-party proprietary rights, unless you have permission from the rightful owner of the material, or you are otherwise legally entitled to post the material and to grant Utsavlife the necessary license and rights required under the Platform Terms. You shall solely be responsible for all claims in respect of your User-generated Service published on the Platform.</p>
      <p class="modal-para">3. For clarity, you retain your ownership rights in your User-generated Service. However, you grant a limited license to Utsavlife to make available the User-generated Service on the Platform. Please read the ‘Intellectual Property’ section below to know the exact nature of license and rights you grant to Utsavlife.</p>
      <p class="modal-para">4. Furthermore, you confirm that you shall not host, display, upload, modify, publish, transmit, store, update or share User-generated Service or any information on the Platform that:</p>
      <p class="modal-para">a. belongs to another person and to which you do not have any right;</p>
      <p class="modal-para">b. is defamatory, obscene, pornographic, invasive of another’s privacy including bodily privacy, insulting or harassing on the basis of gender, libellous, racially or ethnically objectionable, relating or encouraging money laundering or gambling, or otherwise inconsistent with or contrary to the laws in force;</p>
      <p class="modal-para">c. is harmful to a child;</p>
      <p class="modal-para">d. infringes any patent, trademark, copyright or other proprietary rights of another;</p>
      <p class="modal-para">e. violates any law, statue, ordinance or regulation or Platform Terms;</p>
      <p class="modal-para">f. deceives or misleads any User about the origin of the message or knowingly and intentionally communicates any information which is patently false or misleading in nature but may reasonably be perceived as a fact;</p>
      <p class="modal-para">g. impersonates another person;</p>
      <p class="modal-para">h. threatens the unity, integrity, defence, security or sovereignty of India, friendly relations with foreign States, or public order, or causes incitement to the commission of any cognizable offence or prevents investigation of any offence or is insulting other nation;</p>
      <p class="modal-para">i. contains software virus or any other computer code, file or program designed to interrupt, destroy or limit the functionality of any computer resource;</p>
      <p class="modal-para">j. is patently false and untrue, and is written or published in any form, with the intent to mislead or harass a person, entity or agency for financial gain or to cause any injury to any person;</p>
      <p class="modal-para">k. False, inaccurate or misleading;</p>
      <p class="modal-para">l. obscene or contain pornography;</p>
      <p class="modal-para">m. Contain any viruses, trojan horses, worms, cancelbots or other computer programming routines that may damage, detrimentally interfere with, surreptitiously intercept, or expropriate any system, data or Personal Information.</p>
      <p class="modal-para">5. Your conduct on the Platform shall strictly be in accordance with the User Guidelines and other Platform Terms.</p>
      <p class="modal-para">6. You understand that as a User you may interact with Minors/Children (refer to ‘Right to Access and Account Creation’ section above) on the Platform; accordingly, you shall make yourself fully aware of our <a href="#" data-bs-toggle="modal" data-bs-target="#minor_inter" data-bs-dismiss="modal">Minor &amp; Customer Interaction Guidelines</a> and conduct yourself in accordance thereof.</p>
      <p class="modal-para">7. You understand and confirm that you shall not during your use of the Utsavlife Platform at any time post or publish any Service, comments or act in any way which will amount to harassment of any other User. If at any given point it comes to Utsavlife’s notice that you have engaged in any kind of harassment of other Users, then in such a case you agree that Utsavlife shall have the sole right to suspend/terminate your account with immediate effect and without any notice of such suspension or termination and we also reserve the right in our sole discretion to initiate any legal proceedings against you in such cases.</p>
      <p class="modal-para">8. Utsavlife does not endorse any User-generated Service submitted on the Utsavlife Platform by any User, or any opinion, recommendation, or advice expressed therein, and Utsavlife expressly disclaims any and all liability in connection with User-generated Service. Utsavlife does not permit copyright infringing activities and infringement of intellectual property rights on the Utsavlife Platform, and Utsavlife will remove all User-generated Service if properly notified that such User-generated Service infringes on another’s intellectual property rights in line with its obligations as an ‘intermediary’. Utsavlife reserves the right to remove User- generated Service without prior notice if it has reason to believe that the User- generated Service is violative of these Terms and Conditions. Please refer to the <a href="#" data-bs-toggle="modal" data-bs-target="#takedown" data-bs-dismiss="modal">Takedown Policy</a> and ‘Copyright, Trademarks and other Intellectual Property Rights ‘section below to understand the process to notify Utsavlife about any infringing Service and the process of takedown of infringing Service followed by Utsavlife.</p>
      <p class="modal-para">9. You shall not engage in any activity that increases/optimizes the User views on any particular Service Provider; these activities, without limitation, include creating multiple fake accounts as Customers, either by yourself or through a third-party.</p>
      <p class="modal-para">10. You shall not engage in any activity that will negatively impact Utsavlife and/or other Users of the Platform, including without limitation, activities that involve screen- recording, screen-casting or downloading on any other device of any Service Provider Service (live or recorded) in any manner that is not directly facilitated as feature within the Platform and/or sharing or otherwise publishing such screen-recorded Service on third-party platforms, either for a cost or otherwise. If Utsavlife becomes aware of your engagement, either by yourself or through a third-party, in any such activity, then Utsavlife may immediately terminate your or such User’s access / Booking along with termination and removal of access to all downloaded Service with a right to initiate appropriate legal action, at the sole discretion of Utsavlife.</p>
      <h4 class="modal-heading" id="communications">H. Communications</h4>
      <p class="modal-para">When you visit the Platform, you are communicating with us electronically. You may be required to provide a valid phone number while creating any account with us or while enrolling or purchasing any Service. We may communicate with you by e- mail, SMS, phone call or by posting notices on the Platform or by any other mode of communication. By providing your information you authorize Utsavlife, its affiliates, and their respective employees, agents, and contractors to initiate electronic communications by email, telephone calls, or such other mode of communication with respect to your use of the Platform and regarding the products and services offered by Utsavlife and its affiliates. These communications may be made by or on behalf of Utsavlife, even if your phone number is registered on any state or federal do not call list. Telephone calls may be recorded. You acknowledge that your telephone operator and/or internet service provider may have levied certain charges on you vis-à-vis your communications with Utsavlife as it constitutes availing their services, and you agree to be responsible for all such charges, and Utsavlife will not be responsible for any such charges. Do not submit your information if you do not consent to being contacted by telephone, text, email or such other mode of communication. Further, you will always have an option to unsubscribe / opt out from any promotional communications sent by Utsavlife and / or its affiliates either by following the relevant instructions that may be communicated via text, email or such other mode of communication in which you received a promotional communication or by disabling the options provided within your account on the Platform.</p>
      <p class="modal-para">Please note that –</p>
      <p class="modal-para">1. If you opt out of promotional communications, we may still send you transactional communications, such as service announcements, administrative and legal notices, and information about your account, without offering you the opportunity to opt out of these communications. If you no longer wish to use our Platform or receive any communications from us (except for those that are legally required), then you may delete your account by either writing to us at the email address provided under ‘Contact for User Support/Queries ‘section below by using the option enabled within the Platform; and</p>
      <p class="modal-para">2. opting out of promotional communications only affects future communications from us. If we have already provided your information to a third party (as stated in our Privacy Policy) before you changed your preferences or updated your information, you may have to change your preferences directly with that third party.</p>
      <p class="modal-para">3. We do not sell your Personal Information to third parties, and we do not use your name or name of your company in marketing statements without your consent.</p>
      <p class="modal-para">Further, in respect of interactions between Users - Utsavlife is only an intermediary and does not monitor any of the interactions that take place between Users on the Platform, but Utsavlife has clearly laid out the terms and guidelines a User must follow in their conduct on the Platform as part of the Platform Terms; and if Utsavlife receives from any User a complaint of misconduct against you, in any form, or if Utsavlife otherwise deems necessary, Utsavlife reserves the right to suspend or terminate your access to any the Platform or any part thereof at any time, with or without giving any notice or reason.</p>
      <p class="modal-para">You acknowledge that any User-generated Service (including without limitation any Service Provider Service, chats, postings, or materials posted by the Users) posted by you on part of the Platform, is neither endorsed nor controlled by us. You further understand and agree that you shall be solely responsible for any User-generated Service published by you on the Platform, including its legality, reliability, accuracy, and appropriateness, and shall be solely liable for the consequences of its publication. You represent and warrant that you own and control all rights in and to any User-generated Service uploaded by you on the Platform, or that you have the necessary licenses or permissions or are legally entitled to use and reproduce such User-generated Service on the Platform.</p>
      <h4 class="modal-heading" id="processing_personal_information">I. Processing of Personal Information</h4>
      <p class="modal-para">All our collection, processing, sharing and storing of any Personal Information collected from you shall be in accordance with our Privacy Policy. Kindly read the same to understand the security measures undertaken by Utsavlife to safeguard your Personal Information. Should you have any queries in respect of the same, please feel free to write to us at <a href="mailto:info@utsavlife.com">info@utsavlife.com</a>.</p>
      <h4 class="modal-heading" id="intellectual_property_license">J. Intellectual Property and License to User-generated Service</h4>
      <p class="modal-para"><b>1. User-generated Service:</b> You shall remain the sole owner of any Service uploaded or published or submitted or posted by you on the Platform, including without limitation, the Service published by you as a Service Provider and/or any text, image, media, written statements or other Service posted or published by a User anywhere on the Platform including without limitations in the comments section (“User-generated Service”)and Utsavlife does not claim any ownership over any User-generated Service uploaded/published by any User on the Platform.</p>
      <p class="modal-para">By submitting the User-generated Service on the Platform, you hereby grant Utsavlife a limited, worldwide, non-exclusive, royalty-free, sub-licensable and transferable license to use, reproduce, distribute, share, display, publish, retain, make available online and/or electronically transmit such User-generated Service as well as technical information collected via the Platform to the extent necessary (i) to provide the Platform and our Services; (ii) to perform our obligations under the Platform Terms and other written agreement with the User; (iii) to provide, monitor, correct, and improve the Platform and Services related thereto; (iv) for the Utsavlife Platform and Utsavlife’s (and its successors’, subsidiaries and affiliates’) business, including without limitation for promoting and redistributing part or all of the Utsavlife Platform in any media formats and through any media channels; (v) to de-identify User data such that there is no reasonable basis to believe that the information can be used, alone, or in combination with other reasonably available information, to identify any individual or to identify User as the source of such data; (vi) to aggregate User data with other data; and (vii) to comply with applicable laws. However, please note that we will never disclose aggregated or de-identified information in a manner that could identify you as an individual, and all your information shall be processed in accordance with our Privacy Policy.</p>
      <p class="modal-para">You also hereby grant each User of the Platform a limited, non-exclusive license to access your User-generated Service through the Platform.</p>
      <p class="modal-para"><b>2. Utsavlife Service:</b> Utsavlife and / or its affiliates own all information and materials (in whatever form or media) provided or communicated to you by or on behalf of Utsavlife including but not limited to, the Platform, illustrations, letters, images, ideas, concepts, the layout, design, flow, look and price of the Platform, logos, marks, graphics, audio files, video files, any software which is owned by or licensed to Utsavlife and / or its affiliates, the underlying source and object code, instructions embedded in any form of digital documents and other data, information, or material made available to you by Utsavlife (“Utsavlife Service”). Utsavlife Service specifically excludes any Service uploaded by the Users, including without limitation, any User-generated Service on the Platform. Utsavlife Service, including its trademarks, will not be used, modified, or altered by you in any way. You acknowledge and agree that you do not acquire any ownership or rights to the Utsavlife Service or the Platform by use of the Platform. You acknowledge and agree that the Utsavlife Service is protected by the copyright, trademark, patent, trade secret and other intellectual property or proprietary rights laws and any unauthorized use, reproduction, modification, distribution, transmission, republication, display or performance of the Utsavlife Service and any component thereof is strictly prohibited.</p>
      <p class="modal-para">You confirm and undertake not to utilize any data mining tools, robots, or similar data gathering and extraction tools to extract for re-utilization of any substantial parts of this Platform, without Utsavlife’s express prior written consent.</p>
      <h4 class="modal-heading" id="feedback">K. Priced-back</h4>
      <p class="modal-para">If any User(s) submits suggestions, ideas, comments, or questions containing product priced-back about the Platform or any of the Services, either through the Platform or otherwise (“Priced-back”), then such User(s) grants Utsavlife and its affiliates a worldwide, non-exclusive, royalty-free, perpetual, and irrevocable right to use (and full right to sublicense), reproduce, modify, adapt, publish, translate, create derivative works from, distribute, transmit, and display such Pricedback in any form. Users shall have no intellectual property right in the Platform as a result of Utsavlife’s incorporation of their Priced-back in the Platform.</p>
      <h4 class="modal-heading" id="copyrights">L. Copyright, Trademarks, and other Intellectual Property Rights</h4>
      <p class="modal-para">At Utsavlife, we respect the intellectual property of others just as much ours and, hence, if you believe that your intellectual property rights have been used in a way that gives rise to concerns of infringement of your intellectual property (including your copyrights and trademarks), then kindly write to us at <a href="mailto:info@utsavlife.com">info@utsavlife.com</a> with complete details as required under <a href="#" data-bs-toggle="modal" data-bs-target="#takedown" data-bs-dismiss="modal">Takedown Policy</a>. If Utsavlife has knowledge of or has any reason to believe that any User-generated Service on the Platform violates the intellectual property rights of Utsavlife or other Users, then we reserve the right to remove access to such Service in accordance with takedown practices specified in <a href="#" data-bs-toggle="modal" data-bs-target="#takedown" data-bs-dismiss="modal">Takedown Policy</a>.</p>
      <p class="modal-para">If Utsavlife has knowledge of or has any reason to believe that any User-generated Service on the Platform violates the intellectual property rights of Utsavlife or other Users, then we reserve the right to remove access to such Service in accordance with takedown practices specified in <a href="#" data-bs-toggle="modal" data-bs-target="#takedown" data-bs-dismiss="modal">Takedown Policy.</a></p>
      <h4 class="modal-heading" id="claims_against_user_content">M. Claims Against User-generated Service</h4>
      <p class="modal-para">Utsavlife does not monitor or have any control over or does not warrant, and makes no claim or representation regarding the accuracy, completeness, or usefulness of any User-generated Service provided on the Platform by its Users and accepts no responsibility for reviewing changes or updates to, or the quality, Service, policies, nature or reliability of, such User-generated Service. Utsavlife disclaims all liability and responsibility arising from any reliance placed on such materials by you. All statements and/or opinions expressed in these materials, and all articles and responses to questions and other Service, other than the Utsavlife Service, are solely the responsibility of the User providing those materials.</p>
      <h4 class="modal-heading" id="unacademy_rights">N. Utsavlife’s Rights</h4>
      <p class="modal-para">In respect of the entire Platform, Utsavlife reserves the following rights:</p>
      <p class="modal-para">1. Utsavlife reserves the right to put on-hold or reject or suspend or terminate your registration on the Platform for the purpose of complying with the legal and regulatory requirements.</p>
      <p class="modal-para">2. Utsavlife reserves the right to remove you and/or the User-generated Service without notice if you violate any provisions of the Platform Terms.</p>
      <p class="modal-para">3. Utsavlife may modify, terminate, or refuse to provide Services at any time for any reason, without notice.</p>
      <p class="modal-para">4. Notwithstanding anything contrary stated in the Platform Terms, in its sole discretion, Utsavlife may remove anyone from the Platform at any time for any reason.</p>
      <p class="modal-para">5. Utsavlife reserves the right to access your account and/or the User-generated Service in order to respond to requests for technical support, to maintain the safety and security of the Platform, legal purposes and for other legitimate business purposes, as necessary, in Utsavlife’s discretion.</p>
      <p class="modal-para">6. Utsavlife has no obligation to monitor any Service that appears on the Platform or review any conduct occurring through the Platform, including any interactions between Users, however, if Utsavlife receives notice or becomes aware of, any violation of the Platform Terms, then, Utsavlife reserves the right to refuse your access to the Platform, terminate accounts or remove such violating Service at any time without notice to you.</p>
      <h4 class="modal-heading" id="platform_availability">O. Platform Availability</h4>
      <p class="modal-para">Your access to the Platform may occasionally be suspended or restricted to allow for repairs, maintenance, or due to the introduction of new facilities or services at any time without prior notice. We will attempt to limit the frequency and duration of any such suspension or restriction. You agree that Utsavlife will not be liable for any losses that may be incurred by you if for any reason all or part of the Platform is unavailable at any time or for any period for use.</p>
      <h4 class="modal-heading" id="deletion_of_account">P. Deletion of Account</h4>
      <p class="modal-para">As a Customer, you may delete your account at any time by either writing to us at the email address provided under ‘Contact for User Support/Queries’ section below or by using the delete option provided within your account on the Platform (if available). If your account is deleted (regardless of the reason), you will no longer have access to your account on the Platform and your User-generated Service may no longer be available; any deletion once processed is irrecoverable. Utsavlife is not responsible for the loss of your information and/or User-generated Service upon deletion and Utsavlife shall not be liable to any party in any way for the inability to access User-generated Service arising from any deletion. Please note that all accounts will remain active unless you explicitly ask us to delete it, and applicable Booking payments shall continue to be deducted until cancelled by you or until your account is deleted on your request (as stated in the ‘Pricing and Payments’ section above) or otherwise terminated in accordance with the Platform Terms</p>
      <p class="modal-para">Please note that we may not be able to delete all communications or photos, files, or other documents publicly made available by you on the Platform, however, we shall anonymize your Personal Information (as defined in the Privacy Policy) in such a way that you can no longer be identified as an individual in association with such information made available by you on the Platform. We will never disclose aggregated or de-identified information in a manner that could identify you as an individual.</p>
      <p class="modal-para">If you are a Service Provider, your access and use of the Platform may be subject to a separate agreement with Utsavlife and shall be collectively governed by the terms of such agreement, the Terms and Conditions and other Platform Terms.</p>
      <h4 class="modal-heading" id="disclaimer">Q. Disclaimer:</h4>
      <p class="modal-para">YOU AGREE THAT THE PLATFORM, SERVICE, AND ALL MATERIALS ARE PROVIDED ON AN “AS IS” AND “AS AVAILABLE” BASIS AND YOUR USE OF THE PLATFORM SHALL BE AT YOUR SOLE RISK. TO THE FULLEST EXTENT PERMITTED BY LAW, UTSAVLIFE, ITS OFFICERS, DIRECTORS, EMPLOYEES, AND AGENTS DISCLAIM AND EXCLUDE ALL WARRANTIES, EXPRESS OR IMPLIED, IN CONNECTION WITH THE PLATFORM AND YOUR USE THEREOF. TO THE FULLEST EXTENT PERMITTED BY LAW, UTSAVLIFE EXCLUDES ALL WARRANTIES, CONDITIONS, TERMS OR REPRESENTATIONS ABOUT THE ACCURACY, SECURITY, RELIABILITY, QUALITY, AVAILABILITY OR COMPLETENESS OF THE PLATFORM, USER-GENERATED SERVICE ON THE PLATFORM, OR THE SERVICE OF ANY SITES SO LINKED AND ASSUMES NO LIABILITY OR RESPONSIBILITY FOR ANY (I) ERRORS, MISTAKES, OR INACCURACIES OF USER-GENERATED SERVICE OR ANY SERVICE ON THE PLATFORM, (II) PERSONAL INJURY OR PROPERTY DAMAGE, OF ANY NATURE WHATSOEVER, RESULTING FROM YOUR ACCESS TO AND USE OF THE PLATFORM, (III) ANY UNAUTHORIZED ACCESS TO OR USE OF OUR SECURE SERVERS AND/OR ANY AND ALL PERSONAL INFORMATION AND/OR FINANCIAL INFORMATION STORED THEREIN, (IV) ANY INTERRUPTION OR CESSATION OF TRANSMISSION TO OR FROM THE PLATFORM, (IV) ANY BUGS, VIRUSES, TROJAN HORSES, OR THE LIKE WHICH MAY BE TRANSMITTED TO OR THROUGH THE PLATFORM BY ANY THIRD PARTY, AND/OR (V) ANY ERRORS OR OMISSIONS IN ANY USER-GENERATED SERVICE OR ANY OTHER SERVICE OR FOR ANY LOSS OR DAMAGE OF ANY KIND INCURRED AS A RESULT OF THE USE OF ANY USER- GENERATED SERVICE OR ANY OTHER SERVICE THAT IS POSTED, EMAILED, TRANSMITTED, OR OTHERWISE MADE AVAILABLE VIA THE PLATFORM AS UTSAVLIFE IS STRICTLY AN INTERMEDIARY AS UNDER THE INFORMATION TECHNOLOGY ACT, 2000. UTSAVLIFE DOES NOT WARRANT, ENDORSE, GUARANTEE, OR ASSUME RESPONSIBILITY FOR ANY USER- GENERATED SERVICE OR THE PLATFORM ADVERTISED OR OFFERED BY A THIRD PARTY THROUGH THE PLATFORM OR ANY HYPERLINKED SERVICES OR FEATURED IN ANY BANNER OR OTHER ADVERTISING, AND UTSAVLIFE WILL NOT BE A PARTY TO OR IN ANY WAY BE RESPONSIBLE FOR MONITORING ANY TRANSACTION BETWEEN YOU AND THIRD-PARTY PROVIDERS OF USER-GENERATED SERVICE OR SERVICES. AS WITH THE BOOKING OF A SERVICE THROUGH ANY MEDIUM OR IN ANY ENVIRONMENT, YOU SHOULD USE YOUR BEST JUDGMENT AND EXERCISE CAUTION WHERE APPROPRIATE.</p>
      <h4 class="modal-heading" id="limitation_of_liability">R. Limitation of Liability</h4>
      <p class="modal-para">TO THE FULLEST EXTENT PERMITTED BY LAW, IN NO EVENT SHALL UTSAVLIFE, ITS AFFILIATES, THEIR RESPECTIVE OFFICERS, DIRECTORS, EMPLOYEES, OR AGENTS, BE LIABLE TO YOU FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, PUNITIVE, LOSSES OR EXPENSES OR CONSEQUENTIAL DAMAGES WHATSOEVER RESULTING FROM ANY (I) ERRORS, MISTAKES, OR INACCURACIES OF USER-GENERATED SERVICE OR ANY OTHER SERVICE AVAILABLE AT UTSAVLIFE, (II) PERSONAL INJURY OR PROPERTY DAMAGE, OF ANY NATURE WHATSOEVER, RESULTING FROM YOUR ACCESS TO AND USE OF OUR UTSAVLIFE PLATFORMS, (III) ANY UNAUTHORIZED ACCESS TO OR USE OF OUR SECURE SERVERS AND/OR ANY AND ALL PERSONAL INFORMATION AND/OR FINANCIAL INFORMATION STORED THEREIN, (IV) ANY INTERRUPTION OR CESSATION OF TRANSMISSION TO OR FROM THE UTSAVLIFE PLATFORM, (IV) ANY BUGS, VIRUSES, TROJAN HORSES, OR THE LIKE, WHICH MAY BE TRANSMITTED TO OR THROUGH OUR UTSAVLIFE PLATFORMS BY ANY THIRD PARTY, AND/OR (V) ANY ERRORS OR OMISSIONS IN ANY USER-GENERATED SERVICE OR ANY OTHER SERVICE OR FOR ANY LOSS OR DAMAGE OF ANY KIND INCURRED AS A RESULT OF YOUR USE OF ANY SERVICE POSTED, EMAILED, TRANSMITTED, OR OTHERWISE MADE AVAILABLE VIA THE UTSAVLIFE PLATFORM, WHETHER BASED ON WARRANTY, CONTRACT, TORT, OR ANY OTHER LEGAL THEORY, AND WHETHER OR NOT UTSAVLIFE IS ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.</p>
      <p class="modal-para">WE UNDERSTAND THAT, IN SOME JURISDICTIONS, WARRANTIES, DISCLAIMERS AND CONDITIONS MAY APPLY THAT CANNOT BE LEGALLY EXCLUDED, IF THAT IS TRUE IN YOUR JURISDICTION, THEN TO THE EXTENT PERMITTED BY LAW, UTSAVLIFE AND ITS AFFILIATES LIMIT THEIR LIABILITY FOR ANY CLAIMS UNDER THOSE WARRANTIES OR CONDITIONS TO SUPPLYING YOU THE UTSAVLIFE PLATFORM AGAIN.</p>
      <p class="modal-para">YOU SPECIFICALLY ACKNOWLEDGE THAT UTSAVLIFE SHALL NOT BE LIABLE FOR USER- GENERATED SERVICE OR THE DEFAMATORY, OFFENSIVE, OR ILLEGAL CONDUCT OF ANY THIRD PARTY AND THAT THE RISK OF HARM OR DAMAGE FROM THE FOREGOING RESTS ENTIRELY WITH YOU.</p>
      <p class="modal-para">THE UTSAVLIFE PLATFORM IS CONTROLLED AND OFFERED BY UTSAVLIFE AND / OR ITS AFFILIATES DEPENDING UPON YOUR JURISDICTION. UTSAVLIFE MAKES NO REPRESENTATIONS THAT THE UTSAVLIFE PLATFORM IS APPROPRIATE OR AVAILABLE FOR USE IN OTHER LOCATIONS. THOSE WHO ACCESS OR USE THE UTSAVLIFE PLATFORM FROM OTHER JURISDICTIONS DO SO AT THEIR OWN VOLITION AND ARE RESPONSIBLE FOR COMPLIANCE WITH LOCAL LAW.</p>
      <h4 class="modal-heading" id="indemnity_and_release">S. Indemnity and Release</h4>
      <p class="modal-para">To the extent permitted by applicable law, you agree to defend, indemnify and hold harmless Utsavlife, its affiliates, their respective officers, directors, employees and agents, from and against any and all claims, damages, obligations, losses, liabilities, costs or debt, and expenses (including but not limited to attorney’s prices) arising from: (i) your use of and access to the Utsavlife Platform; (ii) your violation of any term of the Platform Terms; (iii) your violation of any third party right, including without limitation any copyright, property, or privacy right; (iv) any claim that your User-generated Service caused damage to a third party; or (v) violation of any applicable laws. This defence and indemnification obligation will survive these Terms and Conditions and your use of the Utsavlife Platform.</p>
      <p class="modal-para">You hereby expressly release Utsavlife, its affiliates and any of their respective officers, directors, employees and agents from any cost, damage, liability or other consequence of any of the actions/inactions of any third-party vendors or service providers and specifically waive any claims or demands that you may have in this behalf against any of Utsavlife, its affiliates and any of their respective officers, directors, employees and agents under any statute, contract or otherwise</p>
      <h4 class="modal-heading" id="governing_laws">T. Applicable Law and Jurisdiction</h4>
      <p class="modal-para">The applicable law and jurisdiction is dependent upon which entity forming part of the Utsavlife group is offering you the Platform and the Services, which in turn is dependent upon the Booking chosen by you. Illustratively, Services provisioned in respect of Bookings pertaining to India, Utsavlife India shall be the entity rendering the Services and, accordingly, the Agreement shall be governed by and construed in accordance with the laws of India; and you agree, as we do, to submit to the exclusive jurisdiction of the courts at Bangalore, Karnataka, India. Similarly, Services in respect of Bookings pertaining to US shall be rendered by Utsavlife Inc. and, accordingly, in such cases, the Agreement shall be governed by and construed in accordance with the laws of State of Delaware, U.S.A. and you agree, as we do, to submit to the exclusive jurisdiction of the courts at State of Delaware, U.S.A.</p>
      <h4 class="modal-heading" id="general_provisions">U. General Provisions:</h4>
      <p class="modal-para"><b>1. Legal Notices:</b> In the event of any other disputes or claims arising from the use of the Utsavlife Platform, please get in touch with us at <a href="mailto:info@utsavlife.com">info@utsavlife.com</a> </p>
      <p class="modal-para"><b>2. Modification, Amendment or Termination:</b> Utsavlife may, in its sole discretion, modify or revise the Agreement and policies at any time, and you agree to be bound by such modifications or revisions. Your continued use of the Platform post any modification of the Agreement shall be taken as your consent and acceptance to such modifications. Nothing in the Agreement shall be deemed to confer any third-party rights or benefits. You are advised to check our Platform frequently to see recent changes and to keep yourself updated with the most recent updates.</p>
      <p class="modal-para"><b>3. Force Majeure:</b> Utsavlife shall not be liable for failure to perform, or the delay in performance of, any of its obligations if, and to the extent that, such failure or delay is caused by events substantially beyond its control, including but not limited to acts of God, acts of the public enemy or governmental body in its sovereign or contractual capacity, war, terrorism, floods, fire, strikes, epidemics, civil unrest or riots, power outage, and/or unusually severe weather.</p>
      <p class="modal-para"><b>4. Miscellaneous:</b> If any part of the Agreement is found to be unlawful, void or unenforceable, that part of the Agreement will be deemed severable and will not affect the validity and enforceability of any remaining provisions. Any notice required to be given in connection with the Platform shall be in writing and sent to the registered office of Utsavlife. We do not guarantee continuous, uninterrupted or secure access to the Platform, and operation of the Platform may be interfered by numerous factors outside our control. Headings are for reference purpose only and in no way define, limit, construe or describe the scope or extent of such section. Our failure to act with respect to any breach by you or others does not waive our right to act with respect to subsequent or similar breaches.</p>
      <h4 class="modal-heading" id="user_support">V. Contact for User Support/Queries</h4>
      <p class="modal-para">For queries relating to Services offered by Utsavlife, please write to us at <a href="mailto:info@utsavlife.com">info@utsavlife.com</a></p>
      <h4 class="modal-heading" id="contact_us">W. Contact Us</h4>
      <p class="modal-para">If you have concerns or queries regarding the Platform Terms, you may write to us by email at <a href="mailto:info@utsavlife.com">info@utsavlife.com</a> or by post to:</p>
      <p class="modal-para"><b>Utsavlife Private Limited</b></p>
      <p class="modal-para">R- 16, Uttam Nagar west metro station Gate Number 1,</p>
      <p class="modal-para">Metro pillar Number 690, Bikaner vali Gali, New Delhi 110059, India.</p>
      <h4 class="modal-heading">Annexure A</h4>
      <p class="modal-para">All Services offered on the Platform other than those offered under the ‘International Goals’ section on the Platform are provisioned by Utsavlife Private Limited (Utsavlife India), R- 16, Uttam Nagar west metro station Gate Number 1, Metro pillar Number 690, Bikaner vali Gali, New Delhi, India 110059.</p>
      <p class="modal-para">Terms and Conditions – Version 1.0</p>
      <p class="modal-para">Last Updated on 16th JANUARY, 2023</p>
      </div>
       """,
          // remove padding margin from h1 and h4
          customStylesBuilder: (e) {
            if (e.classes.contains("modal-heading")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            if (e.classes.contains("modal-heading2")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            if (e.classes.contains("modal-para")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            if (e.classes.contains("modal-para")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            if (e.classes.contains("modal-heading2")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            if (e.classes.contains("modal-heading")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            return null;
          },
        ),
      ),
    );
  }
}

class RefundPolicy extends StatelessWidget {
  static const String routeName = '/refund'; // Add route name

  const RefundPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Refund Policy',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: HtmlWidget(
          """
       <div class="modal-body">
        <h4 class="modal-heading">Refund And Cancellation Policy</h4>  
        <p class="modal-para">Please read the Booking terms and conditions carefully before purchasing/Booking to any of the services, as once you have purchased/Booked you cannot change, cancel your Order. Once you Booked and make the required payment, it shall be final and there cannot be any changes or modifications to the same and neither will there be any refund.</p>
      </div>
       """,
          // remove padding margin from h1 and h4
          customStylesBuilder: (e) {
            if (e.classes.contains("modal-heading")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            if (e.classes.contains("modal-heading2")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            if (e.classes.contains("modal-para")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            if (e.classes.contains("modal-para")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            if (e.classes.contains("modal-heading2")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            if (e.classes.contains("modal-heading")) {
              return {
                "margin": "0px",
                "padding": "0px",
              };
            }
            return null;
          },
        ),
      ),
    );
  }
}
