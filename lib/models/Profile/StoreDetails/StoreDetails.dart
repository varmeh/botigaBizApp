import 'package:json_annotation/json_annotation.dart';
part 'storeDetails.g.dart';

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

@JsonSerializable()
class Address {
  String area;
  String pincode;
  String city;
  String building;
  String state;
  String street;
  Address(
      {this.area,
      this.pincode,
      this.city,
      this.building,
      this.state,
      this.street});

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
