import 'package:customerapp/config.dart';
import 'package:customerapp/core/models/customerDetailsModel.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../utils/dio.dart';

Future<CustomerDetailsModel> getProfileData(AuthProvider auth) async {
  Response response = await customDioClient.client.get(
    "${APIConfig.baseUrl}/api/customer-details",
    options: Options(headers: {"Authorization": "Bearer ${auth.token}"}),
  );

  CustomLogger.debug("UserData : $response");
  if (kDebugMode) {
    print("Raw response data: ${response.data}");
  }
  // Create and return a CustomerDetailsModel instance from the response data
  return CustomerDetailsModel.fromJson(response.data);
}

Future<void> updateProfileData(
    AuthProvider auth, Map<String, dynamic> data, Uint8List? imageFile) async {
  try {
    // Create a FormData object from the data map
    FormData formData = FormData.fromMap(data);

    // If an image file is provided, add it to the formData
    if (imageFile != null) {
      var mimeType = lookupMimeType('', headerBytes: imageFile);
      var fileType = mimeType?.split('/');
      if (kDebugMode) {
        print(imageFile);
        print('file type $fileType');
        print(mimeType);
      }
      formData.files.add(
        MapEntry(
          'image', // The key expected by the server for the image file
          MultipartFile.fromBytes(
            imageFile,
            filename: 'profile_image.${fileType?[1] ?? 'png'}',
            // Use the extension from mimeType or default to 'png'
            contentType: MediaType(
                fileType![0], fileType[1]), // Use both type and subtype
          ),
        ),
      );
    }

    CustomLogger.debug(
        "UserData : $data + ImageFile : ${imageFile != null ? "Yes" : "No"}");

    // Send the request with the FormData
    Response response = await customDioClient.client.post(
      "${APIConfig.baseUrl}/api/customer-update",
      data: formData,
      options: Options(headers: {"Authorization": "Bearer ${auth.token}"}),
    );

    // Optionally, handle the response if needed
    CustomLogger.debug("Response: ${response.data}");
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response?.data);
    }
    return Future.error(e);
  }
}

/* Future<void> editProfile(AuthProvider auth, Map<String, dynamic> data) async {
  try {
    CustomLogger.debug(data);
    Response response = await customDioClient.client.post(
        "${APIConfig.baseUrl}/api/customer-update",
        data: FormData.fromMap(data),
        options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
  } catch (e) {
    if (e is DioException) {
      CustomLogger.error(e.response!.data);
    }
    return Future.error(e);
  }
} */
