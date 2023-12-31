import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:customerapp/core/components/divider.dart';
import 'package:customerapp/core/models/address.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/addressProvider.dart';
import 'package:customerapp/core/utils/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../components/errors.dart';
import '../models/countries.dart';
import '../repo/address.dart';
import '../repo/countries.dart';
import '../utils/logger.dart';

class AddressAddPage extends StatefulWidget {
  static const routeName = "/addAddress";
  const AddressAddPage({Key? key}) : super(key: key);

  @override
  State<AddressAddPage> createState() => _AddressAddPageState();
}

class _AddressAddPageState extends State<AddressAddPage> {
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
  bool clicked = false;
  late Future<List<Country>> _countryFuture;
  late Future<Map> _geolocationFuture;

  @override
  void initState() {
    super.initState();
    _countryFuture = getCountries(context.read<AuthProvider>());
    _geolocationFuture = getLocation();
  }
  Future<Map> getLocation()async
  {
    Map data = await getCountryCityState();
    setState(() {
      country=data["country"];
      state=data["state"];
      city=data["city"];
    });
    return data;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_countryFuture,_geolocationFuture]),
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
            CustomLogger.error(snapshot.error);
            return CustomErrorWidget(backgroundColor: Colors.white, icon: Icons.error, message: "Something wrong. Please try again later.");
          }
          final data = (snapshot.data![0]) as List<Country>;
          CustomLogger.debug(snapshot.data![1]);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Add an Address"),
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
                        currentCountry: country,
                        currentState: state,
                        currentCity: city,
                        flagState: CountryFlag.DISABLE,
                        onCountryChanged: (value) {
                          setState(() {
                            country = value;
                          });
                        },
                        onStateChanged:(value) {
                          setState(() {
                            state = value;
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
                                      setState(() {
                                        clicked = true;
                                      });
                                      submit(context.read<AuthProvider>(),data);
                                    }
                                  }, child: clicked?const CircularProgressIndicator():const Text("Proceed"))),
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You have successfully added a new Address.")));
        Navigator.pop(context);
      }

    }catch(e){
      setState(() {
        clicked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something wrong with the request. Please try again later.")));
      CustomLogger.error(e);
    }
  }

}

class AddressPage extends StatefulWidget {
  static const routeName = "/address";
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_)=>AddressProvider(Provider.of<AuthProvider>(context)),
      child: Consumer<AddressProvider>(
        builder: (context,state,child) {
          if(state.isLoading){
            return Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Manage Addresses"),
            ),
            bottomNavigationBar: Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 40,left: 40,right: 40),
              child: ElevatedButton(
                onPressed: ()async{
                  await Navigator.pushNamed(context, AddressAddPage.routeName);
                  if(context.mounted)await state.getAddress(context.read<AuthProvider>());
                },
                child: const Text("Add a New Address"),
              ),
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Your Addresses",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15.sp),)
                        ],
                      ),
                      const SizedBox(height: 20,),
                      ...state.data.map((e) => _addressTile(e,state)).toList()
                    ],
                  ),
              ),
            ),
          );
        }
      ),
    );
  }
  Widget _addressTile(AddressModel address,AddressProvider state){
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${address.houseNumber}, ${address.landmark}, \n${address.area} , ${address.city}, \n${address.state}, ${address.countryName}",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>AddressEditPage(address: address))).then((value) => state.getAddress(context.read<AuthProvider>()));
              }, child: const Text("Edit")),
              const SizedBox(width: 20,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: ()async{
                    await state.deleteAddress(context.read<AuthProvider>(), address.id.toString());
              }, child: const Text("Delete")),
            ],
          ),
          const DashedDivider(),
        ],
      ),
    );
  }
}

class AddressEditPage extends StatefulWidget {
  final AddressModel address;
  const AddressEditPage({Key? key,required this.address}) : super(key: key);

  @override
  State<AddressEditPage> createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
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
  bool clicked = false;
  late Future<List<Country>> _countryFuture;
  @override
  void initState() {
    super.initState();
    _countryFuture = getCountries(context.read<AuthProvider>());
    _addressTypeController.text = "${widget.address.addressType[0].toUpperCase()}${widget.address.addressType.substring(1).toLowerCase()}";
    _addressForController.text = "${widget.address.forAddress[0].toUpperCase()}${widget.address.forAddress.substring(1).toLowerCase()}";
    _billingNameController.text = widget.address.billingName;
    _billingMobileController.text = widget.address.billingMobile;
    _pinCodeController.text = widget.address.pinCode;
    _houseNumberController.text = widget.address.houseNumber;
    _areaController.text = widget.address.area;
    _landmarkController.text = widget.address.landmark;
    city=widget.address.city;
    state=widget.address.state;
    
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
          country=data.firstWhere((element) => element.id.toString()==widget.address.country).name;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Edit Address"),
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
                        currentCountry: country,
                        currentState: state,
                        currentCity: city,
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
                                      setState(() {
                                        clicked = true;
                                      });
                                      submit(context.read<AuthProvider>(),data);
                                    }
                                  }, child: clicked?const CircularProgressIndicator(color: Colors.white,):const Text("Proceed"))),
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
        "address_id":widget.address.id,
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
      await editAddress(auth, data);
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You have successfully edited Address.")));
        Navigator.pop(context);
      }

    }catch(e){
      setState(() {
        clicked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something wrong with the request. Please try again later.")));
      CustomLogger.error(e);
    }
  }

}
