import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:customerapp/core/components/Rating_view.dart';
import 'package:customerapp/core/constant/HorizontalImageSlider.dart';
import 'package:customerapp/core/models/orders.dart';
import 'package:customerapp/core/models/single_package.dart';
import 'package:customerapp/core/utils/textFormater.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../views/view.dart';
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
import 'package:customerapp/core/routes/checkoutPage.dart';

import '../components/banner.dart';
import '../utils/logger.dart';

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
  bool _isShowMoreFD = false;
  bool isProcessing = false;

  int passindex=0;

  List<String> _cities = [];
  String? selectedCity = " Select a City";
  String defaultCityMessage = "Open for every city";
  bool isLoading = false;

  List<PopupCategory> popupCategories = [];
  PopupCategory? selectedCategory;
  bool isExpanded = false;
  /* List<String> videoUrls = []; */

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
      if (kDebugMode) {
        print('${e.toString()} getDay error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print(">>>>_SingleServiceRouteState");
    _startDate.addListener(_calculateDays);
    _endDate.addListener(_calculateDays);
    _quantity.text = widget.service.minQnty.toString() == "0" ||
            widget.service.minQnty.toString() == "null"
        ? "1"
        : widget.service.minQnty.toString();
    _duration.text = "Full Day";
    getSingleService();
  }

  Future<void> getSingleService() async {
    try {
      setState(() {
        isLoading = true;
      });
      ServiceModel data =
          await getSingleServiceData(widget.service.id.toString());
      log(data.toString(), name: "Single Service Data");
      popupCategories = data.popupCategories ?? [];
      if (popupCategories.isNotEmpty) {
        selectedCategory = popupCategories.first;
        _categoryName.text = selectedCategory!.category?.categoryName ?? "";
      }
      /* videoUrls = data.videoUrl ?? [];
      log(videoUrls.toString(), name: "Single Service VideoUrl"); */
      _cities = data.availableCities ?? [];
      if (_cities.isNotEmpty) {
        selectedCity = _cities.first;
      } else {
        selectedCity = defaultCityMessage;
      }
    } catch (e) {
      CustomLogger.error(e);
    } finally {
      setState(() {
        isLoading = false;
      });
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
                                      if (_startDate.text.isEmpty) {
                                        return "Please select a start date first.";
                                      }
                                      if (kDebugMode) {
                                        print(
                                          _startDate.text,
                                        );
                                      }
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
                                     const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        "Quantity",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: _quantity,
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return "Required";
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
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 0.5,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          hintText: "Select Quantity"),
                                    ),
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
                                            keyboardType: TextInputType.number,
                                            controller: _days,
                                            validator: (text) {
                                              if (text == null ||
                                                  text.isEmpty) {
                                                return "";
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
                                        Visibility(
                                          visible: false,
                                          child: QuantityManager(
                                            qnty: _quantity.text,
                                            minQnty:
                                                widget.service.minQnty == null
                                                    ? 1
                                                    : int.parse(widget
                                                        .service.minQnty
                                                        .toString()),
                                            onChanged: (v) {
                                              setState(() {
                                                _quantity.text = v;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
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
                                              "\u20B9 ${double.parse(selectedCategory?.discountPrice.toString() ?? widget.service.price.toString()) * int.parse(_quantity.text)}",
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
                                                        };
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

                                                          setState((){
                                                            isProcessing=false;
                                                          });
                                                        }

                                                        if (context.mounted) {
                                                          setState(() {
                                                            isProcessing = false;
                                                          });
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
          return BottomNav(onTabChange: (p0) {
            print(">>>>>>onTabChange$p0");
            setState(() {
              passindex=p0;
            });
          },
            index: passindex==0?null:passindex,
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
                                  imageUrls: widget.service.images!,
                                  videoUrls: widget.service.videos!,
                                )),
                            Container(
                              margin: EdgeInsets.only(top: 0.h),
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
                                        color: Colors.black),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Company Name',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.service.companyName != null &&
                                        widget.service.companyName!
                                            .trim()
                                            .isNotEmpty
                                    ? widget.service.companyName!
                                    : "NA",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp,
                                        color: Theme.of(context).primaryColor),
                              ),
                            ),

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
                                    if (kDebugMode) {
                                      print(constraints.maxHeight.toString());
                                    }
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
                                    _isShowMore ? "Show Less" : "Read More",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            fontSize: 14, color: primaryColor),
                                  ),
                                ),
                              ),
                            const Divider(
                              thickness: 1,
                              height: 1,
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: (selectedCategory
                                                                ?.discountPrice
                                                                ?.toString()
                                                                .trim() ??
                                                            "0") ==
                                                        "0"
                                                    ? "\u20B9 ${selectedCategory?.servicePrice?.toString().trim() ?? "0.00"} "
                                                    : "\u20B9 ${selectedCategory?.discountPrice?.toString().trim() ?? "0.00"} ",
                                                style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context)
                                                        .primaryColorDark),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "for ${selectedCategory?.category?.categoryName?.trim() ?? ""}",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColorDark,
                                                        fontSize: 20.sp),
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      ),
                                      const Text(
                                        'Exc. all taxes',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Check price for other event',
                                        style:  TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: MediaQuery.of(context).size.width - 30.0,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor, // Background color
                                          borderRadius: BorderRadius.circular(12.0), // Rounded corners
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0), // Internal padding
                                        child: DropdownButton<PopupCategory?>(
                                          isExpanded: true,
                                          style: TextStyle(color: Theme.of(context).primaryColor),
                                          underline: Container(),
                                          iconSize: 20,
                                          icon: const Icon(
                                            Icons.arrow_drop_down_circle_outlined,
                                            color: Colors.white, // Icon color to match the blue background
                                          ),
                                          value: selectedCategory, // Ensure this is the correct binding to selectedCategory
                                          hint: selectedCategory == null
                                              ? Text(
                                            "Select a category", // Hint text
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white, // Hint text color
                                            ),
                                          )
                                              : null, // Hide the hint once a value is selected
                                          dropdownColor: Theme.of(context).primaryColor, // Optional: Dropdown menu background
                                          items: popupCategories
                                              .map(
                                                (e) => DropdownMenuItem<PopupCategory>(
                                              value: e,
                                              child: Text(
                                                e.category?.categoryName ?? "",
                                                style: const TextStyle(fontSize: 14, color: Colors.white),
                                              ),
                                            ),
                                          )
                                              .toList(),
                                          onChanged: (PopupCategory? newValue) {
                                            setState(() {
                                              selectedCategory = newValue; // Update selectedCategory when a new value is selected
                                              _categoryName.text = selectedCategory?.category?.categoryName ?? "";
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              height: 1,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.h
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
                                  if ((selectedCategory?.discountPrice ?? "0")
                                          .toString() !=
                                      "0") ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Discount Price:",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                            "\u20B9 ${selectedCategory?.discountPrice ?? "0.0"}")
                                      ],
                                    ),
                                  ],
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
                                        "\u20B9 ${selectedCategory?.servicePrice ?? widget.service.price}",
                                        style: TextStyle(
                                            decoration: (selectedCategory
                                                            ?.discountPrice
                                                            ?.toString()
                                                            .trim() ??
                                                        "0") ==
                                                    "0"
                                                ? TextDecoration.none
                                                : TextDecoration.lineThrough),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: !isLoading,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 2.h),
                                child: Column(children: [
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (auth.authState ==
                                              AuthState.loggedIn) {
                                            addToCartDialog(
                                                context, categories);
                                          } else {
                                            showAuthDialog(context, auth,
                                                categories, false);
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
                                        height: 2.h,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (auth.authState ==
                                              AuthState.loggedIn) {
                                            addToCartDialog(context, categories,
                                                isFromBookNow: (serviceIds,
                                                    data, totalPrice) {
                                              List<String> lis=[];
                                              lis.add("${selectedCategory?.id}");
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckoutPage(
                                                    serviceIds:lis ,
                                                    cartItems: data,
                                                    cartSubTotal: double.parse("${selectedCategory?.discountPrice}"),
                                                  ),
                                                ),
                                              );
                                            });
                                          } else {
                                            showAuthDialog(context, auth,
                                                categories, true);
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
                            ),
                            const Divider(
                              thickness: 1,
                              height: 1,
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
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: const Divider(
                                thickness: 1,
                                height: 1,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: 8.0,
                                  left: 15.0,
                                  bottom: 8.0),
                              child: Text(
                                "Feature Image",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Container(
                                  constraints: const BoxConstraints(
                                      maxHeight: double.infinity,
                                      minWidth: double.infinity,
                                      maxWidth: double.infinity),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: HorizontalImageSlider(images: widget.service.images!)),
                            ),

                            const SizedBox(height: 5,),

                            const SizedBox(height: 5,),
                            if (widget.service.featured_description != null ||
                                parseHtmlString(widget.service.featured_description ?? "") != "") ...[
                              Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [


                                      const Text(
                                        "Feature Description",
                                        style: TextStyle(
                                          fontSize: 16, //16
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      AnimatedContainer(
                                        constraints: BoxConstraints(
                                          minHeight: 1.h,
                                          maxHeight: _isShowMoreFD
                                              ? MediaQuery.of(context).size.height // Use screen height instead of infinity
                                              : 30.h,
                                          minWidth: double.infinity,
                                          maxWidth: double.infinity,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        duration: const Duration(milliseconds: 600),
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            if (kDebugMode) {
                                              print(constraints.maxHeight.toString());
                                            }
                                            return HtmlTextView(
                                              htmlText: widget.service.featured_description ?? "",
                                            );
                                          },
                                        ),
                                      )
                                      ,
                                      if (widget.service.featured_description!.length > 100)
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isShowMoreFD = !_isShowMoreFD;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 4.w,
                                            ),
                                            child: Text(
                                              _isShowMoreFD ? "Read Less" : "Read More",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                  fontSize: 14, color: primaryColor),
                                            ),
                                          ),
                                        ),
                                     // Text(parseHtmlString(),),

                                    ],
                                  )),

                              const Divider(thickness: 1, // Thickness of the line
                                height: 1,  ),
                              const ExtraDetails(),
                            ],
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

  void showAuthDialog(BuildContext context, AuthProvider authProvider,
      CategoryProvider categories, bool isBookNow) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Authentication Required'),
          content: const Text(
              'You need to be signed in to add items to the cart or proceed to checkout.'),
          actions: [
            // Sign In Button
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const SignInPageRoute(
                      comeBack: true,
                    ),
                  ),
                ).then((_) {
                  if (authProvider.authState == AuthState.loggedIn) {
                    if (isBookNow) {
                      addToCartDialog(context, categories,
                          isFromBookNow: (serviceIds, data, totalPrice) {
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
                      addToCartDialog(context, categories);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please login to continue"),
                      ),
                    );
                  }
                });
              },
              child: const Text('Sign In'),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const SignUpPageRoute(
                      comeback: true,
                    ),
                  ),
                ).then((_) {
                  if (authProvider.authState == AuthState.loggedIn) {
                    if (isBookNow) {
                      addToCartDialog(context, categories,
                          isFromBookNow: (serviceIds, data, totalPrice) {
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
                      addToCartDialog(context, categories);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please sign up to continue"),
                      ),
                    );
                  }
                });
              },
              child: const Text('Sign Up'),
            ),
          ],
        );
      },
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
    if (auth.authState != AuthState.loggedIn) return const SizedBox();
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