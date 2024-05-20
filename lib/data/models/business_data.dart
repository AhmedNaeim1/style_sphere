class BusinessModel {
  String? businessID;
  String? userID;
  String? businessName;
  String? contactInfo;
  String? billingAddress;
  String? bio;
  String? businessCategory;
  DateTime? dateCreated;

  BusinessModel({
    this.businessID,
    this.userID,
    this.businessName,
    this.contactInfo,
    this.billingAddress,
    this.businessCategory,
    this.dateCreated,
    this.bio,
  });

  BusinessModel.fromJson(Map<String, dynamic> json) {
    businessID = json['businessID'];
    userID = json['userID'];
    businessName = json['businessName'];
    contactInfo = json['contactInfo'];
    billingAddress = json['billingAddress'];
    businessCategory = json['businessCategory'];
    bio = json['bio'];
    dateCreated = DateTime.tryParse(json['dateCreated'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['businessID'] = businessID;
    data['userID'] = userID;
    data['businessName'] = businessName;
    data['contactInfo'] = contactInfo;
    data['billingAddress'] = billingAddress;
    data['businessCategory'] = businessCategory;
    data['bio'] = bio;
    data['dateCreated'] = dateCreated?.toIso8601String();
    return data;
  }
}
