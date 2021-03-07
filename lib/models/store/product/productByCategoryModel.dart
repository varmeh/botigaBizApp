import 'package:json_annotation/json_annotation.dart';
part 'productByCategoryModel.g.dart';

@JsonSerializable()
class ProductByCategory {
  String categoryId;
  String name;
  List<Product> products;

  ProductByCategory({this.categoryId, this.name, this.products});

  factory ProductByCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductByCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductByCategoryToJson(this);
}

@JsonSerializable()
class Product {
  String id;
  String name;
  double price;
  double mrp;
  bool available;
  String size;
  String description;
  String imageUrl;
  String imageUrlLarge;
  List<String> secondaryImageUrls;
  String tag;

  Product({
    this.id,
    this.name,
    this.price,
    this.mrp,
    this.available,
    this.size,
    this.description = '',
    this.imageUrl = '',
    this.imageUrlLarge = '',
    this.secondaryImageUrls,
    this.tag,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
