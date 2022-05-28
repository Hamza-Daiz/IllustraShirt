import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:illustrashirt/constants.dart';

class SortBy {
  String value;
  String text;
  String sortOrder;
  SortBy({this.value,this.text,this.sortOrder});
}

enum LoadMoreStatus { INITIAL, LOADING, STABLE}


class ProductProvider with ChangeNotifier {

  bool bottomBarShow = true;

 String typeId ;

  int indexHome =0;

  void updateindex(int ind){
    indexHome = ind ;
  }

  APIService _apiService;
  List<Product> _productList;
  SortBy _sortBy;

  int pageSize = 10;

  List<Product> get allProducts => _productList ;
  double get totalRecords => _productList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;
  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider(){
    resetStreams();
    _sortBy = SortBy(value: "modified",text: "Latest",sortOrder: "asc" );
  }

  void resetStreams(){
    _apiService = APIService();
    _productList = List<Product>();
  }

/* CircularProgressIndicator(
      strokeWidth: 5,
      valueColor: AlwaysStoppedAnimation<Color>(KprimaryColor),
    );
    */

  setLoadingState(LoadMoreStatus loadMoreStatus){
    _loadMoreStatus = loadMoreStatus ;
  }

  setSortOrder(SortBy sortBy){
    _sortBy = sortBy;
    notifyListeners();
  }

  fetchProducts(
      pageNumber,
      {
        String strSearch,
        String tagId,
        String typeId,
        String categoryId,
        String sortBy,
        String sortOrder = "asc",
      }
      ) async {
    List<Product> itemModel = await _apiService.getProducts(
        tagId : tagId,
        strSearch: strSearch,
        categoryId : categoryId,
        typeId: typeId,
    );

    if(itemModel.length >0){
      _productList.addAll(itemModel);
    }

    setLoadingState(LoadMoreStatus.STABLE);
    notifyListeners();

  }


}