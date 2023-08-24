import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/repo/order.dart';
import 'package:customerapp/core/routes/mainpage.dart';
import 'package:customerapp/core/utils/geolocator.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentPage extends StatefulWidget {
  String addressId;
  PaymentPage({Key? key,required this.addressId}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _paymentModeController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showCard=true;
  @override
  void initState() {
    super.initState();
    _paymentModeController.addListener(() {
      if(_paymentModeController.text=="Cash On Delivery"){
       setState(() {
         showCard=false;
       });
      }
      else{
        showCard=true;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 5,),
                  Text("Payment Details",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)
                ],
              ),
              const SizedBox(height: 20,),
              CustomDropdown(
                  hintText: "Select Payment Mode",
                  items: const ["Cash On Delivery","Online"], controller: _paymentModeController),
              const SizedBox(height: 20,),
              if(showCard)
              Form(
                key: _formKey,
                child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5,),
                      Text("Card Details",style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600),)
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          validator: (text){
                            if(text==null || text.isEmpty){
                              return "Required";
                            }
                            if(text.length!=16){
                              return "Please enter valid Card Number";
                            }
                          },
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: "Enter Card Number"
                          ),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: TextFormField(
                          validator: (text){
                            if(text==null || text.isEmpty){
                              return "Required";
                            }
                            if(text.length!=3){
                              return "Please enter valid cvv";
                            }
                          },
                          controller: _cardNumberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(width: 0),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: "CVV"
                          ),
                        ),
                      ),
                      const SizedBox(width: 20,),
                    ],
                  ),
                  const SizedBox(height: 30,),
                ],
            ),
              ),
              Row(
                children: [
                  Expanded(child:
                  ElevatedButton(
                    onPressed:(){
                      submit(context.read<AuthProvider>());
                    },
                    child: const Text("Place Order"),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> submit(AuthProvider auth)async{
    try{
      Map data=await getCountryCityState();
      CustomLogger.debug(data);
      await placeOrder(auth, _paymentModeController.text.contains("Cash")?"cod":"online", widget.addressId,data["city"]);
      if(context.mounted){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const MainPageRoute()), (route) => route.isFirst);
      }

    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("There was something wrong. Please try again later")));
    }
  }
}
