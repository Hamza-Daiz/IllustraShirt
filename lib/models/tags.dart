
class TagModel {
  String id;
  String name;

  TagModel({
    this.id,
    this.name,
  });

  TagModel.fromJson(Map<String,dynamic> json){
    id = json["id"];
    name = json["name"];
  }

  factory TagModel.fromJsonF(Map<String,dynamic> json){
    return TagModel(
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> json = new Map<String,dynamic>();
    json["id"] = this.id;
    json["name"] = this.name;
    return json;

  }

}