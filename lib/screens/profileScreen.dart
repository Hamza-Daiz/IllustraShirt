import 'package:flutter/material.dart';
import 'package:illustrashirt/provider/Chekout_provider.dart';
import 'package:illustrashirt/screens/HomeScreen.dart';
import 'package:illustrashirt/screens/chekOutScreen.dart';
import 'package:provider/provider.dart';

import '../constants.dart';



class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    var bagProvider = Provider.of<ChekOutProvider>(context, listen: false);

    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: KsecondaryColor,
                    )
                  ),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: KprimaryColor,
                  ),
                ),

                SizedBox(height: 10,),

                Text(bagProvider.clientName !="" ? bagProvider.clientName :"Uknown yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: KprimaryColor,
                    fontSize: 18,
                  ),),
              ],
            ),


            SizedBox(height: 30,),

            InkWell(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Edit Profile"),
              ),
            ),

            SizedBox(height: 20,),

            InkWell(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Orders"),
              ),
            ),
            SizedBox(height: 20,),

            InkWell(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Logout"),
              ),
            ),


          ],
        ),
      );
  }
}
