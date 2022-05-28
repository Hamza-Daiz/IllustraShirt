
class ShippingZone{

   int id;
    String name;

  ShippingZone({
    this.id,
    this.name,
  });

 ShippingZone.fromJson(Map<String,dynamic> json){
    id = json["id"];
    name = json["name"];
  }

}

class ShippingLines{

  String title;
  double total;

  ShippingLines(
      {
    this.title,
    this.total});

  ShippingLines.fromJson(Map<String,dynamic> json){
    title = json["title"]["value"];
    total=double.parse(json["cost"]["value"]);
  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> data = new Map<String,dynamic>();
    data["method_id"] = "flat_rate";
    data["method_title"] = title ;
    data["total"] = total.toString() ;

    return data;
  }


}