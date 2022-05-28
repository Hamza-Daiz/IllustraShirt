import 'dart:io';

import 'package:illustrashirt/db/bag_database.dart';

final String tableBag = "bag" ;

class BagFields{

  static final List<String> values = [
    id,name,price,size,type,sex,count,city,color,category,imagePathFromGallerie,imageUrl,
  ];

  static final String id = "_id";
  static final String imageUrl = "imageUrl";
  static final String name= "name";
  static final String price= "price";
  static final String size= "size";
  static final String type= "type";
  static final String sex= "sex" ;
  static final String count= "count";
  static final String city= "city";
  static final String color= "color";
  static final String imagePathFromGallerie= "imagePathFromGallerie";
  static final String category= "category";

}

class BasketModel{
  int id;
  String imageUrl;
  String name;
  double price;
  String size;
  String type;
  String sex ;
  int count;
  String city;
  String color;
  String category;
  String imagePathFromGallerie;
  File imageFileGallery;

  BasketModel({
    this.id,
  this.imageUrl,
  this.name,
  this.price,
  this.size,
  this.type,
  this.category,
  this.sex,
  this.count,
  this.color,
  this.city,
  this.imagePathFromGallerie,
  this.imageFileGallery
  });


  static BasketModel fromJson(Map<String,dynamic> json) => BasketModel(
    id :  json[BagFields.id] as int ,
    name :  json[BagFields.name] as String ,
    price :  json[BagFields.price]+0.0as double ,
    size :  json[BagFields.size]as String ,
    color :  json[BagFields.color]as String ,
    type :  json[BagFields.type]as String ,
    sex :  json[BagFields.sex] as String,
    category :  json[BagFields.category]as String ,
    count :  json[BagFields.count] as int ,
    city :  json[BagFields.city]as String ,
    imagePathFromGallerie :  json[BagFields.imagePathFromGallerie]as String ,
    imageUrl :  json[BagFields.imageUrl]as String ,

  );


  Map<String,dynamic> toJson() =>
      {
    BagFields.id : id,
    BagFields.name : name,
    BagFields.price : price,
    BagFields.size : size,
    BagFields.color : color,
    BagFields.type : type,
    BagFields.sex : sex,
    BagFields.category : category,
    BagFields.count : count,
    BagFields.city : city,
    BagFields.imagePathFromGallerie : imagePathFromGallerie,
    BagFields.imageUrl : imageUrl,

  };

  BasketModel copy({

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

  }) => BasketModel(
    id: id ?? this.id,
  );


}