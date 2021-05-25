import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/screens/branch_choose.dart';
import 'package:venti_metri/screens/venti_m_q_dashboard.dart';
import 'package:venti_metri/screens/venti_m_q_splah.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '20m2',
        initialRoute: VentiMetriQuadriSplash.id,
        routes:{
          VentiMetriQuadriSplash.id : (context) => VentiMetriQuadriSplash(),
          VentiMetriQuadriDashboard.id : (context) => VentiMetriQuadriDashboard(),
          BranchChooseScreen.id : (context) => BranchChooseScreen(),
        }
    );

  }
}
