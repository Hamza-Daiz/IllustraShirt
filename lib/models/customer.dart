import 'dart:core';

class CustomerModel{
  String name ;
  String email ;
  String password ;

  CustomerModel({
    this.name,
    this.email,
    this.password,
  });

    Map< String , dynamic> toJson(){
        Map<String, dynamic> map = {};
        map.addAll(
          {
            'email':email,
            'first_name' :name ,
            'password':password,
            'username': email,
          }
        );
        return map;
    }


}