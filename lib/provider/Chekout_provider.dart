import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:illustrashirt/models/customer_detail_model.dart';
import 'package:illustrashirt/models/product_basketModel.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:illustrashirt/constants.dart';


class ChekOutProvider with ChangeNotifier{

  int countBag = 0;

  String clientPhoneNumber = "";
  String clientName = "";
  String clientAdress = "";
  String clientCity = "";
  String clientZip = "";


  CustomerDetailsModel _customerDetailsModel;
  APIService _apiService;


   List<BasketModel> ProductOrdered = [];


  int getItemsCount(){
    int countproduct = 0;
    ProductOrdered.forEach((element) {countproduct+=element.count;});
    return countproduct;
  }

  double getitemsPrice(){
    double priceBag = 0;
    ProductOrdered.forEach((element) { priceBag+=element.price; });
    return priceBag;
  }

  fetchShippingDetails()async{
    if(_customerDetailsModel == null){
      _customerDetailsModel = new CustomerDetailsModel();
    }
    _apiService = new APIService();

    _customerDetailsModel = await _apiService.getCustomerDetails(userId:"1");
    notifyListeners();
  }

  notifyListeners();
}