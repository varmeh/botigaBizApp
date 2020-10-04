import 'package:json_annotation/json_annotation.dart';
part 'AggregatedOrders.g.dart';

@JsonSerializable()
class AggregatedOrders {
  int totalRevenue;
  int totalOrders;
  List<AppartmentBreakUp> apartmentWiseBreakup;

  AggregatedOrders(
      {this.totalRevenue, this.totalOrders, this.apartmentWiseBreakup});

  factory AggregatedOrders.fromJson(Map<String, dynamic> json) =>
      _$AggregatedOrdersFromJson(json);

  Map<String, dynamic> toJson() => _$AggregatedOrdersToJson(this);
}

@JsonSerializable()
class AppartmentBreakUp {
  String id;
  String apartmentName;
  int orders;
  int revenue;

  AppartmentBreakUp({this.id, this.apartmentName, this.orders, this.revenue});

  factory AppartmentBreakUp.fromJson(Map<String, dynamic> json) =>
      _$AppartmentBreakUpFromJson(json);

  Map<String, dynamic> toJson() => _$AppartmentBreakUpToJson(this);
}
