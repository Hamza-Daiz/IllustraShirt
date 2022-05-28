import 'dart:math';

import 'package:flutter/material.dart';
import 'package:illustrashirt/models/cart_response_model.dart';
import 'package:illustrashirt/models/cart_request_model.dart';
import 'package:illustrashirt/models/customer_detail_model.dart';
import 'package:illustrashirt/models/order.dart';
import 'package:illustrashirt/models/shipping_zone.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CartProvider with ChangeNotifier{

  int idshippingLine;
  ShippingLines shippingLine = new ShippingLines();

  List<ShippingZone> listzones;

  Future getZones(String title) async{
    listzones = new List<ShippingZone>();

    listzones = await _apiService.getShippingZones();

    listzones.forEach((element) {
      if(element.name == title){
        idshippingLine = element.id;
      }
    });
  }

  setShippingLine(
      {int id, String title, double total,}){

    shippingLine.title = title;
    shippingLine.total = total;
    notifyListeners();
  }

  Future<void> getTheLineShipping() async{

    print("hahowa l id li an3eyto lih 3la wed shippin :" + idshippingLine.toString());

    shippingLine = await _apiService.getShippingLines(idshippingLine.toString());
  }

  setIdShippingLine(int id){
    idshippingLine = id;
  }

  APIService _apiService;

  List<CartItem> _cartItem;
  CustomerDetailsModel _customerDetailsModel = new CustomerDetailsModel();
  OrderModel _orderModel;

  bool _isOrderCreated = false;
  bool changed ;
  bool isListEmpty = true;


  bool isLoading = false;

  Future<bool> IsLoading() async{

    return isLoading ;
  }

  isChanged (bool val){
    changed = val;
  }

  double p  = 0;
  int a = 0 ;



  CustomerDetailsModel get customerDetailsModel => _customerDetailsModel;

  List<CartItem> get CartItems => _cartItem;
  OrderModel get orderModel => _orderModel;
  bool get isOrderCreated => _isOrderCreated;

  resetCartItems(){
    _cartItem = new List<CartItem>();
    notifyListeners();
  }

  getTotaleItem(){
    a = 0 ;
    if(_cartItem!=null && _cartItem.length>0 ) {
      _cartItem.forEach((element) {
      a +=  element.qty;
    });
    }
    notifyListeners();

  }

  getTotaleamount() {
     p = 0;
    if(_cartItem!=null) {
      _cartItem.forEach((element) {
        p += (element.lineTotale );
      });
    }
    notifyListeners();

  }


  CartProvider(){
    _apiService = new APIService();
    _cartItem = new List<CartItem>();
  }

  resetStream(){
    _apiService = new APIService();
    _cartItem = new List<CartItem>();
    changed = false;
  }

  void addToCart(CartProducts product, Function oncallBack,) async {

    CartRequestModel requestModel = new CartRequestModel();

    requestModel.products = new List<CartProducts>();

    if(_cartItem == null) resetStream();

    _cartItem.forEach((element) {
      requestModel.products.add(
        new CartProducts(
          productId: element.productId ,
          quantity: element.qty,
          variationId: element.variationId,
        ),
      );
    });


    requestModel.products.add(product);

    await _apiService.addToCart(requestModel).then((cartRequestModel) {

      if(cartRequestModel.data != null){
        _cartItem = [];
        _cartItem.addAll(cartRequestModel.data);
      }

      oncallBack(cartRequestModel);

      notifyListeners();

    });

  }


  fetchCartItems() async{
    isLoading = true;

     _cartItem = new List<CartItem>();

     await _apiService.getCartItems().then((cartResponseModel) {
       if(cartResponseModel != null){

         if(cartResponseModel.data != null){
           _cartItem.addAll(cartResponseModel.data);
         }

         getTotaleItem();
         getTotaleamount();

         if (_cartItem.length==0){
           isListEmpty = true;
         }else{
           isListEmpty = false;
         }
       }
     });

     notifyListeners();

    isLoading = false;


  }



  void uptadeQty(int productId,int qty){

    var isProductExist =_cartItem.firstWhere((prd) => prd.productId == productId, orElse: ()=>null);
    if(isProductExist != null){

      isProductExist.qty = qty;
    }
    notifyListeners();
  }

  void updateCart (Function oncallBack) async{


    CartRequestModel requestModel = new CartRequestModel();

    requestModel.products = new List<CartProducts>();

    if(_cartItem == null) resetStream();


    if(_cartItem.isEmpty ){
      print("vide");

      await _apiService.addToCart(CartRequestModel(userId: 2, products:[] )).then((cartRequestModel) {

        resetCartItems();

        oncallBack(cartRequestModel);
      });

      getTotaleItem();
      getTotaleamount();

      notifyListeners();
    }else{
      print("pas vide");

      _cartItem.forEach((element) {
        requestModel.products.add(
          new CartProducts(
            productId: element.productId,
            quantity: element.qty,
            variationId: element.variationId,
          ),
        );
      });

      await _apiService.addToCart(requestModel).then((cartRequestModel) {
        if (cartRequestModel.data != null) {
          _cartItem = new List<CartItem>();

          _cartItem.addAll(cartRequestModel.data);
        } else {
          _cartItem = new List<CartItem>();
        }

        oncallBack(cartRequestModel);
      });

      getTotaleItem();
      getTotaleamount();

      notifyListeners();


    }

  }

  void removeItem (int productId){

    var isProductExist =_cartItem.firstWhere((prd) => prd.productId == productId, orElse: ()=>null);

    if(isProductExist != null){
      _cartItem.remove(isProductExist);
    }

    if(_cartItem.isEmpty){
      resetCartItems();

      resetStream();
      isListEmpty = true;
    }
    notifyListeners();

  }

  fetchShippingDetails() async {

     if(customerDetailsModel == null ) _customerDetailsModel = new CustomerDetailsModel();

     _customerDetailsModel= await _apiService.getCustomerDetails();

     await getZones(_customerDetailsModel.billing.city);

     shippingLine = await _apiService.getShippingLines(idshippingLine.toString());

     print(idshippingLine);


     notifyListeners();
  }

  processOrder(OrderModel orderModel){
      this._orderModel = orderModel;
      notifyListeners();
  }

  void createOrder(
      {double shippingfee, String payMeth, String payTitle}
      ) async{

    _orderModel = new OrderModel();
    _customerDetailsModel= await _apiService.getCustomerDetails();

    if(_orderModel.shipping == null){
      _orderModel.shipping == new Shipping();
    }

    if(this.customerDetailsModel.shipping != null){
      _orderModel.shipping = this.customerDetailsModel.shipping;
    }

    if(this.customerDetailsModel.billing != null){
      _orderModel.billing = this.customerDetailsModel.billing;
    }

    if(orderModel.lineItems == null){
      _orderModel.lineItems = new List<LineItems>();
    }
    _orderModel.shippingFee = shippingfee;
    _orderModel.paymentMethodTitle = payTitle;
    _orderModel.paymentMethod = payMeth;

    if(_orderModel.shippingLines == null) _orderModel.shippingLines = new List<ShippingLines>();
   // _orderModel.shippingLines.add(shippingLine);


    _cartItem.forEach((v) {
      _orderModel.lineItems.add(
        new LineItems(
          productID: v.productId,
          quantity: v.qty,
          variationID: v.variationId,
        )
      );
    });

    await _apiService.createOrder(_orderModel,shippingLine).then(
            (value)  {
              if(value){
               _isOrderCreated = true;
               notifyListeners();
               print("goo check Order");

              }
            }
    );

  }


}