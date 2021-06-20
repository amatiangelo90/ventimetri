import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/screens/auth/auth_screen.dart';
import 'package:venti_metri/screens/branch_choose.dart';
import 'package:venti_metri/screens/event/add_event_screen.dart';
import 'package:venti_metri/screens/event/bar_position_manager_screen.dart';
import 'package:venti_metri/screens/event/single_bar_champ_page_manager_screen.dart';
import 'package:venti_metri/screens/event/single_event_manager_screen.dart';
import 'package:venti_metri/screens/event/event_manager_screen.dart';
import 'package:venti_metri/screens/event/products_manager_page.dart';
import 'package:venti_metri/screens/venti_m_q_dashboard.dart';
import 'package:venti_metri/screens/venti_m_q_splah.dart';

import 'component/chart_class.dart';


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
          ExpenceProfitDetails.id : (context) => ExpenceProfitDetails(),
          PartyScreenManager.id : (context) => PartyScreenManager(),
          AddEventScreen.id : (context) => AddEventScreen(),
          SingleEventManagerScreen.id : (context) => SingleEventManagerScreen(),
          ProductPageManager.id : (context) => ProductPageManager(),
          BarPositionClassManagerScreen.id : (context) => BarPositionClassManagerScreen(),
          LoginAuthScreen.id : (context) => LoginAuthScreen(),
          SingleBarChampManagerScreen.id : (context) => SingleBarChampManagerScreen(),
        }
    );
  }
}

