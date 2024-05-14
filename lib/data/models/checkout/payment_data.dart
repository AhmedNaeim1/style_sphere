class PaymentData {
  PaymentData({
    this.paymentMethodID,
    this.userID,
    this.cardNumber,
    this.name,
    this.expirationDate,
  });

  int? paymentMethodID;
  String? userID;
  String? cardNumber;
  String? name;
  String? expirationDate;

  PaymentData.fromJson(dynamic json) {
    paymentMethodID = json['paymentMethodID'];
    userID = json['userID'];
    cardNumber = json['cardNumber'];
    expirationDate = json['expirationDate'];
    // billingAddress = json['billingAddress'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['paymentMethodID'] = paymentMethodID;
    map['name'] = name;
    map['userID'] = userID;
    map['cardNumber'] = cardNumber;
    map['expirationDate'] = expirationDate;
    // map['billingAddress'] = billingAddress;
    return map;
  }
}
