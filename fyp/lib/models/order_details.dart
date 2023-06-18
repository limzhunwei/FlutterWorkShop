class OrderDetails {
  String? receipt_id;
  String? prid;
  String? prname;
  String? cartqty;
  String? prprice;
  String? order_date;
  String? order_status;
  String? total_qty;
  String? price_total;
  String? total;


  OrderDetails(
      {
      this.receipt_id,
      this.prid,
      this.prname,
      this.cartqty,
      this.prprice,
      this.order_date,
      this.order_status,
      this.total_qty,
      this.price_total,
      this.total
      });

  OrderDetails.fromJson(Map<String, dynamic> json) {
    receipt_id = json['receipt_id'];
    prid = json['prid'];
    prname = json['prname'];
    cartqty = json['cartqty'];
    prprice = json['prprice'];
    order_date = json['order_date'];
    order_status = json['order_status'];
    total_qty = json['total_qty'];
    price_total = json['price_total'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['receipt_id'] = receipt_id;
    data['prid'] = prid;
    data['prname'] = prname;
    data['cartqty'] = cartqty;
    data['prprice'] = prprice;
    data['order_date'] = order_date;
    data['order_status'] = order_status;
    data['total_qty'] = total_qty;
    data['price_total'] = price_total;
    data['total'] = total;
    return data;
  }
}