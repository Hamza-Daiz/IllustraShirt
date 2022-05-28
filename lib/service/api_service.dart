import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:illustrashirt/models/ProductModel.dart';
import 'package:illustrashirt/models/cart_response_model.dart';
import 'package:illustrashirt/models/customer.dart';
import 'package:illustrashirt/models/customer_detail_model.dart';
import 'package:illustrashirt/models/login_model.dart';
import 'package:illustrashirt/models/cart_request_model.dart';
import 'package:illustrashirt/models/order.dart';
import 'package:illustrashirt/models/shipping_zone.dart';
import 'package:illustrashirt/models/tags.dart';
import 'package:illustrashirt/service/config.dart';
import 'package:dio/dio.dart';
import 'package:illustrashirt/models/category.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/models/product_basketModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class APIService{


  Future<bool> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode(Config.key + ':' + Config.secret),
    );

    bool ret = false ;

    try{

      var response = await Dio().post(
          Config.url + Config.customerURL,
          data : model.toJson(),
          options: new Options(headers:{
            HttpHeaders.authorizationHeader : 'Basic $authToken',
            HttpHeaders.contentTypeHeader : "application/json",
          }
          )
      );

      if(response.statusCode == 201){ret = true;}

    }on DioError catch(e) {
      if(e.response.statusCode == 404){
        ret = false;
      }else{
        ret = false;
      }
    }

    return ret ;

  }

  Future<LoginResponseModel> loginCustomer(dynamic username, dynamic password) async{
    LoginResponseModel model;
    try {
      var response = await Dio().post(
        Config.tokenURL,
        data: {
          "username" : username,
          "password" : password,
        },
        options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
            }
        ),
      );

      if(response.statusCode == 200){
        model = LoginResponseModel.fromJson(response.data);
      }

    }on DioError catch (e){
      print(e.message);
    }

    return model ;

  }

  Future<List<Category>> getCategoris() async {

    List<Category> data = new List<Category>();


    try{
      String url = Config.url + Config.categoriesURL +"?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      var response = await Dio().get(
        url,
        options: new Options(
          headers:{
            HttpHeaders.contentTypeHeader : "application/json",
          },
        ),
      );
      if(response.statusCode == 200){

        data = (response.data as List).map(
            (i) => Category.fromJson(i),
        ).toList();

      }
    }on DioError catch (e){
      print(e.response);
    }
    return data;

  }

  Future<List<TagModel>> getTags() async {

    List<TagModel> data = new List<TagModel>();
    SharedPreferences pref = await SharedPreferences.getInstance();


    try{
      String url = "https://illustrashirt.com/wp-json/wc/v3/" + Config.tagsURL +"?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      print(url);

      var response = await Dio().get(
        url,
        options: new Options(
          headers:{
            HttpHeaders.contentTypeHeader : "application/json",
          },
        ),
      );
      if(response.statusCode == 200){

        print ( " Worky Wokry ¨¨¨ Tags ¨¨¨ !!!!");

        print(response.data);
        print (response.data.length);


        pref.setString("tags", response.data.toString());
        print ( "Tags addedd to preferences!!!!");

        print(pref.getString("tags"));


        data = (pref.getString("tags") as List )
            .map((e) => TagModel.fromJson(e),)
            .toList();

        print("ookkeeeyyy");

      }
    }on DioError catch (e){

      print ( " error !¨¨¨in Tags ¨¨¨¨¨¨!!!!");

      print(e.response);
    }
    return data ;

  }

  Future<CustomerDetailsModel> getCustomerDetails({String userId}) async {

    CustomerDetailsModel responseModel;

    try{
      String url = Config.url + Config.customerURL+"/${Config.userId}"+
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}";
      var response = await Dio().get(
        url,
        options: new Options(
          headers:{
            HttpHeaders.contentTypeHeader : "application/json",
          },
        ),
      );


      if(response.statusCode == 200){
       responseModel =CustomerDetailsModel.fromJson(response.data) ;
      }
    }on DioError catch (e){
      print(e.response);
    }
    return responseModel;

  }

  Future<CustomerDetailsModel> setFullName( {Billing data}) async {

    CustomerDetailsModel responseModel;

    try{
      String url = Config.url + Config.customerURL+"/${Config.userId}"+"?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "first_name": data.firstname,
        }
        ),
      );
      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": data.email,
        }
        ),
      );

      print("done go check name");

    }on DioError catch (e){
      if(e.response.statusCode == 404){
        print(e.response.statusCode);
      }
      print("the exeption is : ") ;
      print(e.response);
      print("fin---------") ;
    }
    return responseModel;

  }

  Future<CustomerDetailsModel> setbillingDetails( {Billing data}) async {

    CustomerDetailsModel responseModel;

    try{
      String url = Config.url + Config.customerURL+"/${Config.userId}"+"?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

       http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "billing": {
            "first_name": data.firstname,
          },
        }
        ),
      );

      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "billing": {
            "address_1" : data.adress,
          },
        }
        ),
      );

      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "billing": {
            "city": data.city,

          },
        }
        ),
      );

      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Map<String,String>>{
          "shipping": {
            "country" : "Morroco",

          },
        }
        ),
      );

      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "billing": {
            "phone": data.phone,
          },
        }
        ),
      );

      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "billing": {
            "email": data.email,

          },
        }
        ),
      );

      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "billing": {
            "postcode": data.zipCode,

          },
        }
        ),
      );


    print("done go check billing");
    }on DioError catch (e){
      if(e.response.statusCode == 404){
        print(e.response.statusCode);
      }
      print("the exeption is : ") ;
      print(e.response);
      print("fin---------") ;
    }
    return responseModel;

  }

  Future<CustomerDetailsModel> setshippingDetails( {Billing data}) async {

    CustomerDetailsModel responseModel;

    try{
      String url = Config.url + Config.customerURL+"/${Config.userId}"+"?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Map<String,String>>{
          "shipping": {
            "first_name":data.firstname,
          },
        }
        ),
      );
      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Map<String,String>>{
          "shipping": {
            "address_1" : data.adress,
          },
        }
        ),
      );
      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Map<String,String>>{
          "shipping": {
            "city": data.city,

          },
        }
        ),
      );
      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Map<String,String>>{
          "shipping": {
            "country" : "Morroco",

          },
        }
        ),
      );
      http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Map<String,String>>{
          "shipping": {
            "postcode": data.zipCode,

          },
        }
        ),
      );


      print("done go check shipping");
    }on DioError catch (e){
      if(e.response.statusCode == 404){
        print(e.response.statusCode);
      }
      print("the exeption is : ") ;
      print(e.response);
      print("fin---------") ;
    }
    return responseModel;

  }


  Future<List<Product>> getProducts ({
    String tagId,
    String strSearch,
    String categoryId,
    String typeId,
  }) async {

    List<Product> data = new List<Product>();

    try{
      String parametre = "";

      if(strSearch != null){
        parametre+="&search=$strSearch";
      }
      if(typeId != null){
        parametre+="&type=$typeId";
      }
      if(tagId != null){
        parametre+="&tag=$tagId";
      }
      if(categoryId != null){
        parametre+="&category=$categoryId";
      }


      String url = Config.url + Config.productsURL +
          "?consumer_key=${Config.key}&consumer_secret=${Config.secret}${parametre.toString()}";

      var response = await Dio().get(
        url,
        options:  new Options(
          headers: {
            HttpHeaders.contentTypeHeader :"application/json",
          },
        ),
      );

      if(response.statusCode == 200){
        data = (response.data as List )
            .map((e) => Product.fromJson(e),)
            .toList();
      }

    }on DioError catch (e){
        print(e.response);  
    }
    return data;
  }

  /*Future<List<ProductModelFilter>> getProductsFilters ({
    String tagId,
    String strSearch,
    String categoryId,
    String typeId,
  }) async {

    List<ProductModelFilter> data = new List<ProductModelFilter>();

    try{
      String parametre = "";

      if(strSearch != null){
        parametre+="&search=$strSearch";
      }
      if(typeId != null){
        parametre+="&type=$typeId";
      }
      if(tagId != null){
        parametre+="&tag=$tagId";
      }
      if(categoryId != null){
        parametre+="&category=$categoryId";
      }

      print("try call api");
      var response = await http.get(Uri.https('illustrashirt.com','/wp-json/wp/v2/product?id=1119'));

      print("sucess call api");

      var jsondata =  jsonDecode(response.body);


        data.add(new ProductModelFilter(
          id: jsondata['id'],
          name: jsondata['slug'],
          typeid: jsondata['collection'][0],
          price: jsondata['_price'],
        ));


    }on DioError catch (e){
      print(e.response);
    }
    return data;
  }*/


  Future<CartResponsemodel> addToCart( CartRequestModel model) async {

    String url = Config.url + Config.addToCartUrl ;

      model.userId = int.parse(Config.userId);

    CartResponsemodel responseModel;

    print (" posting in cart in : " + url);

    try{

      var response = await Dio().post(
        url,
        data: model.toJson(),
        options: new Options(
          headers:{
            HttpHeaders.contentTypeHeader : "application/json",
          },
        ),
      );

      if(response.statusCode == 200){
        responseModel = CartResponsemodel.fromJson(response.data);
      }
    }on DioError catch (e){
      if(e.response.statusCode == 404){
        print(e.response.statusCode);
      }
      print("the exeption is : ") ;
      print(e.response);
      print("fin---------") ;
    }
    return responseModel ;

  }

  Future<CartResponsemodel> getCartItems() async {

    CartResponsemodel responseModel;

    try{
      String url = Config.url + Config.cartUrl+ "?user_id=${Config.userId}" +"&consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      print (" getting cart items from : " + url);
      var response = await Dio().get(
        url,
        options: new Options(
          headers:{
            HttpHeaders.contentTypeHeader : "application/json",
          },
        ),
      );
      if(response.statusCode == 200){
        responseModel = CartResponsemodel.fromJson(response.data);
      }
    }on DioError catch (e){
      print(e.response);
    }
    return responseModel;

  }

  Future<List<OrderModel>> getOrders({String userId}) async {

    List<OrderModel> data = new List<OrderModel>();


    try{
      String url = Config.url + Config.orderURL +"?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      print (" getting orders  from : " + url);

      var response = await Dio().get(
        url,
        options: new Options(
          headers:{
            HttpHeaders.contentTypeHeader : "application/json",
          },
        ),
      );
      if(response.statusCode == 200){
        data = (response.data as List).map(
              (i) => OrderModel.fromJson(i),
        ).toList();
      }
    }on DioError catch (e){
      print(e.response);
    }


    return data ;

  }

  Future<bool> createOrder(OrderModel model,ShippingLines shippingLine) async{

    model.customerId = 2 ;
    bool isOrderCreated= false;

    model.shippingFee = shippingLine.total;
    model.shippingLines.add(ShippingLines(
      title: shippingLine.title,
      total: shippingLine.total,

    ));
    print("shipping fee  ${model.shippingFee}");

    var authAuth = base64.encode(
      utf8.encode(Config.key +":"+Config.secret)
    );

    try{

      print (" create orders in : " + Config.url + Config.orderURL);

      var response = await Dio().post(
        Config.url + Config.orderURL ,
        data: model.toJson(),
        options: new Options(
          headers:{
            HttpHeaders.authorizationHeader: 'Basic $authAuth',
            HttpHeaders.contentTypeHeader : "application/json",
          },
        ),
      );

      if(response.statusCode == 201){
        isOrderCreated = true;
      }
    }on DioError catch (e){
      if(e.response.statusCode == 404){
        print(e.response.statusCode);
      }
      print("the exeption is : ") ;
      print(e.response);
      print("fin---------") ;
    }

    return isOrderCreated;

  }

  Future<List<ShippingZone>> getShippingZones() async {

    List<ShippingZone> responseModel;

    try{
      String url = Config.url + "shipping/zones?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      print("getShippingZones from :");
      print(url);
      var response = await Dio().get(
        url,
        options: new Options(
          headers:{
            HttpHeaders.contentTypeHeader : "application/json",
          },
        ),
      );
      if(response.statusCode == 200){

        print("getShippingZones succes :");
        responseModel = (response.data as List )
            .map((e) => ShippingZone.fromJson(e),)
            .toList();
      }
    }on DioError catch (e){
      print("getShippingZones error :");
      print(e.response);
    }

    if(responseModel!= null)
    responseModel.removeAt(0);

    return responseModel;

  }

  Future<ShippingLines> getShippingLines(String shippingID) async {

    ShippingLines responseModel;

    try{
      String url = Config.url + "shipping/zones/$shippingID/methods?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      print("getShippingLines from :");
      print(url);
      var response = await Dio().get(
        url,
        options: new Options(
          headers:{
            HttpHeaders.contentTypeHeader : "application/json",
          },
        ),
      );
      if(response.statusCode == 200){

        responseModel = ShippingLines.fromJson(response.data[0]["settings"]);
      }
    }on DioError catch (e){
      print(e.response);
    }
    return responseModel;

  }

}
