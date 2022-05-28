import 'package:flutter/material.dart';
import 'package:illustrashirt/constants.dart';
import 'package:illustrashirt/db/bag_database.dart';
import 'package:illustrashirt/models/category.dart';
import 'package:illustrashirt/models/product_basketModel.dart';
import 'package:illustrashirt/models/product_model.dart';
import 'package:illustrashirt/myWidgets/widgets_home_categories.dart';
import 'package:illustrashirt/provider/products_provider.dart';
import 'package:illustrashirt/screens/ProductScreen.dart';
import 'package:illustrashirt/screens/ProductsFiltred.dart';
import 'package:illustrashirt/screens/chekOutScreen.dart';
import 'package:illustrashirt/service/api_service.dart';
import 'package:provider/provider.dart';
import 'HomeScreen.dart';


class FiltersScreen extends StatefulWidget {

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {

  List<Product> _productsFiltred;
  Future<List<Product>> _productsadded;


  String gender = "Both";
  String type = "all";

  String _myCategory = "ANIME";
  String _typeId;

  List<String> CategoriesIcons = [
    'assets/filter/all_icon.png',
    'assets/filter/tshirt_icon.png',
    'assets/filter/hoodie_icon.png',
    'assets/filter/mug_icon.png',
    'assets/filter/poster_icon.png',
    'assets/filter/sweat_icon.png',
  ];
  List<String> nameType = [
    'all',
    'tshirt',
    'hoodie',
    'mug',
    'poster',
    'sweat',
  ];

  List<BasketModel> bags;

  bool isloading = false;

  APIService apiService;

  List<Category> allCategoriesfromApi;

  @override
   void initState()  {

    refreshBag();

    apiService = new APIService();
    allCategoriesfromApi = new List<Category>();

    super.initState();
  }

  Future refreshBag() async{
    setState(() {isloading = true;});

    this.bags = await BagDatabase.instance.readAll() ;

    setState(() {isloading = true;});
  }

  // -------------------- List of CheckBox Categories --------------------

  Map<String,bool> CheckBoxListValues ={};

  var Categories = [
    "ANIME",
    "FITNESS",
    "GAME",
    "QUOTES",
    "SERIE",
    "VALENTINE",
    "OTHER",
  ];

  Map<String,String> CatIds={};

 /* List<Widget> _checkBoxList(){
    return Categories.map((e) => Row(
      children: [
        Checkbox(
          activeColor: KprimaryColor,
            value: CheckBoxListValues[e] ?? false,
            onChanged: (newVal){
              setState(() {
                if(CheckBoxListValues[e]==null){
                  CheckBoxListValues[e] = true;
                }else{

                }

                CheckBoxListValues[e] = !CheckBoxListValues[e];
              });

            }),
        Text(e),
      ],
    ),
    ).toList();
  }*/

  // -------------------- List of CheckBox Tags --------------------

  Map<String,bool> CheckBoxListValuesTags ={};


  var Tags = [
    "DEVELOPERS",
    "GAMER",
    "KUROKO",
    "LOGO",
    "ONE PIECE",
    "POPULARITEMS",
    "PUBG",
  ];

  Map<String,String> tagIds={};

  List<Widget> _checkBoxListTags(){
    return Tags.map((e) => Row(
      children: [
        Checkbox(
            activeColor: KprimaryColor,
            value: CheckBoxListValuesTags[e] ?? false,
            onChanged: (newVal){
              setState(() {
                if(CheckBoxListValuesTags[e]==null){
                  CheckBoxListValuesTags[e] = true;
                }else{

                }

                CheckBoxListValuesTags[e] = !CheckBoxListValuesTags[e];
              });

            }),
        Text(e),
      ],
    ),
    ).toList();
  }


  @override
  Widget build(BuildContext context)  {

    List<Function> onTapCategories = [
          (){
        setState(() {
          type = "all";
          _typeId = null;
        });
      },
          (){
        setState(() {
          type = "tshirt";
          _typeId = "49";
        });
      },
          (){
        setState(() {
          type = "hoodie";
          _typeId = "51";
        });
      },
          (){
        setState(() {
          type = "mug";
          _typeId = "52";
        });
      },
          (){
        setState(() {
          type = "poster";
          _typeId = "53";
        });
      },
          (){
        setState(() {
          type = "sweat";
          _typeId = "50";
        });
      },
    ];


    final widthScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    double width30 = widthScreen - 30;

    return Scaffold(
      backgroundColor: KbackgroundColor,

      appBar: AppBar(

        centerTitle: true,

        iconTheme: IconThemeData(
          color: Colors.black,
        ),

        elevation: 0,
        backgroundColor: KbackgroundColor,
        title: Text(
          "Filters",
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
      
      body: SingleChildScrollView(
        child: Container(
          width: widthScreen,
          margin: EdgeInsets.symmetric(horizontal:15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Design for :",style: TextStyle(
                color: KprimaryColor,
                fontSize: 20,
                fontFamily: "Quincy",
                fontWeight: FontWeight.w700
              ),),

              SizedBox(height: 10,),

              Container(
                width: widthScreen - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            gender = "Both";
                          });
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          color: gender == "Both" ? KsecondaryColor: KbackgroundColor,
                          child: Text(
                            "Both",
                              style: TextStyle(
                                color: gender == "Both" ? KbackgroundColor: KsecondaryColor,
                              ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            gender = "Male";
                          });
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          color: gender == "Male" ? KsecondaryColor: KbackgroundColor,
                          child: Text(
                            "Male",
                            style: TextStyle(
                              color: gender == "Male" ? KbackgroundColor: KsecondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            gender = "Female";
                          });
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          color: gender == "Female" ? KsecondaryColor: KbackgroundColor,
                          child: Text(
                            "Female",
                            style: TextStyle(
                              color: gender == "Female" ? KbackgroundColor: KsecondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10,),

              Text("Product Type :",style: TextStyle(
                  color: KprimaryColor,
                  fontSize: 20,
                  fontFamily: "Quincy",
                  fontWeight: FontWeight.w700
              ),),

              SizedBox(height: 10,),

              Container(
                width: widthScreen -30,
                height: 230,
                child: Center(
                   child: GridView.builder(
                       itemCount: 6,
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 3,
                       mainAxisSpacing: 10,
                       crossAxisSpacing: 10),
                       itemBuilder: (BuildContext context, int index) {
                         var pathImage = CategoriesIcons[index];
                         return GestureDetector(
                           onTap: onTapCategories[index],
                           child: Container(
                                width: 80,
                                height: 80,
                                padding: EdgeInsets.all(20),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: type ==nameType[index]? KprimaryColor: KsecondaryColor ,
                                  borderRadius: BorderRadius.circular(5),

                                ),
                               
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(pathImage),
                                ),
                      ),
                    );

                  }),
            ),

          ),

              Container(
                width: widthScreen-30,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Filters of Categories :
                        Column(
                          children: [
                            Text("Categories :",style: TextStyle(
                                color: KprimaryColor,
                                fontSize: 20,
                                fontFamily: "Quincy",
                                fontWeight: FontWeight.w700
                                ),
                            ),
                            SizedBox(height: 10,),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: apiService.getCategoris(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(

                                        child: Container(
                                          width: widthScreen/2 -40,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              physics: ClampingScrollPhysics(),
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {

                                                Categories.add(snapshot.data[index].categoryName.toString());

                                                CatIds[snapshot.data[index].categoryName.toString()] = snapshot.data[index].categoryId.toString();

                                                return Row(
                                                  children: [
                                                    Checkbox(
                                                        activeColor: KprimaryColor,
                                                        value: CheckBoxListValues[snapshot.data[index].categoryName] ?? false,

                                                        onChanged: (newVal){
                                                          setState(() {

                                                            if(CheckBoxListValues[snapshot.data[index].categoryName]==null){

                                                              CheckBoxListValues[snapshot.data[index].categoryName] = true;

                                                            }else{
                                                              CheckBoxListValues[snapshot.data[index].categoryName] = !CheckBoxListValues[snapshot.data[index].categoryName];
                                                            }



                                                            if( CheckBoxListValues[snapshot.data[index].categoryName] == true
                                                                &&
                                                                !allCategoriesfromApi.contains(snapshot.data[index])
                                                              )
                                                            {
                                                              allCategoriesfromApi.add(snapshot.data[index]);
                                                            }else
                                                              if(CheckBoxListValues[snapshot.data[index].categoryName]==false && allCategoriesfromApi.contains(snapshot.data[index])){
                                                                allCategoriesfromApi.remove(snapshot.data[index]);
                                                            }
                                                          });

                                                        }),
                                                    Text(snapshot.data[index].categoryName),
                                                  ],
                                                );
                                              }),
                                        ),
                                      );
                                    } else
                                      return Container(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 5,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              KprimaryColor),
                                        ),
                                      );
                                  },
                                ),
                              ],
                            ),

                          ],
                        ),

                        // Filters of Tags
                        Column(
                          children: [
                            Text("Tags :",style: TextStyle(
                                color: KprimaryColor,
                                fontSize: 20,
                                fontFamily: "Quincy",
                                fontWeight: FontWeight.w700
                              ),
                            ),
                            SizedBox(height: 10,),


                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: apiService.getTags(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {

                                      return Container(
                                              width: widthScreen/2 -40,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            physics: ClampingScrollPhysics(),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {

                                              tagIds[snapshot.data[index].name.toString()] = snapshot.data[index].id.toString();

                                              return Row(
                                                children: [
                                                  Checkbox(
                                                      activeColor: KprimaryColor,
                                                      value: CheckBoxListValuesTags[snapshot.data[index].name] ?? false,
                                                      onChanged: (newVal){
                                                        setState(() {
                                                          if(CheckBoxListValuesTags[snapshot.data[index].name]==null){
                                                            CheckBoxListValuesTags[snapshot.data[index].name] = true;
                                                          }else{

                                                          }

                                                          CheckBoxListValuesTags[snapshot.data[index].name] = !CheckBoxListValuesTags[snapshot.data[index].name];
                                                        });

                                                      }),
                                                  Text(snapshot.data[index].name),
                                                ],
                                              );
                                            }),
                                      );

                                    } else
                                      return Container(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 5,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              KprimaryColor),
                                        ),
                                      );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: KsecondaryColor,
        onPressed: () {

          int a = 0 ;
          var productList = Provider.of<ProductProvider>(context, listen: false,);

          productList.resetStreams();

          productList.setLoadingState(LoadMoreStatus.INITIAL);

          Categories.forEach((e) async{

                if(CheckBoxListValues[e]!=null) {
                  setState(() {
                    a=1;
                  });
                /*
                 bool boolTag = false;

                Tags.forEach((e) {
                    if(CheckBoxListValues[e]!=null){

                      productList.fetchProducts(1,categoryId: CatIds[e]);

                      setState(() {
                        boolTag = true;
                      });

                    }
                  });*/

                    productList.fetchProducts(1,categoryId: CatIds[e]);
                }
          });

          if (a==0){
            Tags.forEach((e) {
              if(CheckBoxListValues[e]!=null){
                setState(() {
                  a=1;
                });
                productList.fetchProducts(1,tagId: tagIds[e]);

              }
            });
          }
          if (a==0){
                productList.fetchProducts(1,tagId: _typeId);
          }

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context)=>ProductsFiltred(
                items: productList.allProducts,
              ),
            ),
          );
        },
        child: Icon(
          Icons.search,
          color: KprimaryColor,
        ),
      ),
    );
  }
}
