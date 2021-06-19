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

  User loggedInUser;
  FirebaseAuth _auth;
  var _tapPosition;

  @override
  void initState() {
    super.initState();

    _auth = FirebaseAuth.instance;

    getCurrentUser();

    _eventClass = this.widget.eventClass;

    crudModelEventSchema = CRUDModel(EVENTS_SCHEMA);
    crudModelBarPosition = CRUDModel(BAR_POSITION_SCHEMA);
    crudModelChampagnerie = CRUDModel(CHAMPAGNERIE_POSITION_SCHEMA);

    crudModelBarProducts = CRUDModel(BAR_LIST_PRODUCT_SCHEMA + getAppIxFromNameEvent(_eventClass.title));
    crudModelChampagnerieProducts = CRUDModel(CHAMPAGNERIE_LIST_PRODUCT_SCHEMA + getAppIxFromNameEvent(_eventClass.title));

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
                                  _eventClass.listBarPositionIds.forEach((element) {
                                    crudModelBarPosition.removeDocumentById(element);
                                  });
                                  _eventClass.listChampagneriePositionIds.forEach((element) {
                                    crudModelChampagnerie.removeDocumentById(element);
                                  });
                                  _eventClass.productBarList.forEach((element) {
                                    crudModelBarProducts.removeDocumentById(element);
                                  });
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
            ],
            title: Text(_eventClass.title, style: TextStyle(fontFamily: 'LoraFont'),),
          ),
          body: Container(
            color: VENTI_METRI_BLUE,
            child: SingleChildScrollView(
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
                      child: snapshot.data,
                    );
                  }else{
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Widget> createBody() async {

    List<BarPositionClass> barPositionList = await crudModelBarPosition.fetchBarPositionListByEventId(_eventClass.id);
    List<BarPositionClass> champagnerieList = await crudModelChampagnerie.fetchBarPositionListByEventId(_eventClass.id);

    print('List Bar position: ' + barPositionList.toString());
    print('List Champagnerie position: ' + champagnerieList.toString());

    return Column(
      children: [
        Card(
          color: Colors.green.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 2,),
                Text('Password Evento: ${_eventClass.passwordEvent}', style: TextStyle(fontSize: 15, color: VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                SizedBox(height: 2,),
              ],
            ),
          ),
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
              child: Text('Champagnerie - n° ${champagnerieList.length}', style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'LoraFont')),
            ),
            SizedBox(height: 3,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: buildCardItemsByBarPositionList(champagnerieList, 'champagnerie'),
              ),
            ),
            SizedBox(height: 15,),
          ],
        ),
        Card(
          color: VENTI_METRI_MONOPOLI,
          child: const Center(
            child: const Text('Lista Carico Bar', style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'LoraFont')),
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection(BAR_LIST_PRODUCT_SCHEMA + getAppIxFromNameEvent(_eventClass.title)).orderBy('name', descending: false).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return const Text('Loading data..');
            return Container(
              height: MediaQuery.of(context).size.height*1/3,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemExtent: 40,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => _buildListItems(context, snapshot.data.docs[index], _eventClass.productBarList)
              ),
            );
          },
        ),
        SizedBox(
          height:14,
        ),
        Card(
          color: VENTI_METRI_LOCOROTONDO,
          child: Center(
            child: Text('Lista Carico Champagnerie', style: TextStyle(fontSize: 17, color: VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection(CHAMPAGNERIE_LIST_PRODUCT_SCHEMA + getAppIxFromNameEvent(_eventClass.title)).orderBy('name', descending: false).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return const Text('Loading data..');
            return Container(
              height: MediaQuery.of(context).size.height*1/3,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemExtent: 40,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => _buildListItems(context, snapshot.data.docs[index], _eventClass.productChampagnerieList)
              ),
            );
          },
        ),
      ],
    );
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ListTile(
                    title: Text(currentBarChampPosition.name, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 26, color: type == 'bar' ? Colors.white:  VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                    subtitle: Text('Resp: ' + currentBarChampPosition.ownerBar, style: TextStyle(color: type == 'bar' ? Colors.white:  VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                  ),
                  ListTile(
                    title: Text(type == 'bar' ? 'Password postazione Bar' : 'Password postazione Chmapgnerie', style: TextStyle(fontSize: 15, color: type == 'bar' ? Colors.white:  VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                    subtitle: Text(currentBarChampPosition.passwordBarChampPosition.toString(), style: TextStyle(fontSize: 25, color: type == 'bar' ? Colors.white:  VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        textColor: Colors.white,
                        child: Text('Modifica'),
                      ),
                      FlatButton(
                        textColor: VENTI_METRI_BLUE,
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
                        child: Text('Cancella'),
                      ),
                    ],
                  ),
                ],
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
                      SizedBox(height: 3,),
                      TextField(
                        enabled: false,
                        style: TextStyle(height:1),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: currentBarChampPosition.passwordBarChampPosition.toString()),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.vpn_key_outlined),
                          labelText: 'Password',
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
  Widget _buildListItems(BuildContext context,
      DocumentSnapshot document,
      List<dynamic> productBarList) {

    return ListTile(
      title: Table(
        border: TableBorder(
            horizontalInside: BorderSide(
                width: 1,
                color: Colors.white, style: BorderStyle.solid)),
        children: _buidTableRow(document, productBarList),
      ),
    );
  }

  _buidTableRow(DocumentSnapshot doc,
      List<dynamic> productBarList) {

    List<TableRow> rList = <TableRow>[];

    rList.add(
      TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(doc['name'].toString(),overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'LoraFont')),
            ),
            GestureDetector(
              onLongPress: (){
                final RenderBox overlay = Overlay.of(context).context.findRenderObject();

                showMenu(
                    context: context,
                    items: <PopupMenuEntry<double>>[MinusEntry()],
                    position: RelativeRect.fromRect(
                        _tapPosition & Size(40, 40),
                        Offset.zero & overlay.size
                    )
                )
                    .then<void>((double delta) {

                  if (delta == null) return;

                  if(doc['stock'] > delta){
                    FirebaseFirestore.instance.runTransaction((transaction) async {
                      DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                      await transaction.update(freshSnap.reference, {
                        'stock' : doc['stock'] - delta,
                      });
                    });
                  }
                });
              },
              onTapDown: _storePosition,
                child: RaisedButton(
                  elevation: 0.5,
                  color: VENTI_METRI_BLUE,
                  child: Text('-', style: TextStyle(color: Colors.redAccent, fontSize: 25.0, fontFamily: 'LoraFont')),
                  onPressed: (){
                    if(doc['stock'] > 1){
                      FirebaseFirestore.instance.runTransaction((transaction) async {
                        DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                        await transaction.update(freshSnap.reference, {
                          'stock' : doc['stock'] - 1,
                        });
                      });
                    }
                  },
                ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Center(child: Text(doc['stock'].toString(), style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'LoraFont'))),
            ),
            GestureDetector(
              onLongPress: (){
                final RenderBox overlay = Overlay.of(context).context.findRenderObject();

                showMenu(
                    context: context,
                    items: <PopupMenuEntry<double>>[PlusEntry()],
                    position: RelativeRect.fromRect(
                        _tapPosition & Size(40, 40),
                        Offset.zero & overlay.size
                    )
                )
                    .then<void>((double delta) {

                  if (delta == null) return;
                  FirebaseFirestore.instance.runTransaction((transaction) async{
                    DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                    await transaction.update(freshSnap.reference, {
                      'stock' : doc['stock'] + delta,
                    });
                  });

                });
              },
              onTapDown: _storePosition,
              child: RaisedButton(
                elevation: 0.5,
                color: VENTI_METRI_BLUE,
                child: Text('+', style: TextStyle(color: Colors.greenAccent, fontSize: 25.0, fontFamily: 'LoraFont')),
                onPressed: (){
                  FirebaseFirestore.instance.runTransaction((transaction) async{
                    DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                    await transaction.update(freshSnap.reference, {
                      'stock' : doc['stock'] + 1,
                    });
                  });
                },
              ),
            ),
          ]
      ),
    );

    return rList;
  }


  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }
}

class PlusEntry extends PopupMenuEntry<double> {
  @override
  final double height = 90;
  @override
  bool represents(double n) => n == 10 || n == 0.25 || n == 0.10;

  @override
  PlusEntryState createState() => PlusEntryState();
}

class PlusEntryState extends State<PlusEntry> {
  void _plus10() {
    Navigator.pop<double>(context, 10);
  }

  void _plus025() {
    Navigator.pop<double>(context, 0.25);
  }

  void _plus010() {
    Navigator.pop<double>(context, 0.10);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: FlatButton(onPressed: _plus10, child: Text('+10', style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 15.0, fontFamily: 'LoraFont')))),
        Expanded(child: FlatButton(onPressed: _plus025, child: Text('+0,25', style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 15.0, fontFamily: 'LoraFont')))),
        Expanded(child: FlatButton(onPressed: _plus010, child: Text('+0,1', style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 15.0, fontFamily: 'LoraFont')))),
      ],
    );
  }
}

class MinusEntry extends PopupMenuEntry<double> {
  @override
  final double height = 90;
  @override
  bool represents(double n) => n == 10 || n == 0.25 || n == 0.10;

  @override
  MinusEntryState createState() => MinusEntryState();
}

class MinusEntryState extends State<MinusEntry> {
  void _plus10() {
    Navigator.pop<double>(context, 10);
  }

  void _plus025() {
    Navigator.pop<double>(context, 0.25);
  }

  void _plus010() {
    Navigator.pop<double>(context, 0.10);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: FlatButton(onPressed: _plus10, child: Text('-10', style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 15.0, fontFamily: 'LoraFont')))),
        Expanded(child: FlatButton(onPressed: _plus025, child: Text('-0,25', style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 15.0, fontFamily: 'LoraFont')))),
        Expanded(child: FlatButton(onPressed: _plus010, child: Text('-0,1', style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 15.0, fontFamily: 'LoraFont')))),
      ],
    );
  }
}