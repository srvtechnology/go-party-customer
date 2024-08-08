import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:customerapp/core/components/Rating_view.dart';
import 'package:customerapp/core/models/orders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constant/themData.dart';
import 'package:customerapp/core/components/bottomNav.dart';
import 'package:customerapp/core/components/card.dart';
import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/components/divider.dart';
import 'package:customerapp/core/components/htmlTextView.dart';
import 'package:customerapp/core/components/quantity_Manager.dart';
import 'package:customerapp/core/components/share_rapper.dart';
import 'package:customerapp/core/models/cartModel.dart';
import 'package:customerapp/core/models/service.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/providers/cartProvider.dart';
import 'package:customerapp/core/providers/categoryProvider.dart';
import 'package:customerapp/core/providers/orderProvider.dart';
import 'package:customerapp/core/repo/cartRepo.dart';
import 'package:customerapp/core/repo/services.dart';
import 'package:customerapp/core/routes/cartPage.dart';
import 'package:customerapp/core/routes/checkoutPage.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/signin.dart';

import '../components/banner.dart';

class SingleServiceRoute extends StatefulWidget {
  final ServiceModel service;

  const SingleServiceRoute({Key? key, required this.service}) : super(key: key);

  @override
  State<SingleServiceRoute> createState() => _SingleServiceRouteState();
}

class _SingleServiceRouteState extends State<SingleServiceRoute> {
  final TextEditingController _categoryName = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  final TextEditingController _startDateView = TextEditingController();
  final TextEditingController _endDateView = TextEditingController();
  final TextEditingController _selectedCity = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _days = TextEditingController();
  final TextEditingController _duration = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isShowMore = false;
  bool isProcessing = false;
  List<String> _cities = [];
  String? selectedCity = " Select a City";
  String defaultCityMessage = "Open for every city";
  bool isLoading = false;

  List<ServicePopUpCategory> popupCategories = [];
  ServicePopUpCategory? selectedCategory;

  void _calculateDays() {
    try {
      if (_startDate.text.isNotEmpty && _endDate.text.isNotEmpty) {
        if (DateTime.parse(_startDate.text)
            .isAfter(DateTime.parse(_endDate.text))) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Start date should be less than end date")));
          // _endDate.clear();
          // _days.clear();
        }
      }
      _days.text = getDay(DateTime.parse(_endDate.text)
          .difference(DateTime.parse(_startDate.text))
          .inDays
          .toString());
    } catch (e) {
      print('${e.toString()} getDay error');
    }
  }

  @override
  void initState() {
    super.initState();
    _startDate.addListener(_calculateDays);
    _endDate.addListener(_calculateDays);
    _quantity.text = widget.service.minQnty.toString() == "0" ||
            widget.service.minQnty.toString() == "null"
        ? "1"
        : widget.service.minQnty.toString();
    _duration.text = "Full Day";
    getAvailableCities();

    popupCategories = widget.service.popupCategories ?? [];
    if (popupCategories.isNotEmpty) {
      selectedCategory = popupCategories.first;
      _categoryName.text = selectedCategory!.category?.categoryName ?? "";
    }
  }

  Future<void> getAvailableCities() async {
    setState(() => isLoading = true);
    List cities = await getSingleService(widget.service.id!);

    setState(() {
      _cities = cities.map((e) => e.toString()).toList();
      if (_cities.isNotEmpty) {
        selectedCity = _cities.first;
      } else {
        selectedCity = defaultCityMessage;
      }
      isLoading = false;
    });
    if (kDebugMode) {
      print(_cities.toString());
    }
  }

  /*getAvailableCities() async {
    setState(() => isloading = true);
    List cities = await getServicesCities(widget.service.id!);

    setState(() {
      _cities = cities.map((e) => e.toString()).toList();
      isloading = false;
    });
    print(_cities.toString());
  }*/

  TextFormField datePickField(TextEditingController controller,
      TextEditingController controllerView, String hintText,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controllerView,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide:
                BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),
          )),
      validator: validator ??
          (text) {
            if (text == null || text.isEmpty) {
              return "Required";
            }
            return null;
          },
      readOnly: true,
      onTap: () async {
        DateTime? date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(3000));
        if (date != null) {
          controllerView.text = DateFormat("dd-MM-yyyy").format(date);
          controller.text = date.toString().substring(0, 10);
        }
      },
    );
  }

  void addToCartDialog(BuildContext context, CategoryProvider categories,
      {Function(
              List<String> serviceIds, List<CartModel> data, double totalPrice)?
          isFromBookNow}) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return FractionallySizedBox(
              heightFactor: 0.8,
              child: ListenableProvider(
                  create: (_) =>
                      CartProvider(auth: context.read<AuthProvider>()),
                  child: Consumer2<CartProvider, AuthProvider>(
                      builder: (context, cart, auth, child) {
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 2.h),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Proceed To Cart',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  )),
                              // package name
                              Text(
                                widget.service.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                alignment: Alignment.topCenter,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Select Your Event",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    CustomDropdown.search(
                                      onChanged: (p0) {
                                        setState(() {
                                          selectedCategory = popupCategories
                                              .firstWhere((element) =>
                                                  element
                                                      .category?.categoryName ==
                                                  p0);
                                          _categoryName.text = p0;
                                        });
                                      },
                                      borderSide: BorderSide(
                                          width: 0.5,
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(10),
                                      hintText: "Select Your Event",
                                      controller: _categoryName,
                                      items: popupCategories
                                          .map((e) =>
                                              e.category?.categoryName ?? "")
                                          .toList(),
                                      /*categories.data
                                          .map((e) => e.name)
                                          .toList(),*/
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // CustomDropdown.search(
                                    //   borderSide: BorderSide(
                                    //       width: 0.5,
                                    //       color:
                                    //           Theme.of(context).primaryColor),
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   hintText: "Select Service City",
                                    //   controller: _selectedCity,
                                    //   items: _cities.map((e) => e).toList(),
                                    // ),
                                    // const SizedBox(
                                    //   height: 20,
                                    // ),
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Event Start Date",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    datePickField(_startDate, _startDateView,
                                        "Event Start Date", validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return "Start Date Required";
                                      }

                                      // if date is today and current time is greater than 3:59 pm then show error
                                      DateTime now = DateTime.now();
                                      DateTime date =
                                          DateTime.parse(_startDate.text);

                                      if (date.day == now.day &&
                                          date.month == now.month &&
                                          date.year == now.year &&
                                          now.hour >= 16) {
                                        return "You can't book for today after 4:00 PM";
                                      }

                                      return null;
                                    }),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Event End Date",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    datePickField(_endDate, _endDateView,
                                        "Event End Date", validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return "End Date Required";
                                      }
                                      print(
                                        _startDate.text,
                                      );
                                      // check end date is greater than start date
                                      if (DateTime.parse(_startDate.text)
                                          .isAfter(
                                              DateTime.parse(_endDate.text))) {
                                        return "End date should be greater than start date";
                                      }
                                      /*--- commented on 31-07-24 : to validate if
                                      * start date and end end is same but before 4:00 P.M --*/
                                      // if start date and end date is same then show error
                                      /*if (DateTime.parse(_startDate.text)
                                          .isAtSameMomentAs(
                                              DateTime.parse(_endDate.text))) {
                                        return "End date should be greater than start date";
                                      }*/
                                      if (DateTime.parse(_startDate.text)
                                          .isAtSameMomentAs(
                                              DateTime.parse(_endDate.text))) {
                                        // Check if the end time is before 4:00 PM
                                        if (DateTime.parse(_endDate.text).hour <
                                            16) {
                                          // Allow the end date if before 4:00 PM
                                          return null; // No error message
                                        } else {
                                          // End time is 4:00 PM or later
                                          return "End date should be greater than start date or before 4:00 P.M";
                                        }
                                      }

                                      return null;
                                    }),
                                    // const SizedBox(
                                    //   height: 20,
                                    // ),
                                    // TextFormField(
                                    //   keyboardType: TextInputType.number,
                                    //   controller: _quantity,
                                    //   validator: (text) {
                                    //     if (text == null || text.isEmpty) {
                                    //       return "Required";
                                    //     }
                                    //     return null;
                                    //   },
                                    //   decoration: InputDecoration(
                                    //       border: OutlineInputBorder(
                                    //         borderSide: BorderSide(
                                    //             width: 0.5,
                                    //             color: Theme.of(context)
                                    //                 .primaryColor),
                                    //         borderRadius:
                                    //             BorderRadius.circular(10),
                                    //       ),
                                    //       enabledBorder: OutlineInputBorder(
                                    //         borderSide: BorderSide(
                                    //             width: 0.5,
                                    //             color: Theme.of(context)
                                    //                 .primaryColor),
                                    //         borderRadius:
                                    //             BorderRadius.circular(10),
                                    //       ),
                                    //       hintText: "Select Quantity"),
                                    // ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Days",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            readOnly: true,
                                            keyboardType: TextInputType.number,
                                            controller: _days,
                                            validator: (text) {
                                              if (text == null ||
                                                  text.isEmpty) {
                                                return "Days Required";
                                              }

                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                hintText: "Days"),
                                          ),
                                        ),
                                        QuantityManager(
                                          qnty: _quantity.text,
                                          minQnty: widget.service.minQnty ==
                                                  null
                                              ? 1
                                              : int.parse(widget.service.minQnty
                                                  .toString()),
                                          onChanged: (v) {
                                            setState(() {
                                              _quantity.text = v;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    // CustomDropdown(
                                    //     borderSide: BorderSide(
                                    //         width: 0.5,
                                    //         color:
                                    //             Theme.of(context).primaryColor),
                                    //     borderRadius: BorderRadius.circular(10),
                                    //     items: const [
                                    //       "Full Day",
                                    //       "Morning",
                                    //       "Night"
                                    //     ],
                                    //     controller: _duration),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.h, horizontal: 2.w),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5,
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Price:",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Text(
                                              "\u20B9 ${double.parse(widget.service.discountedPrice ?? '0') * int.parse(_quantity.text)}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: cart.isLoading
                                          ? const Center(
                                              child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator()),
                                            )
                                          : ElevatedButton(
                                              onPressed: isProcessing
                                                  ? () {}
                                                  : () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          isProcessing = true;
                                                        });
                                                        String categoryId = categories
                                                            .data
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .name ==
                                                                    _categoryName
                                                                        .text)
                                                            .id
                                                            .toString();
                                                        if (kDebugMode) {
                                                          print(_selectedCity
                                                              .text);
                                                        }
                                                        Map data = {
                                                          "service_id":
                                                              widget.service.id,
                                                          "cart_category":
                                                              categoryId,
                                                          "date":
                                                              _startDate.text,
                                                          "end_date":
                                                              _endDate.text,
                                                          "quantity":
                                                              _quantity.text,
                                                          "days": _days.text,
                                                          "time": _duration.text
                                                              .substring(0, 1),
                                                          // "service_city":
                                                          //     _selectedCity.text
                                                        };
                                                        //

                                                        await addtoCart(
                                                            context.read<
                                                                AuthProvider>(),
                                                            data);
                                                        if (context.mounted) {
                                                          cart.getCart(auth);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          "Successfully added to cart")));
                                                        }

                                                        if (context.mounted) {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                        await cart
                                                            .getCart(auth)
                                                            .whenComplete(() {
                                                          if (isFromBookNow !=
                                                              null) {
                                                            isFromBookNow(
                                                                cart.serviceIds,
                                                                cart.data,
                                                                cart.totalPrice);
                                                          }
                                                        });
                                                        setState(() {
                                                          isProcessing = false;
                                                        });
                                                      }
                                                    },
                                              child: isProcessing
                                                  ? const Text('Loading....')
                                                  : const Text("Proceed")),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  })),
            );
          });
        });
  }

  String getDay(String v) {
    try {
      int day = int.parse(v);
      if (day == 0) {
        print('1'.toString() + "getDay");
        return "1";
      }
      // check if - value
      if (day < 0) {
        print('0'.toString() + "getDay");
        return "0";
      }

      print("$v getDay");
      return v.toString();
    } catch (e) {
      print("${e}getDay");
      return v;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: primaryColor,
          statusBarIconBrightness: Brightness.light),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => CategoryProvider(),
          ),
        ],
        child: Consumer2<CategoryProvider, AuthProvider>(
            builder: (context, categories, auth, child) {
          return BottomNav(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: CommonHeader.header(context, onBack: () {
                Navigator.pop(context);
              }, onSearch: () {
                Navigator.pushNamed(context, ProductPageRoute.routeName);
              }),
              body: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      constraints: BoxConstraints(minHeight: 500.h),
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShareRapper(
                                title: widget.service.name,
                                url:
                                    'https://utsavlife.com/customer/service/details/${widget.service.id}',
                                child: PackageImageSlider(
                                    imageUrls: widget.service.images!)),
                            Container(
                              margin: EdgeInsets.only(top: 2.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.service.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.sp,
                                    ),
                              ),
                            ),
                            // Container(
                            //     constraints: BoxConstraints(
                            //         minHeight: 1.h,
                            //         maxHeight: double.infinity,
                            //         minWidth: double.infinity,
                            //         maxWidth: double.infinity),
                            //     padding: EdgeInsets.symmetric(
                            //       horizontal: 4.w,
                            //     ),
                            //     alignment: Alignment.centerLeft,
                            //     child:
                            //         HtmlTextView(htmlText: widget.service.description)),
                            AnimatedContainer(
                                constraints: BoxConstraints(
                                    minHeight: 1.h,
                                    maxHeight:
                                        _isShowMore ? double.infinity : 10.h,
                                    minWidth: double.infinity,
                                    maxWidth: double.infinity),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                ),
                                alignment: Alignment.centerLeft,
                                duration: const Duration(milliseconds: 600),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    print(constraints.maxHeight.toString());
                                    return HtmlTextView(
                                        htmlText:
                                            widget.service.description ?? "");
                                  },
                                )),
                            if (widget.service.description!.length > 100)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isShowMore = !_isShowMore;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: Text(
                                    _isShowMore ? "Show Less" : "Show More",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            fontSize: 14, color: primaryColor),
                                  ),
                                ),
                              ),
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: 4.w,
                            //   ),
                            //   height: 5.h,
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       const Icon(
                            //         Icons.star,
                            //         color: Color.fromARGB(255, 212, 119, 61),
                            //       ),
                            //       SizedBox(
                            //         width: 2.w,
                            //       ),
                            //       Text(
                            //         widget.service.rating ?? "Not Rated",
                            //         style: const TextStyle(
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.w600),
                            //       ),
                            //       SizedBox(
                            //         width: 2.w,
                            //       ),
                            //       Text(
                            //           "( ${widget.service.reviews!.length} rating${widget.service.reviews!.length > 1 ? "s" : ""} )")
                            //     ],
                            //   ),
                            // ),
                            const Divider(
                              thickness: 1,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 1.h),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    "\u20B9 ${widget.service.discountedPrice} ",
                                                style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context)
                                                        .primaryColorDark),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "/ ${widget.service.priceBasis}",
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: Colors.black),
                                                  ),
                                                ]),
                                            TextSpan(
                                              text:
                                                  " for ${selectedCategory?.category?.categoryName?.trim() ?? ""}",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontSize: 16.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Text(
                                        'Exc. all taxes',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const Text(
                                        'Check price for other event ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const Text(
                                        '',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  /*-- 26-07-24 : for popup categories ----*/
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      DropdownButton<ServicePopUpCategory?>(
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          underline: Container(),
                                          iconSize: 16,
                                          icon: const Icon(
                                            Icons
                                                .arrow_drop_down_circle_outlined,
                                            color: primaryColor,
                                          ),
                                          value: selectedCategory,
                                          items: popupCategories
                                              .map((e) => DropdownMenuItem<
                                                      ServicePopUpCategory>(
                                                  value: e,
                                                  child: Text(
                                                    e.category?.categoryName ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  )))
                                              .toList(),
                                          onChanged: (v) {
                                            setState(() {
                                              selectedCategory = v;
                                              _categoryName.text =
                                                  selectedCategory?.category
                                                          ?.categoryName ??
                                                      "";
                                            });
                                          })
                                    ],
                                  )
                                ],
                              ),
                            ),
                            /*-- 25-07-24 : for available city ----*/
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Available City',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  DropdownButton<String?>(
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    underline: Container(),
                                    iconSize: 16,
                                    icon: _cities.isEmpty
                                        ? Container() // Hide icon if the list is empty
                                        : const Icon(
                                            Icons
                                                .arrow_drop_down_circle_outlined,
                                            color: primaryColor,
                                          ),
                                    value: selectedCity,
                                    items: _cities.isEmpty
                                        ? [
                                            DropdownMenuItem<String>(
                                              value: defaultCityMessage,
                                              child: Text(defaultCityMessage,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                          ]
                                        : _cities.map((city) {
                                            return DropdownMenuItem<String>(
                                              value: city,
                                              child: Text(city),
                                            );
                                          }).toList(),
                                    onChanged: _cities.isEmpty
                                        ? null // Disable onChanged if the list is empty
                                        : (city) {
                                            setState(() {
                                              selectedCity = city;
                                            });
                                          },
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              height: 1,
                            ),
                            Container(
                              decoration:
                                  const BoxDecoration(color: tertiaryColor),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Pricing Info",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Discount Price:",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                          "\u20B9 ${selectedCategory?.discountPrice ?? widget.service.discountedPrice}")
                                    ],
                                  ),
                                  const DashedDivider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Original Price:",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "\u20B9 ${widget.service.price}",
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough),
                                      )
                                    ],
                                  ),
                                  // const DashedDivider(),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     const Text(
                                  //       "Unit:",
                                  //       style: TextStyle(fontSize: 16),
                                  //     ),
                                  //     Text(
                                  //       widget.service.priceBasis,
                                  //     )
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                              child: Column(children: [
                                // Container(
                                //   height: 6.h,
                                //   decoration: BoxDecoration(
                                //     border: Border.all(
                                //         width: 0.5,
                                //         color: Theme.of(context).primaryColor),
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     children: [
                                //       const Text(
                                //         'View More Details',
                                //         style: TextStyle(
                                //           fontSize: 16,
                                //           fontWeight: FontWeight.w600,
                                //           color: primaryColor,
                                //         ),
                                //       ),
                                //       SizedBox(
                                //         width: 2.w,
                                //       ),
                                //       const Icon(
                                //         Icons.arrow_forward_ios_rounded,
                                //         color: primaryColor,
                                //         size: 16,
                                //       )
                                //     ],
                                //   ),
                                // ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (auth.authState ==
                                            AuthState.LoggedIn) {
                                          addToCartDialog(context, categories);
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignInPageRoute(
                                                        comeBack: true,
                                                      ))).then((value) {
                                            if (auth.authState ==
                                                AuthState.LoggedIn) {
                                              addToCartDialog(
                                                  context, categories);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Please login to continue")));
                                            }
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 6.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: tertiaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Text('Add to Cart',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: primaryColor,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (auth.authState ==
                                            AuthState.LoggedIn) {
                                          addToCartDialog(context, categories,
                                              isFromBookNow: (serviceIds, data,
                                                  totalPrice) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckoutPage(
                                                  serviceIds: serviceIds,
                                                  cartItems: data,
                                                  cartSubTotal: totalPrice,
                                                ),
                                              ),
                                            );
                                          });
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignInPageRoute(
                                                        comeBack: true,
                                                      ))).then((value) {
                                            if (auth.authState ==
                                                AuthState.LoggedIn) {
                                              addToCartDialog(
                                                  context, categories,
                                                  isFromBookNow: (serviceIds,
                                                      data, totalPrice) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CheckoutPage(
                                                      serviceIds: serviceIds,
                                                      cartItems: data,
                                                      cartSubTotal: totalPrice,
                                                    ),
                                                  ),
                                                );
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Please login to continue")));
                                            }
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 6.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Text('Book Now',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                ),
                                margin: EdgeInsets.only(top: 1.h),
                                child: const Text(
                                  "About",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )),
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: 4.w,
                            //   ),
                            //   child: Row(
                            //     children: [
                            //       ...widget.service.s.map((e) => Container(
                            //             alignment: Alignment.centerLeft,
                            //             child: Text(e.name),
                            //           ))
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  minHeight: 1.h,
                                  maxHeight: double.infinity,
                                  minWidth: double.infinity,
                                  maxWidth: double.infinity),
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                              ),
                              alignment: Alignment.centerLeft,
                              child: HtmlTextView(
                                  htmlText: widget.service.description ?? ""),
                            ),
                            Container(
                                constraints: BoxConstraints(
                                    minHeight: 1.h,
                                    maxHeight: double.infinity,
                                    minWidth: double.infinity,
                                    maxWidth: double.infinity),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                ),
                                child: Column(
                                  children: widget.service.images!
                                      .map((e) => Container(
                                            margin: EdgeInsets.only(
                                                bottom: 2.h, top: 2.h),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: NetworkImage(e),
                                                    fit: BoxFit.cover)),
                                            height: 26.h,
                                            width: double.infinity,
                                          ))
                                      .toList(),
                                )),
                            SizedBox(
                              height: 2.h,
                            ),
                            // Container(
                            //     padding: EdgeInsets.symmetric(
                            //       horizontal: 4.w,
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       crossAxisAlignment: CrossAxisAlignment.center,
                            //       children: [
                            //         const Text(
                            //           "Reviews",
                            //           style: TextStyle(
                            //               fontSize: 20,
                            //               fontWeight: FontWeight.w600),
                            //         ),
                            //         // write review button
                            //         WriteReview(
                            //           serviceId: widget.service.id.toString(),
                            //         ),
                            //       ],
                            //     )),
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: 4.w,
                            //   ),
                            //   height: 5.h,
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       const Icon(
                            //         Icons.star,
                            //         color: Color.fromARGB(255, 212, 119, 61),
                            //       ),
                            //       SizedBox(
                            //         width: 2.w,
                            //       ),
                            //       Text(
                            //         widget.service.rating ?? "Not Rated",
                            //         style: const TextStyle(
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.w600),
                            //       ),
                            //       SizedBox(
                            //         width: 2.w,
                            //       ),
                            //       Text(
                            //           "( ${widget.service.reviews?.length} rating${widget.service.reviews!.length > 1 ? "s" : ""} )")
                            //     ],
                            //   ),
                            // ),
                            // const Divider(
                            //   thickness: 1,
                            // ),
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: 4.w,
                            //   ),
                            //   child: Column(
                            //       children: widget.service.reviews!
                            //           .getRange(
                            //               0,
                            //               min(4,
                            //                   widget.service.reviews!.length))
                            //           .map((e) => ReviewTile(e: e))
                            //           .toList()),
                            // ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => ReviewPage(
                            //                 reviews: widget.service.reviews!)));
                            //   },
                            //   child: Container(
                            //     height: 6.h,
                            //     margin: EdgeInsets.symmetric(
                            //       horizontal: 4.w,
                            //     ),
                            //     decoration: BoxDecoration(
                            //       border: Border.all(
                            //           width: 0.5,
                            //           color: Theme.of(context).primaryColor),
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       crossAxisAlignment: CrossAxisAlignment.center,
                            //       children: [
                            //         const Text(
                            //           'View All Reviews',
                            //           style: TextStyle(
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.w600,
                            //             color: primaryColor,
                            //           ),
                            //         ),
                            //         SizedBox(
                            //           width: 2.w,
                            //         ),
                            //         const Icon(
                            //           Icons.arrow_forward_ios_rounded,
                            //           color: primaryColor,
                            //           size: 16,
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Divider(
                              thickness: 1,
                              height: 6.h,
                            ),
                            const ExtraDetails(),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }
}

class WriteReview extends StatelessWidget {
  final String serviceId;

  const WriteReview({
    Key? key,
    required this.serviceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    if (auth.authState != AuthState.LoggedIn) return const SizedBox();
    return ListenableProvider(
      create: (_) => OrderProvider(context.read<AuthProvider>()),
      child: Consumer<OrderProvider>(builder: (context, state, child) {
        if (state.isLoading) return const SizedBox();
        OrderModel? order;
        try {
          order = state.deliveredData.firstWhere(
            (element) => element.service.id == serviceId,
          );
        } catch (e) {
          order = null;
        }
        if (order == null) return const SizedBox();
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              backgroundColor: scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
              ),
              builder: (context) => StatefulBuilder(
                builder: (context, setState) => RatingView(
                  // rating: value,
                  orderID: order?.id,
                ),
              ),
            );
          },
          child: Container(
            height: 4.h,
            width: 30.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Text('Write a Review',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                )),
          ),
        );
      }),
    );
  }
}

class ReviewPage extends StatefulWidget {
  final List<ReviewModel> reviews;

  const ReviewPage({Key? key, required this.reviews}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: widget.reviews.map((e) => ReviewTile(e: e)).toList(),
          ),
        ),
      ),
    );
  }
}
