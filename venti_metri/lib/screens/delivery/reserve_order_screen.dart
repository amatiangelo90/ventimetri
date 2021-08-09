import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/component/icon_content.dart';
import 'package:venti_metri/component/reusable_card.dart';
import 'package:venti_metri/screens/delivery/utils/costants.dart';
import 'package:venti_metri/utils/utils.dart';

import 'dash_menu/menu_administrator.dart';

class ReserveOrderChooseScreen extends StatefulWidget {

  static String id = 'choosingscreen';

  @override
  _ReserveOrderChooseScreenState createState() => _ReserveOrderChooseScreenState();
}

class _ReserveOrderChooseScreenState extends State<ReserveOrderChooseScreen> {

  final _passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: VENTI_METRI_MONOPOLI,
        child: Scaffold(
          backgroundColor: VENTI_METRI_MONOPOLI,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                child: Column(
                  children: [
                    Image.asset('images/terrazzament.png',
                      fit: BoxFit.contain,
                    ),
                    Text('v. 1.0.120', style: TextStyle(fontSize: 7, color: Colors.white),),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: ReusableCard(
                  color: Colors.white,
                  cardChild: IconContent(label: 'Menù', icon: Icons.restaurant_menu,color: VENTI_METRI_MONOPOLI, description: '',),
                  onPress: () {

                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: ReusableCard(
                  color: Colors.white,
                  cardChild: IconContent(label: 'Prenota un tavolo', icon: Icons.calendar_today,color: VENTI_METRI_MONOPOLI, description: '',),
                  onPress: () {
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: ReusableCard(
                  color: Colors.white,
                  cardChild: IconContent(label: 'Settings', icon: Icons.settings,color: VENTI_METRI_MONOPOLI, description: '',),
                  onPress: _showModalSettingsAccess,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showModalSettingsAccess() {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Settings"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Center(
              child: Card(
                color: Colors.white,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  controller: _passwordController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 0.0),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.black,
                    labelText: 'Password',
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              FlatButton(
                child: Text('Chiudi'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text('Accedi'),
                    onPressed: (){
                      if(_passwordController.value.text == CURRENT_PASSWORD_ADMIN){
                        setState(() {
                          _passwordController.clear();
                        });
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, MenuAdministratorScreen.id);
                      }else{
                        setState(() {
                          _passwordController.clear();
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(backgroundColor: Colors.red.shade500 ,
                            content: Text('Password errata')));
                    }
                  }
              ),
            ],
          )
        ],
      ),
    );
  }
}
