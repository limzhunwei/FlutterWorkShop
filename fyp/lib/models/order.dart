class Order {
  String? order_id;
  String? receipt_id;
  String? order_date;
  String? total_qty;
  String? order_status;

  Order(
      {this.order_id,
      this.receipt_id,
      this.order_date,
      this.total_qty,
      this.order_status,
      });

  Order.fromJson(Map<String, dynamic> json) {
    order_id = json['order_id'];
    receipt_id = json['receipt_id'];
    order_date = json['order_date'];
    total_qty = json['total_qty'];
    order_status = json['order_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = order_id;
    data['receipt_id'] = receipt_id;
    data['order_date'] = order_date;
    data['total_qty'] = total_qty;
    return data;
  }
}