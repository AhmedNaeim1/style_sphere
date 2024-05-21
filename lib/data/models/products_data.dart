class ProductModel {
  String? productID;
  String? businessID;
  String? name;
  String? description;
  String? condition;
  String? material;
  List<String>? styleAndOccasion;
  String? category;
  double? price;
  List<String>? sizes;
  List<String>? quantities;
  List<String>? colors;
  List<String>? imageUrls;
  List<String>? type;
  DateTime? dateAdded;

  ProductModel({
    this.productID,
    this.businessID,
    this.name,
    this.description,
    this.condition,
    this.material,
    this.styleAndOccasion,
    this.category,
    this.price,
    this.sizes,
    this.quantities,
    this.colors,
    this.imageUrls,
    this.type,
    this.dateAdded,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    productID = json['productID'];
    businessID = json['businessID'];
    name = json['name'];
    description = json['description'];
    condition = json['condition'];
    material = json['material'];
    styleAndOccasion = List<String>.from(json['styleAndOccasion']);
    category = json['category'];
    price = json['price']?.toDouble();
    sizes = List<String>.from(json['sizes']);
    quantities = List<String>.from(json['quantities']);
    colors = List<String>.from(json['colors']);
    imageUrls = List<String>.from(json['imageUrls']);
    type = List<String>.from(json['type']);
    dateAdded = DateTime.tryParse(json['dateAdded'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productID'] = productID;
    data['businessID'] = businessID;
    data['name'] = name;
    data['description'] = description;
    data['condition'] = condition;
    data['material'] = material;
    data['styleAndOccasion'] = styleAndOccasion;
    data['category'] = category;
    data['price'] = price;
    data['sizes'] = sizes;
    data['quantities'] = quantities;
    data['colors'] = colors;
    data['imageUrls'] = imageUrls;
    data['type'] = type;
    data['dateAdded'] = dateAdded?.toIso8601String();
    return data;
  }
}
