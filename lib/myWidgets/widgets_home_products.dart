import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/provider/products_provider.dart';
import 'package:illustrashirt/screens/ProductDetails.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:illustrashirt/constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WidgetHomeProducts extends StatefulWidget {
  Future<List<Product>> productsAp;
  WidgetHomeProducts({this.productsAp});

  @override
  _WidgetHomeProductsState createState() => _WidgetHomeProductsState();
}

class _WidgetHomeProductsState extends State<WidgetHomeProducts> {
  APIService apiService;

  get ProductsAp => widget.productsAp;


  @override
  void initState() {
    apiService = new APIService();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final withScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;


    return _productsList();
  }

  Widget _productsList() {
    return new FutureBuilder(
        future: ProductsAp,

        builder: (BuildContext context, AsyncSnapshot<List<Product>> model) {
          if (model.hasData) {
            return buildProductsList(model.data, true);
          }
          return Center(
            child: buildProductsList(model.data, false),
          );
        });
  }

  Widget buildProductsList(List items, bool bool) {
    return Container(
      height: 300,
      child: bool
          ? ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var data = items[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ProductDetails(
                        product: data,
                      ),
                    ));
                  },
                  child: Card(
                    elevation: 0.5,
                    color: KbackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            data.images[0].src,
                            height: 230,
                            fit: BoxFit.cover,
                            width: 180,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 160,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                width: 150,
                                child: Text(
                                  data.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: KprimaryColor,
                                    fontFamily: "Quincy"
                                  ),
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Text(
                                    data.price + ".00 DH",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: KsecondaryColor,
                                    ),
                                  ),

                                  Container(
                                    width: 50,
                                    child: Row(
                                      children:[Icon(Icons.star,color: KprimaryColor,),
                                        Text(
                                          "4.6",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: KsecondaryColor,
                                          ),
                                        ),],

                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
          : ListView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 0.5,
                  color: KbackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:5.0,horizontal: 10),
                    child: Shimmer.fromColors(
                      period: Duration(milliseconds : 8000),
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[200],
                       child: ShimmerLayout(),
                    ),
                  ),
                );
              }),
    );
  }

}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 210,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[500],
          ),
        ),
        SizedBox(height: 5,),
        Container(
          height: 15,
          width: 100,
          color: Colors.grey[500],
        ),
        SizedBox(height: 5,),
        Container(
          height: 15,
          width: 80,
          color: Colors.grey[500],
        ),
      ],
    );
  }
}
