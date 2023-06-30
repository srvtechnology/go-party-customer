import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/logger.dart';
import '../repo/auth.dart' as authRepo;

enum AuthState {
  LoggedOut,
  Waiting,
  LoggedIn,
  Error
}
class AuthProvider with ChangeNotifier {
  AuthState _authState = AuthState.Waiting;
  String? _token=null;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  UserModel? _user;
  late final SharedPreferences pref;
  String? get token => _token ;
  AuthState get authState => _authState;
  UserModel? get user => _user ;
  void startLoading(){
    _isLoading = true;
    notifyListeners();
  }
  void stopLoading(){
    _isLoading = false;
    notifyListeners();
  }
  void isLoggedIn(){
    if (_token==null){
      _authState = AuthState.LoggedOut ;
    }
    else{
      _authState = AuthState.LoggedIn;
    }
    notifyListeners();
  }
  AuthProvider(){
    init();
  }
  void init()async{
    startLoading();
    pref = await SharedPreferences.getInstance();
    String? tempToken =await getTokenFromStorage();
    if(tempToken==null){
      _authState = AuthState.LoggedOut;
    }
    else{
      _token = tempToken;
      print("Logged in");
      await getUser();
      _authState = AuthState.LoggedIn ;

    }
    stopLoading();
  }
  Future<void> getUser()async{
    print("Getting user data");
    _user = await authRepo.get_UserData(_token!); // from repo
  }
  void saveTokenToStorage(String tempToken){
    pref.setString("token", tempToken);
  }
  void saveEmailPasswordToStorage(String email,String password){
    pref.setString("email", email);
    pref.setString("password", password);
  }
  Future<String?> getTokenFromStorage()async{
    String? tempToken = pref.getString("token");
    return tempToken;
  }
  Future<String?> getEmailFromStorage()async{
    String? email = pref.getString("email");
    return email;
  }
  Future<String?> getPasswordFromStorage()async{
    String? password = pref.getString("password");
    return password;
  }
  void deleteTokenFromStorage(){
    pref.remove("token");
    pref.remove("email");
    pref.remove("password");
  }
  void reLogin()async{
    String? email =await getEmailFromStorage();
    String? password =await getPasswordFromStorage();
    if(email!=null && password!=null)login(email, password);
  }
  Future<void> login(String email,String password)async{
    _authState = AuthState.Waiting;
    notifyListeners();
    try {
      String tempToken = await authRepo.login(email, password);
      saveTokenToStorage(tempToken);
      saveEmailPasswordToStorage(email, password);
      _token = tempToken;
      _authState = AuthState.LoggedIn;
      await getUser();
    }
    catch(e){
      _authState = AuthState.Error;
    }
    notifyListeners();
  }
  void deleteAllFromStorage(){
    pref.clear();
  }
  void logout(){
    _token = null;
    _authState = AuthState.LoggedOut;
    _user = null ;
    CustomLogger.debug("Changed");
    notifyListeners();
    deleteTokenFromStorage();
  }

  void clear()async{
    CustomLogger.debug("Deleting all data");
    final SharedPreferences instance = await SharedPreferences.getInstance();
    instance.clear();
  }
 }