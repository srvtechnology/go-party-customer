import 'dart:convert';
import 'dart:developer';

import 'package:customerapp/core/models/Leadspersons.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart';
import '../models/service.dart';
import '../providers/AuthProvider.dart';
import '../utils/dio.dart';
import '../utils/logger.dart';

class AddLeads extends StatefulWidget {
  static const routeName = "/add-leads";

  @override
  State<AddLeads> createState() => AddLeadsState();
}
class AddLeadsState extends State<AddLeads> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  // Dropdown values
  String? selectedCategory_id;
  String? selectedService_id;
  late AuthProvider auth;

  // Text field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  // Dummy dropdown options
  late List<EventModel> categoriesList = [];
  late List<ServiceModel> servicesList = [];

  // Get the services here
  Future<List<ServiceModel>> getServices() async {
    try {
      Response response = await customDioClient.client
          .get("${APIConfig.baseUrl}/api/customer-all-service");
      log(jsonEncode(response.data), name: "GetServices Response");
      List<ServiceModel> services = [];
      for (var serviceJson in response.data["services"]) {
        try {
          services.add(ServiceModel.fromJson(serviceJson));
        } catch (e) {
          CustomLogger.error(e);
        }
      }
      return services;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<EventModel>> getEvents() async {
    try {
      Response response =
      await Dio().get("${APIConfig.baseUrl}/api/view-all-events");
      log(jsonEncode(response.data), name: "Package events");
      List<EventModel> events = [];
      for (var eventJson in response.data["data"]) {
        try {
          events.add(EventModel.fromJson(eventJson));
        } catch (e) {
          CustomLogger.error(eventJson);
        }
      }
      return events;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthProvider>(context, listen: false);
    initialiseData();
  }

  void initialiseData() async {
    try {
      // Fetch services and categories
      List<ServiceModel> services = await getServices();
      List<EventModel> categories = await getEvents();

      // Update state
      setState(() {
        categoriesList = categories;
        servicesList = services;
        isLoading = false;

        // Initialize selectedCategory_id and selectedService_id if lists are not empty
        if (categoriesList.isNotEmpty) {
          selectedCategory_id = categoriesList[0].id;
        }
        if (servicesList.isNotEmpty) {
          selectedService_id = servicesList[0].id;
        }

        print(">>>>${categoriesList.length}");
        print(">>>>${servicesList.length}");
      });
    } catch (e) {
      // Handle error
      print("Error fetching services: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Leads'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Dropdown
                const Text('Category', style: TextStyle(fontSize: 16)),
                DropdownButtonFormField<String>(
                  value: selectedCategory_id,
                  items: categoriesList
                      .map((category) => DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory_id = value;
                      print(">>>>$selectedCategory_id");
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a category' : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 16),

                // Service Dropdown
                const Text('Service', style: TextStyle(fontSize: 16)),
                DropdownButtonFormField<String>(
                  value: selectedService_id,
                  items: servicesList
                      .map((service) => DropdownMenuItem(
                    value: service.id,
                    child: Text(service.name!),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedService_id = value;
                      print(">>>>$selectedService_id");
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a service' : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
                const SizedBox(height: 16),

                // Name Field
                const Text('User Name', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name',
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 16),

                // Address Field
                const Text('Address', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your address',
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Please enter your address'
                      : null,
                ),
                const SizedBox(height: 16),

                // City Field
                const Text('City', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your city',
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Please enter your city'
                      : null,
                ),
                const SizedBox(height: 24),
                const Text('Pin', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your pin',
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Please enter your pin'
                      : null,
                ),
                const SizedBox(height: 24),
                const Text('Email', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Please enter your email'
                      : null,
                ),
                const SizedBox(height: 24),
                const Text('mobile', style: TextStyle(fontSize: 16)),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your mobile number',
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty
                      ? 'Please enter your mobile number'
                      : null,
                ),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true; // Show loader
                      });
                      addLeads();
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Response?> addLeads() async {
    try {
      final options = Options(
        headers: {
          "Authorization": "Bearer ${auth.token}",
          "Accept": "application/json",
        },
        validateStatus: (status) {
          return status! < 500;
        },
      );

      final url = "${APIConfig.baseUrl}/api/agent/save-leads";
      final requestData = {
        "category_id": selectedCategory_id,
        "service_id": selectedService_id,
        "lead_name": _nameController.text,
        "lead_address": _addressController.text,
        "lead_city":_cityController.text,
        "lead_pin": _pinController.text,
        "lead_email": _emailController.text,
        "lead_phone": _mobileController.text,
      };

      // Log request details
      log(">>>>Request URL: $url", name: "API Request");
      log(">>>>Request Headers: ${options.headers}", name: "API Request");
      log(">>>>Request Body: $requestData", name: "API Request");

      // Make the request
      Response response = await Dio().post(url, data: requestData, options: options);

      // Log response details
      log("Response Status Code: ${response.statusCode}", name: "API Response");
      log("Response Data: ${response.data}", name: "API Response");

      // Assuming the response contains 'success' and 'message'
      bool success = response.data['success'];
      String message = response.data['message'];

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success: $message')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $message')),
        );
      }

      return response;
    } catch (e) {
      log("Error: ${e.toString()}", name: "API Error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
      return null;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveLeads() async {
    try {
      final options = Options(
        headers: {"Authorization": "Bearer ${auth.token}"},
        validateStatus: (status) {
          return status! < 500;
        },
      );

      Response response = await customDioClient.client.post("${APIConfig.baseUrl}/api/agent/save-leads", data: {
          "category_id": selectedCategory_id,
          "service_id": selectedService_id,
          "lead_name": _nameController.text,
          "lead_address": _addressController.text,
          "lead_pin": _pinController.text,
          "lead_email": _emailController.text,
          "lead_phone": _mobileController.text,
        }, options: options,
      );
      bool success = response.data['success'];
      String message = response.data['message'];

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success: $message')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $message')),
        );
      }
    } catch (e) {
      log(jsonEncode(e.toString()), name: "Save leads Error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

