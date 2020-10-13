// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth _$AuthFromJson(Map<String, dynamic> json) {
  return Auth(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    brandName: json['brandName'] as String,
    phone: json['phone'] as String,
    whatsapp: json['whatsapp'] as String,
  );
}

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'brandName': instance.brandName,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
    };
