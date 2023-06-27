import 'package:customerapp/core/components/card.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_icons/simple_icons.dart';

class HomePageScreen extends StatefulWidget {
  static const routeName = "/home";
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int currentIndex = 0;
  List<Widget> items = const [Orders(),Home(),Profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            currentIndex = index ;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag),label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
        ],
      ),
    );
  }
}

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, ProductPageRoute.routeName);
          }, icon: const Icon(Icons.search)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.add_shopping_cart)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            OrderTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000", date: "10.08.23"),
            OrderTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000", date: "10.08.23"),
            OrderTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000", date: "10.08.23"),
            OrderTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000", date: "10.08.23"),
            OrderTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000", date: "10.08.23"),
            OrderTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000", date: "10.08.23"),
            OrderTile(category: "Wedding", service: "Planning", vendor: "Paras Ltd", price: "45000", date: "10.08.23"),
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){},
            child: Row(
              children:const [
                Expanded(child: Icon(Icons.location_city)),
                Expanded(child: Icon(Icons.arrow_drop_down))
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Home"),
        actions: [
          IconButton(onPressed: (){

            Navigator.pushNamed(context, ProductPageRoute.routeName);
          }, icon: const Icon(Icons.search)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.add_shopping_cart)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_border)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
                padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                child: Text("Discover the experience",style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600,fontSize: 19.sp),)),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Our top services",style: Theme.of(context).textTheme.labelLarge,),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CircularOrderCard(service: "Catering", category: "Birthday", imageUrl:""),
                        CircularOrderCard(service: "Catering", category: "Birthday", imageUrl:""),
                        CircularOrderCard(service: "Catering", category: "Birthday", imageUrl:""),
                        CircularOrderCard(service: "Catering", category: "Birthday", imageUrl:""),
                        CircularOrderCard(service: "Catering", category: "Birthday", imageUrl:""),
                        CircularOrderCard(service: "Catering", category: "Birthday", imageUrl:""),
                        CircularOrderCard(service: "Catering", category: "Birthday", imageUrl:""),

                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Trending",style: Theme.of(context).textTheme.labelLarge,),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Top Searches of the week",style: Theme.of(context).textTheme.labelLarge,),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Top Categories",style: Theme.of(context).textTheme.labelLarge,),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "Catering", category: "Birthday", imageUrl:"",price:"1499"),
                        OrderCard(service: "More", category: "", imageUrl:"",price:"1499"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){

            Navigator.pushNamed(context, ProductPageRoute.routeName);
          }, icon: const Icon(Icons.search)),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: const Center(
                child: CircleAvatar(
                  radius: 50.0,
                  child: Icon(Icons.person),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_2_outlined),
              title: const Text('Edit Profile'),
              onTap: () {
                // Handle "History" option tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                // Handle "History" option tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                // Handle "Feedback" option tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_phone),
              title: const Text('Contact'),
              onTap: () {
                // Handle "Contact" option tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle "Logout" option tap
              },
            ),
          ],
        ),
      ),
    );
  }
}
