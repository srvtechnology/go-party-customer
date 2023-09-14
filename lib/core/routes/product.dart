import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:customerapp/core/routes/filter.dart';
import 'package:customerapp/core/routes/singlePackage.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../components/card.dart';
import '../components/loading.dart';
import '../models/package.dart';

class ProductPageRoute extends StatefulWidget {
  static const routeName ="/product";
  const ProductPageRoute({Key? key}) : super(key: key);

  @override
  State<ProductPageRoute> createState() => _ProductPageRouteState();
}

class _ProductPageRouteState extends State<ProductPageRoute> {
  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_)=>FilterProvider(),
      child: Consumer<FilterProvider>(
        builder: (context,filters,child) {
          return ListenableProvider(
            create: (_)=>ServiceProvider(filters: filters),
            child: Consumer<ServiceProvider>(
              builder: (context,state,child) {
                if(state.isLoading){
                  return Scaffold(
                      body: Container(
                          alignment: Alignment.center,
                          child:const ShimmerWidget())
                  );
                }
                if(state.data==null){
                  return Scaffold(
                    appBar: AppBar(
                      title:const Text("Services"),
                      centerTitle: true,
                    ),
                    body: Container(
                      alignment: Alignment.center,
                      child: const Text("No services available"),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: (){
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  child: Scaffold(
                      body:Stack(
                        children: [
                          NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder: (context,isChange){
                          return [
                            SliverAppBar(
                              title: const Text("Services"),
                            floating: true,
                            snap: true,
                            elevation: 0,
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(80),
                              child: _searchBar(controller: _searchController,filterState: filters,serviceState: state),
                            )
                          )];
                    },
                    body:Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: Column(
                                children: state.data!.map((e) => ProductTile(service: e,onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleServiceRoute(service: e)));
                                },)).toList()
                              ),
                            ),
                          ),
                    ),
                          Positioned(
                            bottom: 20,
                            left: 180,
                            child: ElevatedButton(

                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                backgroundColor: Theme.of(context).primaryColorDark
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>FilterPage(filterState: filters)));
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.menu_rounded,size: 15,),
                                SizedBox(width: 10,),
                                Text("Filter")
                              ],
                            ),
                          ),)
                        ],
                      ),
                  ),
                );
              }
            ),
          );
        }
      ),
    );
  }
    Widget _searchBar({required TextEditingController controller,required FilterProvider filterState,required ServiceProvider serviceState}){
    return Container(
      color: Colors.white,
      height: 10.h,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: TextFormField(

              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                  labelText: "Search ...",
                  filled: true,
                  fillColor: const Color(0xffe5e5e5),
                  contentPadding: const EdgeInsets.only(bottom: 10,right: 5),
                prefixIcon: Icon(Icons.search,color: Theme.of(context).primaryColor,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                  enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 0.5,color: Colors.grey)
                )
              ),
            ),
          ),
          const SizedBox(width: 20,),
          IconButton(onPressed: (){
            serviceState.getFilteredServices(filterState,searchString: _searchController.text);
          }, icon: const Icon(Icons.search)),

        ],
      ),
    );
    }
}


class PackageListPageRoute extends StatefulWidget {
  final List<PackageModel> packages;
  static const routeName ="/packagelist";

  const PackageListPageRoute({Key? key,required this.packages}) : super(key: key);

  @override
  State<PackageListPageRoute> createState() => _PackageListPageRouteState();
}

class _PackageListPageRouteState extends State<PackageListPageRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Image.asset("assets/images/logo/logo-resized.png",width: 120,),
          actions: [
            Container(
              width: 250,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, ProductPageRoute.routeName);
                },
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffe5e5e5),
                      labelText: "Search ...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
            )
          ],),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: widget.packages.length,
          itemBuilder: (context,index){
            return PackageTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SinglePackageRoute(package: widget.packages[index],)));
                },
                package: widget.packages[index]);
          },
        ),
      ),
    );
  }
}
