class ProductModel {
  String? productID;
  String? businessID;
  String? name;
  String? description;
  String? condition;
  String? material;
  String? category;
  double? price;
  String? sizes;
  String? quantities;
  String? colors;
  String? type;
  DateTime? dateAdded;
  List<String>? imageUrls;

  ProductModel({
    this.productID,
    this.businessID,
    this.name,
    this.description,
    this.condition,
    this.material,
    this.category,
    this.price,
    this.sizes,
    this.quantities,
    this.colors,
    this.type,
    this.dateAdded,
    this.imageUrls,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    productID = json['productID'];
    businessID = json['businessID'];
    name = json['name'];
    description = json['description'];
    condition = json['condition'];
    material = json['material'];
    category = json['category'];
    price = json['price']?.toDouble();
    sizes = json['sizes'] ?? [];
    quantities = json['quantities'] ?? [];
    colors = json['colors'];
    type = json['type'];
    dateAdded = DateTime.tryParse(json['dateAdded'] ?? '');
    imageUrls = List<String>.from(json['imageUrls'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productID'] = productID;
    data['businessID'] = businessID;
    data['name'] = name;
    data['description'] = description;
    data['condition'] = condition;
    data['material'] = material;
    data['category'] = category;
    data['price'] = price;
    data['sizes'] = sizes;
    data['quantities'] = quantities;
    data['colors'] = colors;
    data['type'] = type;
    data['dateAdded'] = dateAdded?.toIso8601String();
    data['imageUrls'] = imageUrls;
    return data;
  }
}
