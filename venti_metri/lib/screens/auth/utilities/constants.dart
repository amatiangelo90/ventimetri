import 'package:flutter/material.dart';
import 'package:venti_metri/utils/utils.dart';

final kHintTextStyle = TextStyle(
  color: VENTI_METRI_BLUE,
  fontFamily: 'LoraFont',
);

final kLabelStyle = TextStyle(
  color: Colors.blueGrey.shade800,
  fontWeight: FontWeight.bold,
  fontFamily: 'LoraFont',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);