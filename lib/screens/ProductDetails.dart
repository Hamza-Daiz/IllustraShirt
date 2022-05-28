import 'dart:async';

import 'package:flutter/material.dart';
import 'package:illustrashirt/constants.dart';
import 'package:illustrashirt/db/bag_database.dart';
import 'package:illustrashirt/models/cart_request_model.dart';
import 'package:illustrashirt/models/cart_response_model.dart';
import 'package:illustrashirt/models/product_basketModel.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/myWidgets/ProgressHUD.dart';
import 'package:illustrashirt/provider/Chekout_provider.dart';
import 'package:illustrashirt/provider/cart_provider.dart';
import 'package:illustrashirt/provider/loader_provider.dart';
import 'package:illustrashirt/screens/HomeScreen.dart';
import 'package:illustrashirt/screens/chekOutPathFromProduct.dart';
import 'package:illustrashirt/screens/chekOutScreen.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {

  Product product;
  ProductDetails({this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();

}

class _ProductDetailsState extends State<ProductDetails> {

  String _size = "S";
  int count = 1;

  int nbrColor=0;
  int nbr =0;

  List<int> attributNbr;

  int indexkipper=0;


  List<dynamic> atrributes ;

  CartProducts cartProducts = new CartProducts();

  BasketModel productToShop = new BasketModel();

  bool isloading = false;

  APIService _apiService;

  @override
  void initState() {
    _apiService = new APIService();
    refreshBag();
    atrributes = new List<dynamic>() ;

    attributNbr = new List<int>();

    widget.product.attributes.forEach((element) {atrributes.add(element.name + ": " +element.options[0]);});


    super.initState();

  }

  Future refreshBag() async{
    setState(() {isloading = true;});

   // this.bags = await BagDatabase.instance.readAll() ;

    setState(() {isloading = true;});
  }

  final _controller = ScrollController();


  @override
  Widget build(BuildContext context) {

    Timer(
      Duration(seconds: 0),
          () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );

    var bagProvider = Provider.of<ChekOutProvider>(context, listen: false);

    final withScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    return Consumer<LoaderProvider>(builder: (context,loaderModel,child){
      return SafeArea(
        child: ProgressHUD(
          inAsyncCall: loaderModel.isApiCallProcess,

          child: Scaffold(

            backgroundColor: KbackgroundColor,
            extendBodyBehindAppBar: true,

            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              child: Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: KsecondaryColor,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {

                            Provider.of<LoaderProvider>(context,listen: false).seLoadingStatut(true);

                            var cartProvider = Provider.of<CartProvider>(context,listen: false);

                            cartProducts.productId = this.widget.product.id;

                            print(this.widget.product.id );

                            cartProducts.quantity = count;
                            cartProducts.variationId = this.widget.product.variations[nbr];

                            cartProvider.addToCart(cartProducts,(val){
                              Provider.of<LoaderProvider>(context,listen: false).seLoadingStatut(false);
                            });

                            
                            /*  Provider.of<LoaderProvider>(context,listen: false).seLoadingStatut(true);

                              var cartProvider = Provider.of<CartProvider>(context,listen: false);

                              cartProducts.productId = this.widget.product.id;
                              cartProducts.quantity = count;
                              cartProducts.variationId = this.widget.product.variations[nbr];

                              cartProvider.addToCart(cartProducts,(val){
                                Provider.of<LoaderProvider>(context,listen: false).seLoadingStatut(false);
                              });


                           /* productToShop.imageUrl = this.widget.product.images[0].src;
                            productToShop.count=count;
                            productToShop.price=price*count;
                            productToShop.color = _color;
                            productToShop.size = _size;
                            productToShop.sex=_sex;
                            productToShop.name =  this.widget.product.name;
                            productToShop.category = this.widget.product.categories[0].name;*/

                            /*
                             bagProvider.ProductOrdered.add(productToShop);
                             bagProvider.countBag++ ;
                             bagProvider.notifyListeners();*/

                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context)=>ChekOutPathFromProduct(

                                    )
                                )
                            );
                              */

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Icon(
                                Icons.add_shopping_cart_rounded,
                                color: KbackgroundColor,
                              ),


                              Expanded(
                                child: Text(
                                  "Add to cart",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: KbackgroundColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            appBar: AppBar(
              elevation: 0,
              actions: [
                shopIconAppBar(
                    context,
                        (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOutScreen()),);
                    },)
              ],
              backgroundColor: Colors.transparent,
              leading: BackButton(
                color: KprimaryColor,
              ),
            ),

            body: Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: withScreen,
                  child: Image.network(this.widget.product.images[0].src,fit: BoxFit.cover,height: (heightScreen - heightScreen*0.2) + 0,),
                ),

                DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    minChildSize: 0.2,
                    maxChildSize: 0.9,
                    builder: (context, controler) {
                      return ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          color: KbackgroundColor,
                          child: NotificationListener<OverscrollIndicatorNotification>(
                            onNotification: (overScroll) {
                              overScroll.disallowGlow();
                              return;
                            },
                            child: SingleChildScrollView(
                              controller: controler,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // ----- Title :
                                  Container(
                                    child: Text(
                                      this.widget.product.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: KprimaryColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 15,
                                  ),

                                  Text(
                                   "Price :"+ this.widget.product.price.toString() + "DH",
                                    style: TextStyle(
                                        color: KsecondaryColor, fontSize: 27),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    atrributes.toString(),
                                    style: TextStyle(
                                        color: KprimaryColor, fontSize: 15),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  /*
                                  /// Size Choices : /////
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Size",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: KsecondaryColor,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Container(
                                    child: Row(
                                      children: [

                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _size = "S";
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color:
                                              _size != "S" ? KbackgroundColor : KsecondaryColor,
                                              border: Border.all(
                                                  color: _size != "S"
                                                      ? KsecondaryColor
                                                      : KsecondaryColor),
                                              borderRadius: BorderRadius.all(Radius.circular(1)),
                                            ),
                                            child: Text(
                                              "S",
                                              style: TextStyle(
                                                color: _size == "S"
                                                    ? KbackgroundColor
                                                    : KsecondaryColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _size = "M";
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color:
                                              _size != "M" ? KbackgroundColor : KsecondaryColor,
                                              border: Border.all(
                                                  color: _size != "M"
                                                      ? KsecondaryColor
                                                      : KsecondaryColor),
                                              borderRadius: BorderRadius.all(Radius.circular(1)),
                                            ),
                                            child: Text(
                                              "M",
                                              style: TextStyle(
                                                color: _size == "M"
                                                    ? KbackgroundColor
                                                    : KsecondaryColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _size = "L";
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color:
                                              _size != "L" ? KbackgroundColor : KsecondaryColor,
                                              border: Border.all(
                                                  color: _size != "L"
                                                      ? KsecondaryColor
                                                      : KsecondaryColor),
                                              borderRadius: BorderRadius.all(Radius.circular(1)),
                                            ),
                                            child: Text(
                                              "L",
                                              style: TextStyle(
                                                color: _size == "L"
                                                    ? KbackgroundColor
                                                    : KsecondaryColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _size = "XL";
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: _size != "XL"
                                                  ? KbackgroundColor
                                                  : KsecondaryColor,
                                              border: Border.all(
                                                  color: _size != "XL"
                                                      ? KsecondaryColor
                                                      : KsecondaryColor),
                                              borderRadius: BorderRadius.all(Radius.circular(1)),
                                            ),
                                            child: Text(
                                              "XL",
                                              style: TextStyle(
                                                color: _size == "XL"
                                                    ? KbackgroundColor
                                                    : KsecondaryColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  //// Sex  : /////
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Gender",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: KsecondaryColor,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Container(
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _sex = "Male";
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color:
                                              _sex != "Male" ? KbackgroundColor : KsecondaryColor,
                                              border: Border.all(
                                                  color: _sex != "Male"
                                                      ? KsecondaryColor
                                                      : KsecondaryColor),
                                              borderRadius: BorderRadius.all(Radius.circular(1)),
                                            ),
                                            child: Text(
                                              "M",
                                              style: TextStyle(
                                                color: _sex == "Male"
                                                    ? KbackgroundColor
                                                    : KsecondaryColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _sex = "Female";
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color:
                                              _sex != "Female" ? KbackgroundColor : KsecondaryColor,
                                              border: Border.all(
                                                  color: _sex != "Female"
                                                      ? KsecondaryColor
                                                      : KsecondaryColor),
                                              borderRadius: BorderRadius.all(Radius.circular(1)),
                                            ),
                                            child: Text(
                                              "F",
                                              style: TextStyle(
                                                color: _sex == "Female"
                                                    ? KbackgroundColor
                                                    : KsecondaryColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),


                                  //// Color Choices : /////
                                  Container(
                                    alignment: Alignment.centerLeft,

                                    child: Text(
                                      "Color",
                                      style: TextStyle(color: KsecondaryColor, fontSize: 24),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Container(
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _color = "Black";
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              border: Border.all(
                                                  color: _color != "Black"
                                                      ? KsecondaryColor
                                                      : KprimaryColor),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(100)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _color = "White";
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: _color != "White"
                                                      ? KsecondaryColor
                                                      : KprimaryColor),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(100)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),


                                  */

                                  Container(
                                    height: this.widget.product.attributes.length*110 +0.1,
                                    child: ListView.separated(
                                      physics: NeverScrollableScrollPhysics(), // <-- this will disable scroll
                                      shrinkWrap: true,
                                      controller: _controller,
                                      itemCount: this.widget.product.attributes.length,
                                      separatorBuilder: (context,index){
                                        return SizedBox(height: 10,);
                                      },
                                      itemBuilder: (context,index){
                                        return Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                this.widget.product.attributes[index].name,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: KsecondaryColor,
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),

                                           Container(
                                             width: 300,
                                             height:50,
                                             child: ListView.separated(
                                               scrollDirection:Axis.horizontal ,
                                                 itemBuilder: (context,indexSui){

                                                   return GestureDetector(

                                                     onTap: () {
                                                       setState(() {
                                                        atrributes[index] =
                                                            this.widget.product.attributes[index].name +
                                                                ": " + this.widget.product.attributes[index].options[indexSui];

                                                        print(indexSui);

                                                        if(atrributes.length != 1){

                                                          if(index != 0) {

                                                            indexkipper = indexSui ;

                                                            if (nbrColor == 0) {
                                                              print("black");
                                                              nbr = indexSui;
                                                            }
                                                            else {
                                                              print("white");
                                                              nbr = indexSui + this.widget.product.attributes[index].options.length;
                                                            }

                                                            indexkipper = nbr;

                                                          }else{

                                                            if(this.widget.product.attributes[0].options[indexSui] == "Black"){
                                                              nbr = indexkipper ;
                                                              if(indexkipper > this.widget.product.attributes[1].options.length - 1){

                                                                nbr-= (this.widget.product.attributes[1].options.length );

                                                              }
                                                              nbrColor=0;
                                                            }else{

                                                              nbr = indexkipper ;

                                                              if(indexkipper <= this.widget.product.attributes[1].options.length - 1){

                                                                nbr = indexkipper + (this.widget.product.attributes[1].options.length ) ;
                                                              }

                                                              nbrColor=1;
                                                            }

                                                          }

                                                        }else{
                                                          if(this.widget.product.attributes[0].options[indexSui] == "Black"){
                                                          nbr = 0;
                                                         }else{
                                                            nbr = 1;
                                                          }
                                                        }


                                                          print ("nbr :" + nbr.toString());
                                                        print(this.widget.product.variations[nbr]);

                                                        print(atrributes);
                                                       });
                                                     },
                                                     child: Container(
                                                       height: 40,
                                                       padding: EdgeInsets.symmetric(horizontal: 5),
                                                       alignment: Alignment.center,
                                                       decoration: BoxDecoration(
                                                         color:
                                                         _size != "S" ? KbackgroundColor : KsecondaryColor,
                                                         border: Border.all(
                                                             color: _size != "S"
                                                                 ? KsecondaryColor
                                                                 : KsecondaryColor),
                                                         borderRadius: BorderRadius.all(Radius.circular(1)),
                                                       ),
                                                       child: Text(
                                                         this.widget.product.attributes[index].options[indexSui],
                                                         style: TextStyle(
                                                           color: _size == "S"
                                                               ? KbackgroundColor
                                                               : KsecondaryColor,
                                                           fontSize: 20,
                                                         ),
                                                       ),
                                                     ),
                                                   );
                                                 },
                                                 separatorBuilder: (context,index){
                                                   return SizedBox(width: 10,);
                                                 },
                                                 itemCount:  this.widget.product.attributes[index].options.length),
                                           ),

                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ) ;
                                      },

                                    ),
                                  ),

                                  //// Quantite Choices : /////
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Quantity",
                                      style: TextStyle(color: KsecondaryColor, fontSize: 24),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: 107,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: KsecondaryColor,
                                        border: Border.all(
                                          color: KsecondaryColor,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                count > 1 ? count-- : null;
                                              });
                                            },
                                            child: Container(
                                              width: 35,
                                              height: 50,
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.remove,
                                                color: KbackgroundColor,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 35,
                                            height: 50,
                                            color: KbackgroundColor,
                                            alignment: Alignment.center,
                                            child: Text(
                                              count.toString(),
                                              style: TextStyle(fontSize: 19),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                count++;
                                              });
                                            },
                                            child: Container(
                                              width: 35,
                                              height: 50,
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.add,
                                                color: KbackgroundColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Description",
                                      style: TextStyle(color: KsecondaryColor, fontSize: 24),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),


                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      this.widget.product.description.replaceAll("<p>", "").replaceAll("</p>", ""),
                                      style: TextStyle(color: KsecondaryColor, fontSize: 16),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      );
    });



  }
}
