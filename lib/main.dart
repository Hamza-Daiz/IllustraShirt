import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:illustrashirt/fireBase_data/getCategories.dart';
import 'package:illustrashirt/provider/cart_provider.dart';
import 'package:illustrashirt/provider/loader_provider.dart';
import 'package:illustrashirt/provider/orders_provider.dart';
import 'package:illustrashirt/provider/products_provider.dart';
import 'package:illustrashirt/screens/HomeScreen.dart';
import 'package:illustrashirt/screens/ProductDetails.dart';
import 'package:illustrashirt/screens/ProductScreen.dart';
import 'package:illustrashirt/screens/chekOutScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

//my imports :
import 'package:illustrashirt/screens/OnBoarding.dart';
import 'package:illustrashirt/screens/Enterance.dart';
import 'package:illustrashirt/constants.dart';
import 'package:illustrashirt/provider/Chekout_provider.dart';


int initScreen;

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences preferences = await SharedPreferences.getInstance();

  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen',1);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Firebase.initializeApp();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
          child: ProductScreen(),
        ),

        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),

        ChangeNotifierProvider(
          create: (context) => ChekOutProvider(),
        ),

        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: ProductDetails(),
        ),

        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: CheckOutScreen(),
        ),

        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: ProductDetails(),
        ),

        Provider(
          create: (context) => CategoryService(),
        ),

      ],
      child: MaterialApp(
        title: "IllustraShirt",
        theme: ThemeData(
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: 'homeScreen',
        routes: {
       //   'home' : (context)=> Home(),
          'onboard' : (context)=> OnBoarding(),
          'enterance' : (context)=> Enterance(),
          'homeScreen' : (context)=> HomeScreen(),
       },
      ),
    );
  }
}

