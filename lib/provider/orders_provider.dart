import 'package:flutter/cupertino.dart';
import 'package:illustrashirt/models/order.dart';
import 'package:illustrashirt/models/product_basketModel.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:illustrashirt/service/config.dart';



class OrderProvider with ChangeNotifier{

  APIService _apiService;
  List<OrderModel> _ordersList ;

  List<OrderModel > get allOrders => _ordersList ;



  OrderProvider(){
    resetStreams();
  }

  void resetStreams(){
    _apiService = APIService();
  }

  fetchOrders() async{

    List<OrderModel> orderlist = await _apiService.getOrders(userId: Config.userId) ;

    if (_ordersList==null){
      _ordersList = new List<OrderModel>();
    }

    if(orderlist.length >0){
      _ordersList=[];
      _ordersList.addAll(orderlist);
    }
    notifyListeners();

  }



}