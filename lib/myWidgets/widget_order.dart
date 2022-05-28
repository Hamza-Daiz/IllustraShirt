import 'package:flutter/material.dart';
import 'package:illustrashirt/models/order.dart';



class WidgetOrder extends StatefulWidget {
  OrderModel order;
  WidgetOrder({this.order});

  @override
  _WidgetOrderState createState() => _WidgetOrderState();
}

class _WidgetOrderState extends State<WidgetOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          orderStatut(this.widget.order.statut),
          Divider(color: Colors.grey,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconText(Text("Order ID"), Icon(Icons.edit,color: Colors.redAccent,)),

              Text(this.widget.order.orderId.toString()),
            ],
          ),
          SizedBox(height: 3,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconText(Text("Order Date"), Icon(Icons.today,color: Colors.redAccent,)),

              Text(this.widget.order.orderDate.toString()),
            ],
          ),
          SizedBox(height: 3,),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                shape: StadiumBorder(),
                  padding: EdgeInsets.all(8),
                  color: Colors.green,
                  onPressed: (){},
                  child: Row(
                    children: [
                      Text(
                      "More details",
                      style: TextStyle(
                            color: Colors.white
                         ),
                      ),
                      Icon(Icons.navigate_next,color: Colors.white,),
                    ],
                  )),

            ],
          ),*/

        ],
      ),
    );
  }

  Widget iconText( Text text, Icon icon){

    return Row(
      children: [
        icon, SizedBox(width: 5,),text,
      ],
    );

  }

  Widget orderStatut(String statut){

    Icon icon;
    Color color;

    if(statut == "pending" ||statut == "processing" || statut == "on hold"){
      icon = Icon(Icons.timer , color: Colors.orange,);
      color= Colors.orange;
    }
    else if( statut == "completed"){
      icon = Icon(Icons.check , color: Colors.green,);
      color= Colors.green;
    }
    else if( statut == "cancelled"||statut == "refunded" || statut == "failed"){
      icon = Icon(Icons.clear , color: Colors.redAccent,);
      color= Colors.redAccent;
    }
    else {
      icon = Icon(Icons.clear , color: Colors.redAccent,);
      color= Colors.redAccent;
    }

    return iconText(
      Text(
        "Order $statut",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      icon,
    );

  }
}


