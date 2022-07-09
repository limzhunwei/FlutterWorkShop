class Cart {
  String? cartid;
  String? subject_name;
  String? subject_qty;
  String? subject_price;
  String? cartqty;
  String? subject_id;
  String? price_total;

  Cart(
      {this.cartid,
      this.subject_name,
      this.subject_qty,
      this.subject_price,
      this.cartqty,
      this.subject_id,
      this.price_total});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    subject_name = json['subject_name'];
    subject_qty = json['subject_qty'];
    subject_price = json['subject_price'];
    cartqty = json['cartqty'];
    subject_id = json['subject_id'];
    price_total = json['price_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartid'] = cartid;
    data['subject_name'] = subject_name;
    data['subject_qty'] = subject_qty;
    data['subject_price'] = subject_price;
    data['cartqty'] = cartqty;
    data['subject_id'] = subject_id;
    data['price_total'] = price_total;
    return data;
  }
}