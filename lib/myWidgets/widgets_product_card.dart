import 'package:flutter/material.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/constants.dart';
import 'package:illustrashirt/screens/ProductDetails.dart';


// ignore: must_be_immutable
class ProductCard extends StatelessWidget {

  Product data;
  ProductCard({this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ProductDetails(
            product: data,
          ),
        ));
      },
      child: Card(
        color: KbackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  data.images.length >0 ?
                  data.images[0].src :
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/300px-No_image_available.svg.png",
                fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: KbackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      color: KprimaryColor,
                      fontFamily: "Quincy",
                    ),
                  ),
                  SizedBox(height: 3,),
                  Text(
                    data.price + ".00 DH",
                    style: TextStyle(
                      fontSize: 15,
                      color: KsecondaryColor,
                      fontFamily: "Quincy",
                    ),
                  ),
                  SizedBox(height: 3,),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
