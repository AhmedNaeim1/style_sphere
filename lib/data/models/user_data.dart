class UserData {
  UserData({
    this.userID,
    this.userName,
    this.name,
    this.email,
    this.password,
    this.dateOfBirth,
    this.location,
    this.profilePictureUrl,
    this.registrationDate,
    this.followingCount,
    this.followersCount,
    this.businessID,
    this.languagePreference,
    this.currencyPreference,
    this.regionPreference,
    this.preferredStyles,
    this.preferredMaterials,
    this.preferredOccasions,
    this.token,
    this.isVerified,
  });

  UserData.fromJson(dynamic json) {
    userID = json['_id'] ?? json['id'];
    userName = json['userName'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    dateOfBirth = json['dateOfBirth'];
    location = json['location'];
    profilePictureUrl = json['profilePictureUrl'];
    registrationDate = json['registrationDate'];
    followingCount = json['followingCount'];
    followersCount = json['followersCount'];
    businessID = json['businessID'];
    languagePreference = json['languagePreference'];
    currencyPreference = json['currencyPreference'];
    regionPreference = json['regionPreference'];
    preferredStyles = json['preferredStyles'] ?? [];
    preferredMaterials = json['preferredMaterials'] ?? [];
    preferredOccasions = json['preferredOccasions'] ?? [];
    token = json['token'];
    isVerified = json['isVerified'];
  }

  String? userID;
  String? userName;
  String? name;
  String? email;
  String? password;
  String? dateOfBirth;
  String? location;
  String? profilePictureUrl;
  dynamic registrationDate;
  int? followingCount;
  int? followersCount;
  int? businessID;
  String? languagePreference;
  String? currencyPreference;
  String? regionPreference;
  List? preferredStyles;
  List? preferredMaterials;
  List? preferredOccasions;
  String? token;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = userID;
    map['userName'] = userName;
    map['name'] = name;
    map['email'] = email;
    map['password'] = password;
    map['dateOfBirth'] = dateOfBirth;
    map['location'] = location;
    map['profilePictureUrl'] = profilePictureUrl;
    map['registrationDate'] = registrationDate;
    map['followingCount'] = followingCount;
    map['followersCount'] = followersCount;
    map['businessID'] = businessID;
    map['languagePreference'] = languagePreference;
    map['currencyPreference'] = currencyPreference;
    map['regionPreference'] = regionPreference;
    map['preferredStyles'] = preferredStyles;
    map['preferredMaterials'] = preferredMaterials;
    map['preferredOccasions'] = preferredOccasions;
    map['token'] = token;
    map['isVerified'] = isVerified;
    return map;
  }
}
