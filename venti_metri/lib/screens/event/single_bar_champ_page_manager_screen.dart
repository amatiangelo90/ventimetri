import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/events_models/bar_position_class.dart';
import 'package:venti_metri/model/events_models/product_datasource.dart';
import 'package:venti_metri/model/events_models/product_event.dart';
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
          backgroundColor: Colors.blueGrey.shade800,
          appBar: AppBar(
            backgroundColor: VENTI_METRI_BLUE,
            centerTitle: true,
            title: Column(
              children: [
                Text(_currentBarPositionObject.name, style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('Responsabile: ' + _currentBarPositionObject.ownerBar, style: TextStyle(color: Colors.blueGrey, fontSize: 14.0, fontFamily: 'LoraFont')),
                ),
              ],
            ),
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
          body: SingleChildScrollView(
            child: Column(
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
                SizedBox(height: 5,),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Prodotto',
                          style: TextStyle(fontSize: 16.0,color: Colors.white, fontFamily: 'LoraFont'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Carico',
                          style: TextStyle(fontSize: 16.0,color: Colors.orange, fontFamily: 'LoraFont'),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Text(
                            'Scarico',
                            style: TextStyle(fontSize: 16.0,color: Colors.green, fontFamily: 'LoraFont'),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Text(
                            '',
                            style: TextStyle(fontSize: 16.0,color: Colors.green, fontFamily: 'LoraFont'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                color: Colors.blueGrey.shade800,
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
                        child: snapshot.data,
                      );
                    }else{
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Widget> createBody() async {

    return Column(
      children: [
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
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => _buildPlayerModelList(snapshot.data.docs[index], _currentBarChampagneriePositionSchema
                      + _currentBarPositionObject.passwordEvent.toString()
                      + _currentBarPositionObject.passwordBarChampPosition.toString())
              ),
            );
          },
        ),
      ],
    );

  }
  Widget _buildPlayerModelList(DocumentSnapshot doc, String currentSchema) {
    TextEditingController _textEditingControllerStock;
    if(doc['stock'].toString() != '' && doc['stock'].toString() != '0.0' && doc['stock'].toString() != '0' && doc['stock'].toString() != '0,0'){
      _textEditingControllerStock = new TextEditingController(text:doc['stock'].toString());
    }else{
      _textEditingControllerStock = new TextEditingController();
    }

    TextEditingController _textEditingControllerConsumed;
    if(doc['consumed'].toString() != '' && doc['consumed'].toString() != '0.0' && doc['consumed'].toString() != '0' && doc['consumed'].toString() != '0,0'){
      _textEditingControllerConsumed = new TextEditingController(text:doc['consumed'].toString());
    }else{
      _textEditingControllerConsumed = new TextEditingController();
    }

    bool _expanded = false;
    return Container(
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: Key(doc['id']),
        background: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(FontAwesomeIcons.trash, color: Colors.white,),
                ),
              ],
            ),
            color: Colors.deepOrangeAccent.shade700),
        child: Card(
          color: VENTI_METRI_BLUE,
          child: ExpansionTile(
            initiallyExpanded: _expanded,
            maintainState: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    doc['name'].toString(),
                    style: TextStyle(fontSize: 14.0,color: Colors.white, fontFamily: 'LoraFont'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    doc['stock'].toString(),
                    style: TextStyle(fontSize: 16.0,color: Colors.orange, fontFamily: 'LoraFont'),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text(
                      doc['consumed'].toString(),
                      style: TextStyle(fontSize: 16.0,color: Colors.green, fontFamily: 'LoraFont'),
                    ),
                  ),
                ),
              ],
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(fontSize: 16.0,color: Colors.orange, fontFamily: 'LoraFont'),
                  controller: _textEditingControllerStock,
                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder (
                      borderSide: BorderSide(color: Colors.orangeAccent, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orangeAccent, width: 1.0),
                    ),
                    border: OutlineInputBorder(

                    ),
                    labelText: 'Carico',
                    labelStyle: TextStyle(fontSize: 16.0,color: Colors.orange, fontFamily: 'LoraFont'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(fontSize: 16.0,color: Colors.green, fontFamily: 'LoraFont'),
                  controller: _textEditingControllerConsumed,
                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder (
                      borderSide: BorderSide(color: Colors.green, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1.0),
                    ),
                    border: OutlineInputBorder(

                    ),
                    labelText: 'Scarico',
                    labelStyle: TextStyle(fontSize: 16.0,color: Colors.green, fontFamily: 'LoraFont'),
                  ),
                ),
              ),
              Container(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    padding: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.blueGrey.shade700,
                    elevation: 19.0,
                    child: Text('Salva', style: TextStyle(fontSize: 18.0,color: Colors.white, fontFamily: 'LoraFont'),),
                    onPressed: (){
                      if (_textEditingControllerStock == null || _textEditingControllerConsumed == null) return;
                      double _currentStockValue = 0.0;
                      double _currentConsumedValue = 0.0;
                      if(_textEditingControllerStock.value.text.replaceAll(",", ".") != ''){
                        if(double.tryParse(_textEditingControllerStock.value.text.replaceAll(",", ".")) != null){
                          _currentStockValue = double.parse(_textEditingControllerStock.value.text.replaceAll(",", "."));
                          if(double.parse(_textEditingControllerStock.value.text.replaceAll(",", ".")) < 0) return;
                        }
                      }
                      if(_textEditingControllerConsumed.value.text.replaceAll(",", ".") != ''){
                        if(double.tryParse(_textEditingControllerConsumed.value.text.replaceAll(",", ".")) != null){
                          _currentConsumedValue = double.parse(_textEditingControllerConsumed.value.text.replaceAll(",", "."));
                          if(double.parse(_textEditingControllerConsumed.value.text.replaceAll(",", ".")) < 0) return;
                        }
                      }
                          FirebaseFirestore.instance.runTransaction((transaction) async{
                            DocumentSnapshot freshSnap = await transaction.get(doc.reference);
                            await transaction.update(freshSnap.reference, {
                              'stock' : _currentStockValue,
                            });
                            await transaction.update(freshSnap.reference, {
                              'consumed' : _currentConsumedValue,
                            });
                          });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          duration: Duration(milliseconds: 500),
                          backgroundColor: Colors.green,
                          content: Text('Aggiornamento effettuato')));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Attenzione"),
                content: Container(
                  child: Text("Eliminare la voce ${doc['name']}?"),
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Conferma")
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
        onDismissed: (direction) async {
            CRUDModel crudModel = CRUDModel(currentSchema);
            await crudModel.removeDocumentById(doc.id);
        },
      ),
    );
  }

  void refreshPage() {
    setState(() {
      if(_insertProductBottonPressed){
        _insertProductBottonPressed = false;
      }else{
        _insertProductBottonPressed = true;
      }
    });
    //setState(() {});
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