import 'package:flutter/material.dart';

//My imorts
import 'package:illustrashirt/main.dart';
import 'package:illustrashirt/constants.dart';
import 'package:illustrashirt/screens/LogInScreen.dart';
import 'package:illustrashirt/screens/SignUpScreen.dart';
import 'package:illustrashirt/screens/HomeScreen.dart';


class Enterance extends StatefulWidget {
  @override
  _EnteranceState createState() => _EnteranceState();
}
class _EnteranceState extends State<Enterance> {
  @override
  Widget build(BuildContext context) {
    final withScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: KsecondaryColor,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/background_entrance.png",
                      height: 200,
                      width: withScreen,

                    ),

                    SizedBox(height : 15),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top:15.0),
                        child: Image.asset("assets/images/icon_illustra.png",
                          width: 70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:4.0,horizontal: 0),
                      child: Container(
                        width: withScreen - 70,
                        child: FlatButton(
                          height: 60,
                          color: KbuttonColor,
                          onPressed: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => LogInScreen()));
                          },
                          child:Center(
                            child:Text("LOG IN",
                              style: TextStyle(
                                fontSize: 18,
                              color: KsecondaryColor,
                            ),),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:4.0,horizontal: 0),
                      child: Container(
                        width: withScreen - 70,
                        child: FlatButton(
                          height: 60,
                          color: KsecondaryColor,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: KbuttonColor,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(3)
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) =>SignUpScreen(),
                                ));
                          },
                          child:Center(
                            child:Text("SIGN UP",
                              style: TextStyle(
                                fontSize: 18,
                              color: KbuttonColor,
                            ),),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30,),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:4.0,horizontal: 0),
                      child: Container(
                        width: withScreen - 70,
                        child: FlatButton(
                          height: 60,
                          color: KprimaryColor,
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) =>HomeScreen(index: 0,categoryIdSending: "",)
                            ));
                          },
                          child:Center(
                            child:Text("ENTER AS A GUEST",style: TextStyle(
                              fontSize: 18,
                              color: KbuttonColor,
                            ),),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
    );
  }
}
