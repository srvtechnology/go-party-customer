import 'package:customerapp/core/components/card.dart';
import 'package:customerapp/core/routes/product.dart';
import 'package:customerapp/core/routes/view_all_service.dart';
import 'package:flutter/material.dart';

import '../models/service.dart';

class EventsPage extends StatefulWidget {
  final List<EventModel> events;
  const EventsPage({Key? key, required this.events}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Image.asset(
          "assets/images/logo/logo-resized.png",
          width: 120,
        ),
        actions: [
          Container(
            width: 250,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () {
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
                    )),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: widget.events.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  /* Navigator.pushNamed(context, ProductPageRoute.routeName); */
                  /* --commented on : 09-04-24 -- */
                  Navigator.pushNamed(context, ViewAllServiceRoute.routeName);
                },
                child: CircularEventCard(event: widget.events[index]));
          },
        ),
      ),
    );
  }
}
