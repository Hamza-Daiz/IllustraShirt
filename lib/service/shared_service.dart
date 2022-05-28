import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:illustrashirt/models/login_model.dart';


class SharedServices{

  static Future<bool> isLoggedIn()async{
    final prefs = await SharedPreferences.getInstance();


    return prefs.getString("login_details")!= null  ? true : false ;

  }

  static Future<LoginResponseModel> loginDetails()async{

    final prefs = await SharedPreferences.getInstance();


    return prefs.getString("login_details")!= null  ?
    LoginResponseModel.fromJson(jsonDecode(prefs.getString("login_details"))) :
    null ;

  }


  static Future<void> setLoginDetails(
      LoginResponseModel loginResponseModel
      )async{

    final prefs = await SharedPreferences.getInstance();


    return prefs.setString(
        "login_details",
        loginResponseModel != null ?
        jsonEncode(loginResponseModel.toJson()) :
        null
    );
  }

  static Future<void> logOut() async{
    await setLoginDetails(null);

  }

}