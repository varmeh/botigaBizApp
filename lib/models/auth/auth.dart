import 'package:json_annotation/json_annotation.dart';
part 'auth.g.dart';

@JsonSerializable()
class Auth {
  String firstName;
  String lastName;
  String brandName;
  String phone;
  String whatsapp;

  Auth(
      {this.firstName,
      this.lastName,
      this.brandName,
      this.phone,
      this.whatsapp});

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  Map<String, dynamic> toJson() => _$AuthToJson(this);
}
