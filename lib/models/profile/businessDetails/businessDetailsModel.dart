import 'package:json_annotation/json_annotation.dart';

part 'businessDetailsModel.g.dart';

@JsonSerializable()
class BusinessDetails {
  String brandName;
  String tagline;
  String imageUrl;
  String businessCategory;

  BusinessDetails(
      {this.brandName, this.tagline, this.imageUrl, this.businessCategory});

  factory BusinessDetails.fromJson(Map<String, dynamic> json) =>
      _$BusinessDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessDetailsToJson(this);
}
