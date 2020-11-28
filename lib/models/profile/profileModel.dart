import 'package:json_annotation/json_annotation.dart';
part 'profileModel.g.dart';

@JsonSerializable()
class Profile {
  String firstName;
  String lastName;
  String businessName;
  String businessCategory;
  Brand brand;
  Contact contact;
  List<Apartment> apartments;

  Profile(
      {this.firstName,
      this.lastName,
      this.businessName,
      this.businessCategory,
      this.brand,
      this.contact,
      this.apartments});

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable()
class Brand {
  String name;
  String tagline;
  String imageUrl;

  Brand({this.name, this.tagline, this.imageUrl});

  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

  Map<String, dynamic> toJson() => _$BrandToJson(this);
}

@JsonSerializable()
class Contact {
  String email;
  String whatsapp;
  String phone;
  Address address;

  Contact({this.email, this.whatsapp, this.phone, this.address});

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
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

@JsonSerializable()
class Apartment {
  String apartmentName;
  String apartmentArea;
  @JsonKey(name: '_id')
  String id;
  bool live;
  String deliveryMessage;
  AprtmentContact contact;

  Apartment(
      {this.apartmentName,
      this.apartmentArea,
      this.id,
      this.live,
      this.deliveryMessage,
      this.contact});

  factory Apartment.fromJson(Map<String, dynamic> json) =>
      _$ApartmentFromJson(json);

  Map<String, dynamic> toJson() => _$ApartmentToJson(this);
}

@JsonSerializable()
class AprtmentContact {
  String email;
  String whatsapp;
  String phone;

  AprtmentContact({this.email, this.whatsapp, this.phone});

  factory AprtmentContact.fromJson(Map<String, dynamic> json) =>
      _$AprtmentContactFromJson(json);

  Map<String, dynamic> toJson() => _$AprtmentContactToJson(this);
}
