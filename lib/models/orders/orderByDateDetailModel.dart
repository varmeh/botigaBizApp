import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'orderByDateDetailModel.g.dart';

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
  DateTime completionDate;
  String number;
  DateTime orderDate;
  String status;
  double totalAmount;
  List<Product> products;

  Order({
    this.expectedDeliveryDate,
    this.number,
    this.orderDate,
    this.products,
    this.status,
    this.totalAmount,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  bool get isOpen => status == 'open';
  bool get isDelayed => status == 'delayed';
  bool get isOutForDelivery => status == 'out';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';

  bool get isCompleted => isDelivered || isCancelled;

  String get statusMessage {
    if (isOpen) {
      return 'Order Placed';
    } else if (isOutForDelivery) {
      return 'Out For Delivery';
    } else if (isDelivered) {
      return 'Delivered';
    } else if (isDelayed) {
      return 'Delayed';
    } else if (isCancelled) {
      return 'Cancelled';
    } else {
      return status;
    }
  }

  Color get statusColor {
    if (isOpen || isDelayed) {
      return Color.fromRGBO(233, 161, 54, 1);
    } else if (isCancelled) {
      return Color.fromRGBO(233, 86, 54, 1);
    } else {
      return Color.fromRGBO(54, 185, 233, 1);
    }
  }
}

@JsonSerializable()
class Product {
  String name;
  double price;
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
  final String status;
  final String paymentId;
  final String paymentMode;

  PaymentModel({
    this.status,
    this.paymentId,
    this.paymentMode,
  });

  bool get isInitiated => status == 'initiated';
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
  bool get isSuccess => status == 'success';
  bool get isFailure => status == 'failure';

  bool get isRefund => status != null;

  bool get isRefundDue => status != null && !isSuccess;

  factory RefundModel.fromJson(Map<String, dynamic> json) =>
      _$RefundModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefundModelToJson(this);
}
