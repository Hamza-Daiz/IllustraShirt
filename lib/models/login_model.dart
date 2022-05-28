import 'dart:core';


class LoginResponseModel {
  bool success;
  int statutcode;
  String code;
  String message;
  Data data;
  LoginResponseModel({
    this.success,
    this.statutcode,
    this.code,
    this.message,
    this.data,
  });

  LoginResponseModel.fromJson(Map<String,dynamic> json) {
    success = json['succes'];
    statutcode = json['statutCode'];
    code = json['code'];
    message = json['message'];
    data = json['data'].length > 0  ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statutCode'] = this.statutcode;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String token;
  int id;
  String email;
  String nicename;
  String firstName;
  String displayName;
  Data(
      {this.token,
      this.id,
      this.email,
      this.firstName,
      this.nicename,
      this.displayName}
      );

  Data.fromJson( dynamic json) {
    token = json['token'];
    id = json['id'];
    email = json['email'];
    nicename = json['nicename'];
    firstName = json['firstName'];
    displayName = json['displayName'];
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['token'] = this.token;
    data['id'] = this.id;
    data['email'] = this.email;
    data['nicename'] = this.nicename;
    data['firstName'] = this.firstName;
    data['displayName'] = this.displayName;

    return data;
  }
}

