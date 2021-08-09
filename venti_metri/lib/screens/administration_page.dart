
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/screens/branch_choose.dart';
import 'package:venti_metri/screens/event/event_manager_screen.dart';
import 'package:venti_metri/screens/venti_m_q_dashboard.dart';
import 'auth/auth_screen.dart';
import 'delivery/dash_menu/menu_administrator.dart';

class AdministrationScreen extends StatefulWidget {
  static String id = 'administration';
  @override
  _AdministrationScreenState createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
  ScrollController scrollViewColtroller = ScrollController();
  User loggedInUser;

  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    getCurrentUser();
  }

  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser;
      if(user != null){
        loggedInUser = user;
        print('Email logged in : ' + loggedInUser.email);
      }
    }catch(e){
      print('Exception : ' + e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade800,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey.shade800,
          title: Center(child: Text('20m² - Administration Console', style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'LoraFont'),)),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.exit_to_app ,size: 30.0, color: Colors.white,), onPressed: (){
              if(_auth!=null){
                _auth.signOut();
              }
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 700),
                  backgroundColor: Colors.orangeAccent,
                  content: Text('Logging out...', style: TextStyle(fontFamily: 'LoraFont', color: Colors.white),)));
              Navigator.pushNamed(context, LoginAuthScreen.id);
            }
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blueGrey.shade800,
                Colors.blueGrey.shade800,
                Colors.blueGrey.shade900,
                Colors.blueGrey.shade900,
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, BranchChooseScreen.id),

                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/20m2.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.dst),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Branch', style: TextStyle(color: Colors.white, fontSize: 30),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(backgroundColor: Colors.green.shade500,
                            content: Text('Accesso al gestore menu..')));
                        Navigator.pushNamed(context, MenuAdministratorScreen.id);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/panino_20m2.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.dst),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Gestione Menu', style: TextStyle(color: Colors.white, fontSize: 30),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(backgroundColor: Colors.green.shade500,
                            content: Text('Accesso al calendario eventi in corso..')));
                        Navigator.pushNamed(context, PartyScreenManager.id);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/discoteche.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.dst),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Serate', style: TextStyle(color: Colors.white, fontSize: 30),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              loggedInUser != null ? Center(child: Text('Utente autenticato : ${loggedInUser.email}', style: TextStyle(color: Colors.white, fontFamily: 'LoraFont', fontSize: 9),)) : SizedBox(height: 0,),
              SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }
}
