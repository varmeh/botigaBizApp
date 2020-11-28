// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storeDetailsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreDetails _$StoreDetailsFromJson(Map<String, dynamic> json) {
  return StoreDetails(
    email: json['email'] as String,
    whatsapp: json['whatsapp'] as String,
    phone: json['phone'] as String,
  );
}

Map<String, dynamic> _$StoreDetailsToJson(StoreDetails instance) =>
    <String, dynamic>{
      'email': instance.email,
      'whatsapp': instance.whatsapp,
      'phone': instance.phone,
    };
