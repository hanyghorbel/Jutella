import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userId = "USERKEY";
  static String userName = "USERNAME";
  static String userEmail = "USEREMAIL";
  //save data to shared preferences in firebase
  static Future<bool> saveUserId(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(userId, isUserLoggedIn);
  }
  static Future<bool> saveUserName(
      String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userName, name);
  }
  static Future<bool> saveUserEmail(
      String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userEmail, email);
  }
  //get data from shared preferences in firebase
  static Future<bool?> userstatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userId);
  }
  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userName);
  }
  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmail);
  }
}