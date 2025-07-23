import 'dart:convert';
import 'dart:developer';

import 'package:customerapp/config.dart';
import 'package:customerapp/core/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/logger.dart';
import '../repo/auth.dart' as authRepo;

enum AuthState { loggedOut, waiting, loggedIn, error }

class AuthProvider with ChangeNotifier {
  AuthState _authState = AuthState.waiting;
  String? _token;
  bool _isLoading = false;
  String? status;
  String? reg_otp="";

  bool get isLoading => _isLoading;
  UserModel? _user;
  bool isAgent = false;
  late final SharedPreferences pref;

  String? _regOtp; // ✅ OTP variable
  String? _agentregOtp; // ✅ OTP variable
  String? get regOtp => _regOtp;
  String? get agentregOtp => _agentregOtp;

  String? get token => _token;

  AuthState get authState => _authState;

  UserModel? get user => _user;
  int agentRegistrationStep = 1;

  int? userId;
  String? tempToken;

  void setOtp(String otp) {
    _regOtp = otp;
    notifyListeners();
  }

  void setAgentOtp(String otp) {
    _agentregOtp = otp;
    notifyListeners();
  }

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void isLoggedIn() {
    if (_token == null) {
      _authState = AuthState.loggedOut;
    } else {
      _authState = AuthState.loggedIn;
    }
    notifyListeners();
  }

  AuthProvider() {
    init();
  }

  Future<bool> register(
      String name, String email, String phone, String password) async {
    // try {
    _isLoading = true;
    notifyListeners();
    print("Registering User");
    final res = await authRepo.register(email, password, name, phone);
    print(res.toString());

    final otp = res?.data['user']['reg_otp'];
    setOtp(otp);

    if (res != null && res.statusCode == 200) {
      userId = res.data['user']['id'];
      return true;
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> verifySignupOTP(String otp) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await authRepo.verifyOTP(userId?.toString() ?? "", otp);
      if (response['status']) {
        // Add these steps from login function
        saveTokenToStorage(response['token']);
        _token = response['token'];
        _authState = AuthState.loggedIn;
        final userType = pref.getString("userType");
        await getUser(userType: userType);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerAgent(
    BuildContext context, {
    required String name,
    required String email,
    required String phone,
    required String password,
    required TextEditingController otpcontroller,
  }) async {
    // try {
    _isLoading = true;
    notifyListeners();
    print("Registering Agent");
    final res = await authRepo.registerAgent(email, password, name, phone);
    print(res.toString(),);
    print(res!.statusCode.toString());
    if (res.statusCode == 200) {
      userId = res.data['data']['id'];
      log(res.data.toString(), name: "Agent Registered OTP");

      setAgentOtp(res.data['data']['reg_otp']);
      agentRegistrationStep = 2;
      _isLoading = false;
      notifyListeners();
      return;
    }
    _isLoading = false;
    notifyListeners();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.data['error'] ?? "Invalid Credentials"),
        ),
      );
    }
  }

  Future resendOtp(scaffoldKey, {required String email}) async {
    try {
      log("Resending OTP");
      final res = await authRepo.resendOTp(userId.toString());
      log(res.toString(), name: "OTP resend");
      if (res?.statusCode == 200) {
        log(res!.data['opt_code'].toString(), name: "OTP resend");
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text("OTP sent to $email"),
          ),
        );
      }
    } catch (e) {
      CustomLogger.error(e);
    }
  }

  Future<Response?> resendCustomerOTP() async {
    try {
      Response response = await customDioClient.client
          .post("${APIConfig.baseUrl}/api/customer-login/resend-otp", data: {
        "user_id": userId,
      });
      log(jsonEncode(response.data.toString()));
      return Future.value(response);
    } catch (e) {
      return Future.value(null);
    }
  }

  Future init() async {
    startLoading();
    pref = await SharedPreferences.getInstance();
    String? tempToken = await getTokenFromStorage();
    if (tempToken == null) {
      _authState = AuthState.loggedOut;
    } else {
      try {
        _token = tempToken;
        if (kDebugMode) {
          print("Logged in");
        }
        final userType = pref.getString("userType");
        await getUser(userType: userType);

        _authState = AuthState.loggedIn;
      } catch (e) {
        _authState = AuthState.loggedOut;
      }
    }
    stopLoading();
  }

  Future<void> getUser({required String? userType}) async {
    try {
      log(userType.toString(), name: "UserType");
      if (userType == "agent") {
        final res = await authRepo.get_AgentData(_token!);
        log(res.toString(), name: "AgentData");
        _user = UserModel(
          id: res.data['data']['id'].toString(),
          name: res.data['data']['name'].toString(),
          email: res.data['data']['email'].toString(),
          mobile: res.data['data']['mobile'].toString(),
          status: res.data['data']['status'].toString(),
        );
        // isAgent = true;
        notifyListeners();
        return;
      }
      final res = await authRepo.get_UserData(_token!);
      status = res.status;
      log(status!, name: "User Status");
      if (res.status == "I") {
        logout();
        return;
      }
      _user = res;
    } catch (e) {
      logout();
    }
    notifyListeners();
  }

  void saveTokenToStorage(String tempToken) {
    pref.setString("token", tempToken);
  }

  void saveUserType(String type) {
    pref.setString("userType", type);
  }

  void saveEmailPasswordToStorage(String email, String password) {
    pref.setString("email", email);
    pref.setString("password", password);
  }

  Future<String?> getTokenFromStorage() async {
    String? tempToken = pref.getString("token");
    return tempToken;
  }

  Future<String?> getEmailFromStorage() async {
    String? email = pref.getString("email");
    return email;
  }

  Future<String?> getPasswordFromStorage() async {
    String? password = pref.getString("password");
    return password;
  }

  void deleteTokenFromStorage() {
    pref.remove("token");
    pref.remove("email");
    pref.remove("password");
  }

  void reLogin() async {
    String? email = await getEmailFromStorage();
    String? password = await getPasswordFromStorage();
    if (email != null && password != null) login(email, password);
  }

  Future<void> login(String email, String password) async {
    _authState = AuthState.waiting;
    notifyListeners();
    try {
      String tempToken = await authRepo.login(email, password);
      saveTokenToStorage(tempToken);
      saveEmailPasswordToStorage(email, password);
      _token = tempToken;
      _authState = AuthState.loggedIn;
      final userType = pref.getString("userType");
      await getUser(userType: userType);
      log("token: $_token");
    } catch (e) {
      _authState = AuthState.error;
      notifyListeners();

      // Show error message
      CustomLogger.error(e);

      // Reset the authState after handling the error
      Future.delayed(const Duration(seconds: 2), () {
        _authState = AuthState.loggedOut;
        notifyListeners();
      });
      rethrow;
    }
    notifyListeners();
  }

  Future loginAgent(
    scaffoldKey, {
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await authRepo.agentLogin(
        email: email,
        password: password,
      );
      if (res?.statusCode == 200) {
        final tempToken = res!.data['token'];
        if (tempToken == null) {
          ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
            SnackBar(
              content: Text(res.data['error'] ?? "Invalid Credentials"),
            ),
          );

          // Reset auth state after showing the error message.
          _authState = AuthState.loggedOut;
          notifyListeners();
          return;
        }
        saveTokenToStorage(tempToken);
        saveEmailPasswordToStorage(email, password);
        saveUserType("agent");
        _token = tempToken;
        _authState = AuthState.loggedIn;
        final userType = pref.getString("userType");
        await getUser(userType: userType);
      }
    } catch (e) {
      CustomLogger.error(e);
      _authState = AuthState.error;
      notifyListeners();

      // Reset the auth state after the error is handled
      Future.delayed(const Duration(seconds: 2), () {
        _authState = AuthState.loggedOut;
        notifyListeners();
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void deleteAllFromStorage() {
    pref.remove("token");
    pref.remove("userType");
    pref.clear();
  }

  void logout() {
    _token = null;
    _authState = AuthState.loggedOut;
    _user = null;
    CustomLogger.debug("Changed");
    notifyListeners();
    deleteTokenFromStorage();
  }

  Future deActivateAccount() async {
    log("Deactivating account");
    log(_token!, name: 'token');
    log(_user!.id.toString(), name: "UserId");
    try {
      _isLoading = true;
      final data = await authRepo.de_Activate(_token!, _user!.id);
      if (data["status"] == true) {
        _token = null;
        _authState = AuthState.loggedOut;
        _user = null;
        CustomLogger.debug("Changed");
        notifyListeners();
        deleteTokenFromStorage();
      } // from repo
    } catch (e) {
      _isLoading = false;
    } finally {
      _isLoading = false;
    }
  }

  void clear() async {
    CustomLogger.debug("Deleting all data");
    final SharedPreferences instance = await SharedPreferences.getInstance();
    instance.clear();
  }

  Future registerAgentOtp(scaffoldKey, {required String otp}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await authRepo.submitAgentOTp(
        otp,
        userId,
      );
      log(res!.data.toString());
      if (res.data['status'] == true) {
        tempToken = res.data['token'];
        log(res.data.toString(), name: "Agent Registered 2");
        agentRegistrationStep = 3;
      } else {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text("Invalid OTP"),
          ),
        );
      }
    } catch (e) {
      CustomLogger.error(e);
      _authState = AuthState.error;
      agentRegistrationStep = 2;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future registerAgentBankDetails(
    BuildContext context, {
    required String email,
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
    required String ifscCode,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await authRepo.submitAgentBankData(
        user_id: userId.toString(),
        bankName: bankName,
        accountNumber: accountNumber,
        accountHolderName: accountHolderName,
        ifscCode: ifscCode,
      );
      log(res?.data.toString() ?? "", name: 'registerAgentBankDetails');

      if (res?.statusCode == 200) {
        log(res!.data.toString(), name: "Agent Registered 3");
        saveTokenToStorage(tempToken ?? "");
        saveEmailPasswordToStorage(email, password);
        saveUserType("agent");
        _token = tempToken;
        agentRegistrationStep = 1;
        _authState = AuthState.loggedIn;
        final userType = pref.getString("userType");
        await getUser(userType: userType);
      } else {
        throw Exception('Bank registration failed.');
      }
    } catch (e) {
      log(e.toString(), name: "registerAgentBankDetails");
      _authState = AuthState.error;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

