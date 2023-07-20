import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:customerapp/core/routes/filter.dart';
import 'package:customerapp/core/routes/singleService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../components/card.dart';
import '../components/loading.dart';

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
                return Scaffold(
                    body:NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context,isChange){
                    return [
                      SliverAppBar(
                        title: const Text("Services"),
                      floating: true,
                      snap: true,
                      elevation: 0,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(60),
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
      height: 9.h,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(bottom: 10,right: 5),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                )
              ),
            ),
          ),
          const SizedBox(width: 20,),
          IconButton(onPressed: (){
            serviceState.getFilteredServices(filterState,searchString: _searchController.text);
          }, icon: const Icon(Icons.search)),
          Expanded(
            flex: 4,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
                ),
                backgroundColor: Colors.redAccent
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FilterPage(filterState: filterState,))).then((value) => serviceState.getFilteredServices(filterState));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:  [
                  const Icon(Icons.account_tree_outlined,size: 15,),
                  Text("Filters",style: TextStyle(fontSize: 12.sp),),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20,),
        ],
      ),
    );
    }
}
