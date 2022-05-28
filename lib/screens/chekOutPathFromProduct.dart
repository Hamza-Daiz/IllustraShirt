import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:illustrashirt/constants.dart';
import 'package:illustrashirt/models/cart_request_model.dart';
import 'package:illustrashirt/models/customer_detail_model.dart';
import 'package:illustrashirt/models/shipping_zone.dart';
import 'package:illustrashirt/myWidgets/ProgressHUD.dart';
import 'package:illustrashirt/provider/cart_provider.dart';
import 'package:illustrashirt/provider/loader_provider.dart';
import 'package:illustrashirt/provider/products_provider.dart';
import 'package:illustrashirt/screens/HomeScreen.dart';
import 'package:illustrashirt/screens/chekOutScreen.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:illustrashirt/service/config.dart';
import 'package:provider/provider.dart';

import 'OrderScreen.dart';

class ChekOutPathFromProduct extends StatefulWidget {


 /* int productID;
  int productCount;

  BasketModel productToShop ;
  ChekOutPathFromProduct({this.productToShop,this.productCount,this.productID});*/

  @override
  _ChekOutPathFromProductState createState() => _ChekOutPathFromProductState();
}

class _ChekOutPathFromProductState extends State<ChekOutPathFromProduct> {

  TextEditingController describeController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  String groupValue = "cash on Delivery";

  String cityShipping;
  String priceShipping;

  int path = 1;

  bool down = true;
  bool choose = false;

  GestureDetector IconPath({String pathIcon, Function fct, Color color}) {
    return GestureDetector(
      onTap: fct,
      child: Container(
        height: 40,
        width: 40,
        padding: EdgeInsets.all(6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Image.asset(
          pathIcon,
        ),
      ),
    );
  }


  bool isloading = false;

  Billing _billing ;

  APIService apiService;
  CustomerDetailsModel customerDetailsModel;

  ShippingLines _shippingLines ;
  int zoneId ;

  @override
  void initState() {
   apiService = new APIService();
   _shippingLines = new ShippingLines();
   customerDetailsModel = new CustomerDetailsModel();

    var cartProvider = Provider.of<CartProvider>(context,listen: false);
    cartProvider.fetchShippingDetails();

    _billing = new Billing();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    var providerVar = Provider.of<ProductProvider>(context, listen: true);

    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    double width30 = widthScreen - 30;

    return Scaffold(

      backgroundColor: KbackgroundColor,

      appBar: AppBar(

        leading: MenuAppBar(context,1),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: KbackgroundColor,
        title: Text(
          "ChekOut",
          style: TextStyle(color: KprimaryColor, fontFamily: "Quincy"),
        ),
        actions: [
          shopIconAppBar(
            context,
                (){
                    providerVar.bottomBarShow = true;
                    providerVar.notifyListeners();

                    Navigator.of(context).pop();
                },

                ),
        ],
      ),

      body:
      ProgressHUD(
        inAsyncCall: Provider.of<LoaderProvider>(context,listen: false).isApiCallProcess,
        opacity: 0.3,
        child: Consumer<CartProvider>(builder: (context,customerModel,child){

         if(customerModel.customerDetailsModel != null) {

           if(customerModel.customerDetailsModel.id != null){

            CustomerDetailsModel model = customerModel.customerDetailsModel;

            _billing.city = model.billing.city;

            _shippingLines = customerModel.shippingLine;

            return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Visibility(
                      visible: path == 1 ? true : false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Form(
                            key: _formKey3,
                            child: Column(
                              children: [

                                // Path Design :
                                Container(
                                  width: width30 - 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/path_custom.png",
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      IconPath(
                                        pathIcon: "assets/path/Layer_path.png",
                                        color: KprimaryColor,
                                        fct: () {
                                          setState(() {
                                            if (_formKey.currentState.validate()) {
                                              providerVar.bottomBarShow = true;
                                              providerVar.notifyListeners();
                                              path = 1;
                                            }
                                          });
                                        },
                                      ),
                                      IconPath(
                                        pathIcon: "assets/path/card_path.png",
                                        color: KsecondaryColor,
                                        fct: () {
                                          setState(() {
                                            if (_formKey3.currentState.validate()) {
                                              providerVar.bottomBarShow = false;
                                              providerVar.notifyListeners();
                                              path = 2;
                                            }
                                          });
                                        },
                                      ),
                                      IconPath(
                                        pathIcon: "assets/path/mark_path.png",
                                        color: KsecondaryColor,
                                        fct: () {},
                                      )
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                Container(
                                  width: width30 - 30,
                                  child: Text(
                                    "Billing details.",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: KprimaryColor,
                                        fontSize: 22,
                                        fontFamily: "quincy",
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),

                                Container(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  margin: EdgeInsets.only(top: 10),
                                  width: width30 - 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                      color: Kbordercolor,
                                      width: 1,
                                    ),
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    cursorColor: KsecondaryColor,
                                    initialValue: model.billing.firstname,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Full name',
                                      labelStyle: TextStyle(color: Colors.black54),
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _billing.firstname = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "Please enter your Name..";
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                Container(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  margin: EdgeInsets.only(top: 10),
                                  width: width30 - 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                      color: Kbordercolor,
                                      width: 1,
                                    ),
                                  ),
                                  child: TextFormField(
                                    initialValue: model.billing.phone,
                                    keyboardType: TextInputType.phone,
                                    cursorColor: KsecondaryColor,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Phone number',
                                      labelStyle: TextStyle(color: Colors.black54),
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _billing.phone = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "Please enter your phone number..";
                                      }if (value.toString().length < 10 ) {
                                        return "Please enter a valid phone number..";
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                Container(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  margin: EdgeInsets.only(top: 10),
                                  width: width30 - 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                      color: Kbordercolor,
                                      width: 1,
                                    ),
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    cursorColor: KsecondaryColor,
                                    initialValue: model.billing.adress,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Street address',
                                      labelStyle: TextStyle(color: Colors.black54),
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _billing.adress = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "Please enter your Adress..";
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                // City : ---------

                                Container(
                                  height: 50,
                                  width: width30 - 30,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      color: KbackgroundColor,
                                      border: Border.all(
                                        color: KsecondaryColor,
                                      )),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              model.billing.city,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: KsecondaryColor,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Visibility(
                                              visible: choose,
                                              child: Text(
                                                "choose the city",
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(down
                                            ? Icons.arrow_drop_down_outlined
                                            : Icons.arrow_drop_up_outlined),
                                        onPressed: () {
                                          setState(() {
                                            down = !down;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 5,
                                ),

                                Visibility(
                                  visible: !down,
                                  child: FutureBuilder(
                                    future: apiService.getShippingZones(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {

                                        return Container(
                                          width: width30 - 30,
                                          decoration: BoxDecoration(
                                              color: KbackgroundColor,
                                              border: Border.all(
                                                color: KsecondaryColor,
                                              )),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              physics: ClampingScrollPhysics(),
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {

                                                if(_billing.city == snapshot.data[index].name){

                                                  zoneId = snapshot.data[index].id;

                                                  Provider.of<CartProvider>(context,listen: false).setIdShippingLine(snapshot.data[index].id);
                                                  }

                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                                  child: InkWell(
                                                    onTap: () async{

                                                      Provider.of<CartProvider>(context,listen: false).setIdShippingLine(snapshot.data[index].id);

                                                      setState(() {

                                                        _billing.city = snapshot.data[index].name.toString();

                                                        model.billing.city = snapshot.data[index].name.toString();

                                                        zoneId = snapshot.data[index].id;


                                                        down = !down;
                                                        choose = false;
                                                      });

                                                      _shippingLines = await apiService.getShippingLines(zoneId.toString());

                                                    },
                                                    child: Text(
                                                      snapshot.data[index].name.toString(),
                                                      style: TextStyle(fontSize: 20),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                );
                                              }),
                                        );
                                      } else
                                        return Container(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                KprimaryColor),
                                          ),
                                        );
                                    },
                                  ),
                                ),

                                Container(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  margin: EdgeInsets.only(top: 10),
                                  width: width30 - 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                      color: Kbordercolor,
                                      width: 1,
                                    ),
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    cursorColor: KsecondaryColor,
                                    initialValue: model.billing.zipCode,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Zip Code',
                                      labelStyle: TextStyle(color: Colors.black54),
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _billing.zipCode = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "Please enter the zip code..";
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                Container(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  margin: EdgeInsets.only(top: 10),
                                  width: width30 - 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                      color: Kbordercolor,
                                      width: 1,
                                    ),
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: KsecondaryColor,
                                    initialValue: model.billing.email,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Email address',
                                      labelStyle: TextStyle(color: Colors.black54),
                                      focusedBorder: InputBorder.none,
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _billing.email = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.toString().isEmpty) {
                                        return "Please enter your Adress..";
                                      }
                                      return null;
                                    },
                                  ),
                                ),


                                SizedBox(
                                  height: 10,
                                ),

                                Visibility(
                                  visible: isloading,
                                  child: Container(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          KprimaryColor),
                                    ),
                                  ),
                                )


                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: ()async {
                                    setState(() {
                                      isloading = true;
                                    });
                                  var cartProvider=  Provider.of<CartProvider>(context,listen: false);

                                      if (_formKey3.currentState.validate()) {

                                       await apiService.setbillingDetails(data: _billing);
                                       await apiService.setshippingDetails(data: _billing);
                                       await apiService.setFullName(data: _billing);


                                       await cartProvider.getTheLineShipping();

                                    //   cartProvider.getTheLineShipping(cartProvider.idshippingLine);

                                        print("done");

                                        setState(() {
                                           path = 2;

                                           providerVar.bottomBarShow = false;
                                           providerVar.notifyListeners();

                                         });
                                      }
                                    setState(() {
                                      isloading = false;
                                    });

                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: KsecondaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "NEXT",
                                      style: TextStyle(
                                        color: KbackgroundColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
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
                        ],
                      ),
                    ),

                    Visibility(
                      visible: path == 2 ? true : false,
                      child: Container(
                        height: heightScreen - 50,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Path Design :
                                  Container(
                                    width: width30 - 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "assets/images/path_custom.png",
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        IconPath(
                                          pathIcon: "assets/path/Layer_path.png",
                                          color: KsecondaryColor,
                                          fct: () {
                                            setState(() {
                                              providerVar.bottomBarShow = true;
                                              providerVar.notifyListeners();
                                              path = 1;
                                            });
                                          },
                                        ),
                                        IconPath(
                                          pathIcon: "assets/path/card_path.png",
                                          color: KprimaryColor,
                                          fct: () {
                                            setState(() {
                                              if (_formKey3.currentState.validate()) {
                                                path = 2;
                                              }
                                            });
                                          },
                                        ),
                                        IconPath(
                                          pathIcon: "assets/path/mark_path.png",
                                          color: KsecondaryColor,
                                          fct: () {
                                            setState(() {
                                              providerVar.bottomBarShow = true;
                                              providerVar.notifyListeners();
                                              path = 3;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 15,
                                  ),

                                  Container(
                                    width: width30 - 30,
                                    child: Text(
                                      "ALMOST DONE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: width30 - 30,
                                    child: Text(
                                      "Choose Your Payment Method",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: KprimaryColor,
                                          fontSize: 22,
                                          fontFamily: "quincy",
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Container(
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: ListTile(
                                      leading: Container(
                                        height: 60,
                                        width: 65,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: KsecondaryColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Image.asset(
                                          "assets/images/paypal.png",
                                        ),
                                      ),
                                      title: Text(
                                        "Paypal",
                                        style: TextStyle(
                                            color: KsecondaryColor.withOpacity(0.3),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20),
                                      ),
                                      trailing: Radio(
                                        onChanged: (value) {},
                                        groupValue: groupValue,
                                        value: "paypal",
                                        activeColor: KprimaryColor,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: ListTile(
                                      leading: Container(
                                        alignment: Alignment.center,
                                        height: 60,
                                        width: 65,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: KsecondaryColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "\$",
                                          style: TextStyle(
                                              color: KbackgroundColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40),
                                        ),
                                      ),
                                      title: Text(
                                        "Cash On Delivery ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 20),
                                      ),
                                      trailing: Radio(
                                        onChanged: (value) {
                                          setState(() {
                                            groupValue = value;
                                          });
                                        },
                                        groupValue: groupValue,
                                        value: "cash on Delivery",
                                        activeColor: KprimaryColor,
                                        autofocus: true,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),

                              Container(
                                padding: EdgeInsets.only(top: 25, left: 20,right:20,bottom:10),
                                alignment: Alignment.center,
                                width: width30 ,

                                decoration:BoxDecoration(
                                  color: KsecondaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ) ,
                                child: SingleChildScrollView(

                                  child: Column(
                                    children: [

                                      Container(
                                        width: width30 - 30,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Items :",
                                              style: TextStyle(
                                                  color: KbuttonColor, fontSize: 16),
                                            ),
                                            Text(
                                              Provider.of<CartProvider>(context,listen: false).a.toString(),
                                              style: TextStyle(
                                                  color: KbuttonColor, fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),

                                      Container(
                                        width: width30 - 30,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Shipping fee to " + (_shippingLines != null ? _shippingLines.title??"":""),
                                              style: TextStyle(
                                                color: KbuttonColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              (_shippingLines != null ? _shippingLines.total.toString()??"":"") +"DH",
                                              style: TextStyle(
                                                color: KbuttonColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),

                                      Container(
                                        width: width30 - 30,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "TOTAL",
                                              style: TextStyle(
                                                color: KprimaryColor,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              (Provider.of<CartProvider>(context,listen: false).p + (_shippingLines!= null ?_shippingLines.total ?? 0:0)).toString() + " DH",
                                              style: TextStyle(
                                                color: KprimaryColor,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),

                                      // ------- Confirm Order : ------------

                                      InkWell(
                                        onTap: () async {

                                          Provider.of<LoaderProvider>(context,listen: false).seLoadingStatut(true);

                                          var cartItemlist = Provider.of<CartProvider>(context,listen: false);

                                          cartItemlist.createOrder(
                                            shippingfee: _shippingLines.total,
                                            payMeth: "cod",
                                            payTitle: "Cash on delivery",
                                          );

                                          await http.delete(
                                              Uri.parse(
                                                  "https://illustrashirt.com/wp-json/wc/v3/cart?user_id=2&consumer_key=ck_7d37f1a42b05d0819e59b405f2ffdec4b4a52417&consumer_secret=cs_fe5087450da706010e2bbf430a4a9ab94fbb51f5"),
                                          );
                                          //cartItemlist.fetchCartItems();

                                          Provider.of<LoaderProvider>(context,listen: false).seLoadingStatut(false);

                                          setState(() {
                                            path = 3;
                                            providerVar.bottomBarShow = true;
                                            providerVar.notifyListeners();
                                          });

                                        },
                                        child: Container(
                                          width: width30 - 30,
                                          height: 60,
                                          color: KprimaryColor,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "CONFIRM YOUR ORDER",
                                            style: TextStyle(
                                              color: KbackgroundColor,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      Container(
                                        width: width30 - 30,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              providerVar.bottomBarShow = true;
                                              providerVar.notifyListeners();
                                              path = 1;
                                            });
                                          },
                                          child: Text(
                                            "RETURN",
                                            style: TextStyle(
                                              color: KbackgroundColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: path == 3 ? true : false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Container(
                            width: widthScreen,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Path Design :
                                Container(
                                  width: width30 - 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/path_custom.png",
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconPath(
                                        pathIcon: "assets/path/Layer_path.png",
                                        color: KsecondaryColor,
                                        fct: () {
                                          setState(() {

                                          });
                                        },
                                      ),
                                      IconPath(
                                        pathIcon: "assets/path/card_path.png",
                                        color: KsecondaryColor,
                                        fct: () {
                                          setState(() {

                                          });
                                        },
                                      ),
                                      IconPath(
                                        pathIcon: "assets/path/mark_path.png",
                                        color: KprimaryColor,
                                        fct: () {
                                          setState(() {

                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 100,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/congratBox.png",
                                width: width30 / 2,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Congrats!",
                                style: TextStyle(
                                  color: KprimaryColor,
                                  fontSize: 30,
                                  fontFamily: "Quincy",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Your product is on the way",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Go to ",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>OrderScreen()));

                                    },
                                    child: Text(
                                      "orders ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: KprimaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "for more details ",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 30,),

                              InkWell(
                                onTap: (){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
                                },
                                child: Container(
                                  height: 70,
                                  width: width30-30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: KsecondaryColor,

                                  ),
                                  child: Text("RETURN TO HOME",style: TextStyle(
                                    fontSize: 20,
                                    color: KbackgroundColor,
                                  ),),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                )
            );

          }

           else{
             return Center(
               child: CircularProgressIndicator(
                 strokeWidth: 5,
                 valueColor: AlwaysStoppedAnimation<Color>(
                     KprimaryColor),
               ),
             ) ;
           }
         }
         return Center(
           child: Text("No Network.." ,style: TextStyle(
             color: KprimaryColor,
             fontSize: 20,
           ),),
         );

        }),
      )

    );
  }
}
