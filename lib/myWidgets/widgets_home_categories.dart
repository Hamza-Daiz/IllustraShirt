import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:illustrashirt/models/category.dart';
import 'package:illustrashirt/provider/products_provider.dart';
import 'package:illustrashirt/screens/HomeScreen.dart';
import 'package:illustrashirt/screens/ProductScreen.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:illustrashirt/constants.dart';
import 'package:provider/provider.dart';

class WidgetCategories extends StatefulWidget {
  String categoryIdVariable;

  @override
  _WidgetCategoriesState createState() => _WidgetCategoriesState();
}

class _WidgetCategoriesState extends State<WidgetCategories> {

  APIService apiService;

  bool _network = true;

  @override
  void initState() {
    // TODO: implement initState
    apiService = new APIService();
    checkInternetConnectivity();
    super.initState();
  }

  List<String> Categories = [
    'assets/categories/all_categories.png',
    "assets/categories/tshirt_categories.png",
    "assets/categories/hoddies_categories.png",
    "assets/categories/mugs_categories.png",
    "assets/categories/posters_categories.png",
    "assets/categories/sweat_categories.png",
  ];

  @override
  Widget build(BuildContext context) {

    var productList = Provider.of<ProductProvider>(context,listen: true);

    List<Function> onTapCategories = [
          (){
      setState(() {
        title = "Search";
        productList.typeId = null;
        productList.updateindex(2);
        productList.notifyListeners();
      });


      },
          (){
        setState(() {
          title = "Search";
          productList.typeId = "49";
          productList.updateindex(2);
          productList.notifyListeners();
        });
      },
          (){
        setState(() {
          title = "Search";
          productList.typeId = "51";
          productList.updateindex(2);
          productList.notifyListeners();
        });
      },
          (){
        setState(() {
          title = "Search";
          productList.typeId = "52";
          productList.updateindex(2);
          productList.notifyListeners();
        });
      },
          (){
        setState(() {
          title = "Search";
          productList.typeId = "53";
          productList.updateindex(2);
          productList.notifyListeners();
        });
      },
          (){
        setState(() {
          title = "Search";
          productList.typeId = "50";
          productList.updateindex(2);
          productList.notifyListeners();
        });
      },

    ];

    final withScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;



    return buildCategoriesList(Categories,onTapCategories);
  }

  Widget buildCategoriesList(List<String> categories, List<Function> tapCategories) {

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height*0.33,
      alignment: Alignment.center,
      child: Center(
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemBuilder: (BuildContext context, int index) {
                    var pathImage = categories[index];
                    return GestureDetector(
                      onTap: tapCategories[index],
                      child: Container(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(pathImage),
                        ),
                      ),
                    );


                  }),
            ),

    );
  }

  checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        _network = false;
      });
    } else {
      setState(() {
        _network = true;
      });
    }
  }

  Center NoInternetShowAleart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_outlined,
            color: KprimaryColor,
            size: 50,
          ),
          FlatButton(
            height: 40,
            minWidth: 60,
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('homeScreen'),
            child: Text(
              "Retry",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
