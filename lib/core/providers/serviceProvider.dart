import 'dart:convert';
import 'dart:developer';

import 'package:customerapp/core/models/saveSearchTextModel.dart';
import 'package:customerapp/core/repo/services.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import '../models/package.dart';
import '../models/service.dart';
import 'AuthProvider.dart';

class ServiceProvider with ChangeNotifier {
  AuthProvider? authProvider;

  List<ServiceModel>? _data;

  List<ServiceModel>? get data => _data;

  List<ServiceModel>? searchData = [];
  List<SaveSearchTextModel>? savedSearchData = [];

  List<String> banner1Images = [];
  List<String> mobileBannerImages = [];

  List<EventModel>? _eventData = [];

  List<EventModel>? get eventData => _eventData;

  List<PackageModel>? _packageData = [];

  List<PackageModel>? get packageData => _packageData;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ServiceProvider(
      {AuthProvider? authProvider, required FilterProvider filters}) {
    if (filters.hasFilters == true) {
      CustomLogger.debug("Getting filtered Services");
      getFilteredServices(authProvider, filters);
    } else {
      getAllServices();
    }
    getSavedSearchText(authProvider);
  }

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getAllServices() async {
    try {
      startLoading();
      _data = await getServices();
      banner1Images = await getBannerImages();
      mobileBannerImages = await getMobileBannerImages();
      _eventData = await getEvents();
      _packageData = await getPackages();
    } catch (e) {
      if (e is DioException) {
        CustomLogger.error(e);
      }
      CustomLogger.error(e);
    } finally {
      stopLoading();
    }
  }

  Future<void> getFilteredServices(AuthProvider? auth, FilterProvider filters,
      {String? searchString, bool isUpdateMainData = false}) async {
    try {
      log("Getting filtered Services");
      log(filters.categories.toString());
      log(filters.services.toString());
      log(filters.cities.toString());
      log(filters.sortOptions.toString());
      log(filters.startPrice.toString(), name: "Start Price");
      log(filters.endPrice.toString(), name: "End Price");

      startLoading();

      Map<String, dynamic> data = {};

      if (searchString != null) {
        data["search"] = searchString;
      } else {
        data["search"] = "";
      }

      log(searchString!, name: "SearchKeyword");

      if (filters.startPrice != null && filters.endPrice != null) {
        data["start_price"] = filters.startPrice;
        data["end_price"] = filters.endPrice;
      } else {
        data["start_price"] = "";
        data["end_price"] = "";
      }

      if (filters.categories.isNotEmpty) {
        filters.categories.forEachIndexed((index, value) {
          data["category[$index]"] = value;
        });
      } else {
        data["category"] = "";
      }

      if (filters.services.isNotEmpty) {
        filters.services.forEachIndexed((index, value) {
          data["service_ids[$index]"] = value;
        });
      } else {
        data["service_ids"] = "";
      }

      if (filters.cities.isNotEmpty) {
        filters.cities.forEachIndexed((index, value) {
          data["city_ids[$index]"] = value;
        });
      } else {
        data["city_ids"] = "";
      }

      String highToLow = "";
      String lowToHigh = "";

      for (var element in filters.sortOptions) {
        if (element.contains("High to Low")) {
          highToLow = "high";
          lowToHigh = "";
        } else if (element.contains("Low to High")) {
          lowToHigh = "low";
          highToLow = "";
        } else {
          highToLow = "";
          lowToHigh = "";
        }
      }

      data["high_to_low"] = highToLow;
      data["low_to_high"] = lowToHigh;

      log(jsonEncode(data), name: "Filter Data");
      if (isUpdateMainData) {
        _data = await searchServices(data);
        return;
      }

      searchData = await searchServices(data);
      callSaveSearchStringAPi(auth, searchString);
      log(searchData.toString(), name: "SearchData");
    } catch (e) {
      CustomLogger.error(e);
    } finally {
      stopLoading();
    }
  }

  Future<void> refresh() async {
    try {
      startLoading();
      _data = await getServices();
      banner1Images = await getBannerImages();
      mobileBannerImages = await getMobileBannerImages();
      _eventData = await getEvents();
      _packageData = await getPackages();
    } catch (e) {
      if (e is DioException) {
        CustomLogger.error(e);
      }
      CustomLogger.error(e);
    } finally {
      stopLoading();
    }
  }

  Future<void> callSaveSearchStringAPi(
      AuthProvider? auth, String searchString) async {
    if (auth == null &&
        auth!.authState != AuthState.LoggedIn &&
        auth.user == null &&
        searchString.isNotEmpty) {
      log("==> CallSearchSaveString Failed");
      return;
    } else {
      Map<String, dynamic> searchStringSaveData = {};
      searchStringSaveData["search_title"] = searchString;
      await saveSearchTextApi(auth, searchStringSaveData);
      /* await getSavedSearchText(auth); */
      notifyListeners();
    }
  }

  Future<void> getSavedSearchText(AuthProvider? auth) async {
    if (auth == null &&
        auth!.authState != AuthState.LoggedIn &&
        auth.user == null) {
      log("==> GetSearchSaveString Failed");
      return;
    } else {
      savedSearchData = await getSavedSearchTextApi(auth);
      /* await getSavedSearchText(auth); 
      notifyListeners();*/
      log("savedSearchData : $savedSearchData");
    }
  }

  Future<void> clearSavedSearchTextApi(AuthProvider? auth) async {
    if (auth == null &&
        auth!.authState != AuthState.LoggedIn &&
        auth.user == null) {
      log("==> GetSearchSaveString Failed");
      return;
    } else {
      await clearSavedSearchApi(auth);
      /*  await getSavedSearchText(auth); */
      notifyListeners();
    }
  }
}

class FilterProvider with ChangeNotifier {
  List<String> _events = [];
  List<String> _services = [];
  List<String> _cities = [];
  List<String> _sortOptions = [];
  String? _startPrice, _endPrice;

  List<String> get categories => _events;

  List<String> get services => _services;

  List<String> get cities => _cities;

  List<String> get sortOptions => _sortOptions;
  bool _hasFilters = false;

  bool get hasFilters => _hasFilters;

  String? get startPrice => _startPrice;

  String? get endPrice => _endPrice;

  void setFilters(
      {required List<String> events,
      required List<String> services,
      required List<String> cities,
      required List<String> sortOptions,
      String? startPrice,
      String? endPrice}) {
    _events = [...events];
    _services = [...services];
    _cities = [...cities];
    _sortOptions = [...sortOptions];
    _startPrice = startPrice;
    _endPrice = endPrice;
    _hasFilters = true;
    notifyListeners();
  }

  Future<void> refresh() async {
    _events = [];
    _services = [];
    _cities = [];
    _startPrice = null;
    _endPrice = null;
    _hasFilters = false;
    notifyListeners();
  }
}
