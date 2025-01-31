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
  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;
  final ValueNotifier<List<dynamic>?> _searchDataNotifier = ValueNotifier(null);

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _removeOverlay();
    _searchDataNotifier.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final serviceState = context.read<ServiceProvider>();
    final filterState = context.read<FilterProvider>();

    // Optionally pass a search string if needed
    await serviceState.getFilteredServices(
      serviceState.authProvider,
      filterState,
      searchString: _searchController.text,
    );

    //Update the UI with new data (notifier will automatically notify listeners)
    setState(() {});
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
                    state.savedSearchData!
                        .any((model) => model.data.isNotEmpty)) {
                  _showOverlay(context, state.savedSearchData!, auth, state,filters);
                } else if (state.searchData != null &&
                    state.searchData!.isNotEmpty) {
                  _removeOverlay();
                }

                // Update the search data notifier
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
                      body: state.isLoading
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10),
                                  Text(
                                    "Searching for services",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : state.data == null || state.searchData!.isEmpty
                              ? Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    width: MediaQuery.of(context).size.width,
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
                                        SizedBox(height: 5),
                                        Text(
                                          "Search for services",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: state.searchData!.length,
                                    itemBuilder: (context, index) {
                                      final e = state.searchData![index];
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
                                                  package: e.package,
                                                ),
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
                                                  service: e,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 10.49.h,
          width: constraints.maxWidth,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: TextFormField(
            key: key,
            controller: controller,
            onTap: () {
              if (savedSearchList != null && savedSearchList.isNotEmpty) {
                _showOverlay(context, savedSearchList, auth, serviceState,filterState);
              }
            },
            onChanged: (value) {
              if (value.isEmpty) {
                if (savedSearchList != null && savedSearchList.isNotEmpty) {
                  _showOverlay(context, savedSearchList, auth, serviceState,filterState);
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
              hintText: "Search...",
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
                  _removeOverlay();
                },
                icon: const Icon(Icons.search),
                color: Colors.black,
              ),
              suffixIcon: Visibility(
                visible: controller.text.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    controller.clear();
                    FocusScope.of(context).unfocus();
                    _removeOverlay();
                    //close icon click should go back from the screen...
                    Navigator.pop(context);
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
      },
    );
  }

  void _showOverlay(
      BuildContext context,
      List<SaveSearchTextModel>? savedSearchList,
      AuthProvider? auth,
      ServiceProvider serviceState,
      FilterProvider filterState,
      ) {
    if (_isOverlayVisible) return; // Prevent duplicate overlay

    _isOverlayVisible = true; // Mark overlay as visible

    final RenderBox renderBox =
    _searchBarKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeOverlay();
        },
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 10.0,
              width: size.width,
              child: Material(
                elevation: 4.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 200, // Fixed height for 4 items
                    color: Colors.white,
                    child: savedSearchList != null && savedSearchList.isNotEmpty
                        ? ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: savedSearchList
                          .expand((item) => item.data)
                          .length,
                      itemBuilder: (context, index) {
                        final datum = savedSearchList
                            .expand((item) => item.data)
                            .toList()[index];

                        return Column(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text(datum.value ?? ''),
                                      onTap: () {
                                        _removeOverlay(); // Close overlay when tapped
                                        if (datum.value != null) {
                                          serviceState.getFilteredServices(
                                              auth, filterState,
                                              searchString: datum.value);
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
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        final parentIndex = savedSearchList
                                            .indexWhere(
                                                (item) => item.data.contains(datum));
                                        if (parentIndex != -1) {
                                          savedSearchList[parentIndex].data.remove(datum);
                                          if (savedSearchList[parentIndex].data.isEmpty) {
                                            savedSearchList.removeAt(parentIndex);
                                          }
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.blue,
                                      size: 24.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    )
                        : Container(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }





  //Consumer<FilterProvider>(builder: (context, filters, child) {
  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
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
  void initState() {
    super.initState();
    print(">>>> init state product...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader.header(showBackButton: false,context, onBack: () {
        Navigator.pop(context);
      }, onSearch: () {
        if (kDebugMode) {
          print("Search");
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


