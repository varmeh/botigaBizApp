// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    businessName: json['businessName'] as String,
    businessCategory: json['businessCategory'] as String,
    brand: json['brand'] == null
        ? null
        : Brand.fromJson(json['brand'] as Map<String, dynamic>),
    contact: json['contact'] == null
        ? null
        : Contact.fromJson(json['contact'] as Map<String, dynamic>),
    apartments: (json['apartments'] as List)
        ?.map((e) =>
            e == null ? null : Apartment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'businessName': instance.businessName,
      'businessCategory': instance.businessCategory,
      'brand': instance.brand,
      'contact': instance.contact,
      'apartments': instance.apartments,
    };

Brand _$BrandFromJson(Map<String, dynamic> json) {
  return Brand(
    name: json['name'] as String,
    tagline: json['tagline'] as String,
    imageUrl: json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'name': instance.name,
      'tagline': instance.tagline,
      'imageUrl': instance.imageUrl,
    };

Contact _$ContactFromJson(Map<String, dynamic> json) {
  return Contact(
    email: json['email'] as String,
    whatsapp: json['whatsapp'] as String,
    phone: json['phone'] as String,
    address: json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'email': instance.email,
      'whatsapp': instance.whatsapp,
      'phone': instance.phone,
      'address': instance.address,
    };

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    area: json['area'] as String,
    pincode: json['pincode'] as String,
    city: json['city'] as String,
    building: json['building'] as String,
    state: json['state'] as String,
    street: json['street'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'area': instance.area,
      'pincode': instance.pincode,
      'city': instance.city,
      'building': instance.building,
      'state': instance.state,
      'street': instance.street,
    };

Apartment _$ApartmentFromJson(Map<String, dynamic> json) {
  return Apartment(
    apartmentName: json['apartmentName'] as String,
    apartmentArea: json['apartmentArea'] as String,
    id: json['_id'] as String,
    live: json['live'] as bool,
    deliveryMessage: json['deliveryMessage'] as String,
    contact: json['contact'] == null
        ? null
        : AprtmentContact.fromJson(json['contact'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ApartmentToJson(Apartment instance) => <String, dynamic>{
      'apartmentName': instance.apartmentName,
      'apartmentArea': instance.apartmentArea,
      '_id': instance.id,
      'live': instance.live,
      'deliveryMessage': instance.deliveryMessage,
      'contact': instance.contact,
    };

AprtmentContact _$AprtmentContactFromJson(Map<String, dynamic> json) {
  return AprtmentContact(
    email: json['email'] as String,
    whatsapp: json['whatsapp'] as String,
    phone: json['phone'] as String,
  );
}

Map<String, dynamic> _$AprtmentContactToJson(AprtmentContact instance) =>
    <String, dynamic>{
      'email': instance.email,
      'whatsapp': instance.whatsapp,
      'phone': instance.phone,
    };
