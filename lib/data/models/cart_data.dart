class CartModel {
  String? userID;
  String? productID;
  int? quantity;
  String? addedDate;
  double? price;

  CartModel({
    this.userID,
    this.productID,
    this.quantity,
    this.addedDate,
    this.price,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    productID = json['productID'];
    quantity = json['quantity'];
    addedDate = json['addedDate'];
    price = json['price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['productID'] = productID;
    data['quantity'] = quantity;
    data['addedDate'] = addedDate;
    data['price'] = price;
    return data;
  }
}
