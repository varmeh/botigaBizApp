import 'package:json_annotation/json_annotation.dart';
part 'orderByDateDetail.g.dart';

@JsonSerializable()
class OrderByDateDetail {
  String id;
  Order order;
  Buyer buyer;
  PaymentModel payment;
  RefundModel refund;

  OrderByDateDetail({
    this.id,
    this.order,
  });

  factory OrderByDateDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderByDateDetailFromJson(json);

  Map<String, dynamic> toJson() => _$OrderByDateDetailToJson(this);
}

@JsonSerializable()
class Order {
  DateTime expectedDeliveryDate;
  String number;
  DateTime orderDate;
  String status;
  int totalAmount;
  List<Product> products;

  Order(
      {this.expectedDeliveryDate,
      this.number,
      this.orderDate,
      this.products,
      this.status,
      this.totalAmount});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class Product {
  String name;
  int price;
  int quantity;
  String unitInfo;

  Product({this.name, this.price, this.quantity, this.unitInfo});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class Buyer {
  String email;
  String house;
  String id;
  String name;
  String phone;
  String whatsapp;

  Buyer(
      {this.email, this.house, this.id, this.name, this.phone, this.whatsapp});

  factory Buyer.fromJson(Map<String, dynamic> json) => _$BuyerFromJson(json);

  Map<String, dynamic> toJson() => _$BuyerToJson(this);
}

@JsonSerializable()
class PaymentModel {
  @JsonKey(name: 'paymentId')
  final String id;
  final String status;
  final String txnId;
  final DateTime txnDate;
  final String paymentMode;

  PaymentModel({
    this.id,
    this.status,
    this.txnId,
    this.txnDate,
    this.paymentMode,
  });

  bool get isInitiated => status == 'initiated';
  bool get isPending => status == 'pending';
  bool get isSuccess => status == 'success';
  bool get isFailure => status == 'failure';

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}

@JsonSerializable()
class RefundModel {
  final String id;
  final String amount;
  final String status;
  final DateTime date;

  RefundModel({
    this.id,
    this.amount,
    this.status,
    this.date,
  });

  bool get isInitiated => status == 'initiated';
  bool get isPending => status == 'pending';
  bool get isSuccess => status == 'success';
  bool get isFailure => status == 'failure';

  factory RefundModel.fromJson(Map<String, dynamic> json) =>
      _$RefundModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefundModelToJson(this);
}
