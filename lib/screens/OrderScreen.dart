import 'package:flutter/material.dart';
import 'package:illustrashirt/models/order.dart';
import 'package:illustrashirt/myWidgets/widget_order.dart';
import 'package:illustrashirt/provider/orders_provider.dart';
import 'package:illustrashirt/service/config.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'HomeScreen.dart';
import 'chekOutScreen.dart';

class OrderScreen extends StatefulWidget {

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {


  @override
  void initState() {

    var orderProvider = Provider.of<OrderProvider>(context,listen: false);
    orderProvider.fetchOrders();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Future loading( ) async {
      await Future.delayed(Duration(milliseconds: 400));


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrderScreen()),
      );

    }

    return Scaffold(
      appBar: AppBar(
        leading: MenuAppBar(context,3),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: KbackgroundColor,
        title: Text(
          "My Orders",
          style: TextStyle(color: KprimaryColor, fontFamily: "Quincy"),
        ),
        actions: [
          shopIconAppBar(context,
                (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckOutScreen()),
              );    },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: KprimaryColor,
        onRefresh: loading,
        child: Consumer<OrderProvider>(builder: (context,orderProv,child){

          if(orderProv.allOrders != null && orderProv.allOrders.length>0){

           return _ListView(context,orderProv.allOrders);

          }else{
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(
                    KprimaryColor),
              ),
            ) ;
          }
        },),
      ),
    );
  }

  Widget _ListView(BuildContext context,List<OrderModel> orders){

    return ListView(
      children: [
        ListView.builder(
          itemCount: orders.length,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context,index){
                  return orders[index].customerId.toString() == Config.userId ?
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: WidgetOrder(order: orders[index],),
                  )    :
                      Container()

                  ;
            })
      ],
    );
  }
}
