import 'dart:async';

import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/screens/event/event_manager_screen.dart';
import 'package:venti_metri/screens/venti_m_q_dashboard.dart';
import 'package:venti_metri/utils/utils.dart';

import 'administration_page.dart';
import 'auth/auth_screen.dart';

class BranchChooseScreen extends StatefulWidget {
  static String id = 'branch';
  @override
  _BranchChooseScreenState createState() => _BranchChooseScreenState();
}

class _BranchChooseScreenState extends State<BranchChooseScreen> {
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {
              Navigator.pushNamed(context, AdministrationScreen.id)
            },
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey.shade800,
          title: Center(child: Text('20m² - Gestione Sedi', style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'LoraFont'),)),
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
                      onTap: () =>
                          showDialog(
                              context: context,
                              builder: (context) {
                                return VentiMetriQuadriDashboard(
                                  branch: 'Cisternino',
                                );
                              }
                          ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/cisternino.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.dst),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Cisternino', style: TextStyle(color: Colors.white, fontSize: 30),),
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
                      onTap: () =>
                          showDialog(
                              context: context,
                              builder: (context) {
                                return VentiMetriQuadriDashboard(
                                  branch: 'Locorotondo',
                                );
                              }
                          ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/locorotondo.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.dst),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Locorotondo', style: TextStyle(color: Colors.white, fontSize: 30),),
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
                      onTap: () =>
                          showDialog(
                              context: context,
                              builder: (context) {
                                return VentiMetriQuadriDashboard(
                                  branch: 'Monopoli',
                                );
                              }
                          ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/monopoli.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.dst),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Monopoli', style: TextStyle(color: Colors.white, fontSize: 30),),
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
