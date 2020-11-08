import 'package:flutter/material.dart';

Color statusColor(String status) {
  if (status == 'open' || status == 'delayed') {
    return Color.fromRGBO(233, 161, 54, 1);
  } else if (status == 'out' || status == 'delivered') {
    return Color.fromRGBO(23, 159, 87, 1);
  } else {
    return Color.fromRGBO(233, 86, 54, 1);
  }
}

bool isOrderOpen(String status) {
  if (status == 'open' || status == 'delayed') {
    return true;
  }
  return false;
}

bool isOutForDelivery(String status) {
  if (status == 'out') {
    return true;
  }
  return false;
}

bool isOrderDelivered(String status) {
  if (status == 'delivered') {
    return true;
  }
  return false;
}
