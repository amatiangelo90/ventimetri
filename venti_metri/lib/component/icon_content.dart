import 'package:flutter/material.dart';

class IconContent extends StatelessWidget {

  IconContent({@required this.label, @required this.icon, this.color, this.description});

  final String label;
  final IconData icon;
  final Color color;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
          color: color,
        ),
        SizedBox(width: 30.0,),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            label,
            style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              description,
              style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),
            ),
          ),
        )
      ],
    );
  }
}
