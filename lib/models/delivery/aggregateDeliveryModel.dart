import 'package:json_annotation/json_annotation.dart';

part 'aggregateDeliveryModel.g.dart';

@JsonSerializable()
class AggregateDelivery {
  int count;
  Apartment apartment;

  AggregateDelivery({this.count, this.apartment});

  factory AggregateDelivery.fromJson(Map<String, dynamic> json) =>
      _$AggregateDeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$AggregateDeliveryToJson(this);
}

@JsonSerializable()
class Apartment {
  @JsonKey(name: '_id')
  String id;
  String apartmentName;
  String apartmentArea;
  String deliveryMessage;
  String deliverySlot;
  Apartment(
      {this.id,
      this.apartmentName,
      this.apartmentArea,
      this.deliveryMessage,
      this.deliverySlot});
  factory Apartment.fromJson(Map<String, dynamic> json) =>
      _$ApartmentFromJson(json);

  Map<String, dynamic> toJson() => _$ApartmentToJson(this);
}
