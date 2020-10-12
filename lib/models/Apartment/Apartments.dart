import 'package:json_annotation/json_annotation.dart';
part 'Apartments.g.dart';

@JsonSerializable()
class Apartments {
  List<Apartment> apartments;

  Apartments({this.apartments});

  factory Apartments.fromJson(Map<String, dynamic> json) =>
      _$ApartmentsFromJson(json);

  Map<String, dynamic> toJson() => _$ApartmentsToJson(this);
}

@JsonSerializable()
class Apartment {
  String apartmentName;
  String apartmentArea;
  @JsonKey(name: '_id')
  String id;
  bool live;

  Apartment({this.apartmentName, this.apartmentArea, this.id, this.live});

  factory Apartment.fromJson(Map<String, dynamic> json) =>
      _$ApartmentFromJson(json);

  Map<String, dynamic> toJson() => _$ApartmentToJson(this);
}
