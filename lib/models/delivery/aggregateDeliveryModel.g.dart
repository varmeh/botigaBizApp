// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aggregateDeliveryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AggregateDelivery _$AggregateDeliveryFromJson(Map<String, dynamic> json) {
  return AggregateDelivery(
    count: json['count'] as int,
    apartment: json['apartment'] == null
        ? null
        : Apartment.fromJson(json['apartment'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AggregateDeliveryToJson(AggregateDelivery instance) =>
    <String, dynamic>{
      'count': instance.count,
      'apartment': instance.apartment,
    };

Apartment _$ApartmentFromJson(Map<String, dynamic> json) {
  return Apartment(
    id: json['_id'] as String,
    apartmentName: json['apartmentName'] as String,
    apartmentArea: json['apartmentArea'] as String,
    deliveryMessage: json['deliveryMessage'] as String,
    deliverySlot: json['deliverySlot'] as String,
  );
}

Map<String, dynamic> _$ApartmentToJson(Apartment instance) => <String, dynamic>{
      '_id': instance.id,
      'apartmentName': instance.apartmentName,
      'apartmentArea': instance.apartmentArea,
      'deliveryMessage': instance.deliveryMessage,
      'deliverySlot': instance.deliverySlot,
    };
