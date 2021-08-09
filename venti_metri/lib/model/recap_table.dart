
import 'package:flutter/material.dart';

import 'events_models/product_event.dart';

class RecapTableObject{

  final String barChampName;
  final String barChampPassword;
  final String barOwner;
  final List<Product> listProduct;
  final bool isBarPosition;
  final bool isChampPosition;

  RecapTableObject({
    @required this.barChampName,
    @required this.barChampPassword,
    @required this.barOwner,
    @required this.listProduct,
    @required this.isBarPosition,
    @required this.isChampPosition,});

  @override
  String toString() {
    return 'Name Bar: ' + this.barChampName + ' - Password: ' + this.barChampPassword;
  }
}