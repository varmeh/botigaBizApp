import 'package:json_annotation/json_annotation.dart';

part 'storeCategoryModel.g.dart';

@JsonSerializable()
class StoreCategory {
  String id;
  String name;
  bool visible;

  StoreCategory({this.id, this.name, this.visible});

  factory StoreCategory.fromJson(Map<String, dynamic> json) =>
      _$StoreCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoreCategoryToJson(this);
}
