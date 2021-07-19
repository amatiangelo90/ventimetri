import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/events_models/bar_position_class.dart';
import 'package:venti_metri/model/events_models/event_class.dart';
import 'package:venti_metri/model/events_models/product_class.dart';
import 'package:venti_metri/screens/event/recap_event_screen.dart';
import 'package:venti_metri/screens/event/single_bar_champ_page_manager_screen.dart';
import 'package:venti_metri/screens/event/utils_event/utils_event.dart';
import 'package:venti_metri/utils/utils.dart';

import 'event_manager_screen.dart';

class SingleEventManagerScreen extends StatefulWidget {
  static String id = 'event_manager_page';

  final EventClass eventClass;
  final Function function;

  SingleEventManagerScreen({@required this.eventClass, this.function});

  @override
  _SingleEventManagerScreenState createState() => _SingleEventManagerScreenState();
}

class _SingleEventManagerScreenState extends State<SingleEventManagerScreen> {

  EventClass _eventClass;
  CRUDModel crudModelEventSchema;
  CRUDModel crudModelBarPosition;
  CRUDModel crudModelChampagnerie;
  CRUDModel crudModelBarProducts;
  CRUDModel crudModelChampagnerieProducts;

  CRUDModel crudModelBarProductsExpences;
  CRUDModel crudModelChampagnerieProductsExpences;
  CRUDModel crudModelExpences;

  List<BarPositionClass> _barExpencesClassList = <BarPositionClass>[];
  List<BarPositionClass> _champagnerieExpencesClassList = <BarPositionClass>[];


  User loggedInUser;
  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();

    _auth = FirebaseAuth.instance;

    getCurrentUser();
    _eventClass = this.widget.eventClass;

    crudModelEventSchema = CRUDModel(EVENTS_SCHEMA);
    crudModelBarPosition = CRUDModel(BAR_POSITION_SCHEMA);
    crudModelChampagnerie = CRUDModel(CHAMPAGNERIE_POSITION_SCHEMA);
    crudModelExpences = CRUDModel(EXPENCES_EVENT_SCHEMA + getAppIxFromNameEvent(_eventClass.title));
  }
  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser;
      if(user != null){
        setState(() {
          loggedInUser = user;
        });
        print('Email logged in : ' + loggedInUser.email);
      }else{
        print('No user authenticated');
      }
    }catch(e){
      print('Exception : ' + e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          backgroundColor: VENTI_METRI_BLUE,
          appBar: AppBar(
            backgroundColor: VENTI_METRI_BLUE,
            centerTitle: true,
            actions: [
              loggedInUser == null ? SizedBox(width: 0,) : Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                child: IconButton(
                  icon: Icon(FontAwesomeIcons.trash, color: Colors.redAccent, size: 20,),
                  onPressed: () async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Conferma", style: TextStyle(color: Colors.white, fontSize: 19.0, fontFamily: 'LoraFont'),),
                          content: Text("Eliminare l'evento ${_eventClass.title}?", style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 16.0, fontFamily: 'LoraFont'),),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: (){

                                  _eventClass.expencesBarProductList.forEach((element) {
                                    crudModelBarProductsExpences = CRUDModel(element);
                                    crudModelBarProductsExpences.deleteCollection(element);
                                  });

                                  _eventClass.expencesChampagnerieProductList.forEach((element) {
                                    crudModelChampagnerieProductsExpences = CRUDModel(element);
                                    crudModelChampagnerieProductsExpences.deleteCollection(element);
                                  });

                                  crudModelExpences.deleteCollection(EXPENCES_EVENT_SCHEMA + getAppIxFromNameEvent(_eventClass.title));

                                  _eventClass.listBarPositionIds.forEach((element) {
                                    crudModelBarPosition.removeDocumentById(element);
                                  });
                                  _eventClass.listChampagneriePositionIds.forEach((element) {
                                    crudModelChampagnerie.removeDocumentById(element);
                                  });

                                  crudModelBarProducts = CRUDModel(BAR_LIST_PRODUCT_SCHEMA + getAppIxFromNameEvent(_eventClass.title));

                                  _eventClass.productBarList.forEach((element) {
                                    crudModelBarProducts.removeDocumentById(element);
                                  });

                                  crudModelChampagnerieProducts = CRUDModel(CHAMPAGNERIE_LIST_PRODUCT_SCHEMA + getAppIxFromNameEvent(_eventClass.title));
                                  _eventClass.productChampagnerieList.forEach((element) {
                                    crudModelChampagnerieProducts.removeDocumentById(element);
                                  });

                                  crudModelEventSchema.removeDocumentById(_eventClass.docId);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      backgroundColor: Colors.orange,
                                      content: Text('Evento ${_eventClass.title} eliminato!')));
                                  Navigator.pushNamed(context, PartyScreenManager.id);
                                },
                                child: const Text("Elimina")
                            ),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Indietro"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, size: 30,),
                onPressed: (){
                  refreshPage();
                },
              ),
            ],
            title: Text(_eventClass.title, style: TextStyle(fontFamily: 'LoraFont'),),
          ),
          body: Container(
            color: VENTI_METRI_BLUE,
            child: FutureBuilder(
              initialData: <Widget>[Column(
                children: [
                  Center(child: CircularProgressIndicator()),
                  SizedBox(),
                  Center(child: Text('Caricamento menù..',
                    style: TextStyle(fontSize: 16.0,
                        color: VENTI_METRI_BLUE,
                        fontFamily: 'LoraFont'),
                  ),),
                ],
              ),
              ],
              future: createBody(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: snapshot.data,
                    ),
                  );
                }else{
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Widget>> createBody() async {
    List<BarPositionClass> barPositionList = await crudModelBarPosition.fetchBarPositionListByEventId(_eventClass.id);
    List<BarPositionClass> champagneriePositionList = await crudModelChampagnerie.fetchBarPositionListByEventId(_eventClass.id);

    print(_barExpencesClassList);
    if(champagneriePositionList != null){
      champagneriePositionList.forEach((element) async {
        print('Schema to retrieve champagnerie product ' + BAR_LIST_PRODUCT_SCHEMA + element.passwordEvent.toString() + element.passwordBarChampPosition.toString());
        CRUDModel currentCrudModel = CRUDModel(CHAMPAGNERIE_LIST_PRODUCT_SCHEMA + element.passwordEvent.toString() + element.passwordBarChampPosition.toString());
        _champagnerieExpencesClassList.addAll(await currentCrudModel.fetchBarPositionList());
      });
    }

    print(_champagnerieExpencesClassList);

    List<Widget> items = <Widget>[];
    items.add(Column(
      children: [
        Card(
          color: Colors.green.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 6,),
                Text('Password Evento: ${_eventClass.passwordEvent}', style: TextStyle(fontSize: 15, color: VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                SizedBox(height: 6,),
              ],
            ),
          ),
        ),
        SizedBox(height: 5,),
        Column(
          children: [
            SizedBox(height: 3,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: buildRecaTableForAllEvent(),
              ),
            ),
          ],
        ),
        SizedBox(height: 5,),
        Column(
          children: [
            Center(
              child: Text('Postazioni Bar - n° ${barPositionList.length}', style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'LoraFont')),
            ),
            SizedBox(height: 3,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: buildCardItemsByBarPositionList(barPositionList, 'bar'),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Center(
              child: Text('Champagnerie - n° ${champagneriePositionList.length}', style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'LoraFont')),
            ),
            SizedBox(height: 3,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: buildCardItemsByBarPositionList(champagneriePositionList, 'champagnerie'),
              ),
            ),
            SizedBox(height: 15,),
          ],
        ),
        Container(
            child: FutureBuilder(
              initialData: <Widget>[Column(
                children: [
                  Center(child: CircularProgressIndicator(
                    color: VENTI_METRI_PINK,
                  )),
                  SizedBox(),
                  Center(child: Text('Caricamento dati per tabella resoconto..',
                    style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                  ),),
                ],
              )],
              future: buildRecapTableBarChampConsumption(barPositionList, true, false),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: snapshot.data,
                    ),
                  );
                }else{
                  return CircularProgressIndicator();
                }
              },
            )
        ),
        Container(
            child: FutureBuilder(
              initialData: <Widget>[Column(
                children: [
                  Center(child: CircularProgressIndicator(
                    color: VENTI_METRI_PINK,
                  )),
                  SizedBox(),
                  Center(child: Text('Caricamento dati per tabella resoconto..',
                    style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                  ),),
                ],
              )],
              future: buildRecapTableBarChampConsumption(champagneriePositionList, false, true),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: snapshot.data,
                    ),
                  );
                }else{
                  return CircularProgressIndicator();
                }
              },
            )
        ),
        SizedBox(height: 25,),
        Container(
          height: 60,
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.blueGrey.shade500,
            elevation: 19.0,
            child: Text('Resoconto', style: TextStyle(fontSize: 18.0,color: Colors.white, fontFamily: 'LoraFont'),),
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => RecapEventPage(eventClass: _eventClass,
                  barPositionList: barPositionList,
                  champPositionList: champagneriePositionList,),),);
            },
          ),
        ),
        SizedBox(height: 25,),
        Container(
          height: 60,
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.redAccent,
            elevation: 19.0,
            child: Text('Cancella Evento', style: TextStyle(fontSize: 18.0,color: Colors.white, fontFamily: 'LoraFont'),),
              onPressed: () async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Conferma", style: TextStyle(color: Colors.white, fontSize: 19.0, fontFamily: 'LoraFont'),),
                      content: Text("Eliminare l'evento ${_eventClass.title}?", style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 16.0, fontFamily: 'LoraFont'),),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: (){

                              _eventClass.expencesBarProductList.forEach((element) {
                                crudModelBarProductsExpences = CRUDModel(element);
                                crudModelBarProductsExpences.deleteCollection(element);
                              });

                              _eventClass.expencesChampagnerieProductList.forEach((element) {
                                crudModelChampagnerieProductsExpences = CRUDModel(element);
                                crudModelChampagnerieProductsExpences.deleteCollection(element);
                              });

                              _eventClass.listBarPositionIds.forEach((element) {
                                crudModelBarPosition.removeDocumentById(element);
                              });
                              _eventClass.listChampagneriePositionIds.forEach((element) {
                                crudModelChampagnerie.removeDocumentById(element);
                              });

                              crudModelBarProducts = CRUDModel(BAR_LIST_PRODUCT_SCHEMA + getAppIxFromNameEvent(_eventClass.title));

                              _eventClass.productBarList.forEach((element) {
                                crudModelBarProducts.removeDocumentById(element);
                              });

                              crudModelChampagnerieProducts = CRUDModel(CHAMPAGNERIE_LIST_PRODUCT_SCHEMA + getAppIxFromNameEvent(_eventClass.title));
                              _eventClass.productChampagnerieList.forEach((element) {
                                crudModelChampagnerieProducts.removeDocumentById(element);
                              });

                              crudModelEventSchema.removeDocumentById(_eventClass.docId);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  backgroundColor: Colors.orange,
                                  content: Text('Evento ${_eventClass.title} eliminato!')));
                              Navigator.pushNamed(context, PartyScreenManager.id);
                            },
                            child: const Text("Elimina")
                        ),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Indietro"),
                        ),
                      ],
                    );
                  },
                );
            },
          ),
        ),
        SizedBox(height: 100,),
        Text('Designed by Amati Angelo.', style: TextStyle(
          color: Colors.white10,
          fontFamily: 'LoraFont',
          fontSize: 9.0,
          fontWeight: FontWeight.bold,
        ),),
      ],
    ),
    );
    return items;
  }

  List<Widget> buildCardItemsByBarPositionList(List<BarPositionClass> barPositionList, String type) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<Widget> items = <Widget>[];
    barPositionList.forEach((currentBarChampPosition) {
      TextEditingController _textNameController = TextEditingController(text: currentBarChampPosition.name);
      TextEditingController _ownerPositionController = TextEditingController(text: currentBarChampPosition.ownerBar);
      FlipCardController _flipCardController = FlipCardController();
      items.add(
        FlipCard(
          controller: _flipCardController,
          front:
          Container(
            height: height * 1/4,
            width: width * 4/5,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: type == 'bar' ? VENTI_METRI_MONOPOLI : VENTI_METRI_LOCOROTONDO,
              elevation: 10,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ListTile(
                      title: Text(currentBarChampPosition.name, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 26, color: type == 'bar' ? Colors.white:  VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                      subtitle: Text('Resp: ' + currentBarChampPosition.ownerBar, style: TextStyle(color: type == 'bar' ? Colors.white:  VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                    ),
                    ListTile(
                      title: Text('Password', style: TextStyle(fontSize: 15, color: type == 'bar' ? Colors.white:  VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                      subtitle: Text(currentBarChampPosition.passwordBarChampPosition.toString(), style: TextStyle(fontSize: 25, color: type == 'bar' ? Colors.white:  VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(

                          elevation: 3.0,
                          onPressed: () {
                            if(type == 'bar'){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SingleBarChampManagerScreen(barPosClass: currentBarChampPosition,isBarPosition: true,isChampagneriePosition: false,),),);
                            }else{
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SingleBarChampManagerScreen(barPosClass: currentBarChampPosition,isChampagneriePosition: true,isBarPosition: false,),),);
                            }


                          },
                          padding: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: VENTI_METRI_BLUE,
                          child: Text(
                            'Carico/Scarico',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.0,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'LoraFont',
                            ),
                          ),
                        ),
                        RaisedButton(

                          elevation: 3.0,
                          onPressed: () async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Conferma", style: TextStyle(color: Colors.white, fontSize: 19.0, fontFamily: 'LoraFont'),),
                                  content: Text("Eliminare ${currentBarChampPosition.name} per l\'evento ${currentBarChampPosition.eventName}?", style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: (){
                                          if(type == 'bar'){
                                            CRUDModel variableCrudModel = CRUDModel(BAR_LIST_PRODUCT_SCHEMA + currentBarChampPosition.passwordEvent.toString() + currentBarChampPosition.passwordBarChampPosition.toString());
                                            variableCrudModel.deleteCollection(BAR_LIST_PRODUCT_SCHEMA + currentBarChampPosition.passwordEvent.toString() + currentBarChampPosition.passwordBarChampPosition.toString());
                                          }else{
                                            CRUDModel variableCrudModel = CRUDModel(CHAMPAGNERIE_LIST_PRODUCT_SCHEMA + currentBarChampPosition.passwordEvent.toString() + currentBarChampPosition.passwordBarChampPosition.toString());
                                            variableCrudModel.deleteCollection(CHAMPAGNERIE_LIST_PRODUCT_SCHEMA + currentBarChampPosition.passwordEvent.toString() + currentBarChampPosition.passwordBarChampPosition.toString());
                                          }
                                          if(type == 'bar'){
                                            crudModelBarPosition.removeDocumentById(currentBarChampPosition.docId);
                                            _eventClass.listBarPositionIds.remove(currentBarChampPosition.docId);
                                            crudModelEventSchema.updateEventClassById(_eventClass, _eventClass.docId);
                                          }else{
                                            crudModelChampagnerie.removeDocumentById(currentBarChampPosition.docId);
                                            _eventClass.listChampagneriePositionIds.remove(currentBarChampPosition.docId);
                                            crudModelEventSchema.updateEventClassById(_eventClass, _eventClass.docId);
                                          }
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              duration: Duration(milliseconds: 1000),
                                              backgroundColor: Colors.orange,
                                              content: Text('${currentBarChampPosition.name} per l\'evento ${currentBarChampPosition.eventName} eliminato!')));
                                          refreshPage();
                                          Navigator.of(context).pop(false);
                                        },

                                        child: const Text("Elimina")

                                    ),
                                    FlatButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Indietro"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          padding: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: VENTI_METRI_BLUE,
                          child: Text(
                            'Elimina',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.0,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'LoraFont',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          back: Container(
            height: height * 2/7,
            width: width * 4/5,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: type == 'bar' ? VENTI_METRI_CISTERNINO : Colors.green.shade100,
              elevation: 10,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10,),
                      TextField(
                        controller: _textNameController,
                        style: TextStyle(height:1),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.home),
                          labelText: 'Nome Postazione',
                        ),
                      ),
                      SizedBox(height: 3,),
                      TextField(
                        controller: _ownerPositionController,
                        style: TextStyle(height:1),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person),
                          labelText: 'Responsabile',
                        ),
                      ),

                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            textColor: Colors.greenAccent.shade700,

                            onPressed: (){
                              if(_textNameController.value.text == ''){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1500),
                                    backgroundColor: Colors.redAccent,
                                    content: Text('Assegnare un nominativo alla postazione bar')));
                              }else{
                                currentBarChampPosition.name = _textNameController.value.text;
                                currentBarChampPosition.ownerBar = _ownerPositionController.value.text;
                                if(type == 'bar'){
                                  crudModelBarPosition.updateBarPositionClassById(currentBarChampPosition, currentBarChampPosition.docId);
                                }else{
                                  crudModelChampagnerie.updateBarPositionClassById(currentBarChampPosition, currentBarChampPosition.docId);
                                }
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1500),
                                    backgroundColor: Colors.green,
                                    content: Text('Modifica postazione bar completata')));

                                sleep(Duration(seconds:1));
                                refreshPage();
                              }
                            },

                            child: Text('Salva'),
                          ),
                        ],
                      ),
                      Text(currentBarChampPosition.eventName, style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 10.0, fontFamily: 'LoraFont')),
                      Text(currentBarChampPosition.docId, style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 10.0, fontFamily: 'LoraFont')),
                      Text(currentBarChampPosition.id, style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 10.0, fontFamily: 'LoraFont')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
    return items;
  }

  void refreshPage() {
    this.widget.function();
    setState(() {});
  }

  //RECAP
  Future<List<Widget>> buildRecapTableBarChampConsumption(List<BarPositionClass> barChampagneriePositionList,
      bool barRecap,
      bool champRecap) async{

    String currentSchema;

    if(barRecap){
      currentSchema = BAR_LIST_PRODUCT_SCHEMA;
    } else if(champRecap){
      currentSchema = CHAMPAGNERIE_LIST_PRODUCT_SCHEMA;
    }
    List<Widget> listOut = <Widget>[];

    if(barChampagneriePositionList != null){
      barChampagneriePositionList.forEach((element) async {
        print('Schema to retrieve bar/champagnerie product ' + currentSchema + element.passwordEvent.toString() + element.passwordBarChampPosition.toString());
        CRUDModel currentCrudModel = CRUDModel(currentSchema + element.passwordEvent.toString() + element.passwordBarChampPosition.toString());
        List<Product> currentProductList = await currentCrudModel.fetchProducts();
        listOut.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 8),
            child: Card(
              color: barRecap ? VENTI_METRI_MONOPOLI : VENTI_METRI_LOCOROTONDO,
              child: Center(
                child: Column(
                  children: [
                    Text('${element.name}', style: TextStyle(fontSize: 17, color: barRecap ? Colors.white : VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                    element.ownerBar != '' ? Text('Responsabile : ${element.ownerBar}', style: TextStyle(fontSize: 17, color: barRecap ? Colors.white : VENTI_METRI_BLUE, fontFamily: 'LoraFont')) : SizedBox(height: 0,),
                  ],
                ),
              ),
            ),
          ),
        );
        listOut.add(
            buildTableWithCurrentBarChampagnerieProductElements(currentProductList)
        );
      });
    }

    return listOut;
  }

  Widget buildTableWithCurrentBarChampagnerieProductElements(List<Product> currentProductList) {


    return Table(
        border: TableBorder(horizontalInside: BorderSide(width: 0.5, color: Colors.black12, style: BorderStyle.solid)),
        children: buildTableRowByCurrentProductList(currentProductList),
    );
  }

  buildTableRowByCurrentProductList(List<Product> currentProductList) {
    List<TableRow> _tableRow = <TableRow>[];
    double _currentTotal = 0.0;

    if(loggedInUser != null){
      _tableRow.add(
        TableRow(children :[
          Text('Prodotto', style: TextStyle(fontSize: 11, color: Colors.orange, fontFamily: 'LoraFont')),
          Center(child: Text('Prezzo(€)', style: TextStyle(fontSize: 11, color: Colors.orange, fontFamily: 'LoraFont'))),
          Center(child: Text('Carico', style: TextStyle(fontSize: 11, color: Colors.orange, fontFamily: 'LoraFont'))),
          Center(child: Text('Scarico', style: TextStyle(fontSize: 11, color: Colors.orange, fontFamily: 'LoraFont'))),
          Center(child: Text('Residuo', style: TextStyle(fontSize: 11, color: Colors.orange, fontFamily: 'LoraFont'))),
          Center(child: Text('Costi(€)', style: TextStyle(fontSize: 11, color: Colors.orange, fontFamily: 'LoraFont'))),
        ]),
      );
      currentProductList.forEach((element) {
        _currentTotal = _currentTotal + ((element.stock - element.consumed) * element.price);

        _tableRow.add(
          TableRow(
              children :[
            Text(element.name, style: TextStyle(fontSize: 10, color: Colors.white, fontFamily: 'LoraFont')),
            Center(child: Text(element.price.toStringAsFixed(2), style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'LoraFont'))),
            Center(child: Text(element.stock.toStringAsFixed(2), style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'LoraFont'))),
            Center(child: Text(element.consumed.toStringAsFixed(2), style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'LoraFont'))),
            Center(child: Text((element.stock - element.consumed).toStringAsFixed(2), style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'LoraFont'))),
            Center(child: Text(((element.stock - element.consumed) * element.price).toStringAsFixed(2), style: TextStyle(fontSize: 13, color: Colors.green, fontFamily: 'LoraFont'))),
          ]),
        );
      });
      _tableRow.add(
        TableRow(

            children :[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Text('Totale', style: TextStyle(fontSize: 16, color: Colors.blueAccent, fontFamily: 'LoraFont')),
          ),
          Center(child: Text('', style: TextStyle(fontSize: 11, color: Colors.redAccent, fontFamily: 'LoraFont'))),
          Center(child: Text('', style: TextStyle(fontSize: 11, color: Colors.redAccent, fontFamily: 'LoraFont'))),
          Center(child: Text('', style: TextStyle(fontSize: 11, color: Colors.redAccent, fontFamily: 'LoraFont'))),
          Center(child: Text('', style: TextStyle(fontSize: 11, color: Colors.redAccent, fontFamily: 'LoraFont'))),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Center(child: Text(_currentTotal.toStringAsFixed(2), style: TextStyle(fontSize: 13, color: Colors.blueAccent, fontFamily: 'LoraFont'))),
          ),
        ]),
      );
    }else{
      _tableRow.add(
        TableRow(children :[
          Text('Prodotto', style: TextStyle(fontSize: 15, color: Colors.orange, fontFamily: 'LoraFont')),
          Center(child: Text('Carico', style: TextStyle(fontSize: 15, color: Colors.orange, fontFamily: 'LoraFont'))),
          Center(child: Text('Scarico', style: TextStyle(fontSize: 15, color: Colors.orange, fontFamily: 'LoraFont'))),
          Center(child: Text('Rimanenza', style: TextStyle(fontSize: 15, color: Colors.orange, fontFamily: 'LoraFont'))),
        ]),
      );
      currentProductList.forEach((element) {
        _tableRow.add(
          TableRow(children :[
            Text(element.name, style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'LoraFont')),
            Center(child: Text(element.stock.toString(), style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'LoraFont'))),
            Center(child: Text(element.consumed.toString(), style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'LoraFont'))),
            Center(child: Text((element.stock - element.consumed).toStringAsFixed(2), style: TextStyle(fontSize: 15, color: Colors.white, fontFamily: 'LoraFont'))),
          ]),
        );
      });
    }

    return _tableRow;
  }

  buildRecaTableForAllEvent() {
    List<Widget> items = <Widget>[];
    return items;
  }
}

