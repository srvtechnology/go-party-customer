import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:customerapp/core/components/divider.dart';
import 'package:customerapp/core/components/errors.dart';
import 'package:customerapp/core/components/loading.dart';
import 'package:customerapp/core/models/address.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/addressProvider.dart';
import 'package:customerapp/core/repo/address.dart';
import 'package:customerapp/core/repo/countries.dart';
import 'package:collection/collection.dart';
import 'package:customerapp/core/repo/services.dart';
import 'package:customerapp/core/routes/paymentPage.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/cart.dart';
import '../models/countries.dart';

class CheckoutPage extends StatefulWidget {
  static const routeName = "/checkout";
  List<String> serviceIds;
  List<CartModel> cartItems;
  CheckoutPage({Key? key,required this.serviceIds,required this.cartItems}) : super(key: key);

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
  final _addressController = TextEditingController();
  int _selectedAddressIndex = -1;
  AddressModel? _selectedAddress;
  String? country,state,city;
  String defaultAddress = "Yes";
  bool otherAddress = true;
  late Future<List<Country>> _countryFuture;
  @override
  void initState() {
    super.initState();
    _countryFuture = getCountries(context.read<AuthProvider>());
    _addressController.addListener(() {
        if(_addressController.text.isNotEmpty){
          setState(() {
            otherAddress = false;
          });
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_)=>AddressProvider(context.read<AuthProvider>()),
      child: Consumer<AddressProvider>(
        builder: (context,addressState,child) {
          if(addressState.isLoading){
            return const ShimmerWidget();
          }
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: Theme.of(context).primaryColorLight,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: const [
                                  CircleAvatar(radius: 10,child: Icon(Icons.check,size: 10,),),
                                  SizedBox(height: 5,),
                                  Text("Cart",style: TextStyle(fontSize: 12),)
                                ],
                              ),
                              Column(
                                children: const [
                                  CircleAvatar(radius: 10,child: Icon(Icons.circle,size: 10,),),
                                  SizedBox(height: 5,),
                                  Text("Select Address",style: TextStyle(fontSize: 12),)
                                ],
                              ),
                              Column(
                                children: const [
                                  CircleAvatar(radius: 10,backgroundColor: Colors.grey,),
                                  SizedBox(height: 5,),
                                  Text("Payment",style: TextStyle(fontSize: 12),)
                                ],
                              ),
                              Column(
                                children: const [
                                  CircleAvatar(radius: 10,backgroundColor: Colors.grey,),
                                  SizedBox(height: 5,),
                                  Text("Order Placed",style: TextStyle(fontSize: 12),)
                                ],
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        if(addressState.data.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 5,),
                              Text("Select a delivery Address",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        if(addressState.data.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[200]
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                            child: Column(
                              children: addressState.data.mapIndexed((index,e) => _addressTile(index, e,data,addressState)).toList(),
                            ),
                          ),
                        const SizedBox(height: 20,),
                        if(otherAddress)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              const SizedBox(height: 20,),
                              if(addressState.data.isNotEmpty)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 5,),
                                    Text("OR",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)
                                  ],
                                ),
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
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  onPressed: (){
                                    if(_formKey.currentState!.validate()){
                                      submit(context.read<AuthProvider>(),data,addressState);
                                    }
                                  }, child: const Text("Deliver to this Address")),
                              const SizedBox(height: 100,)
                            ],
                          ),
                        ),
                      ],
                    ),

                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }
  void showNotAvailableDialog(List notAvailable){
    showDialog(context: context,
        builder: (context){
          return Dialog(
            shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 40.h,
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "The following services are not available at your selected address.\nPlease try another address or remove them from cart.",
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.sp),
                    ),
                    const SizedBox(height: 30,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: notAvailable.map((e) => Text(
                          "• ${widget.cartItems
                              .firstWhere((element)
                          => element.service.id == e).service.name}",
                        style: TextStyle(fontSize: 16.sp,color: Colors.grey),
                      )).toList(),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
  
  Widget _addressTile(int index,AddressModel e,List<Country> data,AddressProvider addressState,){
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Column(
              mainAxisAlignment:MainAxisAlignment.start,
              children: [
                Radio(value: index, groupValue: _selectedAddressIndex,
                    onChanged: (index){
                      setState(() {
                        _selectedAddressIndex = index!;
                        _selectedAddress = e;
                        otherAddress = false;
                      });
                    }),
              ],
            )),
            Expanded(flex:5,child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Text(e.billingName,style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColor),),
                Text(e.addressType,style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                Text("${e.houseNumber}, ${e.landmark}, ${e.area}, ${e.state}"),
                const SizedBox(height: 10,),
              ],
            ))
          ],
        ),
        if(_selectedAddress == e)
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  submit(context.read<AuthProvider>(),data,addressState);
                }
              }, child: const Text("Deliver to this Address")),
        const DashedDivider(),
      ],
    );
  }
  
  Future<void> submit(AuthProvider auth,List<Country> countries,AddressProvider addressState)async{
    try{
      if(_selectedAddress!=null){
        String addressId = _selectedAddress!.id.toString();
        List notAvailable=await getServiceAvailability(widget.serviceIds, addressId);
        if(notAvailable.isNotEmpty) {
          showNotAvailableDialog(notAvailable);
        }
        else
        {
          if(context.mounted)Navigator.push(context,MaterialPageRoute(builder: (context)=>PaymentPage(addressId: addressId)));
        }
        return;
      }
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
      String addressId = await addAddress(auth, data);
      List notAvailable=await getServiceAvailability(widget.serviceIds, addressId);
      if(notAvailable.isNotEmpty) {
        showNotAvailableDialog(notAvailable);
      }
      else{
        if(context.mounted) {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>PaymentPage(addressId: addressId)));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You have Successfully placed your order.")));
        }
      }
    }catch(e){
        CustomLogger.error(e);
    }
  }
}
