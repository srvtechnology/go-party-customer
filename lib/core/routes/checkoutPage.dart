import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/services.dart';
import '../constant/themData.dart';
import 'package:customerapp/core/components/errors.dart';
import 'package:customerapp/core/components/loading.dart';
import 'package:customerapp/core/models/addressModel.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/addressProvider.dart';
import 'package:customerapp/core/repo/addressRepo.dart';
import 'package:customerapp/core/repo/countries.dart';
import 'package:collection/collection.dart';
import 'package:customerapp/core/repo/services.dart';
import 'package:customerapp/core/routes/addressPage.dart';
import 'package:customerapp/core/routes/paymentPage.dart';
import 'package:customerapp/core/utils/addressFormater.dart';
import 'package:customerapp/core/utils/geolocator.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../models/cartModel.dart';
import '../models/countries.dart';

class CheckoutPage extends StatefulWidget {
  static const routeName = "/checkout";
  List<String> serviceIds;
  List<CartModel> cartItems;
  double cartSubTotal;

  CheckoutPage(
      {Key? key,
      required this.serviceIds,
      required this.cartItems,
      required this.cartSubTotal})
      : super(key: key);

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
  String? country, state, city;
  String defaultAddress = "Yes";
  bool otherAddress = true;
  late Future<List<Country>> _countryFuture;
  bool isAddressLoading = false;
  bool showAddressContainer = false;

  @override
  void initState() {
    super.initState();
    _countryFuture = getCountries(context.read<AuthProvider>());

    _addressController.addListener(() {
      if (_addressController.text.isNotEmpty) {
        setState(() {
          otherAddress = false;
        });
      }
    });
  }

  getLocationByPin() async {
    setState(() {
      isAddressLoading = true;
    });
    final data = await getCityStateCountryByPin(_pinCodeController.text);
    if (data.isEmpty) return {};
    setState(() {
      country = data["country"];
      state = data["state"];
      city = data["city"];
    });
    setState(() {
      isAddressLoading = false;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => AddressProvider(context.read<AuthProvider>()),
      child: Consumer<AddressProvider>(builder: (context, addressState, child) {
        if (addressState.isLoading) {
          return const Scaffold(body: ShimmerWidget());
        }
        if (addressState.data.isEmpty) {
          showAddressContainer = true;
        }
        return FutureBuilder(
            future: _countryFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return CustomErrorWidget(
                    backgroundColor: Colors.white,
                    icon: Icons.error,
                    message: "Something wrong. Please try again later.");
              }
              List<Country> data = snapshot.data ?? [];
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title: const Text("Checkout"),
                ),
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: const [
                                  CircleAvatar(
                                    radius: 10,
                                    child: Icon(
                                      Icons.check,
                                      size: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Cart",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                              Column(
                                children: const [
                                  CircleAvatar(
                                    radius: 10,
                                    child: Icon(
                                      Icons.circle,
                                      size: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Select Address",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                              Column(
                                children: const [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Payment",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                              Column(
                                children: const [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Order Placed",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        /* if (addressState.data.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Select a delivery Address",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ), */
                        InkWell(
                          onTap: () {
                            setState(() {
                              showAddressContainer = !showAddressContainer;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors
                                  .transparent, // Background color of the button
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text(
                                  'Add New Address',
                                  style: TextStyle(
                                    // Text color
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showAddressContainer,
                          child: Container(
                            // color: Colors.white,
                            padding: EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Billing Details",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _billingNameController,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      labelText: "Name"),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _billingMobileController,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "Required";
                                    }
                                    if (text.length != 10) {
                                      return "Please enter a valid number";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    labelText: "Phone",
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _houseNumberController,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      labelText:
                                          "House / Flat / Building Number"),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _pinCodeController,
                                  onChanged: (text) {
                                    if (text.length == 6) {
                                      getLocationByPin();
                                    }
                                  },
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "Required";
                                    }
                                    if (text.length != 6) {
                                      return "Please enter a valid pincode";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType
                                      .number, // Restrict input to numbers only
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Ensure only digits are allowed
                                  ],
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              width: 0.2,
                                              color: Colors.grey[200]!)),
                                      labelText: "Pin Code"),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _areaController,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      labelText: "Area"),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _landmarkController,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              width: 0.2,
                                              color: Colors.grey[200]!)),
                                      labelText: "Landmark"),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                isAddressLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CSCPicker(
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
                                        onStateChanged: (value) {
                                          setState(() {
                                            state = value;
                                            // _stateController.text=value!;
                                          });
                                        },
                                        onCityChanged: (value) {
                                          setState(() {
                                            city = value;
                                            // _cityController.text = value!;
                                          });
                                        },
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Who is it for ?",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomDropdown(items: const [
                                  "Self",
                                  "Family",
                                  "Friend",
                                  "Other"
                                ], controller: _addressForController),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Select Type of Address",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomDropdown(
                                    items: const ["Home", "Office", "Other"],
                                    controller: _addressTypeController),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Do you want to make this address default ?",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text("Yes"),
                                    Radio(
                                        value: "Yes",
                                        groupValue: defaultAddress,
                                        onChanged: (text) {
                                          setState(() {
                                            defaultAddress = text!;
                                          });
                                        }),
                                    const Text("No"),
                                    Radio(
                                        value: "No",
                                        groupValue: defaultAddress,
                                        onChanged: (text) {
                                          setState(() {
                                            defaultAddress = text!;
                                          });
                                        }),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 0,
                                      right: 0,
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          submit(context.read<AuthProvider>(),
                                              data, addressState);
                                        }
                                      },
                                      child: const Text(
                                          "Deliver to this Address")),
                                ),
                              ],
                            ),
                          ),
                        ),
                        /* Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ExpandablePanel(
                            controller: ExpandableController(
                                initialExpanded:
                                    addressState.data.isEmpty ? true : false),
                            theme: const ExpandableThemeData(
                              hasIcon: true,
                              iconColor: Colors.black,
                              iconPadding: EdgeInsets.only(right: 10, top: 16),
                              collapseIcon: Icons.keyboard_arrow_down,
                              expandIcon: Icons.keyboard_arrow_right,
                            ),
                            header: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Add New Address',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                            collapsed: const SizedBox(),
                            expanded: Container(
                              // color: Colors.white,
                              padding: EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                  right: 10,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Billing Details",
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: _billingNameController,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        labelText: "Name"),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _billingMobileController,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Required";
                                      }
                                      if (text.length != 10) {
                                        return "Please enter a valid number";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      labelText: "Phone",
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: _houseNumberController,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        labelText:
                                            "House / Flat / Building Number"),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _pinCodeController,
                                    onChanged: (text) {
                                      if (text.length == 6) {
                                        getLocationByPin();
                                      }
                                    },
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Required";
                                      }
                                      if (text.length != 6) {
                                        return "Please enter a valid pincode";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 0.2,
                                                color: Colors.grey[200]!)),
                                        labelText: "Pin Code"),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _areaController,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        labelText: "Area"),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _landmarkController,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return "Required";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 0.2,
                                                color: Colors.grey[200]!)),
                                        labelText: "Landmark"),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  isAddressLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : CSCPicker(
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
                                          onStateChanged: (value) {
                                            setState(() {
                                              state = value;
                                              // _stateController.text=value!;
                                            });
                                          },
                                          onCityChanged: (value) {
                                            setState(() {
                                              city = value;
                                              // _cityController.text = value!;
                                            });
                                          },
                                        ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Who is it for ?",
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomDropdown(items: const [
                                    "Self",
                                    "Family",
                                    "Friend",
                                    "Other"
                                  ], controller: _addressForController),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Select Type of Address",
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomDropdown(
                                      items: const ["Home", "Office", "Other"],
                                      controller: _addressTypeController),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Do you want to make this address default ?",
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text("Yes"),
                                      Radio(
                                          value: "Yes",
                                          groupValue: defaultAddress,
                                          onChanged: (text) {
                                            setState(() {
                                              defaultAddress = text!;
                                            });
                                          }),
                                      const Text("No"),
                                      Radio(
                                          value: "No",
                                          groupValue: defaultAddress,
                                          onChanged: (text) {
                                            setState(() {
                                              defaultAddress = text!;
                                            });
                                          }),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 0,
                                        right: 0,
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            submit(context.read<AuthProvider>(),
                                                data, addressState);
                                          }
                                        },
                                        child: const Text(
                                            "Deliver to this Address")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ), */
                        const SizedBox(
                          height: 5,
                        ),
                        if (addressState.data.isNotEmpty)
                          Container(
                            decoration: const BoxDecoration(
                                // borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Select a delivery Address",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ...addressState.data
                                    .mapIndexed((index, e) => _addressTile(
                                        index, e, data, addressState))
                                    .toList()
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 100,
                        )
                        /* if (otherAddress)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                if (addressState.data.isNotEmpty)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "OR",
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                // add hare
                              ],
                            ),
                          ), */
                      ],
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }

  void showNotAvailableDialog(List notAvailable) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 40.h,
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "The following services are not available at your selected address.\nPlease try another address or remove them from cart.",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16.sp),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: notAvailable
                          .map((e) => Text(
                                "• ${widget.cartItems.firstWhere((element) => element.service.id == e).service.name}",
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.grey),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _addressTile(
    int index,
    AddressModel addresses,
    List<Country> data,
    AddressProvider addressState,
  ) {
    if (_selectedAddressIndex == -1 && addresses.defaultAddress == 'Y') {
      _selectedAddressIndex = index;
      _selectedAddress = addresses;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio(
              value: index,
              groupValue: _selectedAddressIndex,
              onChanged: (index) {
                setState(() {
                  _selectedAddressIndex = index!;
                  _selectedAddress = addresses;
                  otherAddress = false;
                });
              }),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (addresses.defaultAddress == "Y") ...[
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Default :  ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Image.asset(
                        "assets/images/logo/logo-resized.png",
                        height: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                ],
                Text(
                  "${addresses.billingName} ",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8),
                  child: Text(
                    getAddressFormat(addresses),
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddressEditPage(address: addresses)))
                              .then((value) => addressState
                                  .getAddress(context.read<AuthProvider>()));
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () async {
                          await addressState.deleteAddress(
                              context.read<AuthProvider>(),
                              addresses.id.toString());
                          await addressState
                              .getAddress(context.read<AuthProvider>());
                        },
                        child: const Text(
                          "Remove",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedAddress == addresses) ...[
                  const Divider(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor),
                      onPressed: () {
                        submit(
                            context.read<AuthProvider>(), data, addressState);
                      },
                      child: const Text("Deliver to this Address")),
                ]
              ],
            ),
          ),
        ],
      ),
    );
    /* return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                    value: index,
                    groupValue: _selectedAddressIndex,
                    onChanged: (index) {
                      setState(() {
                        _selectedAddressIndex = index!;
                        _selectedAddress = e;
                        otherAddress = false;
                      });
                    }),
              ],
            )),
            Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      e.billingName,
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      e.addressType,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "${e.houseNumber}, ${e.landmark}, ${e.area}, ${e.state}"),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ))
          ],
        ),
        if (_selectedAddress == e)
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  submit(context.read<AuthProvider>(), data, addressState);
                }
              },
              child: const Text("Deliver to this Address")),
        const DashedDivider(),
      ],
    ); */
  }

  Future<void> submit(AuthProvider auth, List<Country> countries,
      AddressProvider addressState) async {
    try {
      log('ffd');
      if (_selectedAddress != null) {
        String addressId = _selectedAddress!.id.toString();
        log(addressId, name: 'checkout');
        log(widget.serviceIds.toString(), name: 'checkout');
        List notAvailable =
            await getServiceAvailability(widget.serviceIds, addressId);
        print(notAvailable);
        if (notAvailable.isNotEmpty) {
          showNotAvailableDialog(notAvailable);
        } else {
          if (context.mounted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentPage(
                          serviceIds: widget.serviceIds,
                          cartItems: widget.cartItems,
                          selectedAddress: _selectedAddress!,
                          total: widget.cartSubTotal,
                        )));
          }
        }
        return;
      }
      if (country == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter Country")));
        return;
      }
      if (city == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Please enter City")));
        return;
      }
      if (state == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Please enter State")));
        return;
      }
      if (_addressForController.text.isEmpty ||
          _addressTypeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter all fields")));
        return;
      }
      String countryId = countries
          .firstWhere((element) => element.name == country)
          .id
          .toString();
      Map data = {
        "billing_name": _billingNameController.text,
        "billing_mobile": _billingMobileController.text,
        /* "address": "0", */
        "address": "${_houseNumberController.text}, "
            "${_pinCodeController.text}, "
            "${_areaController.text}, "
            "${_landmarkController.text}, "
            "$city, $state, $country",
        "address_latitude": "0.000001",
        "address_longitude": "0.000001",
        "pin_code": _pinCodeController.text,
        "house_number": _houseNumberController.text,
        "area": _areaController.text,
        "landmark": _landmarkController.text,
        "country": countryId,
        "city": city,
        "state": state,
        "for_address": _addressForController.text.toLowerCase(),
        "address_type": _addressTypeController.text.toLowerCase(),
        "default_address": defaultAddress.substring(0, 1)
      };
      String addressId = await addAddress(auth, data);
      log(addressId.toString(), name: 'checkout');
      AddressModel? add = getSelectedAddress(
          data, int.parse(addressId), int.parse(auth.user!.id));
      if (kDebugMode) {
        print('data ==== >$add');
      }
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentPage(
                      serviceIds: widget.serviceIds,
                      selectedAddress: add,
                      cartItems: widget.cartItems,
                      total: widget.cartSubTotal,
                    )));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text("You have Successfully placed your order.")));
      }
      // List notAvailable =
      //     await getServiceAvailability(widget.serviceIds, addressId);
      // if (notAvailable.isNotEmpty) {
      //   showNotAvailableDialog(notAvailable);
      // } else {
      //   AddressModel? add = getSelectedAddress(
      //       data, int.parse(addressId), int.parse(auth.user!.id));
      //   if (context.mounted) {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => PaymentPage(
      //                   selectedAddress: add,
      //                   total: widget.cartSubToatal,
      //                 )));
      //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //         content: Text("You have Successfully placed your order.")));
      //   }
      // }
    } catch (e) {
      CustomLogger.error(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong. Try again.")));
    }
  }

  AddressModel? getSelectedAddress(Map<dynamic, dynamic> data, int id, userId) {
    return AddressModel(
      address: data['address'],
      addressType: data['address_type'],
      area: data['area'],
      billingMobile: data['billing_mobile'],
      billingName: data['billing_name'],
      city: data['city'],
      country: data['country'],
      countryName: 'India',
      createdAt: DateTime.now(),
      defaultAddress: data['default_address'],
      forAddress: data['for_address'],
      houseNumber: data['house_number'],
      id: id,
      landmark: data['landmark'],
      latitude: 0.000001,
      longitude: 0.000001,
      pinCode: data['pin_code'],
      state: data['state'],
      updatedAt: DateTime.now(),
      userId: userId,
    );
  }
}
