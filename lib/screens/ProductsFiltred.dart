import 'package:flutter/material.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/myWidgets/widgets_product_card.dart';
import 'package:illustrashirt/provider/products_provider.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'HomeScreen.dart';
import 'chekOutScreen.dart';



class ProductsFiltred extends StatefulWidget {

  List<Product> items;
  ProductsFiltred({this.items});

  @override
  _ProductsFiltredState createState() => _ProductsFiltredState();
}

class _ProductsFiltredState extends State<ProductsFiltred> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KbackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: KbackgroundColor,
        title: Text(
          "Products Filtred",
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

      body: Consumer<ProductProvider>(

        builder: (context, productsModel, child) {

          if (productsModel.allProducts != null &&
              productsModel.allProducts.length > 0 &&
              productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {

            return _buildList(
                widget.items,
                productsModel.getLoadMoreStatus() == LoadMoreStatus.LOADING
            );
          } else if (productsModel.allProducts != null &&
              productsModel.allProducts.length == 0 &&
              productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Text(
                  " Oops! Nothings is founded..",
                  style: TextStyle(color: KsecondaryColor),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(KprimaryColor),
            ),
          );
        },
      ),
    );
  }




  Widget _buildList(List<Product> items, bool bool,) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Flexible(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.5,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: items.map((Product items) {
              return ProductCard(data: items);
            }).toList(),
          ),
        ),
        Visibility(
          visible: bool,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(KprimaryColor),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
