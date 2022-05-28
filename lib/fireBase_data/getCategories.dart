import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:illustrashirt/models/category.dart';

class CategoryService  {

  FirebaseFirestore _instance;

  List<Category> _categories = [];

  List<Category> getCategories (){

    return _categories;
  }

  Future<void> getCategoriesFromFireseStore() async {

    _instance = FirebaseFirestore.instance;

    CollectionReference categories = _instance.collection("Categories");

    DocumentSnapshot snapshot = await categories.doc().get() ;

    var data = snapshot.data() ;

    var categoriesData = data as List<dynamic> ;


    categoriesData.forEach((element) {

      Category cat = Category.fromJsonF(element);
      _categories.add(cat);


    });



  }


}