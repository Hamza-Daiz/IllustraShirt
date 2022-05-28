
import 'package:import_js_library/generated/i18n.dart';

class CartRequestModel{

  int userId;
  List<CartProducts> products;


  CartRequestModel({this.userId,this.products});

  CartRequestModel.fromJson(Map<String,dynamic> json){

    userId = json["user_id"];

    if(json["products"]!= null){

      products= new List<CartProducts>();

      json["products"].forEach((v){
        products.add(CartProducts.fromJson(v));
      });

    }

  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();

    data["user_id"]=this.userId;


    if(this.products != null){

      data["products"] =this.products.map((e) => e.toJson()).toList();

    }
    return data;
  }
}

class CartProducts{

  int productId;
  int quantity;
  int variationId;

  CartProducts({this.productId,this.quantity,this.variationId});


  CartProducts.fromJson(Map<String,dynamic> json){

    productId = json["product_id"];
    quantity = json["quantity"];
    variationId = json["variation_id"];

  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> json = new Map<String,dynamic>();

    json["product_id"] = this.productId ;
    json["quantity"] = this.quantity ;
    json["variation_id"] = this.variationId;


    return json;
  }





}