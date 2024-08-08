import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../constant/themData.dart';
import 'package:customerapp/core/components/bottomNav.dart';
import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/components/htmlTextView.dart';
import 'package:customerapp/core/components/quantity_Manager.dart';
import 'package:customerapp/core/components/share_rapper.dart';
import 'package:customerapp/core/models/cartModel.dart';
import 'package:customerapp/core/models/single_package.dart';
import 'package:customerapp/core/providers/cartProvider.dart';
import 'package:customerapp/core/repo/services.dart';
import 'package:customerapp/core/routes/cartPage.dart';
import 'package:customerapp/core/routes/checkoutPage.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/signin.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../components/banner.dart';
import '../components/divider.dart';
import '../models/package.dart';
import '../providers/AuthProvider.dart';
import '../providers/categoryProvider.dart';
import '../repo/cartRepo.dart';

class SinglePackageRoute extends StatefulWidget {
  final PackageModel package;

  const SinglePackageRoute({Key? key, required this.package}) : super(key: key);

  @override
  State<SinglePackageRoute> createState() => _SinglePackageRouteState();
}

class _SinglePackageRouteState extends State<SinglePackageRoute> {
  bool isLoading = false;
  final TextEditingController _categoryName = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  final TextEditingController _startDateView = TextEditingController();
  final TextEditingController _endDateView = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  bool isProcessing = false;
  final TextEditingController _days = TextEditingController();
  final TextEditingController _duration = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<PopupCategory> popupCategories = [];
  PopupCategory? selectedCategory;

  void _calculateDays() {
    if (_startDate.text.isNotEmpty && _endDate.text.isNotEmpty) {
      if (DateTime.parse(_startDate.text)
          .isAfter(DateTime.parse(_endDate.text))) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Start date should be less than end date")));
      }
    }
    _days.text = getDay((DateTime.parse(_endDate.text)
            .difference(DateTime.parse(_startDate.text))
            .inDays)
        .toString());
  }

  String getDay(String v) {
    try {
      int day = int.parse(v);
      if (day == 0) {
        return "1";
      }
      if (day < 0) {
        print('0'.toString() + "getDay");
        return "0";
      }

      print("$v getDay");
      return day.toString();
    } catch (e) {
      return v;
    }
  }

  bool _isShowMore = false;

  @override
  void initState() {
    super.initState();

    getSinglePackage();
    _startDate.addListener(_calculateDays);
    _endDate.addListener(_calculateDays);
    quantity.text = widget.package.minQnty.toString() == "0" ||
            widget.package.minQnty.toString() == "null"
        ? "1"
        : widget.package.minQnty.toString();
    _duration.text = "Full Day";
    log(widget.package.minQnty.toString(), name: "Package");
    /*_categoryName.addListener(() {
      if (popupCategories.isNotEmpty) {
        selectedCategory = popupCategories.firstWhere(
            (element) => element.category?.categoryName == _categoryName.text);
        setState(() {});
        log(selectedCategory!.category!.categoryName.toString(),
            name: "Selected Category");
      }
    });*/
  }

  Future<void> getSinglePackage() async {
    try {
      setState(() {
        isLoading = true;
      });
      SinglePackageData data =
          await getSinglePackageData(widget.package.id.toString());
      log(data.toString(), name: "Single Package Data");
      popupCategories = data.packages?.popupCategories ?? [];
      if (popupCategories.isNotEmpty) {
        selectedCategory = popupCategories.first;
        _categoryName.text = selectedCategory!.category?.categoryName ?? "";
      }
    } catch (e) {
      CustomLogger.error(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
                    return SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                                  widget.package.name,
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
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
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
                                                    element.category
                                                        ?.categoryName ==
                                                    p0);
                                            _categoryName.text = p0;
                                          });
                                        },
                                        borderSide: BorderSide(
                                            width: 0.5,
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                        hintText: "Select Your Event ",
                                        controller: _categoryName,
                                        items: popupCategories
                                            .map((e) =>
                                                e.category?.categoryName ?? "")
                                            .toList(),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
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
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
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
                                        if (kDebugMode) {
                                          print(
                                            _startDate.text,
                                          );
                                        }
                                        // check end date is greater than start date
                                        if (DateTime.parse(_startDate.text)
                                            .isAfter(DateTime.parse(
                                                _endDate.text))) {
                                          return "End date should be greater than start date";
                                        }

                                        /*--- commented on 31-07-24 : to validate if
                                      * start date and end end is same but before 4:00 P.M --*/
                                        // if start date and end date is same then show error
                                        /*if (DateTime.parse(_startDate.text)
                                            .isAtSameMomentAs(DateTime.parse(
                                                _endDate.text))) {
                                          return "End date should be greater than start date";
                                        }*/

                                        // Check if the start and end dates are the same
                                        if (DateTime.parse(_startDate.text)
                                            .isAtSameMomentAs(DateTime.parse(
                                                _endDate.text))) {
                                          // Check if the end time is before 4:00 PM
                                          if (DateTime.parse(_endDate.text)
                                                  .hour <
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
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
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
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _days,
                                              validator: (text) {
                                                if (text == null ||
                                                    text.isEmpty) {
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
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 0.5,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  hintText: "Days"),
                                            ),
                                          ),
                                          QuantityManager(
                                            qnty: quantity.text,
                                            minQnty: selectedCategory?.minQty ??
                                                widget.package.minQnty,
                                            onChanged: (v) {
                                              setState(() {
                                                quantity.text = v;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      // show Package price
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.h, horizontal: 2.w),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.5,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                "\u20B9 ${selectedCategory?.discountPrice ?? widget.package.discountedPrice}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      // CustomDropdown(
                                      //     borderSide: BorderSide(
                                      //         width: 0.5,
                                      //         color: Theme.of(context)
                                      //             .primaryColor),
                                      //     borderRadius:
                                      //         BorderRadius.circular(10),
                                      //     items: const [
                                      //       "Full Day",
                                      //       "Morning",
                                      //       "Night"
                                      //     ],
                                      //     controller: _duration),
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
                                                        if (_formKey
                                                            .currentState!
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
                                                          Map data = {
                                                            "package_id": widget
                                                                .package.id,
                                                            "cart_category":
                                                                categoryId,
                                                            "date":
                                                                _startDate.text,
                                                            "end_date":
                                                                _endDate.text,
                                                            "quantity":
                                                                quantity.text,
                                                            "days": _days.text,
                                                            "time": _duration
                                                                .text
                                                                .substring(0, 1)
                                                          };

                                                          try {
                                                            await addtoCart(
                                                                context.read<
                                                                    AuthProvider>(),
                                                                data);
                                                          } catch (e) {
                                                            CustomLogger.error(
                                                                e);
                                                          }
                                                          if (context.mounted) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text("Successfully added to cart")));
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
                                                            isProcessing =
                                                                false;
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
                      ),
                    );
                  })),
            );
          });
        });
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
              body: Container(
                constraints: BoxConstraints(minHeight: 500.h),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShareRapper(
                          title: widget.package.name,
                          url:
                              'https://utsavlife.com/customer/package/details/${widget.package.id}',
                          child: PackageImageSlider(
                              imageUrls: widget.package.images)),
                      Container(
                        margin: EdgeInsets.only(top: 2.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.package.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                              ),
                        ),
                      ),
                      /* --- commented for the fix below on : 29-07-24 --*/
                      /* AnimatedContainer(
                          constraints: BoxConstraints(
                              minHeight: 1.h,
                              maxHeight: _isShowMore ? double.infinity : 10.h,
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
                                  htmlText: widget.package.description);
                            },
                          )),
                      if (widget.package.description.length > 100)
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
                                  .copyWith(fontSize: 14, color: primaryColor),
                            ),
                          ),
                        ), */
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        child: Column(
                          key: ValueKey<bool>(_isShowMore),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              constraints: BoxConstraints(
                                minHeight: 1.h,
                                maxHeight: _isShowMore ? double.infinity : 10.h,
                                minWidth: double.infinity,
                                maxWidth: double.infinity,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                              ),
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                physics: _isShowMore
                                    ? const NeverScrollableScrollPhysics()
                                    : null,
                                child: HtmlTextView(
                                    htmlText: widget.package.description),
                              ),
                            ),
                            if (widget.package.description.length > 100)
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
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      if (!isLoading)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text:
                                                "\u20B9 ${selectedCategory?.discountPrice ?? widget.package.discountedPrice} ",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                            children: [
                                              // TextSpan(
                                              //   text: "/ ${widget.package.}",
                                              //   style: TextStyle(
                                              //       fontSize: 15.sp,
                                              //       color: Colors.black),
                                              // ),
                                              TextSpan(
                                                text:
                                                    "for ${selectedCategory?.category?.categoryName?.trim() ?? ""}",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    fontSize: 14.sp),
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    'Exc. all taxes',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const Text(
                                    'Check price for other event ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const Text(
                                    '',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  DropdownButton<PopupCategory?>(
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                      underline: Container(),
                                      iconSize: 16,
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                        color: primaryColor,
                                      ),
                                      value: selectedCategory,
                                      items: popupCategories
                                          .map((e) =>
                                              DropdownMenuItem<PopupCategory>(
                                                  value: e,
                                                  child: Text(
                                                    e.category?.categoryName ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  )))
                                          .toList(),
                                      onChanged: (v) {
                                        setState(() {
                                          selectedCategory = v;
                                          _categoryName.text = selectedCategory
                                                  ?.category?.categoryName ??
                                              "";
                                        });
                                      })
                                ],
                              )
                            ],
                          ),
                        ),
                      if (!isLoading)
                        const Divider(
                          thickness: 1,
                          height: 1,
                        ),
                      if (!isLoading)
                        Container(
                          decoration: const BoxDecoration(color: tertiaryColor),
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pricing Info",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
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
                                      "\u20B9 ${selectedCategory?.discountPrice ?? widget.package.discountedPrice}")
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
                                    "\u20B9 ${selectedCategory?.servicePrice ?? widget.package.price}",
                                    style: const TextStyle(
                                        decoration: TextDecoration.lineThrough),
                                  )
                                ],
                              ),
                              const DashedDivider(),
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
                          // SizedBox(
                          //   height: 2.h,
                          // ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (auth.authState == AuthState.LoggedIn) {
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
                                        addToCartDialog(context, categories);
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
                                    borderRadius: BorderRadius.circular(10),
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
                                  if (auth.authState == AuthState.LoggedIn) {
                                    addToCartDialog(context, categories,
                                        isFromBookNow:
                                            (serviceIds, data, totalPrice) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CheckoutPage(
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
                                        addToCartDialog(context, categories,
                                            isFromBookNow:
                                                (serviceIds, data, totalPrice) {
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
                                    borderRadius: BorderRadius.circular(10),
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
                      /* ---commented About since it shows the same as above Show More/Less on : 29-07-24 --*/
                      /*  Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                          ),
                          margin: EdgeInsets.only(top: 1.h),
                          child: const Text(
                            "About",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                        ),
                        child: Row(
                          children: [
                            ...widget.package.services.map((e) => Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(e.name ?? ''),
                                ))
                          ],
                        ),
                      ),
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
                        child:
                            HtmlTextView(htmlText: widget.package.description),
                      ),
                      */
                      const Divider(
                        thickness: 1,
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
                            children: widget.package.images
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

                      const ExtraDetails()
                      // SizedBox(
                      //   height: 5.h,
                      // ),
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

class SelectCategory extends StatelessWidget {
  const SelectCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Weeding', 'Birthday', 'Party']
            .map((e) => ListTile(
                  title: Text(e),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }
}
