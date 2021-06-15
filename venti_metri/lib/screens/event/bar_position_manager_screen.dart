import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/model/events_models/bar_position_class.dart';
import 'package:venti_metri/utils/utils.dart';

class BarPositionClassManagerScreen extends StatefulWidget {
  static String id = 'bar_position_manager_screen';

  final BarPositionClass barPositionClass;

  BarPositionClassManagerScreen({@required this.barPositionClass});

  @override
  _BarPositionClassManagerScreenState createState() => _BarPositionClassManagerScreenState();
}

class _BarPositionClassManagerScreenState extends State<BarPositionClassManagerScreen> {
  BarPositionClass _barPositionClass;

  @override
  void initState() {
    super.initState();
    _barPositionClass = this.widget.barPositionClass;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: VENTI_METRI_BLUE,
              centerTitle: true,
              title: Text(_barPositionClass.name),
            ),
          ),
        )
    );
  }
}
