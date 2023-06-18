class Product{
  String? seller_name;
  String? prid;
  String? pridowner;
  String? prname;
  String? prdesc;
  String? prprice;
  String? user_email;
  String? user_name;
  String? prqty;
  String? prstate;

  Product(
    {required this.seller_name,
      required this.prid,
      required this.prname,
      required this.pridowner,
      required this.prdesc,
      required this.prprice,
      required this.user_email,
      required this.user_name,
      required this.prqty,
      required this.prstate});

  Product.fromJson(Map<String, dynamic> json){
    seller_name = json["seller_name"];
    prid = json["prid"];
    prname = json["prname"];
    pridowner = json["pridowner"];
    prdesc = json["prdesc"];
    prprice = json["prprice"];
    prqty = json["prqty"];
    prstate = json["prstate"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seller_name'] = seller_name;
    data['prid'] = prid;
    data['prname'] = prname;
    data['pridowner'] = pridowner;
    data['prdesc'] = prdesc;
    data['prprice'] = prprice;
    data['prqty'] = prqty;
    data['prstate'] = prstate;
    return data;
  }

}