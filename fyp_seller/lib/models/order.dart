class Order {
  String? order_id;
  String? receipt_id;
  String? order_date;
  String? total_qty;
  String? order_status;
  String? amount_paid;
  String? prid;
  String? cart_status;
  String? user_name;
  String? user_address;
  String? user_phone;

  Order(
      {this.order_id,
      this.receipt_id,
      this.order_date,
      this.total_qty,
      this.order_status,
      this.amount_paid,
      this.prid,
      this.cart_status,
      this.user_name,
      this.user_address,
      this.user_phone
      });

  Order.fromJson(Map<String, dynamic> json) {
    order_id = json['order_id'];
    receipt_id = json['receipt_id'];
    order_date = json['order_date'];
    total_qty = json['total_qty'];
    order_status = json['order_status'];
    amount_paid = json['amount_paid'];
    prid = json['prid'];
    cart_status = json['cart_status'];
    user_name = json['user_name'];
    user_address = json['user_address'];
    user_phone = json['user_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = order_id;
    data['receipt_id'] = receipt_id;
    data['order_date'] = order_date;
    data['total_qty'] = total_qty;
    data['amount_paid'] = amount_paid;
    data['prid'] = prid;
    data['cart_status'] = cart_status;
    data['user_name'] = user_name;
    data['user_address'] = user_address;
    data['user_phone'] = user_phone;
    return data;
  }
}