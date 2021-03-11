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
    visible: json['visible'] as bool,
  );
}

Map<String, dynamic> _$ProductByCategoryToJson(ProductByCategory instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'name': instance.name,
      'visible': instance.visible,
      'products': instance.products,
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] as String,
    name: json['name'] as String,
    price: (json['price'] as num)?.toDouble(),
    mrp: (json['mrp'] as num)?.toDouble(),
    available: json['available'] as bool,
    size: json['size'] as String,
    description: json['description'] as String,
    imageUrl: json['imageUrl'] as String,
    imageUrlLarge: json['imageUrlLarge'] as String,
    secondaryImageUrls:
        (json['secondaryImageUrls'] as List)?.map((e) => e as String)?.toList(),
    tag: json['tag'] as String,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'mrp': instance.mrp,
      'available': instance.available,
      'size': instance.size,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'imageUrlLarge': instance.imageUrlLarge,
      'secondaryImageUrls': instance.secondaryImageUrls,
      'tag': instance.tag,
    };
