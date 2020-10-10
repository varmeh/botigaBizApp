// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderByDateDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderByDateDetail _$OrderByDateDetailFromJson(Map<String, dynamic> json) {
  return OrderByDateDetail(
    id: json['id'] as String,
    order: json['order'] == null
        ? null
        : Order.fromJson(json['order'] as Map<String, dynamic>),
  )..buyer = json['buyer'] == null
      ? null
      : Buyer.fromJson(json['buyer'] as Map<String, dynamic>);
}

Map<String, dynamic> _$OrderByDateDetailToJson(OrderByDateDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'buyer': instance.buyer,
    };

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    expectedDeliveryDate: json['expectedDeliveryDate'] == null
        ? null
        : DateTime.parse(json['expectedDeliveryDate'] as String),
    number: json['number'] as String,
    orderDate: json['orderDate'] == null
        ? null
        : DateTime.parse(json['orderDate'] as String),
    products: (json['products'] as List)
        ?.map((e) =>
            e == null ? null : Product.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    status: json['status'] as String,
    totalAmount: json['totalAmount'] as int,
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'expectedDeliveryDate': instance.expectedDeliveryDate?.toIso8601String(),
      'number': instance.number,
      'orderDate': instance.orderDate?.toIso8601String(),
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'products': instance.products,
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    name: json['name'] as String,
    price: json['price'] as int,
    quantity: json['quantity'] as int,
    unitInfo: json['unitInfo'] as String,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'unitInfo': instance.unitInfo,
    };

Buyer _$BuyerFromJson(Map<String, dynamic> json) {
  return Buyer(
    email: json['email'] as String,
    house: json['house'] as String,
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    whatsapp: json['whatsapp'] as String,
  );
}

Map<String, dynamic> _$BuyerToJson(Buyer instance) => <String, dynamic>{
      'email': instance.email,
      'house': instance.house,
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
    };
