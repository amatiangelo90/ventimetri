import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/screens/party/event_manager_screen.dart';
import 'package:venti_metri/screens/venti_m_q_dashboard.dart';
import 'package:venti_metri/utils/utils.dart';

class BranchChooseScreen extends StatefulWidget {
  static String id = 'choose';
  @override
  _BranchChooseScreenState createState() => _BranchChooseScreenState();
}

class _BranchChooseScreenState extends State<BranchChooseScreen> {
  ScrollController scrollViewColtroller = ScrollController();
  TextEditingController _partyCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        backgroundColor: VENTI_METRI_BLUE,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: VENTI_METRI_BLUE,
          title: Center(child: Text('20m² - Drink & Enjoy')),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.person ,size: 30.0, color: Colors.white,), onPressed: (){

            }
            ),
          ],
        ),
        body: Column(
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () => showModal(
                      configuration: const FadeScaleTransitionConfiguration(
                        transitionDuration: Duration(milliseconds: 500),
                      ),
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Center(child: Text('Serate', style: TextStyle(color: Colors.white, fontSize: 20),)),
                        backgroundColor: VENTI_METRI_BLUE,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: TextField(
                              onChanged: (partyCode){
                                if(partyCode != CURRENT_PASSWORD && partyCode.length == 4){
                                  _partyCodeController.clear();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(backgroundColor: Colors.red.shade500 ,
                                      content: Text('Password errata')));
                                }else if(partyCode == CURRENT_PASSWORD){
                                  Navigator.of(context).pop(true);
                                  _partyCodeController.clear();

                                }
                              },
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                              controller: _partyCodeController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                                  ),
                                  labelText: 'Codice Serata',
                                  labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                                  fillColor: Colors.white
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Center(child: Text(' ---------', style: TextStyle(color: Colors.white, fontSize: 15),)),
                          SizedBox(height: 20.0,),
                          Center(
                            child: ElevatedButton(
                              child: Text('Accedi area gestione'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(VENTI_METRI_BLUE),
                              ),
                              onPressed: (){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(backgroundColor: Colors.green.shade500,
                                    content: Text('Accesso al calendario eventi in corso..')));
                                Timer(Duration(milliseconds: 1000), ()=> Navigator.pushNamed(context, PartyScreenManager.id));
                              },
                            ),
                          ),
                          SizedBox(height: 20.0,),
                        ],
                      ),
                    ),
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
          ],
        ),
      ),
    );
  }
}
