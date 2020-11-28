// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productByCategoryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductByCategory _$ProductByCategoryFromJson(Map<String, dynamic> json) {
  return ProductByCategory(
    categoryId: json['categoryId'] as String,
    name: json['name'] as String,
    products: (json['products'] as List)
        ?.map((e) =>
            e == null ? null : Product.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProductByCategoryToJson(ProductByCategory instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'name': instance.name,
      'products': instance.products,
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] as String,
    name: json['name'] as String,
    price: json['price'] as int,
    available: json['available'] as bool,
    size: json['size'] as String,
    description: json['description'] as String,
    imageUrl: json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'available': instance.available,
      'size': instance.size,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
    };
