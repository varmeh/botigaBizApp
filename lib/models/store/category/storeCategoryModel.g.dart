// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storeCategoryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreCategory _$StoreCategoryFromJson(Map<String, dynamic> json) {
  return StoreCategory(
    id: json['id'] as String,
    name: json['name'] as String,
    visible: json['visible'] as bool,
  );
}

Map<String, dynamic> _$StoreCategoryToJson(StoreCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'visible': instance.visible,
    };
