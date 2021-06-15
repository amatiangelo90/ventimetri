import 'package:flutter/material.dart';
import 'package:venti_metri/utils/utils.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton(
      {@required this.icon, @required this.function, this.color});

  final IconData icon;
  final Function function;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      child: Icon(icon, color: Colors.white,),
      onPressed: function,
      constraints: BoxConstraints.tightFor(width: 40.0, height: 40.0),
      shape: CircleBorder(),
      fillColor: color,
    );
  }
}