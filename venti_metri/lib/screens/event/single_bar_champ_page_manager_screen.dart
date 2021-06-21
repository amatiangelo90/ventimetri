import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/events_models/bar_position_class.dart';
import 'package:venti_metri/model/events_models/product_class.dart';
import 'package:venti_metri/model/events_models/product_datasource.dart';
import 'package:venti_metri/utils/utils.dart';

class SingleBarChampManagerScreen extends StatefulWidget {
  static String id = 'bar_champ_manager_page';

  final BarPositionClass barPosClass;
  final bool isBarPosition;
  final bool isChampagneriePosition;

  const SingleBarChampManagerScreen({@required this.barPosClass, this.isBarPosition, this.isChampagneriePosition});

  @override
  _SingleBarChampManagerScreenState createState() => _SingleBarChampManagerScreenState();
}

class _SingleBarChampManagerScreenState extends State<SingleBarChampManagerScreen> {

  CRUDModel _crudModelProductsEventSchema;
  CRUDModel _alreadyUsedProductSchema;
  List<Product> _productsList = <Product>[];

  BarPositionClass _currentBarPositionObject;
  User loggedInUser;
  FirebaseAuth _auth;
  int _rowsPerPage = 5;
  String _currentBarChampagneriePositionSchema;
  bool _insertProductBottonPressed;

  @override
  void initState() {
    super.initState();
    _crudModelProductsEventSchema = CRUDModel(PRODUCT_LIST_SCHEMA);

    _auth = FirebaseAuth.instance;
    getCurrentUser();
    _currentBarPositionObject = this.widget.barPosClass;
    if(this.widget.isBarPosition){
      _currentBarChampagneriePositionSchema = BAR_LIST_PRODUCT_SCHEMA;

    }else if(this.widget.isChampagneriePosition){
      _currentBarChampagneriePositionSchema = CHAMPAGNERIE_LIST_PRODUCT_SCHEMA;

    }else{
      print('Error - The bar position schema must be one between ${BAR_LIST_PRODUCT_SCHEMA} or ${CHAMPAGNERIE_LIST_PRODUCT_SCHEMA}');
    }
    _insertProductBottonPressed = false;

    _alreadyUsedProductSchema = CRUDModel(_currentBarChampagneriePositionSchema
        + _currentBarPositionObject.passwordEvent.toString()
        + _currentBarPositionObject.passwordBarChampPosition.toString());
    initProductsList();
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
            title: Text(_currentBarPositionObject.name, style: TextStyle(fontFamily: 'LoraFont'),),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 10, 4),
                child: IconButton(onPressed: (){
                  setState(() {
                    if(_insertProductBottonPressed){
                      _insertProductBottonPressed = false;
                    }else{
                      _insertProductBottonPressed = true;
                    }

                  });
                }, icon: Icon(_insertProductBottonPressed ? Icons.close : Icons.add_rounded, size: 30,)),
              ),
            ],
          ),
          body: Container(
            color: VENTI_METRI_BLUE,
            child: SingleChildScrollView(
              child: FutureBuilder(
                initialData: <Widget>[Column(
                  children: [
                    Center(child: CircularProgressIndicator()),
                    SizedBox(),
                    Center(child: Text('Caricamento dati..',
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
      ),
    );
  }

  Future<List<Widget>> createBody() async {


    List<Widget> items = <Widget>[];
    items.add(Column(
      children: [
        _insertProductBottonPressed ? PaginatedDataTable(
          rowsPerPage: _rowsPerPage,
          availableRowsPerPage: const <int>[5, 10, 20, 25],
          onRowsPerPageChanged: (int value) {
            setState(() {
              _rowsPerPage = value;
            });
          },
          columns: kTableColumns,
          source: ProductDataSource(_productsList),
        ) : SizedBox(height: 0,),
        _insertProductBottonPressed ? RaisedButton(
          onPressed: () {
            _productsList.forEach((element) async {
              print(element.name + ' Selected? ' + element.selected.toString());
              if(element.selected){
                await _alreadyUsedProductSchema.addProductObject(element);
              }
            });
            initProductsList();
            refreshPage();
          },
          elevation: 5.0,
          color: VENTI_METRI_BLUE,
          child: Text('Aggiungi', style: TextStyle(color: Colors.white, fontSize: 21.0, fontFamily: 'LoraFont')),
        ): SizedBox(height: 0,),
        Container(
          width: MediaQuery.of(context).size.width ,
          child: Card(
            color: this.widget.isBarPosition ? VENTI_METRI_MONOPOLI : VENTI_METRI_LOCOROTONDO,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Evento : ${_currentBarPositionObject.eventName}' ,overflow: TextOverflow.ellipsis, style: TextStyle(color: this.widget.isBarPosition ? Colors.white : VENTI_METRI_BLUE, fontSize: 16.0, fontFamily: 'LoraFont')),
                  Text('Password postazione bar : ${_currentBarPositionObject.passwordBarChampPosition}' ,overflow: TextOverflow.ellipsis, style: TextStyle(color: this.widget.isBarPosition ? Colors.white : VENTI_METRI_BLUE, fontSize: 16.0, fontFamily: 'LoraFont')),
                  Text('Responsabile : ${_currentBarPositionObject.ownerBar}' ,overflow: TextOverflow.ellipsis, style: TextStyle(color: this.widget.isBarPosition ? Colors.white : VENTI_METRI_BLUE, fontSize: 16.0, fontFamily: 'LoraFont')),
                ],
              ),
            ),
          ),
        ),

        Card(
          color: VENTI_METRI_BLUE,
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 3,
                      color: Colors.white,
                      style: BorderStyle.solid)),
              children: [
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('PRODOTTO',overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('CARICO', style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('SCARICO', style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont')),
                      ),
                    ]
                ),
              ],
            ),
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection(_currentBarChampagneriePositionSchema
              + _currentBarPositionObject.passwordEvent.toString()
              + _currentBarPositionObject.passwordBarChampPosition.toString()).orderBy('name', descending: false).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return const Text('Loading data..');
            return Container(
              height: MediaQuery.of(context).size.height*6/7,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemExtent: 40,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => _buildConsumptionItems(context, snapshot.data.docs[index])
              ),
            );
          },
        ),
      ],
    ),
    );
    return items;

  }


  void refreshPage() {
    setState(() {});
  }


  Widget _buildConsumptionItems(
      BuildContext context,
      DocumentSnapshot document) {

    return ListTile(
      title: Table(
        border: TableBorder(
            horizontalInside: BorderSide(
                width: 1,
                color: Colors.white,
                style: BorderStyle.solid),
        ),

        children: _buidTableRowCounsumption(document),
      ),
    );
  }


  _buidTableRowCounsumption(DocumentSnapshot doc) {

    List<TableRow> rList = <TableRow>[];
    rList.add(
      TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 11, 8, 15),
              child: Text(loggedInUser == null ? doc['name'].toString() : doc['name'].toString() + ' (' + doc['price'].toString()+')',overflow: TextOverflow.visible, style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont')),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      TextEditingController _currentController = TextEditingController(text: doc['stock'].toString());
                      return Container(
                        height: MediaQuery.of(context).size.height * 2/4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: new Icon(Icons.edit),
                              title: new Text('Modifica CARICO per ' + doc['name'].toString()),
                            ),
                            Text(doc['measure'].toString(),overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'LoraFont')),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _currentController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(Icons.line_style),
                                  labelText: 'Quantità',
                                ),
                              ),
                            ),
                            RaisedButton(
                              elevation: 3.0,
                              onPressed: () {
                                print(_currentController.value.text);

                                if (_currentController == null) return;

                                if (_currentController.value.text == '') {
                                  FirebaseFirestore.instance.runTransaction((transaction) async{
                                    DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                                    await transaction.update(freshSnap.reference, {
                                      'stock' : 0,
                                    });
                                  });
                                };
                                if (_currentController.value.text != '') {
                                  if(double.parse(_currentController.value.text) < 0) return;

                                  if(double.tryParse(_currentController.value.text) != null){
                                    FirebaseFirestore.instance.runTransaction((transaction) async{
                                      DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                                      await transaction.update(freshSnap.reference, {
                                        'stock' : double.parse(_currentController.value.text),
                                      });
                                    });
                                  }
                                };
                                Navigator.of(context).pop(true);
                              },
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: Colors.green,
                              child: Text(
                                'Salva',
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
                      );
                    }
                    );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 11, 8, 15),
                child: Text(doc['stock'].toString(), style: TextStyle(color: Colors.lightGreen, fontSize: 20.0, fontFamily: 'LoraFont')),
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      TextEditingController _currentController = TextEditingController(text: doc['consumed'].toString());
                      return Container(
                        height: MediaQuery.of(context).size.height * 2/4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: new Icon(Icons.edit),
                              title: new Text('Modifica SCARICO per ' + doc['name'].toString()),
                            ),
                            Text(doc['measure'].toString(),overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'LoraFont')),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _currentController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(Icons.line_style),
                                  labelText: 'Quantità',
                                ),
                              ),
                            ),
                            RaisedButton(
                              elevation: 3.0,
                              onPressed: () {
                                print(_currentController.value.text);

                                if (_currentController == null) return;
                                if (_currentController.value.text == '') {
                                  FirebaseFirestore.instance.runTransaction((transaction) async{
                                    DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                                    await transaction.update(freshSnap.reference, {
                                      'consumed' : 0,
                                    });
                                  });
                                };
                                if (_currentController.value.text != '') {
                                  if(double.tryParse(_currentController.value.text) != null){
                                    FirebaseFirestore.instance.runTransaction((transaction) async{
                                      DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                                      await transaction.update(freshSnap.reference, {
                                        'consumed' : double.parse(_currentController.value.text),
                                      });
                                    });
                                  }
                                };
                                Navigator.of(context).pop(true);
                              },
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: Colors.orangeAccent,
                              child: Text(
                                'Salva',
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
                      );
                    }
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 11, 8, 15),
                child: Text(doc['consumed'].toString(), style: TextStyle(color: Colors.orangeAccent, fontSize: 20.0, fontFamily: 'LoraFont')),
              ),
            ),
          ]
      ),
    );

    return rList;
  }

  Future<void> initProductsList() async {

    List<Product> list = await _crudModelProductsEventSchema.fetchProducts();
    List<Product> alreadyUsedProduct = await _alreadyUsedProductSchema.fetchProducts();
    List<String> nameListProduct = <String>[];

    alreadyUsedProduct.forEach((element) {
      nameListProduct.add(element.name);
    });

    setState(() {
      _productsList.clear();
      _productsList.addAll(list);
      _productsList.removeWhere((element) => nameListProduct.contains(element.name));
    });
  }
}