

class Category{

  int categoryId;
  String categoryName;
  String categoryDesc;
  String imageUrl;
  List<dynamic> tags;
  int parent;
  Imagee image;

  Category({
    this.categoryId,
    this.categoryName,
    this.categoryDesc,
    this.parent,
    this.image, this.imageUrl,this.tags
  });

  Category.fromJson(Map<String,dynamic> json){
    categoryId = json['id'];
    categoryName = json['name'];
    categoryDesc = json['description'];
    parent = json['parent'];
    image = json['image'] != null ? Imagee.fromJson(json['image']) : null;
  }
  factory Category.fromJsonF(Map<String,dynamic> json){
    return Category(
      categoryName: json['name'],
      imageUrl: json['ImageUrl'],
      tags: json['tags'],

    );
  }
}

  class Imagee {
    String url;
    Imagee({this.url});

    Imagee.fromJson(Map<String,dynamic> json){
      url = json['src'];
    }

  }



