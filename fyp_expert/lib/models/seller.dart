class Seller{
  String? seller_id;
  String? seller_name;
  String? seller_phone;
  String? seller_address;
  String? seller_email;
  String? register_date;
  String? seller_status;

  Seller(
    {this.seller_id, 
    this.seller_name, 
    this.seller_phone, 
    this.seller_address, 
    this.seller_email, 
    this.register_date, 
    this.seller_status});

  Seller.fromJson(Map<String, dynamic> json){
    seller_id = json["seller_id"];
    seller_name = json["seller_name"];
    seller_phone = json["seller_phone"];
    seller_address = json["seller_address"];
    seller_email = json["seller_email"];
    register_date = json["register_date"];
    seller_status = json["seller_status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seller_id'] = seller_id;
    data['seller_name'] = seller_name;
    data['seller_phone'] = seller_phone;
    data['seller_address'] = seller_address;
    data['seller_email'] = seller_email;
    data['register_date'] = register_date;
    data['seller_status'] = seller_status;
    return data;
  }
}