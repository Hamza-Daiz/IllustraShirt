import 'dart:io';

import 'package:flutter/material.dart';
import 'package:illustrashirt/models/cart_request_model.dart';
import 'package:illustrashirt/models/cart_response_model.dart';
import 'package:illustrashirt/models/product_basketModel.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/myWidgets/ProgressHUD.dart';
import 'package:illustrashirt/provider/Chekout_provider.dart';
import 'package:illustrashirt/provider/cart_provider.dart';
import 'package:illustrashirt/provider/loader_provider.dart';
import 'package:illustrashirt/screens/HomeScreen.dart';
import 'package:illustrashirt/service/api_service.dart';

import 'package:provider/provider.dart';
import 'package:illustrashirt/db/bag_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'chekOutPathFromProduct.dart';

class CheckOutScreen extends StatefulWidget {


  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {

  List<BasketModel> bags;

  APIService apiService;

  bool isloading = false;

  @override
  void initState() {
    apiService = new APIService();


    var cartItemlist = Provider.of<CartProvider>(context,listen: false);

    cartItemlist.resetStream();
    cartItemlist.fetchCartItems();


    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;
    double width30 = widthScreen - 30;

   return Consumer<LoaderProvider>(builder: (context,loaderProvider,child){

      return ProgressHUD(
        opacity: 0.3,
        inAsyncCall: loaderProvider.isApiCallProcess,
        child: Scaffold(
          backgroundColor: KbackgroundColor,

          appBar: PreferredSize(

            preferredSize: Size.fromHeight(50.0),

            child: AppBar(

              leading: MenuAppBar(context,3),

              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              elevation: 0,
              backgroundColor: KbackgroundColor,
              title: Text(
                "My Basket",
                style: TextStyle(color: KprimaryColor, fontFamily: "Quincy"),
              ),
              actions: [

                Visibility(
                  visible: Provider.of<CartProvider>(context,listen: false).changed,
                  child: FlatButton(
                      onPressed: ()async{

                        Provider.of<LoaderProvider>(context,listen: false).seLoadingStatut(true);

                        var cartProvider = Provider.of<CartProvider>(context,listen: false);

                        cartProvider.isChanged(false);

                          cartProvider.updateCart((val){
                            Provider.of<LoaderProvider>(context,listen: false).seLoadingStatut(false);
                          });

                      },
                      child: Icon(
                        Icons.sync,
                        color: KprimaryColor,
                      )),
                ),


                shopIconAppBar(context, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CheckOutScreen()),
                  );
                },)
              ],
            ),
          ),

          bottomNavigationBar: ClipRRect(

            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),

            child: Container(
              height: 200,
              color: KsecondaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width30 - 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Items :",
                          style: TextStyle(color: KbuttonColor, fontSize: 16),
                        ),
                        Text(
                          Provider.of<CartProvider>(context,listen: false).a.toString()  ,
                          style: TextStyle(color: KbuttonColor, fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    width: width30 - 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                          "Total price",
                          style: TextStyle(
                            color: KbuttonColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),

                        Text(
                          (Provider.of<CartProvider>(context,listen: false).p + 20).toString()+ " DH",
                          style: TextStyle(
                            color: KbuttonColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // ------- Confirm Order : ------------

                  InkWell(
                    onTap: () {
                      setState(() {

                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context)=>ChekOutPathFromProduct(

                                ),
                            ),
                        );

                      });
                    },
                    child: Container(
                      width: width30 - 30,
                      height: 60,
                      color: KbuttonColor,
                      alignment: Alignment.center,
                      child: Text(
                        "Checkout",
                        style: TextStyle(
                          color: KsecondaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ),

          body: Container(
            width: widthScreen,
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            alignment: Alignment.center,
            child:  buildListChekout(width30) ,
          ),
        ),
      );
    });

  }

   buildListChekout(double width30) {

    return Consumer<CartProvider>(builder: (context,cartModel,child){

      return cartModel.CartItems != null && cartModel.CartItems.length > 0 ?

          ListView.builder(
            itemCount: cartModel.CartItems.length,
            itemBuilder: (BuildContext context, int index) {

              var prod = cartModel.CartItems[index];

              return GestureDetector(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Delet this product?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                              //  BagDatabase.instance.delete(data.id);

                                Provider.of<LoaderProvider>(context,listen: false).seLoadingStatut(true);


                                Provider.of<CartProvider>(context,listen: false).removeItem(prod.productId);

                                if(Provider.of<CartProvider>(context,listen: false).CartItems.isEmpty){
                                  Provider.of<CartProvider>(context,listen: false).resetCartItems();
                                }


                                Provider.of<LoaderProvider>(context,listen: false).seLoadingStatut(false);

                                Provider.of<CartProvider>(context,listen: false).isChanged(true);

                                Navigator.of(context).pop();

                              });
                            },
                            child: Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("no"),
                          ),
                        ],
                      ));
                },

                child: Container(
                  width: width30 - 30,
                  height: 100,

                  margin: EdgeInsets.only(
                    bottom: 10,
                  ),
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: KsecondaryColor,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     prod.thumbnail != null
                          ? Container(
                          height: 85,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                          child: Image.network(
                              prod.thumbnail))
                          : Container(
                        height: 70,
                        width: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: KsecondaryColor,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "YOUR",
                              style: TextStyle(color: KprimaryColor,fontFamily: "Quincy",fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "DESIGN",
                              style: TextStyle(color: KprimaryColor,fontFamily: "Quincy",fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "HERE",
                              style: TextStyle(color: KprimaryColor,fontFamily: "Quincy",fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 70,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(

                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Text(
                                prod.productName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Quincy",
                                ),
                              ),

                              Text(
                                prod.productSalePrice.toString() +
                                    " DH",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Quincy",
                                ),
                              ),

                              Text(
                                prod.atributes.atribute.toString() ,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Quincy",
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                      Text(
                        prod.qty.toString(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {

                                prod.qty > 1
                                    ? prod.qty--
                                    : null;

                                Provider.of<CartProvider>(context,listen: false).isChanged(true);

                                Provider.of<CartProvider>(context,listen: false).uptadeQty(prod.productId, prod.qty);



                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: KsecondaryColor,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.remove,
                                color: KbackgroundColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {


                                prod.qty++;

                                Provider.of<CartProvider>(context,listen: false).isChanged(true);

                                Provider.of<CartProvider>(context,listen:false ).uptadeQty(prod.productId, prod.qty);



                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: KsecondaryColor,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.add,
                                color: KbackgroundColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
       :
          cartModel.isLoading == true ?
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(KprimaryColor),
            ),
          )
          :

      Center(
        child: Text(
          "Cart is empty, go to shop ",
          style: TextStyle(
            color: KprimaryColor,
            fontSize: 18,
          ),
        ),
      );
    });
      
      

  }
}
