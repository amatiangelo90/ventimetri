import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/screens/administration_page.dart';
import 'package:venti_metri/screens/auth/auth_screen.dart';
import 'package:venti_metri/screens/branch_choose.dart';
import 'package:venti_metri/screens/delivery/dash_menu/add_new_product.dart';
import 'package:venti_metri/screens/delivery/dash_menu/manage_menu_item_page.dart';
import 'package:venti_metri/screens/delivery/dash_menu/manage_wine_item.dart';
import 'package:venti_metri/screens/delivery/table_covers_screen.dart';
import 'package:venti_metri/screens/event/add_event_screen.dart';
import 'package:venti_metri/screens/customer_page_events.dart';
import 'package:venti_metri/screens/event/bar_champ_details_page.dart';
import 'package:venti_metri/screens/event/recap_event_screen.dart';
import 'package:venti_metri/screens/event/single_bar_champ_page_manager_screen.dart';
import 'package:venti_metri/screens/event/single_event_manager_screen.dart';
import 'package:venti_metri/screens/event/event_manager_screen.dart';
import 'package:venti_metri/screens/event/products_manager_page.dart';
import 'package:venti_metri/screens/home_screen.dart';
import 'package:venti_metri/screens/reservation/reservation.dart';
import 'package:venti_metri/screens/reservation/reservation_event.dart';
import 'package:venti_metri/screens/venti_m_q_dashboard.dart';
import 'package:venti_metri/screens/venti_m_q_splah.dart';

import 'component/chart_class.dart';
import 'screens/delivery/dash_menu/menu_administrator.dart';


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
          HomeScreen.id : (context) => HomeScreen(),
          VentiMetriQuadriDashboard.id : (context) => VentiMetriQuadriDashboard(),
          BranchChooseScreen.id : (context) => BranchChooseScreen(),
          ExpenceProfitDetails.id : (context) => ExpenceProfitDetails(),
          PartyScreenManager.id : (context) => PartyScreenManager(),
          AddEventScreen.id : (context) => AddEventScreen(),
          SingleEventManagerScreen.id : (context) => SingleEventManagerScreen(),
          ProductPageManager.id : (context) => ProductPageManager(),
          LoginAuthScreen.id : (context) => LoginAuthScreen(),
          SingleBarChampManagerScreen.id : (context) => SingleBarChampManagerScreen(),
          RecapEventPage.id  : (context) => RecapEventPage(),
          CustomerPartyScreen.id  : (context) => CustomerPartyScreen(),
          TableReservationScreen.id  : (context) => TableReservationScreen(),
          EventReservationScreen.id  : (context) => EventReservationScreen(),

          TableCoversScreen.id  : (context) => TableCoversScreen(),
          ManageMenuItemPage.id  : (context) => ManageMenuItemPage(),
          AddNewProductScreen.id  : (context) => AddNewProductScreen(),
          MenuAdministratorScreen.id  : (context) => MenuAdministratorScreen(),
          ManageMenuWinePage.id  : (context) => ManageMenuWinePage(),
          AdministrationScreen.id  : (context) => AdministrationScreen(),
          BarChampDetailsPage.id  : (context) => BarChampDetailsPage(),

        }
    );
  }
}

