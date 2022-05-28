import 'package:illustrashirt/models/category.dart';

class Product {
  int id;
  String name;
  String description;
  String shortDescription;
  String type;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  String stockStatus;
  List<int> variations;
  List<Images> images;
  List<Categories> categories;
  List<Attributes> attributes;

  Product({
    this.id,
    this.name,
    this.description,
    this.shortDescription,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.sku,
    this.stockStatus,
    this.categories,
    this.type,
    this.images,
    this.attributes,
    this.variations,
  });

  Product.fromJson(Map<String,dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    shortDescription = json['shortDescription'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price']!= "" ? json['sale_price'] : json['regular_price'] ;
    stockStatus = json['stock_status'];

    variations = new List<int>();
    json["variations"].forEach(
          (v){
        variations.add(v);
      },
    );

    if(json['categories'] != null){
      categories = new List<Categories>();
      json['categories'].forEach(
          (v){
            categories.add(new Categories.fromJson(v),);
          },
      );
    }
    if(json['images'] != null){
      images = new List<Images>();
      json['images'].forEach(
            (v){
          images.add(new Images.fromJson(v),);
        },
      );
    }
    if(json['attributes'] != null){
      attributes = new List<Attributes>();
      json['attributes'].forEach(
            (v){
              attributes.add(new Attributes.fromJson(v),);
            },
      );
    }

  }

  // Discount :
 /* calculateDiscount(){
    double regularPrice = double.parse(this.regularPrice);
    double salePrice = this.salePrice!= "" ? double.parse(this.salePrice) : regularPrice;

    double discount = regularPrice - salePrice ;
    double disPercent = (discount/regularPrice) * 100;

    return disPercent.round();
  }
  */

}



class Categories {
  int id;
  String name;
  Categories({this.name,this.id});

  Categories.fromJson(Map<String,dynamic> json){
    id= json['id'];
    name=json['name'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['id']= this.id;
    data['name']=this.name;
    return data;
  }
}

class Images {
  String src;
  Images({
    this.src,
  });
  Images.fromJson(Map<String,dynamic> json){
    src = json['src'];
  }
}

class Attributes{
  String name;
  List<String> options;

  Attributes({this.name,this.options});

  Attributes.fromJson(Map<String,dynamic> json){
    name = json['name'];
    if(json['options'] != null){
      options = new List<String>();
      json['options'].forEach(
            (v){
              options.add(v);
        },
      );
    }
  }

}
