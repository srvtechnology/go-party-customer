import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/components/bottomNav.dart';
import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:customerapp/core/routes/filter.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../components/card.dart';
import '../components/loading.dart';

class ViewAllServiceRoute extends StatefulWidget {
  static const routeName = "/viewallservice";
  const ViewAllServiceRoute({Key? key}) : super(key: key);

  @override
  State<ViewAllServiceRoute> createState() => _ViewAllServiceRouteState();
}

class _ViewAllServiceRouteState extends State<ViewAllServiceRoute> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BottomNav(
      child: ListenableProvider(
        create: (_) => FilterProvider(),
        child: Consumer<FilterProvider>(builder: (context, filters, child) {
          return ListenableProvider(
            create: (_) => ServiceProvider(filters: filters),
            child: Consumer<ServiceProvider>(builder: (context, state, child) {
              if (state.isLoading) {
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
              }
              return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                child: Scaffold(
                  body: NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder: (context, isChange) {
                      return [
                        SliverAppBar(
                          title: const Text("Services"),
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
                                        builder: (context) =>
                                            FilterPage(filterState: filters)));
                              },
                            )
                          ],
                          elevation: 0,
                          backgroundColor: primaryColor,
                          // bottom: PreferredSize(
                          //   preferredSize: const Size.fromHeight(80),
                          //   child: Container(
                          //     child: _searchBar(
                          //         controller: _searchController,
                          //         filterState: filters,
                          //         serviceState: state),
                          //   ),
                          // ),
                        )
                      ];
                    },
                    body: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      // color: Colors.white,
                      child: SingleChildScrollView(
                        // padding: EdgeInsets.only(bottom: 5.h, top: 2.h),
                        child: Container(
                          child: Column(
                              children: state.data!
                                  .map((e) => ProductTile(
                                        service: e,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SingleServiceRoute(
                                                          service: e)));
                                        },
                                      ))
                                  .toList()),
                        ),
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

  Widget _searchBar(
      {required TextEditingController controller,
      required FilterProvider filterState,
      required ServiceProvider serviceState}) {
    return Container(
      // color: Colors.white,
      height: 10.49.h,
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        // autofocus: true,
        controller: controller,
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
}

// class PackageListPageRoute extends StatefulWidget {
//   final List<PackageModel> packages;
//   static const routeName = "/packagelist";

//   const PackageListPageRoute({Key? key, required this.packages})
//       : super(key: key);

//   @override
//   State<PackageListPageRoute> createState() => _PackageListPageRouteState();
// }

// class _PackageListPageRouteState extends State<PackageListPageRoute> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonHeader.header(context, onBack: () {
//         Navigator.pop(context);
//       }, onSearch: () {
//         Navigator.pushNamed(context, ViewAllServiceRoute.routeName);
//       }),
//       body: Container(
//         // padding: const EdgeInsets.symmetric(vertical: 10),
//         child: ListView.builder(
//           itemCount: widget.packages.length,
//           itemBuilder: (context, index) {
//             return PackageTile(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => SinglePackageRoute(
//                                 package: widget.packages[index],
//                               )));
//                 },
//                 package: widget.packages[index]);
//           },
//         ),
//       ),
//     );
//   }
// }
