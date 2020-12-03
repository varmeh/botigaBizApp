import 'package:json_annotation/json_annotation.dart';

part 'storeCategoryModel.g.dart';

@JsonSerializable()
class StoreCategory {
  String id;
  String name;

  StoreCategory({this.id, this.name});

  factory StoreCategory.fromJson(Map<String, dynamic> json) =>
      _$StoreCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoreCategoryToJson(this);
}
