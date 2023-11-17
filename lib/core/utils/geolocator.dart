import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<Map> getCountryCityState() async {
  Position coordinates = await _determinePosition();
  List<Placemark> places = await placemarkFromCoordinates(
      coordinates.latitude, coordinates.longitude);
  return {
    "country": places[0].country,
    "city": places[0].locality,
    "postalCode": places[0].postalCode,
    "state": places[0].administrativeArea
  };
}

Future<Map> getCityStateCountryByPin(String pin) async {
  final res = await Dio().get(
      'https://maps.googleapis.com/maps/api/geocode/json?components=postal_code:$pin&key=AIzaSyBb3u4WhswXfkedBokSesulamIrCWhskG4');
  final addList = res.data['results'][0]['address_components'];
  Map address = {};
  for (var i = 0; i < addList.length; i++) {
    if (addList[i]['types'].contains('country')) {
      address['country'] = addList[i]['long_name'];
    }
    if (addList[i]['types'].contains('locality')) {
      address['city'] = addList[i]['long_name'];
    }
    if (addList[i]['types'].contains('administrative_area_level_1')) {
      address['state'] = addList[i]['long_name'];
    }
  }
  return address;
}
