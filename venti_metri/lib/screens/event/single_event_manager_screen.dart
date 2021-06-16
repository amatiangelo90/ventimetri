import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/events_models/bar_position_class.dart';
import 'package:venti_metri/model/events_models/event_class.dart';
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


  @override
  void initState() {
    super.initState();
    _eventClass = this.widget.eventClass;
    crudModelEventSchema = CRUDModel(EVENTS_SCHEMA);
    crudModelBarPosition = CRUDModel(BAR_POSITION_SCHEMA);
    crudModelChampagnerie = CRUDModel(CHAMPAGNERIE_SCHEMA);

    crudModelBarProducts = CRUDModel(BAR_LIST_PRODUCT_SCHEMA);
    crudModelChampagnerieProducts = CRUDModel(CHAMPAGNERIE_LIST_PRODUCT_SCHEMA);
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
              Padding(
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
                )],
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
                Text('Password: ${_eventClass.passwordEvent}', style: TextStyle(fontSize: 13, color: VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
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
          ],
        ),
        Card(
          color: VENTI_METRI_MONOPOLI,
          child: const Center(
            child: const Text('Lista Carico Bar', style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'LoraFont')),
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection(BAR_LIST_PRODUCT_SCHEMA).orderBy('name', descending: false).snapshots(),
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
          stream: FirebaseFirestore.instance.collection(CHAMPAGNERIE_LIST_PRODUCT_SCHEMA).orderBy('name', descending: false).snapshots(),
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
                    title: Text(currentBarChampPosition.name, style: TextStyle(fontSize: 19, color: type == 'bar' ? Colors.white:  VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                    subtitle: Text('Resp: ' + currentBarChampPosition.ownerBar, style: TextStyle(color: type == 'bar' ? Colors.white:  VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
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
            height: height * 2/6,
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
                                _flipCardController.controller.reset();
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
    if(productBarList.contains(doc.id)){
      print('true');
    }else{
      print('false');
    }
    rList.add(

        TableRow(
            children: [
              Text(doc['name'].toString(), style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont')),

              RaisedButton(
                elevation: 0.5,
                color: VENTI_METRI_BLUE,
                child: Text('-', style: TextStyle(color: Colors.white, fontSize: 28.0, fontFamily: 'LoraFont')),
                onLongPress: (){
                  if(doc['stock'] > 10){
                    FirebaseFirestore.instance.runTransaction((transaction) async{
                      DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                      await transaction.update(freshSnap.reference, {
                        'stock' : doc['stock'] - 10,
                      });
                    });
                  }
                },
                onPressed: (){
                  if(doc['stock'] > 1){
                    FirebaseFirestore.instance.runTransaction((transaction) async{
                      DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                      await transaction.update(freshSnap.reference, {
                        'stock' : doc['stock'] - 1,
                      });
                    });
                  }
                },
              ),
              Center(child: Text(doc['stock'].toString(), style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont'))),
              RaisedButton(
                elevation: 0.5,
                color: VENTI_METRI_BLUE,
                child: Text('+', style: TextStyle(color: Colors.white, fontSize: 22.0, fontFamily: 'LoraFont')),
                onLongPress: (){
                  FirebaseFirestore.instance.runTransaction((transaction) async{
                    DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                    await transaction.update(freshSnap.reference, {
                      'stock' : doc['stock'] + 10,
                    });
                  });
                },
                onPressed: (){
                  FirebaseFirestore.instance.runTransaction((transaction) async{
                    DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                    await transaction.update(freshSnap.reference, {
                      'stock' : doc['stock'] + 1,
                    });
                  });
                },
              ),
            ]
        ),
      );

    return rList;
  }
  Container _buildBottomSheet(BuildContext context, BarPositionClass element) {
    return Container(
      height: 600,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: VENTI_METRI_BLUE, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView(
        children: <Widget>[
          ListTile(title: Text(element.name, style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 15.0, fontFamily: 'LoraFont'))),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.attach_money),
              labelText: 'Enter an integer',
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save and close'),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}
