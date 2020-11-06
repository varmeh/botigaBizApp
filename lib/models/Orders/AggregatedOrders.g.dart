// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aggregatedOrders.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AggregatedOrders _$AggregatedOrdersFromJson(Map<String, dynamic> json) {
  return AggregatedOrders(
    totalRevenue: json['totalRevenue'] as int,
    totalOrders: json['totalOrders'] as int,
    apartmentWiseBreakup: (json['apartmentWiseBreakup'] as List)
        ?.map((e) => e == null
            ? null
            : AppartmentBreakUp.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AggregatedOrdersToJson(AggregatedOrders instance) =>
    <String, dynamic>{
      'totalRevenue': instance.totalRevenue,
      'totalOrders': instance.totalOrders,
      'apartmentWiseBreakup': instance.apartmentWiseBreakup,
    };

AppartmentBreakUp _$AppartmentBreakUpFromJson(Map<String, dynamic> json) {
  return AppartmentBreakUp(
    id: json['id'] as String,
    apartmentName: json['apartmentName'] as String,
    orders: json['orders'] as int,
    revenue: json['revenue'] as int,
  );
}

Map<String, dynamic> _$AppartmentBreakUpToJson(AppartmentBreakUp instance) =>
    <String, dynamic>{
      'id': instance.id,
      'apartmentName': instance.apartmentName,
      'orders': instance.orders,
      'revenue': instance.revenue,
    };
