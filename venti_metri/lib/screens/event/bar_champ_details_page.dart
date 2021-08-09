import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/events_models/bar_position_class.dart';
import 'package:venti_metri/model/events_models/event_class.dart';
import 'package:venti_metri/model/events_models/product_event.dart';
import 'package:venti_metri/model/recap_table.dart';
import 'package:venti_metri/utils/utils.dart';

import 'event_manager_screen.dart';

class BarChampDetailsPage extends StatefulWidget {
  static String id = 'bar_champ_detail_page';

  final EventClass eventClass;
  final List<BarPositionClass> barPositionList;
  final List<BarPositionClass> champagneriePositionList;

  BarChampDetailsPage({@required this.barPositionList,
    @required this.champagneriePositionList, @required this.eventClass});

  @override
  _BarChampDetailsPageState createState() => _BarChampDetailsPageState();
}

class _BarChampDetailsPageState extends State<BarChampDetailsPage> {

  EventClass _eventClass;
  User loggedInUser;
  FirebaseAuth _auth;
  List<Product> barCurrentProductList;
  List<Product> champCurrentProductList;
  List<RecapTableObject> recapTableList = <RecapTableObject>[];


  @override
  void initState() {
    super.initState();
    _eventClass = this.widget.eventClass;
    _auth = FirebaseAuth.instance;
    getCurrentUser();
    initRecList();
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
            title: Text(_eventClass.title, style: TextStyle(fontFamily: 'LoraFont'),),
          ),
          body: Column(
            children: buildRecapTableBarChampConsumption(recapTableList),
          ),

        ),
      ),
    );
  }

  void refreshPage() {
    setState(() {});
  }

  Future<void> initListRecap(List<BarPositionClass> barChampagneriePositionList,
      bool barRecap,
      bool champRecap) async{

    String currentSchema;

    if(barRecap){
      currentSchema = BAR_LIST_PRODUCT_SCHEMA;
    } else if(champRecap){
      currentSchema = CHAMPAGNERIE_LIST_PRODUCT_SCHEMA;
    }

    if(barChampagneriePositionList != null){
      barChampagneriePositionList.forEach((element) async {
        print('Schema to retrieve bar/champagnerie product ' + currentSchema + element.passwordEvent.toString() + element.passwordBarChampPosition.toString());
        CRUDModel currentCrudModel = CRUDModel(currentSchema + element.passwordEvent.toString() + element.passwordBarChampPosition.toString());
        List<Product> currentProductList = await currentCrudModel.fetchProducts();
        recapTableList.add(
          RecapTableObject(
              barChampName: element.name,
              barOwner: element.ownerBar,
              barChampPassword: element.passwordBarChampPosition,
              isBarPosition: barRecap,
              isChampPosition: champRecap,
              listProduct: currentProductList));
      });
    }
    return recapTableList;
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

  Future<void> initRecList() async {
    await initListRecap(this.widget.barPositionList, true, false);
    sleep(Duration(seconds:1));
    await initListRecap(this.widget.champagneriePositionList, false, true);
    sleep(Duration(seconds:1));
  }

  buildRecapTableBarChampConsumption(List<RecapTableObject> recapTableList) {

    List<Widget> listOut = <Widget>[];
    recapTableList.forEach((recObject) {
      listOut.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 8),
          child: Card(
            color: recObject.isBarPosition ? VENTI_METRI_MONOPOLI : VENTI_METRI_LOCOROTONDO,
            child: Center(
              child: Column(
                children: [
                  Text('${recObject.barChampName}', style: TextStyle(fontSize: 17, color: recObject.isBarPosition ? Colors.white : VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                  recObject.barOwner != '' ? Text('Responsabile : ${recObject.barOwner}', style: TextStyle(fontSize: 17, color: recObject.isBarPosition ? Colors.white : VENTI_METRI_BLUE, fontFamily: 'LoraFont')) : SizedBox(height: 0,),
                ],
              ),
            ),
          ),
        ),
      );
      listOut.add(
          buildTableWithCurrentBarChampagnerieProductElements(recObject.listProduct)
      );
    });
    return listOut;
  }
}

