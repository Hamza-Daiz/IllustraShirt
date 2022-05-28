

class ProductModelFilter {

  int id;
  String name;
  int typeid;
  String price;

  ProductModelFilter({
    this.id,
    this.name,
    this.price,
    this.typeid,
  });

  ProductModelFilter.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    price = json['_price'];
    typeid = json['collection'];
  }

}
