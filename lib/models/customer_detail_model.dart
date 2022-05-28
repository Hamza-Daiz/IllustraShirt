
import 'dart:convert';

final String tableShipping = "shipping" ;

class BagFields{

  static final List<String> values = [
    id,name,city,adress,zipCode,phone,email,
  ];

  static final String id = "_id";
  static final String name= "first_name";
  static final String city= "city";
  static final String adress= "address_1";
  static final String zipCode= "postcode";
  static final String phone= "phone";
  static final String email= "email";

}

class Billing{
    int id;
    String firstname;
    String adress;
    String city;
    String zipCode;
    String phone;
    String email;

    Billing({
      this.id,
      this.firstname,
      this.city,
      this.phone,
      this.email,
      this.adress,
      this.zipCode,
  });


   /* static Billing fromJson(Map<String,dynamic> json) => Billing(

      id : json[BagFields.id] as int,
      name: json[BagFields.name] as String,
      city: json[BagFields.city] as String,
      adress: json[BagFields.adress] as String,
      phone: json[BagFields.phone] as String,
      zipCode: json[BagFields.zipCode] as String,

    );*/

    Billing.fromJson(Map<String,dynamic> json){

      firstname = json['first_name'] ;
      adress=json['address_1'];
      city=json['city'];
      zipCode = json['postcode'];
      email=json['email'];
      phone=json['phone'];

    }


    Map<String,dynamic> toJson(){
      Map<String,dynamic> data = new Map<String,dynamic>();

      data['first_name']=this.firstname ;
      data['address_1']=this.adress;
      data['city']=this.city;
      data['postcode']=this.zipCode;
      data['email']=this.email;
      data['phone']=this.phone;


      return data;
    }

    Billing copy({

      int id,

      /*String imageUrl,
    String name,
    double price,
    String size,
    String type,
    String sex ,
    int count,
    String city,
    String color,
    String category,
    File imageFileGallery,*/

    }) => Billing(
      id: id ?? this.id,
    );

}




class CustomerDetailsModel{

  int id ;
  String name;
  Billing billing;
  Shipping shipping;

  CustomerDetailsModel(
      {this.id,
        this.name,
        this.billing,
        this.shipping}
      );



  CustomerDetailsModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    name = json['first_name'] ;
    billing = (json['billing'] != null ?
    new Billing.fromJson(json['billing'])
        : null);
    shipping = (json['shipping'] != null ? new Shipping.fromJson(json['shipping']) : null) ;

  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> data = new Map<String,dynamic>();

    data['id']=this.id;
    data['first_name']=this.name;
    data['last_name']=this.name;
    data['billing']=this.billing.toJson();
    data['shipping']=this.shipping.toJson();


    return data;
  }

}


class Shipping{
  String name;
  String adress;
  String city;
  String zipCode;



  Shipping({
    this.name,
    this.city,
    this.adress,
    this.zipCode,
  });

  Shipping.fromJson(Map<String,dynamic> json){

    name = json['first_name'];
    adress=json['address_1'];
    city=json['city'];
    zipCode = json['postcode'];

  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> data = new Map<String,dynamic>();

    data['first_name']=this.name;
    data['address_1']=this.adress;
    data['city']=this.city;
    data['postcode']=this.zipCode;


    return data;
  }

}



