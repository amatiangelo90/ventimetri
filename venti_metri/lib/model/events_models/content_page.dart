import 'package:flutter/material.dart';

class Content extends StatefulWidget {

  final Widget child;

  Content({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> with AutomaticKeepAliveClientMixin<Content>  {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
            fit: FlexFit.loose,
            child: widget.child
        ),
      ],
    );
  }
}