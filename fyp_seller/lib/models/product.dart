class Product{
  String? prid;
  String? pridowner;
  String? prname;
  String? prdesc;
  String? prprice;
  String? prqty;

  Product(
    {
      required this.prid,
      required this.pridowner,
      required this.prname,
      required this.prdesc,
      required this.prprice,
      required this.prqty
    }
  );

  Product.fromJson(Map<String, dynamic> json){
    prid = json["prid"];
    pridowner = json["pridowner"];
    prname = json["prname"];
    prdesc = json["prdesc"];
    prprice = json["prprice"];
    prqty = json["prqty"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["prid"] = prid;
    data["pridowner"] = pridowner;
    data["prname"] = prname;
    data["prdesc"] = prdesc;
    data["prprice"] = prprice;
    data["prqty"] = prqty;
    return data;
  }
}