import 'package:json_annotation/json_annotation.dart';
part 'DeliveryByDateDetails.g.dart';

@JsonSerializable()
class DeliveryByDateDetails {
  String id;
  Order order;
  Buyer buyer;

  DeliveryByDateDetails({
    this.id,
    this.order,
  });

  factory DeliveryByDateDetails.fromJson(Map<String, dynamic> json) =>
      _$DeliveryByDateDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryByDateDetailsToJson(this);
}

@JsonSerializable()
class Order {
  String expectedDeliveryDate;
  String number;
  String orderDate;
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
