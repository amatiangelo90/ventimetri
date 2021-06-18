import 'dart:async';
import 'package:flutter/material.dart';
import 'package:venti_metri/component/chart_class.dart';
import 'package:venti_metri/screens/branch_choose.dart';

import 'auth/auth_screen.dart';

class VentiMetriQuadriSplash extends StatefulWidget {
  static String id = 'splash';
  @override
  _VentiMetriQuadriSplashState createState() => _VentiMetriQuadriSplashState();
}

class _VentiMetriQuadriSplashState extends State<VentiMetriQuadriSplash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blueGrey.shade500,
            Colors.blueGrey.shade600,
            Colors.blueGrey.shade700,
            Colors.blueGrey.shade800,
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),

      child: Image.asset('images/logo_home_nero.png',
        fit: BoxFit.scaleDown,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), ()=> Navigator.pushNamed(context, LoginAuthScreen.id));
  }
}