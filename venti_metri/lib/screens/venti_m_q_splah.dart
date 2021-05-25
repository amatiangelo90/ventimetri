import 'dart:async';
import 'package:flutter/material.dart';
import 'package:venti_metri/screens/branch_choose.dart';
import 'package:venti_metri/screens/venti_m_q_dashboard.dart';

class VentiMetriQuadriSplash extends StatefulWidget {
  static String id = 'splash';
  @override
  _VentiMetriQuadriSplashState createState() => _VentiMetriQuadriSplashState();
}

class _VentiMetriQuadriSplashState extends State<VentiMetriQuadriSplash> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Image.asset('images/logo_home_nero.png',
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), ()=> Navigator.pushNamed(context, BranchChooseScreen.id));
  }
}