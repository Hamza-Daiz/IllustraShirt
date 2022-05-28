
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:illustrashirt/constants.dart';
import 'package:illustrashirt/db/shipping_database.dart';
import 'package:illustrashirt/models/category.dart';
import 'package:illustrashirt/models/customer_detail_model.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/provider/products_provider.dart';
import 'package:illustrashirt/screens/HomeScreen.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


import 'package:provider/provider.dart';
import 'package:illustrashirt/db/bag_database.dart';
import 'package:illustrashirt/db/shipping_database.dart';

import 'package:illustrashirt/provider/Chekout_provider.dart';
import 'package:illustrashirt/models/product_basketModel.dart';
import 'package:illustrashirt/screens/chekOutScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomDesignPath extends StatefulWidget {
  APIService apiService;

  CustomDesignPath({this.apiService});
  @override
  _CustomDesignPathState createState() => _CustomDesignPathState();
}

class _CustomDesignPathState extends State<CustomDesignPath> {

  TextEditingController describeController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  Color borderColor = KsecondaryColor;
  String groupValue = "cash on Delivery";

  String _size = "M";
  String _color = "Black";
  String _sex = "Female";
  int count = 1;
  double price = 129;

  int path = 1;

  int choice = 1;

  bool _mine = true;
  bool down = true;
  bool choose = false;

  String _myCategory = "CHOOSE CATEGORY";
  String _imagePathFromGallerie ;
  String _descrip = "";
  String _phoneNumber = "";

  String _name = "";
  String _adress = "";
  String _city = "";
  String _zip = "";

  Widget ChoiceCustomWidget({String pathimage, String title}) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: KsecondaryColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            pathimage,
            height: 50,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(
              color: KbackgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget titleText({String data}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        data,
        style: TextStyle(
            color: KprimaryColor,
            fontSize: 20,
            fontFamily: "Quincy",
            fontWeight: FontWeight.w600),
      ),
    );
  }

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

  File imageFile;
  final picker = ImagePicker();

  chooseImage(ImageSource source) async{

    final pickedFile = await  picker.pickImage(source: source);

    setState((){
      _imagePathFromGallerie = pickedFile.path;
      imageFile = File(_imagePathFromGallerie);

    });

  }

  List<Billing> billing;
  bool isloading = false;
  int firstTime = 0;

  Billing _billing ;
  Billing _billingSaved = Billing(
    firstname: "",city: "",phone: "",adress: "",zipCode: "",
  ) ;

  @override
  void initState() {

    refreshBag();

    _billing = new Billing();

    super.initState();
  }

  Future refreshBag() async{
    setState(() {isloading = true;});

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("firstTime", 0);

    billing = await ShippingDatabase.instance.readAll() ;

    try{
      setState(() {
        _billingSaved = billing.first  ;
      });
    }catch (e) {
      print('Something happened while printing the list');
      print('Printing out the message: $e');
    }

    setState(() {isloading = false;});
  }

  @override
  Widget build(BuildContext context) {

    var providerVar = Provider.of<ProductProvider>(context, listen: true);

    var bagProvider = Provider.of<ChekOutProvider>(context,listen: false);





    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    BasketModel _costumProduct ;
    _costumProduct = new BasketModel();

    double width30 = widthScreen - 30;



    if (firstTime!=0){
      }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Visibility(
            visible: path == 1 ? true : false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                        pathIcon: "assets/path/tshirt_path.png",
                        color: KprimaryColor,
                        fct: () {
                          setState(() {
                            providerVar.bottomBarShow = true;
                            providerVar.notifyListeners();
                            path = 1;
                          });
                        },
                      ),
                      IconPath(
                        pathIcon: "assets/path/pen_path.png",
                        color: KsecondaryColor,
                        fct: () {
                          setState(() {
                            providerVar.bottomBarShow = true;
                            providerVar.notifyListeners();
                            path = 2;
                          });
                        },
                      ),
                      IconPath(
                        pathIcon: "assets/path/Layer_path.png",
                        color: KsecondaryColor,
                        fct: () {},
                      ),
                      IconPath(
                        pathIcon: "assets/path/card_path.png",
                        color: KsecondaryColor,
                        fct: () {},
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
                  height: 15,
                ),

                Container(
                  width: width30 - 30,
                  child: Text(
                    "Choose the product you want",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: KprimaryColor,
                        fontSize: 22,
                        fontFamily: "quincy",
                        fontWeight: FontWeight.w700),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                Container(
                  width: width30,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: KsecondaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/path/tshirt_page1_custom.png",
                        height: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "T-SHIRT",
                        style: TextStyle(
                          color: KprimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Container(
                  width: width30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ChoiceCustomWidget(
                          pathimage: "assets/path/mug_page1_custom.png",
                          title: "MUG",
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: ChoiceCustomWidget(
                        pathimage: "assets/path/poster_page1_custom.png",
                        title: "POSTER",
                      )),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Container(
                  width: width30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ChoiceCustomWidget(
                          pathimage: "assets/path/hoodie_page1_custom.png",
                          title: "HOODIE",
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: ChoiceCustomWidget(
                        pathimage: "assets/path/sweat_page1_custom.png",
                        title: "SWEATSHIRT",
                      )),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                //// Size Choices : /////
                Container(
                  alignment: Alignment.centerLeft,
                  width: width30,
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
                  width: width30,
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
                                _size != "S" ? KbackgroundColor : KprimaryColor,
                            border: Border.all(
                                color: _size != "S"
                                    ? KsecondaryColor
                                    : KprimaryColor),
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
                                _size != "M" ? KbackgroundColor : KprimaryColor,
                            border: Border.all(
                                color: _size != "M"
                                    ? KsecondaryColor
                                    : KprimaryColor),
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
                                _size != "L" ? KbackgroundColor : KprimaryColor,
                            border: Border.all(
                                color: _size != "L"
                                    ? KsecondaryColor
                                    : KprimaryColor),
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
                                : KprimaryColor,
                            border: Border.all(
                                color: _size != "XL"
                                    ? KsecondaryColor
                                    : KprimaryColor),
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
                  width: width30,
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
                  width: width30,
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
                            _sex != "Male" ? KbackgroundColor : KprimaryColor,
                            border: Border.all(
                                color: _sex != "Male"
                                    ? KsecondaryColor
                                    : KprimaryColor),
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
                            _sex != "Female" ? KbackgroundColor : KprimaryColor,
                            border: Border.all(
                                color: _sex != "Female"
                                    ? KsecondaryColor
                                    : KprimaryColor),
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
                  width: widthScreen - 30,
                  child: Text(
                    "Color",
                    style: TextStyle(color: KsecondaryColor, fontSize: 24),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Container(
                  width: width30,
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

                //// Quantite Choices : /////
                Container(
                  alignment: Alignment.centerLeft,
                  width: width30,
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
                  width: widthScreen - 30,
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ITEM PRICE : ",
                        style: TextStyle(
                          color: KsecondaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        (count * price).toString() + " DH",
                        style: TextStyle(
                          color: KprimaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        path = 2;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 15),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: KsecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "NEXT",
                        style: TextStyle(
                          color: KbackgroundColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [

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
                            pathIcon: "assets/path/tshirt_path.png",
                            color: KsecondaryColor,
                            fct: () {
                              setState(() {
                                path = 1;
                                providerVar.bottomBarShow = true;
                                providerVar.notifyListeners();
                              });
                            },
                          ),
                          IconPath(
                            pathIcon: "assets/path/pen_path.png",
                            color: KprimaryColor,
                            fct: () {
                              setState(() {
                                providerVar.bottomBarShow = true;
                                providerVar.notifyListeners();
                                path = 2;
                              });
                            },
                          ),
                          IconPath(
                            pathIcon: "assets/path/Layer_path.png",
                            color: KsecondaryColor,
                            fct: () {},
                          ),
                          IconPath(
                            pathIcon: "assets/path/card_path.png",
                            color: KsecondaryColor,
                            fct: () {},
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
                        "Upload your design or request one.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: KprimaryColor,
                            fontSize: 22,
                            fontFamily: "quincy",
                            fontWeight: FontWeight.w700),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              choice = 1;
                              _mine = true;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: width30 / 2 - 20,
                            height: 50,
                            decoration: BoxDecoration(
                              color: choice == 1
                                  ? KsecondaryColor
                                  : KbackgroundColor,
                            ),
                            child: Text(
                              "UPLOAD MINE",
                              style: TextStyle(
                                color: choice == 1
                                    ? KbackgroundColor
                                    : KsecondaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              choice = 2;
                              _mine = false;
                            });
                          },
                          child: Container(
                            width: width30 / 2 - 20,
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              color: choice == 2
                                  ? KsecondaryColor
                                  : KbackgroundColor,
                            ),
                            child: Text(
                              "MAKE ONE FOR ME",
                              style: TextStyle(
                                color: choice == 2
                                    ? KbackgroundColor
                                    : KsecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Visibility(
                      visible: _mine,
                      child: Column(
                        children: [

                          InkWell(
                            onTap: () {

                              chooseImage(ImageSource.gallery);
                              if(imageFile!=null) borderColor = KsecondaryColor;

                            },
                            child: Container(
                              width: width30 - 30,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: KsecondaryColor,
                              )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("CHOOSE FROM GALLERY"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.file_upload,
                                  )
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          imageFile != null ? InkWell(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: Text("Delet this product?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            imageFile = null;
                                            _imagePathFromGallerie = null;

                                            Navigator.pop(context);
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
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(imageFile),
                                )
                              ),
                            ),
                          ) :
                              Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: borderColor,
                                  )
                                ),
                                child: Text("Here The Image Downloaded",textAlign: TextAlign.center,),
                              ),
                        ],
                      ),

                    ),

                    Visibility(
                      visible: !_mine,
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: width30 - 30,
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
                                        _myCategory,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: KsecondaryColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Visibility(
                                        visible: choose,
                                        child: Text(
                                          "choose the category",
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
                              future: widget.apiService.getCategoris(),
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
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _myCategory = snapshot
                                                      .data[index].categoryName
                                                      .toString();
                                                  down = !down;
                                                  choose = false;
                                                });
                                              },
                                              child: Text(
                                                snapshot
                                                    .data[index].categoryName
                                                    .toString(),
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

                          SizedBox(
                            height: 5,
                          ),

                          // -------- Input description :: --------

                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            height: 150,
                            width: width30 - 30,
                            decoration: BoxDecoration(
                                color: KbackgroundColor,
                                border: Border.all(
                                  color: KsecondaryColor,
                                )),
                            child: TextField(
                              controller: describeController,
                              cursorColor: KsecondaryColor,
                              cursorHeight: 20,
                              minLines: 1,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                _descrip = value;
                              },
                              decoration: InputDecoration(
                                hintText: "DESCRIBE WHAT DO YOU WANT...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: width30 - 30,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 23, vertical: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: Kbordercolor,
                                width: 1,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Icon(
                                      Icons.phone,
                                      color: KprimaryColor,
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 35,
                                    color: Kbordercolor,
                                    margin: EdgeInsets.only(right: 10),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _billingSaved.phone,
                                      keyboardType: TextInputType.number,
                                      cursorColor: KprimaryColor,
                                      showCursor: false,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'WhatsApp Number',
                                        labelStyle:
                                            TextStyle(color: Colors.black54),
                                        focusedBorder: InputBorder.none,
                                      ),
                                      onChanged: (String value) {
                                        setState(() {
                                          bagProvider.clientPhoneNumber = value;
                                          bagProvider.notifyListeners();
                                        });
                                      },
                                      validator: (value) {
                                        if (value.toString().isEmpty) {
                                          return "Please enter your phone number..";
                                        }
                                        if (value.toString().length < 10) {
                                          return "Please enter a valid phone number..";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            path = 1;
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
                            "BACK",
                            style: TextStyle(
                              color: KbackgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (!_mine) {
                              if (_formKey.currentState.validate() &&
                                  _myCategory != "CHOOSE CATEGORY") {
                                setState(() {
                                  path = 3;
                                  choose = false;
                                });
                              } else if (_myCategory == "CHOOSE CATEGORY") {
                                setState(() {
                                  choose = true;
                                });
                              }

                            }else{
                              if(imageFile!=null){
                                setState(() {
                                  _costumProduct.imageFileGallery = imageFile;
                                  path = 3;
                                  choose = false;
                                });
                              }else{
                                  setState(() {
                                    borderColor = Colors.red;
                                  });
                              }
                            }
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
            visible: path == 3 ? true : false,
            child: !isloading ?

            Column(
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
                              pathIcon: "assets/path/tshirt_path.png",
                              color: KsecondaryColor,
                              fct: () {
                                setState(() {
                                  path = 1;
                                  providerVar.bottomBarShow = true;
                                  providerVar.notifyListeners();
                                });
                              },
                            ),
                            IconPath(
                              pathIcon: "assets/path/pen_path.png",
                              color: KsecondaryColor,
                              fct: () {
                                setState(() {
                                  path = 2;
                                  providerVar.bottomBarShow = true;
                                  providerVar.notifyListeners();
                                });
                              },
                            ),
                            IconPath(
                              pathIcon: "assets/path/Layer_path.png",
                              color: KprimaryColor,
                              fct: () {
                                setState(() {
                                  if (_formKey.currentState.validate()) {
                                    providerVar.bottomBarShow = true;
                                    providerVar.notifyListeners();
                                    path = 3;
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
                                    path = 4;
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
                          "Shipping Adress.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: KprimaryColor,
                              fontSize: 22,
                              fontFamily: "quincy",
                              fontWeight: FontWeight.w700),
                        ),
                      ),

                      // Input name  :
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
                          initialValue: _billingSaved.firstname,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.black54),
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _name = value;
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

                      // Input phone :
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
                          initialValue: _billingSaved.phone,
                          keyboardType: TextInputType.number,
                          cursorColor: KsecondaryColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Phone number',
                            labelStyle: TextStyle(color: Colors.black54),
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _phoneNumber = value;
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

                      // Input adress :
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
                          initialValue: _billingSaved.adress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Adress',
                            labelStyle: TextStyle(color: Colors.black54),
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _adress = value;
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

                      // Input city :
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
                          initialValue: _billingSaved.city,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'City',
                            labelStyle: TextStyle(color: Colors.black54),
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _city = value;
                            });
                          },
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "Please enter Your City name..";
                            }
                            return null;
                          },
                        ),
                      ),

                      // Input zip :
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
                          initialValue:  _billingSaved.zipCode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Zip Code',
                            labelStyle: TextStyle(color: Colors.black54),
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _zip = value;
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

                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      InkWell(
                        onTap: () {
                          setState(() {
                            path = 2;
                            providerVar.bottomBarShow = true;
                            providerVar.notifyListeners();
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
                            "BACK",
                            style: TextStyle(
                              color: KbackgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: ()  async{

                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          setState(() {
                            if (_formKey3.currentState.validate()) {

                              _billing.email="";
                              _billing.phone=_phoneNumber;
                              _billing.zipCode=_zip;
                              _billing.city=_city;
                              _billing.firstname=_name;
                              _billing.adress=_adress;

                              setState(() {
                                if(billing.isEmpty){

                                  ShippingDatabase.instance.create(_billing);



                                  preferences.setInt("firstTime", 1);

                                  firstTime = preferences.getInt("firstTime");
                                }else {

                                  ShippingDatabase.instance.update(_billing);
                                }
                              });
                              path = 4;

                              providerVar.bottomBarShow = false;
                              providerVar.notifyListeners();
                            }
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
            ) :

            Container(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(
                    KprimaryColor),
              ),
            ),
          ),

          Visibility(
            visible: path == 4 ? true : false,
            child: Container(
               height: heightScreen - 90 ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top:0.0),
                    child: SingleChildScrollView(
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
                                  pathIcon: "assets/path/tshirt_path.png",
                                  color: KsecondaryColor,
                                  fct: () {
                                    setState(() {
                                      path = 1;
                                    });
                                  },
                                ),
                                IconPath(
                                  pathIcon: "assets/path/pen_path.png",
                                  color: KsecondaryColor,
                                  fct: () {
                                    setState(() {
                                      path = 2;
                                    });
                                  },
                                ),
                                IconPath(
                                  pathIcon: "assets/path/Layer_path.png",
                                  color: KsecondaryColor,
                                  fct: () {
                                    setState(() {
                                      providerVar.bottomBarShow = true;
                                      providerVar.notifyListeners();
                                      path = 3;
                                    });
                                  },
                                ),
                                IconPath(
                                  pathIcon: "assets/path/card_path.png",
                                  color: KprimaryColor,
                                  fct: () {
                                    setState(() {
                                      if (_formKey3.currentState.validate()) {
                                        path = 4;
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
                                      path = 5;
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
                                EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                                EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      child: Container(
                        padding:
                            EdgeInsets.only(top: 20, left: 20,right:20,bottom:5),
                        alignment: Alignment.center,
                        width: double.infinity,
                        color: KsecondaryColor,
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
                                      count.toString(),
                                      style: TextStyle(
                                          color: KbuttonColor, fontSize: 16),
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
                                      "Shipping fee to Marrakech :",
                                      style: TextStyle(
                                        color: KbuttonColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "20 DH",
                                      style: TextStyle(
                                        color: KbuttonColor,
                                        fontSize: 16,
                                      ),
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
                                      "TOTAL",
                                      style: TextStyle(
                                        color: KprimaryColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      (count * price).toString() + " DH",
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
                                height: 10,
                              ),

                              // ------- Confirm Order : ------------

                              Container(
                                width: width30 - 30,
                                height: 60,
                                color: KprimaryColor,
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {

                                      _costumProduct.count = count;
                                      _costumProduct.size = _size;
                                      _costumProduct.price = price;
                                      _costumProduct.name = "Custom product";
                                      _costumProduct.imagePathFromGallerie= _imagePathFromGallerie;
                                      _costumProduct.sex = _sex;
                                      _costumProduct.city = _city;
                                      _costumProduct.color = (_color == "White"? "White" : "Black");
                                      _costumProduct.category = _myCategory != "CHOOSE CATEGORY" ?_myCategory :"UNCATEGORIZED";

                                      if(imageFile!=null) _costumProduct.imageFileGallery = imageFile;

                                      BagDatabase.instance.create(_costumProduct);

                                      path = 5;
                                      providerVar.bottomBarShow = true;
                                      providerVar.notifyListeners();


                                    });
                                  },
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
                                      path = 3;
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
                    ),
                  ),
                ],
              ),
            ),
          ),

          Visibility(
            visible: path == 5 ? true : false,
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
                              pathIcon: "assets/path/tshirt_path.png",
                              color: KsecondaryColor,
                              fct: () {
                                setState(() {
                                  path = 1;
                                });
                              },
                            ),
                            IconPath(
                              pathIcon: "assets/path/pen_path.png",
                              color: KsecondaryColor,
                              fct: () {
                                setState(() {
                                  path = 2;
                                });
                              },
                            ),
                            IconPath(
                              pathIcon: "assets/path/Layer_path.png",
                              color: KsecondaryColor,
                              fct: () {
                                setState(() {
                                  providerVar.bottomBarShow = true;
                                  providerVar.notifyListeners();
                                  path = 3;
                                });
                              },
                            ),
                            IconPath(
                              pathIcon: "assets/path/card_path.png",
                              color: KsecondaryColor,
                              fct: () {
                                setState(() {
                                  providerVar.bottomBarShow = false;
                                  providerVar.notifyListeners();
                                  path = 4;
                                });
                              },
                            ),
                            IconPath(
                              pathIcon: "assets/path/mark_path.png",
                              color: KprimaryColor,
                              fct: () {
                                setState(() {
                                  providerVar.bottomBarShow = true;
                                  providerVar.notifyListeners();
                                  path = 5;
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
                  height: 30,
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
                      height: 20,
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
                      },
                      child: Container(
                        height: 60,
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
                    SizedBox(
                      height: 20,
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>CheckOutScreen()));
                      },
                      child: Container(
                        height: 60,
                        width: width30-30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: KprimaryColor,
                          ),

                        ),
                        child: Text("CHEKOUT Orders",style: TextStyle(
                          fontSize: 20,
                          color: KprimaryColor,
                        ),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
