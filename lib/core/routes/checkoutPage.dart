import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:customerapp/core/components/errors.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/repo/address.dart';
import 'package:customerapp/core/repo/countries.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/countries.dart';

class CheckoutPage extends StatefulWidget {
  static const routeName = "/checkout";
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _addressForController = TextEditingController();
  final TextEditingController _addressTypeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _billingNameController = TextEditingController();
  final _billingMobileController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();
  String? country,state,city;
  String defaultAddress = "Yes";
  late Future<List<Country>> _countryFuture;
  @override
  void initState() {
    super.initState();
    _countryFuture = getCountries(context.read<AuthProvider>());
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _countryFuture,
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          );
        }
        if(snapshot.hasError || !snapshot.hasData){
          return CustomErrorWidget(backgroundColor: Colors.white, icon: Icons.error, message: "Something wrong. Please try again later.");
        }
        List<Country> data = snapshot.data??[];
        return Scaffold(
          appBar: AppBar(
            title: const Text("Checkout"),
          ),
          body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5,),
                        Text("Billing Details",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)
                      ],
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 6.h,
                      child: TextFormField(
                        controller: _billingNameController,
                        validator: (text){
                          if (text == null || text.isEmpty)return "Required";
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          labelText: "Name"
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      height: 6.h,
                      child: TextFormField(
                        controller: _billingMobileController,
                        validator: (text){
                          if (text == null || text.isEmpty)return "Required";
                          if(text.length!=10)return "Please enter a valid number";
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          labelText: "Phone",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5,),
                        Text("Address Details",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)
                      ],
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 6.h,
                      child: TextFormField(
                        controller: _houseNumberController,
                        validator: (text){
                          if (text == null || text.isEmpty)return "Required";
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          labelText: "House / Flat / Building Number"
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      height: 6.h,
                      child: TextFormField(
                        controller: _areaController,
                        validator: (text){
                          if (text == null || text.isEmpty)return "Required";
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          labelText: "Area"
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      height: 6.h,
                      child: TextFormField(
                        controller: _landmarkController,
                        validator: (text){
                          if (text == null || text.isEmpty)return "Required";
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 0.2,color: Colors.grey[200]!)
                          ),
                          labelText: "Landmark"
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    CSCPicker(
                      flagState: CountryFlag.DISABLE,
                      onCountryChanged: (value) {
                        setState(() {
                          country = value;
                       //   _countryController.text=value;
                        });
                      },
                      onStateChanged:(value) {
                        setState(() {
                          state = value;
                         // _stateController.text=value!;
                        });
                      },
                      onCityChanged:(value) {
                        setState(() {
                          city = value;
                         // _cityController.text = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 6.h,
                      child: TextFormField(
                        controller: _pinCodeController,
                        validator: (text){
                          if (text == null || text.isEmpty)return "Required";
                          if(text.length!=6)return "Please enter a valid pincode";
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 0.2,color: Colors.grey[200]!)
                            ),
                            labelText: "Pin Code"
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5,),
                        Text("Who is it for ?",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    CustomDropdown(items: const ["Self","Family","Friend","Other"], controller: _addressForController),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5,),
                        Text("Select Type of Address",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    CustomDropdown(
                        items: const ["Home","Office","Other"], controller: _addressTypeController),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5,),
                        Text("Do you want to make this address default ?",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Yes"),
                        Radio(
                            value: "Yes", groupValue: defaultAddress, onChanged: (text){
                          setState(() {
                            defaultAddress = text!;
                          });
                        }),
                        const Text("No"),
                        Radio(value: "No", groupValue: defaultAddress, onChanged: (text){
                          setState(() {
                            defaultAddress = text!;
                          });
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                onPressed: (){
                                  if(_formKey.currentState!.validate()){
                                    submit(context.read<AuthProvider>(),data);
                                  }
                                }, child: const Text("Proceed"))),
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

  Future<void> submit(AuthProvider auth,List<Country> countries)async{
    try{
      if(country==null){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter Country")));
        return;
      }if(city==null){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter City")));
        return;
      }if(state==null){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter State")));
        return;
      }
      if(_addressForController.text.isEmpty || _addressTypeController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter all fields")));
        return;
      }
      String countryId = countries.firstWhere((element) => element.name == country).id.toString();
      Map data = {
        "billing_name":_billingNameController.text,
        "billing_mobile":_billingMobileController.text,
        "address":"0",
        "address_latitude":"0.000001",
        "address_longitude":"0.000001",
        "pin_code":_pinCodeController.text,
        "house_number":_houseNumberController.text,
        "area":_areaController.text,
        "landmark":_landmarkController.text,
        "country":countryId,
        "city":city,
        "state":state,
        "for_address":_addressForController.text.toLowerCase(),
        "address_type":_addressTypeController.text.toLowerCase(),
        "default_address":defaultAddress.substring(0,1)
      };
      await addAddress(auth, data);
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You have Successfully placed your order.")));
      }

    }catch(e){
        CustomLogger.error(e);
    }
  }
}
