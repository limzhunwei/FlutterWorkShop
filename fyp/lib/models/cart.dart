class Cart {
  String? cartid;
  String? prname;
  String? prqty;
  String? prprice;
  String? cartqty;
  String? prid;
  String? price_total;

  Cart(
      {this.cartid,
      this.prname,
      this.prqty,
      this.prprice,
      this.cartqty,
      this.prid,
      this.price_total});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    prname = json['prname'];
    prqty = json['prqty'];
    prprice = json['prprice'];
    cartqty = json['cartqty'];
    prid = json['prid'];
    price_total = json['price_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartid'] = cartid;
    data['prname'] = prname;
    data['prqty'] = prqty;
    data['prprice'] = prprice;
    data['cartqty'] = cartqty;
    data['prid'] = prid;
    data['price_total'] = price_total;
    return data;
  }
}