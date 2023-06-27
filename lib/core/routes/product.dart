import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../components/card.dart';

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
    return Scaffold(
        body:NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context,isChange){
        return [SliverAppBar(
          floating: true,
          snap: true,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(10.h),
            child: _searchBar(controller: _searchController),
          )
        )];
      },
      body:Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProductTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000"),
                ProductTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000"),
                ProductTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000"),
                ProductTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000"),
                ProductTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000"),
                ProductTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000"),
                ProductTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000"),
                ProductTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000"),
                ProductTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000"),
                ProductTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000"),

              ],
            ),
          ),
        ),
      ),
    );
  }
    Widget _searchBar({required TextEditingController controller}){
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
          Expanded(
            flex: 4,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
                ),
                backgroundColor: Colors.redAccent
              ),
              onPressed: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.account_tree_outlined,size: 15,),
                  Text("Filters"),
                ],
              ),
            ),
          )
        ],
      ),
    );
    }
}
