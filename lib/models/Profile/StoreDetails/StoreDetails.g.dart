// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storeDetails.dart';

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

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    area: json['area'] as String,
    pincode: json['pincode'] as String,
    city: json['city'] as String,
    building: json['building'] as String,
    state: json['state'] as String,
    street: json['street'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'area': instance.area,
      'pincode': instance.pincode,
      'city': instance.city,
      'building': instance.building,
      'state': instance.state,
      'street': instance.street,
    };
