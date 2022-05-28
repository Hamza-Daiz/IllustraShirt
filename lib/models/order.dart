import 'package:illustrashirt/models/shipping_zone.dart';

import 'customer_detail_model.dart';

class OrderModel {

  int customerId;
  String paymentMethod;
  String paymentMethodTitle;
  bool setPaid ;
  String transactionId;
  List<LineItems> lineItems;
  List<ShippingLines> shippingLines;

  int orderId;
  String orderNumber;
  String statut;
  DateTime orderDate;
  double shippingFee;
  Shipping shipping;
  Billing billing;


  OrderModel({
    this.customerId,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.setPaid,
    this.transactionId,
    this.lineItems,
    this.shippingLines,
    this.orderId,
    this.orderNumber,
    this.statut,
    this.orderDate,
    this.shippingFee,
    this.shipping,
    this.billing,
  });

  OrderModel.fromJson(Map<String,dynamic> json){
    customerId = json["customer_id"];
    orderId = json["id"];
    statut = json["status"];
    orderNumber = json["order_key"];
    orderDate = DateTime.parse(json["date_created"]);
  }

  Map<String,dynamic> toJson(){

    Map<String,dynamic> json = new Map<String,dynamic>();

    json["status"]= "processing";

    json["customer_id"] = customerId;
    json["payment_method"] = paymentMethod;
    json["payment_method_title"]= paymentMethodTitle;
    json["set_paid"]=setPaid;
    json["statut"]= statut;
    json["transaction_id"]=transactionId ;
    json["shipping_total"] = shippingFee ;
    json["shipping"] = shipping!= null ? shipping.toJson() : new Shipping();
    json["billing"] = billing!= null ? billing.toJson() : new Billing();

    if(lineItems != null){
      json["line_items"] = lineItems.map((v)=>v.toJson()).toList();
    }
    if(shippingLines != null){
      json["shipping_lines"] = [shippingLines.first.toJson()];
    }

    return json;

  }

}

class LineItems{

  int productID;
  int quantity ;
  int variationID;

  LineItems({
    this.productID,
    this.quantity,
    this.variationID,
});

  Map<String,dynamic> toJson(){

    Map<String,dynamic> json = new Map<String,dynamic>();

    json["product_id"] = this.productID;
    json["quantity"]= this.quantity;
    if(this.variationID!= null){
      json["variation_id"]= this.variationID;
    }
    return json;

  }

}