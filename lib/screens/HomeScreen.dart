
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:focused_menu/modals.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:illustrashirt/db/bag_database.dart';
import 'package:illustrashirt/models/product_basketModel.dart';
import 'package:illustrashirt/provider/cart_provider.dart';
import 'package:illustrashirt/screens/Enterance.dart';
import 'package:illustrashirt/screens/profileScreen.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:illustrashirt/constants.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/myWidgets/widgets_home_products.dart';
import 'package:illustrashirt/myWidgets/widgets_home_categories.dart';


// Screens :
import 'package:illustrashirt/screens/ProductScreen.dart';
import 'package:illustrashirt/screens/Custom_Design.dart';
import 'package:illustrashirt/screens/chekOutScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OrderScreen.dart';
import 'filters_screen.dart';


// Providers :
import 'package:illustrashirt/provider/products_provider.dart';
import 'package:illustrashirt/provider/Chekout_provider.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:illustrashirt/service/config.dart';



class HomeScreen extends StatefulWidget {

  int index = 0;
  String categoryIdSending = "";


  HomeScreen({this.index, this.categoryIdSending});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<BasketModel> bags = List<BasketModel>();
bool isloading = false;


 shopIconAppBar( BuildContext context,Function func )  {

  return InkWell(
    onTap: func,
    child: Container(
      margin: const EdgeInsets.only(right: 10.0),
      width: 50,
      height: 50,
      child: Stack(
        children: [
          Positioned(
            bottom: 10,
            left: 0,
            right: 10,
            child: Icon(
              Icons.shopping_cart_outlined,
              color: KsecondaryColor,
              size: 25,
            ),
          ),
          Positioned(
            right: 10,
            bottom: 28,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: KprimaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                Provider.of<CartProvider>(context,listen: false).a.toString() ,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

}

FocusedMenuItem FocusedCustom({String text}) {
  return FocusedMenuItem(
    backgroundColor: KsecondaryColor,
    title: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        text,
        style: TextStyle(color: KbackgroundColor),
      ),
    ),
    onPressed: () {},
  );
}

Widget MenuAppBar( BuildContext context ,  int choice) {
  return FocusedMenuHolder(
    menuBoxDecoration: BoxDecoration(
      color: KsecondaryColor,
    ),
    onPressed: () {},
    openWithTap: true,
    blurSize: 0.4,
    menuItems: [

      FocusedMenuItem(
        backgroundColor: KsecondaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20),
          child: Text(
            "Home",
            style: TextStyle(color:choice ==1 ?KprimaryColor : KbackgroundColor),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
        },
      ),

      FocusedMenuItem(
        backgroundColor: KsecondaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20),
          child: Text(
            "Categories",
            style: TextStyle(color: choice ==2 ?KprimaryColor : KbackgroundColor),
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FiltersScreen()));
        },
      ),

      FocusedMenuItem(
        backgroundColor: KsecondaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20),
          child: Text(
            "My orders",
            style: TextStyle(color: choice ==3 ?KprimaryColor : KbackgroundColor),
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OrderScreen()));
        },
      ),

      FocusedMenuItem(
        backgroundColor: KsecondaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20),
          child: Text(
            "Sign Out",
            style: TextStyle(color: choice ==4 ?KprimaryColor : KbackgroundColor),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Enterance()));
        },
      ),

      FocusedMenuItem(
        backgroundColor: KsecondaryColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 0),
          child: Container(
            alignment: Alignment.center,
            width: 150,
            height: 2,
            color: KprimaryColor,
          ),
        ),
        onPressed: () {},
      ),

      FocusedCustom(text: "Terms And Condition"),
      FocusedCustom(text: "Privacy Policy"),
      FocusedCustom(text: "Shipping And Return"),

    ],
    child: Icon(
      Icons.menu,
      color: KsecondaryColor,
      size: 25,
    ),
  );
}

String title = "Home";

class _HomeScreenState extends State<HomeScreen> {

  APIService _apiService;
  Future<List<Product>> _productsMostPopular;
  int homeIndex;

  ProductProvider productList;


  @override
  void initState() {

    var cartProvider = Provider.of<CartProvider>(context,listen: false);

     cartProvider.fetchCartItems();


     productList = Provider.of<ProductProvider>(context,listen: false);
     productList.bottomBarShow = true ;

      homeIndex = productList.indexHome;
      productList.updateindex(0);

      _apiService = new APIService();
      
      _productsMostPopular = _apiService.getProducts(tagId: Config.tagPopularItemsId) ;


      super.initState();
  }

  DateTime timeBackPress = DateTime.now();

  @override
  Widget build(BuildContext context) {

    Future loading( ) async {
      await Future.delayed(Duration(milliseconds: 400));

      bags = await BagDatabase.instance.readAll() ;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

    }


    List<Widget> homeWidgets = [

      ListView(
        children: [
          // Title : Categories
          Padding(
            padding:
            const EdgeInsets.only(top: 0.0, left: 10, bottom: 5),
            child: Text(
              "Collections",
              style: TextStyle(
                  color: KprimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Quincy"),
            ),
          ),

          // Categories Liste From Widget_home_categories :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: WidgetCategories(),
          ),

          // Title : Most Popular
          Padding(
            padding: const EdgeInsets.only(left: 10.0,bottom: 5,top: 5),
            child: Text(
              "Most popular items",
              style: TextStyle(
                  color: KprimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Quincy"),
            ),
          ),

          // Product Liste From Widget_home_product :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),

            child: WidgetHomeProducts(productsAp: _productsMostPopular,),
          ),
        ],
      ),

      CustomDesignPath(apiService: _apiService),

      ProductScreen(),

      ProductScreen(),

      ProfileScreen() ,

    ];

    var providerFromHome = Provider.of<ProductProvider>(context,listen: true);

    return WillPopScope(
      onWillPop: () async {
        final different = DateTime.now().difference(timeBackPress);

        final isExitWarning = different >= Duration(seconds: 2);

        timeBackPress = DateTime.now();

        if(isExitWarning){
          final message = "Press again to exit";
          Fluttertoast.showToast(msg: message,fontSize: 16);

          return false;
        }else{
          Fluttertoast.cancel();
          return true;
        }
      },
      child: SafeArea(
        child: RefreshIndicator(
          color: KprimaryColor,
          onRefresh: loading,
          child: Scaffold(
            backgroundColor: KbackgroundColor,

            appBar: AppBar(
              leading: MenuAppBar(context,1),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              elevation: 0,
              backgroundColor: KbackgroundColor,
              title: Text(
                providerFromHome.indexHome ==0 ? "Home" : title,
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


            body: homeWidgets[providerFromHome.indexHome] ,



            bottomNavigationBar: productList.bottomBarShow ? ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),

              child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: (index) {
                  setState(() {
                    providerFromHome.updateindex(index);
                    if (providerFromHome.indexHome == 1) {
                      title = "Custom Design";

                    }
                    if (providerFromHome.indexHome == 0) {
                      title = "Home";
                      widget.categoryIdSending = null;
                    } else if (providerFromHome.indexHome == 2) {
                      title = "Search";
                    }else if (providerFromHome.indexHome == 4) {
                      title = "Profile";
                    }
                  });
                },
                currentIndex: providerFromHome.indexHome,
                elevation: 5.0,
                backgroundColor: KsecondaryColor,
                unselectedItemColor: KbackgroundColor,
                selectedItemColor: KbackgroundColor,
                type: BottomNavigationBarType.fixed,
                items: [
                  buildBottomNavigationBarItem("assets/images/icon_home.png"),
                  buildBottomNavigationBarItem("assets/images/icon_pen.png"),
                  buildBottomNavigationBarItem("assets/images/icon_search.png"),
                  buildBottomNavigationBarItem("assets/images/icon_alert.png"),
                  buildBottomNavigationBarItem("assets/images/icon_person.png"),
                ],
              ),
            ) : null,
          ),
        ),
      ),
    );
  }

  InkWell drawerItems(
      {Function onTapFonction, IconData iconItem, String textItem}
      ) {
    return InkWell(
      onTap: onTapFonction,
      child: ListTile(
        leading: Icon(
          iconItem,
          color: KprimaryColor,
          size: 30,
        ),
        title: Text(
          textItem,
          style: TextStyle(
            color: KsecondaryColor,
            fontSize: 20,
            fontFamily: 'Quincy',
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
    String imagPate,
  ) {
    return BottomNavigationBarItem(
      activeIcon: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
            color: KprimaryColor, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            imagPate,
            width: 20,
            height: 20,
            color: KbackgroundColor,
          ),
        ),
      ),
      icon: Image.asset(
        imagPate,
        width: 20,
        color: KbackgroundColor,
      ),
      label: "",
    );
  }
}
