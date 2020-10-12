// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Apartments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Apartments _$ApartmentsFromJson(Map<String, dynamic> json) {
  return Apartments(
    apartments: (json['apartments'] as List)
        ?.map((e) =>
            e == null ? null : Apartment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ApartmentsToJson(Apartments instance) =>
    <String, dynamic>{
      'apartments': instance.apartments,
    };

Apartment _$ApartmentFromJson(Map<String, dynamic> json) {
  return Apartment(
    apartmentName: json['apartmentName'] as String,
    apartmentArea: json['apartmentArea'] as String,
    id: json['_id'] as String,
    live: json['live'] as bool,
  );
}

Map<String, dynamic> _$ApartmentToJson(Apartment instance) => <String, dynamic>{
      'apartmentName': instance.apartmentName,
      'apartmentArea': instance.apartmentArea,
      '_id': instance.id,
      'live': instance.live,
    };
