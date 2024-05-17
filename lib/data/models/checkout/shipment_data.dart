class ShipmentModel {
  int? shippingAddressID;
  String? userID;
  String? shippingAddress;
  String? name;
  String? phoneNumber;
  String? country;
  String? city;

  ShipmentModel({
    this.shippingAddressID,
    this.userID,
    this.shippingAddress,
    this.name,
    this.phoneNumber,
    this.country,
    this.city,
  });

  ShipmentModel.fromJson(Map<String, dynamic> json) {
    shippingAddressID = json['shippingAddressID'];
    userID = json['userID'];
    shippingAddress = json['shippingAddress'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    country = json['country'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shippingAddressID'] = shippingAddressID;
    data['userID'] = userID;
    data['shippingAddress'] = shippingAddress;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['country'] = country;
    data['city'] = city;
    return data;
  }
}
