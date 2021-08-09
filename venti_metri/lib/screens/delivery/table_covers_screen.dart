import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:venti_metri/component/round_icon_botton.dart';
import 'package:venti_metri/screens/delivery/reserve_order_screen.dart';
import 'package:venti_metri/screens/delivery/utils/costants.dart';
import 'package:venti_metri/screens/home_screen.dart';
import 'package:venti_metri/utils/utils.dart';

import 'dash_menu/menu_administrator.dart';
import 'delivery_home.dart';

class TableCoversScreen extends StatefulWidget {

  static String id = 'tablecovers';
  
  @override
  _TableCoversScreenState createState() => _TableCoversScreenState();
}

class _TableCoversScreenState extends State<TableCoversScreen> {
  bool _isTableSelected = true;
  String _tableSelected = '';
  final _passwordController = TextEditingController();
  int _covers = 1;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: _isTableSelected ? Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: _isTableSelected ? Colors.white : VENTI_METRI_MONOPOLI),
              onPressed: () => {
                setState(() {
                  _isTableSelected = false;
                  _tableSelected = '';
                }),

              },
            ),
            automaticallyImplyLeading: false,
            backgroundColor: VENTI_METRI_BLUE,
            title:  Text('Seleziona Numero Coperti', style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'LoraFont'),),
            centerTitle: true,
          ),
          backgroundColor: VENTI_METRI_BLUE,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text('',
                      style: TextStyle(fontSize: 15.0,
                          color: Colors.white,
                          fontFamily: 'LoraFont'),),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundIconButton(
                      icon: FontAwesomeIcons.minus,
                      function: () {
                        print(DateTime.now().toString());
                        setState(() {
                          if (_covers > 1)
                            _covers = _covers - 1;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                      _covers <= 1 ?
                      Text(_covers.toString() + ' Coperto',
                        style: TextStyle(fontSize: 25.0,
                            color: Colors.white,
                            fontFamily: 'LoraFont'),) :
                      Text(_covers.toString() + ' Coperti',
                        style: TextStyle(fontSize: 25.0,
                            color: Colors.white,
                            fontFamily: 'LoraFont'),),
                    ),
                    RoundIconButton(
                      icon: FontAwesomeIcons.plus,
                      function: () {
                        setState(() {
                          _covers = _covers + 1;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(width: 140.0,),
                MaterialButton(
                  minWidth: 200.0,
                  height: 35,
                  color: VENTI_METRI_MONOPOLI,
                  child: new Text('Vai al Menù',
                      style: new TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'LoraFont')),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VentiMetriRestaurantScreen(
                        covers: _covers.toString(),
                      ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ) : Scaffold(

          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: VENTI_METRI_BLUE,
            title:  Text('Seleziona Tavolo', style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'LoraFont'),),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: ()=> Navigator.pushNamed(context, HomeScreen.id),
            ),
          ),
          backgroundColor: VENTI_METRI_BLUE,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(20, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isTableSelected = true;
                        _tableSelected = (index+1).toString();
                      });
                    },
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: VENTI_METRI_MONOPOLI, width: 3.0),
                        ),
                        padding: const EdgeInsets.all(18.0),
                        child: Center(
                          child: Text(
                            'Tavolo ${index+1}',
                            style: TextStyle(fontSize: 14,color: Colors.white, fontFamily: 'LoraFont'),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
