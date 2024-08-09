import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant/themData.dart';
import 'package:customerapp/core/components/bottomNav.dart';
import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:customerapp/core/routes/filter.dart';
import 'package:customerapp/core/routes/singlePackage.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../components/card.dart';
import '../models/package.dart';

class ProductPageRoute extends StatefulWidget {
  static const routeName = "/product";
  const ProductPageRoute({Key? key}) : super(key: key);

  @override
  State<ProductPageRoute> createState() => _ProductPageRouteState();
}

class _ProductPageRouteState extends State<ProductPageRoute> {
  final TextEditingController _searchController = TextEditingController();
  // Timer? _timer;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNav(
      child: ListenableProvider(
        create: (_) => FilterProvider(),
        child: Consumer<FilterProvider>(builder: (context, filters, child) {
          return ListenableProvider(
            create: (_) => ServiceProvider(filters: filters),
            child: Consumer<ServiceProvider>(builder: (context, state, child) {
              /* if (state.isLoading) {
                return Scaffold(
                    body: Container(
                        alignment: Alignment.center,
                        child: const ShimmerWidget()));
              }
              if (state.data == null) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("Services"),
                    centerTitle: true,
                    elevation: 0,
                  ),
                  body: Container(
                    alignment: Alignment.center,
                    child: const Text("No services available"),
                  ),
                );
              } */

              if (kDebugMode) {
                print('StateData: ${state.data}');
                print('SearchData: ${state.searchData}');
                print('SearchString: ${_searchController.text}');
              }

              bool showFilterIcon = state.data != null &&
                  state.searchData != null &&
                  state.searchData!.isNotEmpty;

              return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size(MediaQuery.of(context).size.width, 60),
                    child: Material(
                      elevation: 0.1,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        color: primaryColor,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios),
                              color: Colors.white,
                            ),
                            Expanded(
                                child: _searchBar(
                              controller: _searchController,
                              filterState: filters,
                              serviceState: state,
                            )),
                            if (showFilterIcon)
                              IconButton(
                                icon: const Icon(Icons.tune),
                                color: Colors.white,
                                onPressed: () {
                                  if (_searchController.text.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg:
                                          "Search field cannot be empty to apply filter",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FilterPage(
                                          filterState: filters,
                                        ),
                                      ),
                                    ).then((_) {
                                      /* -- Reload filtered services when returning from the filter page -- */
                                      if (_searchController.text.isNotEmpty) {
                                        state.getFilteredServices(filters,
                                            searchString:
                                                _searchController.text);
                                      }
                                    });
                                  }
                                },
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                  body: NestedScrollView(
                    controller: _scrollController,
                    floatHeaderSlivers: true,
                    headerSliverBuilder: (context, isChange) {
                      return [
                        /* SliverAppBar(
                            title: _searchBar(
                              controller: _searchController,
                              filterState: filters,
                              serviceState: state,
                            ),
                            floating: true,
                            snap: true,
                            pinned: true,
                            actions: [
                              // filter button
                              IconButton(
                                icon: const Icon(Icons.tune),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FilterPage(
                                                filterState: filters,
                                              )));
                                  if (_searchController.text.isNotEmpty) {
                                    state.getFilteredServices(filters,
                                        searchString: _searchController.text);
                                  }
                                },
                              )
                            ],
                            elevation: 0,
                            backgroundColor: primaryColor,
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(80),
                              child: Container(
                                child: _searchBar(
                                    controller: _searchController,
                                    filterState: filters,
                                    serviceState: state),
                              ),
                            )) */
                      ];
                    },
                    body: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      // color: Colors.white,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        // padding: EdgeInsets.only(bottom: 5.h, top: 2.h),
                        child: state.isLoading
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    // search icon
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // search text
                                    Text(
                                      "Searching for services",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    )
                                  ],
                                ),
                              )
                            : Column(
                                children: state.data == null ||
                                        state.searchData!.isEmpty
                                    ? [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.6,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              // search icon
                                              Icon(
                                                Icons.search,
                                                size: 100,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              // search text
                                              Text(
                                                "Search for services",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        )
                                      ]
                                    : state.searchData!.map((e) {
                                        if (e.package is PackageModel) {
                                          /* -- Handle the case where e is a PackageModel -- */
                                          return PackageTile(
                                            package: e.package,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SinglePackageRoute(
                                                          package: e.package),
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          /* --- Handle the case where e is a ServiceModel -- */
                                          return ProductTile(
                                            service: e,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SingleServiceRoute(
                                                          service: e),
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }).toList()),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _searchBar({
    required TextEditingController controller,
    required FilterProvider filterState,
    required ServiceProvider serviceState,
  }) {
    return Container(
      height: 10.49.h,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: (value) {
          if (controller.text.isNotEmpty) {
            serviceState.getFilteredServices(filterState,
                searchString: controller.text);
          } else {
            Fluttertoast.showToast(
              msg: "Search field cannot be empty",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 10, left: 20),
          hintText: "Search ...",
          filled: true,
          fillColor: Colors.white,
          prefixIcon: IconButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                serviceState.getFilteredServices(filterState,
                    searchString: controller.text);
              } else {
                Fluttertoast.showToast(
                  msg: "Search field cannot be empty",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            icon: const Icon(Icons.search),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0.5, color: Colors.white),
          ),
        ),
      ),
    );
  }

  /*--- commented on 06-8-24 : to fix the scrolling
  issue on click of Done button in keypad
  ----*/
  /*
  Widget _searchBar(
      {required TextEditingController controller,
      required FilterProvider filterState,
      required ServiceProvider serviceState}) {
    return Container(
      // color: Colors.white,
      height: 10.49.h,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: TextFormField(
        // autofocus: true,
        controller: controller,
        onChanged: (v) {
          // if (_timer != null) _timer?.cancel();
          Debouncer(milliseconds: 500).run(() {
            serviceState.getFilteredServices(filterState,
                searchString: _searchController.text);
          });
          // _timer = Timer(const Duration(milliseconds: 500), () async {
          //   await serviceState.getFilteredServices(filterState,
          //       searchString: _searchController.text);
          // });
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 10, left: 20),
            hintText: "Search ...",
            filled: true,
            fillColor: Colors.white,
            prefixIcon: IconButton(
                onPressed: () {
                  serviceState.getFilteredServices(filterState,
                      searchString: _searchController.text);
                },
                icon: const Icon(Icons.search)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 0.5, color: Colors.white))),
      ),
      // height: 10.h,
      // padding: const EdgeInsets.all(20),
      // child: Row(
      //   children: [

      //     SizedBox(
      //       width: 4.w,
      //     ),
      //     IconButton(
      //         onPressed: () {
      //           serviceState.getFilteredServices(filterState,
      //               searchString: _searchController.text);
      //         },
      //         icon: const Icon(Icons.search)),
      //   ],
      // ),
    );
  }
  */
}

class PackageListPageRoute extends StatefulWidget {
  final List<PackageModel> packages;
  static const routeName = "/packagelist";

  const PackageListPageRoute({Key? key, required this.packages})
      : super(key: key);

  @override
  State<PackageListPageRoute> createState() => _PackageListPageRouteState();
}

class _PackageListPageRouteState extends State<PackageListPageRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.header(context, onBack: () {
        Navigator.pop(context);
      }, onSearch: () {
        if (kDebugMode) {
          print("search");
        }
        Navigator.pushNamed(context, ProductPageRoute.routeName);
      }),
      body: ListView.builder(
        itemCount: widget.packages.length,
        itemBuilder: (context, index) {
          return PackageTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SinglePackageRoute(
                              package: widget.packages[index],
                            )));
              },
              package: widget.packages[index]);
        },
      ),
    );
  }
}
