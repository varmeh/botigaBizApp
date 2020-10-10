import 'package:json_annotation/json_annotation.dart';
part 'OrderByDateDetail.g.dart';

@JsonSerializable()
class OrderByDateDetail {
  String id;
  Order order;
  Buyer buyer;

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
