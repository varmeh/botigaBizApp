import 'package:json_annotation/json_annotation.dart';
part 'productByCategory.g.dart';

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
  int price;
  bool available;
  String size;
  String description;
  String imageUrl;

  Product(
      {this.id,
      this.name,
      this.price,
      this.available,
      this.size,
      this.description = '',
      this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
