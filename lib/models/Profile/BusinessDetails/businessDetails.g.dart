// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'businessDetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessDetails _$BusinessDetailsFromJson(Map<String, dynamic> json) {
  return BusinessDetails(
    brandName: json['brandName'] as String,
    tagline: json['tagline'] as String,
    imageUrl: json['imageUrl'] as String,
    businessCategory: json['businessCategory'] as String,
  );
}

Map<String, dynamic> _$BusinessDetailsToJson(BusinessDetails instance) =>
    <String, dynamic>{
      'brandName': instance.brandName,
      'tagline': instance.tagline,
      'imageUrl': instance.imageUrl,
      'businessCategory': instance.businessCategory,
    };
