import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/utils/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CurrentLocationView extends StatefulWidget {
  const CurrentLocationView({super.key});

  @override
  State<CurrentLocationView> createState() => _CurrentLocationViewState();
}

class _CurrentLocationViewState extends State<CurrentLocationView> {
  Map currentLocation = {};

  @override
  void initState() {
    super.initState();

    getLocation();
  }

  void getLocation() async {
    currentLocation = await getCountryCityState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
      ),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.3),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.pin_drop_outlined,
            color: primaryColor,
          ),
          SizedBox(
            width: 2.w,
          ),
          Expanded(
            child: currentLocation.isEmpty
                ? Text(
                    'Loading....',
                    style: TextStyle(
                        fontSize: 16.sp,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        color: primaryColor),
                  )
                : Text(
                    "Deliver to ${currentLocation['city']}, ${currentLocation['country']} ${currentLocation['postalCode']} ${currentLocation['state']}",
                    style: TextStyle(
                        fontSize: 16.sp,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        color: primaryColor),
                  ),
          ),
        ],
      ),
    );
  }
}
