

import 'package:import_js_library/generated/i18n.dart';

class CartResponsemodel{

  bool statut;
  List<CartItem> data;

  CartResponsemodel({this.statut,this.data});

  CartResponsemodel.fromJson(Map<String,dynamic> json){

    statut = json["status"];

    if(json["data"] != null){

      data = new List<CartItem>();
      json["data"].forEach((v){
        data.add(CartItem.fronJson(v));
      });

    }
  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> json = new Map<String,dynamic>();

    json["status"] = this.statut;

    if(this.data != null){
      json["data"] = this.data.map((e) => e.toJson()).toList();
    }
    return json;
  }

}

class CartItem {

  int productId;
  String productName;
  String productRegularPrice;
  String productSalePrice;
  String thumbnail;
  int qty;
  double lineSubtotal;
  double lineTotale;
  int variationId;
  Atrributes atributes;

  CartItem({
    this.productId,
    this.productName,
    this.productRegularPrice,
    this.productSalePrice,
    this.thumbnail,
    this.qty,
    this.lineSubtotal,
    this.lineTotale,
    this.variationId,
    this.atributes,
  });

  CartItem.fronJson(Map<String,dynamic> json){

    productId = json["product_id"];
    productName = json["product_name"];
    productRegularPrice = json["product_regular_price"];
    productSalePrice = json["product_sale_price"];
    thumbnail = json["thumbnail"];
    qty = json["qty"];
    lineSubtotal = double.parse(json["line_subtotal"].toString());
    lineTotale = double.parse(json["line_total"].toString());
    variationId = json["variation_id"];

    if(json['attribute'] != null){
      atributes = Atrributes.fromJson(json["attribute"]);
    }

  }

  Map<String,dynamic> toJson(){

    final Map<String,dynamic> json = new Map<String,dynamic>();

    json["product_id"] =this.productId ;
    json["product_name"]= this.productName ;
    json["product_regular_price"] = this.productRegularPrice ;
    json["product_sale_price"] = this.productSalePrice ;
    json["thumbnail"]= this.thumbnail ;
    json["qty"] = this.qty ;
    json["line_subtotal"] = this.lineSubtotal;
    json["line_total"] = this.lineTotale ;
    json["variation_id"]= this.variationId;

    return json;
  }

}
class Atrributes{
  String atribute;

  Atrributes({this.atribute});

  Atrributes.fromJson(Map<String,dynamic> json){
    try{ atribute = json["pa_color"];
    atribute += " ";
    atribute += json["pa_size"]??"";
    atribute += " ";
    atribute += json["pa_poster-size"]??"";
    }catch (e){
      print(e);
    }

  }

  Map<String,dynamic> toJson(){
    return {
      "pa_color" : this.atribute.toString(),
    };
  }

}