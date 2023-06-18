class Expert{
  String? id;
  String? name;
  String? phone;
  String? address;
  String? email;

  Expert(
    {this.id, 
    this.name, 
    this.phone, 
    this.address, 
    this.email
    }
  );

  Expert.fromJson(Map<String, dynamic> json){
    id = json["id"];
    name = json["name"];
    phone = json["phone"];
    address = json["address"];
    email = json["email"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['email'] = email;
    return data;
  }
}