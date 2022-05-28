import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/myWidgets/widgets_product_card.dart';
import 'package:illustrashirt/provider/products_provider.dart';
import 'package:illustrashirt/screens/filters_screen.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:illustrashirt/constants.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {

  String categoryId;
  String tagId;
  String typeId;
  ProductScreen({this.categoryId,this.tagId,this.typeId,});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  int _page = 1;
  ScrollController _scrollController = new ScrollController();

  final _searchQuery = new TextEditingController();

  Timer _debounce;

  @override
  void initState() {

    var productList = Provider.of<ProductProvider>(context, listen: false);

    productList.resetStreams();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page,typeId: productList.typeId);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productList.setLoadingState(LoadMoreStatus.LOADING);
        productList.fetchProducts(++_page,typeId: productList.typeId);
      }
    });
    _searchQuery.addListener(_onShearchChange);
    super.initState();
  }

  _onShearchChange() {
    var productList = Provider.of<ProductProvider>(context, listen: false,);

    if (_debounce?.isActive ?? false) _debounce.cancel();

    _debounce = Timer(
        const Duration(milliseconds: 300),
            () {
          productList.resetStreams();
          productList.setLoadingState(LoadMoreStatus.INITIAL);
          productList.fetchProducts(_page, strSearch: _searchQuery.text,typeId: productList.typeId);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final withScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: _productList(),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FiltersScreen()));
            },
            child: Image.asset(
              "assets/images/icon_filter.png",
              height: 30,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: KsecondaryColor,
                ),
              ),
              child: TextField(
                controller: _searchQuery,
                decoration: InputDecoration(
                  hintText: "Search..",
                  border: InputBorder.none,
                  suffixIcon: GestureDetector(
                    child: Icon(Icons.cancel,color: KsecondaryColor,size: 40,),
                    onTap: () {
                      _searchQuery.clear();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productList() {
    return new Consumer<ProductProvider>(

      builder: (context, productsModel, child) {

        if (productsModel.allProducts != null &&
            productsModel.allProducts.length > 0 &&
            productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {

          return _buildList(
              productsModel.allProducts,
              productsModel.getLoadMoreStatus() == LoadMoreStatus.LOADING
          );
        } else if (productsModel.allProducts != null &&
            productsModel.allProducts.length == 0 &&
            productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
          return Column(
            children: [
              _searchBar(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Text(
                  " Oop! Nothings is founded..",
                  style: TextStyle(color: KsecondaryColor),
                ),
              ),
            ],
          );
        }
        return Column(
          children: [
            _searchBar(),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(KprimaryColor),
            ),
          ],
        );
      },
    );
  }

  Widget _buildList(List<Product> items, bool isloadmoreproduct) {
    return Column(
      children: [
        _searchBar(),
        SizedBox(
          height: 5,
        ),
        Flexible(
          child: GridView.count(
            controller: _scrollController,
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
          visible: isloadmoreproduct,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(KprimaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
