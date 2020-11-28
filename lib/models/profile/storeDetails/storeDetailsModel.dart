import 'package:json_annotation/json_annotation.dart';
part 'storeDetailsModel.g.dart';

@JsonSerializable()
class StoreDetails {
  String email;
  String whatsapp;
  String phone;

  StoreDetails({this.email, this.whatsapp, this.phone});

  factory StoreDetails.fromJson(Map<String, dynamic> json) =>
      _$StoreDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$StoreDetailsToJson(this);
}
