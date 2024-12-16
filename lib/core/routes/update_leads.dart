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
class UpdateLeads extends StatefulWidget {
  static const routeName = "/update-leads";
  Leads? preLeads;

  UpdateLeads({
  this.preLeads});

  @override
  State<UpdateLeads> createState() => UpdateLeadsState();
}

class UpdateLeadsState extends State<UpdateLeads> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  String? selectedCategory_id;
  String? selectedService_id;
  late AuthProvider auth;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

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
    print(">>>${widget.preLeads?.leadName!}");
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
        selectedCategory_id = widget.preLeads?.categoryId!;
        selectedService_id = widget.preLeads?.agentId!;

        // Prefill the text fields with preLead data
        _nameController.text = widget.preLeads?.leadName??"";
        _addressController.text = widget.preLeads?.leadAddress!??"";
        _cityController.text = widget.preLeads?.leadCity!??"";
        _pinController.text = widget.preLeads?.leadPin!??"";
        _emailController.text = widget.preLeads?.leadEmail!??"";
        _mobileController.text = widget.preLeads?.leadPhone!??"";

        print(">>>>${categoriesList.length}");
        print(">>>>${servicesList.length}");
      });
    } catch (e) {
      print("Error fetching services: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Leads'),
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
                const Text('Mobile', style: TextStyle(fontSize: 16)),
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
                      saveLeads();
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

  Future<void> saveLeads() async {
    try {
      final options = Options(
        headers: {"Authorization": "Bearer ${auth.token}"},
        validateStatus: (status) {
          return status! < 500;
        },
      );

      Response response = await Dio().post(
        "${APIConfig.baseUrl}/api/agent/update-leads",
        data: {
          "category_id": selectedCategory_id,
          "service_id": selectedService_id,
          "lead_name": _nameController.text,
          "lead_address": _addressController.text,
          "lead_pin": _pinController.text,
          "lead_email": _emailController.text,
          "lead_phone": _mobileController.text,
        },
        options: options,
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


