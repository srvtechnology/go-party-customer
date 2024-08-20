import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../components/loading.dart';
import '../constant/themData.dart';
import 'package:customerapp/core/components/bottomNav.dart';
import 'package:customerapp/core/components/commonHeader.dart';
import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:customerapp/core/routes/filter.dart';
import 'package:customerapp/core/routes/singlePackage.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/card.dart';
import '../models/package.dart';
import '../models/saveSearchTextModel.dart';
import '../providers/AuthProvider.dart';

class ProductPageRoute extends StatefulWidget {
  static const routeName = "/product";
  const ProductPageRoute({Key? key}) : super(key: key);

  @override
  State<ProductPageRoute> createState() => _ProductPageRouteState();
}

class _ProductPageRouteState extends State<ProductPageRoute> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _searchBarKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  late OverlayEntry? _overlayEntry;
  final ValueNotifier<List<dynamic>?> _searchDataNotifier = ValueNotifier(null);

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _removeOverlay();
    _searchDataNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNav(
      child: ListenableProvider(
        create: (_) => FilterProvider(),
        child: Consumer<FilterProvider>(builder: (context, filters, child) {
          return ListenableProvider(
            create: (_) => ServiceProvider(
                authProvider: context.read<AuthProvider>(), filters: filters),
            child: Consumer2<ServiceProvider, AuthProvider>(builder: (
              context,
              state,
              auth,
              child,
            ) {
              if (state.isLoading) {
                return Scaffold(
                    body: Container(
                        alignment: Alignment.center,
                        child: const ShimmerWidget()));
              }

              // Update search data notifier
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (state.savedSearchData != null &&
                    state.savedSearchData!.isNotEmpty) {
                  _showOverlay(context, state.savedSearchData!, auth, state);
                } else if (state.searchData != null &&
                    state.searchData!.isNotEmpty) {
                  _removeOverlay();
                }

                _searchDataNotifier.value = state.searchData;
              });

              // Use ValueListenableBuilder to respond to changes in searchData
              return ValueListenableBuilder<List<dynamic>?>(
                valueListenable: _searchDataNotifier,
                builder: (context, searchData, child) {
                  if (searchData != null && searchData.isNotEmpty) {
                    _removeOverlay();
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
                        preferredSize:
                            Size(MediaQuery.of(context).size.width, 60),
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
                                  key: _searchBarKey,
                                  auth: auth,
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
                                          if (_searchController
                                              .text.isNotEmpty) {
                                            state.getFilteredServices(
                                                state.authProvider, filters,
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
                          return [];
                        },
                        body: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: state.isLoading
                                ? Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          height: 10,
                                        ),
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.search,
                                                    size: 100,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
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
                                              return PackageTile(
                                                package: e.package,
                                                onTap: () {
                                                  _removeOverlay();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SinglePackageRoute(
                                                              package:
                                                                  e.package),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              return ProductTile(
                                                service: e,
                                                onTap: () {
                                                  _removeOverlay();
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
                },
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _searchBar({
    required GlobalKey<State<StatefulWidget>> key,
    AuthProvider? auth,
    List<SaveSearchTextModel>? savedSearchList,
    required TextEditingController controller,
    required FilterProvider filterState,
    required ServiceProvider serviceState,
  }) {
    return Container(
      height: 10.49.h,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: TextFormField(
        key: key, // Use the passed key instead of _searchBarKey
        controller: controller,
        onTap: () {
          if (kDebugMode) {
            print('onTap - savedSearchList: $savedSearchList');
          }
          if (savedSearchList != null && savedSearchList.isNotEmpty) {
            _showOverlay(context, savedSearchList, auth, serviceState);
          }
        },
        onChanged: (value) {
          if (value.isEmpty) {
            if (savedSearchList != null && savedSearchList.isNotEmpty) {
              _showOverlay(context, savedSearchList, auth, serviceState);
            }
          } else {
            _removeOverlay();
          }
        },
        onFieldSubmitted: (value) {
          FocusScope.of(context).unfocus();
          if (controller.text.isNotEmpty) {
            serviceState.getFilteredServices(auth, filterState,
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
                serviceState.getFilteredServices(auth, filterState,
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
              // Remove the overlay when search is initiated
              _removeOverlay();
            },
            icon: const Icon(Icons.search),
            color: Colors.black,
          ),
          suffixIcon: Visibility(
            visible: controller.text.isNotEmpty ? true : false,
            child: IconButton(
              onPressed: () {
                controller.clear();
                FocusScope.of(context).unfocus();
                // Remove the overlay when clearing the search field
                _removeOverlay();
              },
              icon: const Icon(Icons.clear),
              color: Colors.black,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showOverlay(
    BuildContext context,
    List<SaveSearchTextModel>? savedSearchList,
    AuthProvider? auth,
    ServiceProvider serviceState,
  ) {
    // Get the RenderBox of the TextFormField
    final RenderBox renderBox =
        _searchBarKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx, // Position horizontally aligned with the TextFormField
        top: offset.dy +
            size.height +
            10.0, // Add padding between the TextFormField and the overlay
        width: size.width, // Match the width of the TextFormField
        child: Material(
          elevation: 4.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10), // Rounded edges
            child: Container(
              color: Colors.white,
              child: savedSearchList != null && savedSearchList.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: savedSearchList.expand((item) {
                        final dataItems = item.data;
                        return dataItems.expand((datum) {
                          return [
                            ListTile(
                              title: Text(datum.value ?? ''),
                              onTap: () {
                                _searchController.text = datum.value ?? '';
                                _removeOverlay();
                              },
                            ),
                            const Divider(), // Divider between items
                          ];
                        }).toList();
                      }).toList()
                        ..removeLast(), // Remove the last divider
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

/* Widget _searchBar({
    AuthProvider? auth,
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
            serviceState.getFilteredServices(auth, filterState,
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
                serviceState.getFilteredServices(auth, filterState,
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
  } */

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
