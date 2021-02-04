// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderByDateDetailModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderByDateDetail _$OrderByDateDetailFromJson(Map<String, dynamic> json) {
  return OrderByDateDetail(
    id: json['id'] as String,
    order: json['order'] == null
        ? null
        : Order.fromJson(json['order'] as Map<String, dynamic>),
  )
    ..buyer = json['buyer'] == null
        ? null
        : Buyer.fromJson(json['buyer'] as Map<String, dynamic>)
    ..payment = json['payment'] == null
        ? null
        : PaymentModel.fromJson(json['payment'] as Map<String, dynamic>)
    ..refund = json['refund'] == null
        ? null
        : RefundModel.fromJson(json['refund'] as Map<String, dynamic>);
}

Map<String, dynamic> _$OrderByDateDetailToJson(OrderByDateDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'buyer': instance.buyer,
      'payment': instance.payment,
      'refund': instance.refund,
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
    totalAmount: (json['totalAmount'] as num)?.toDouble(),
  )..completionDate = json['completionDate'] == null
      ? null
      : DateTime.parse(json['completionDate'] as String);
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'expectedDeliveryDate': instance.expectedDeliveryDate?.toIso8601String(),
      'completionDate': instance.completionDate?.toIso8601String(),
      'number': instance.number,
      'orderDate': instance.orderDate?.toIso8601String(),
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'products': instance.products,
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    name: json['name'] as String,
    price: (json['price'] as num)?.toDouble(),
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

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return PaymentModel(
    status: json['status'] as String,
    paymentId: json['paymentId'] as String,
    paymentMode: json['paymentMode'] as String,
  );
}

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'status': instance.status,
      'paymentMode': instance.paymentMode,
    };

RefundModel _$RefundModelFromJson(Map<String, dynamic> json) {
  return RefundModel(
    id: json['id'] as String,
    amount: json['amount'] as String,
    status: json['status'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$RefundModelToJson(RefundModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'status': instance.status,
      'date': instance.date?.toIso8601String(),
    };
