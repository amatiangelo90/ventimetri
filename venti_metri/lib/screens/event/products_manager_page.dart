import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:venti_metri/component/round_icon_botton.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/events_models/content_page.dart';
import 'package:venti_metri/model/events_models/product_class.dart';
import 'package:venti_metri/model/events_models/product_datasource.dart';
import 'package:venti_metri/utils/utils.dart';

class ProductPageManager extends StatefulWidget {
  static String id = 'product_page_manager';
  @override
  _ProductPageManagerState createState() => _ProductPageManagerState();
}

class _ProductPageManagerState extends State<ProductPageManager> {

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  List<Product> _products;
  List<String> choicedChangesList = [];
  String _currentMeasureChoiced = '';
  CRUDModel _crudModelEventSchema;
  var uuid = Uuid();

  double _price = 0;
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _measureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _products = [];
    _crudModelEventSchema = CRUDModel(PRODUCT_LIST_SCHEMA);
    initProductsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestione Prodotti'),
        backgroundColor: VENTI_METRI_BLUE,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.trash,
              color: Colors.redAccent,
              size: 20,),
            onPressed: () async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Conferma", style: TextStyle(color: Colors.white, fontSize: 19.0, fontFamily: 'LoraFont'),),
                    content: Text("Eliminare i prodotti selezionati?", style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 16.0, fontFamily: 'LoraFont'),),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: (){
                            bool productSelected = false;
                            _products.forEach((element) async {

                              if(element.selected){
                                productSelected = true;
                                await _crudModelEventSchema.removeDocumentById(element.docId);
                              }
                            });
                            if(productSelected){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: Duration(milliseconds: 500),
                                  backgroundColor: Colors.orange,
                                  content: Text('Prodotti eliminati')
                              ),
                              );
                            }else{
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  duration: Duration(milliseconds: 500),
                                  backgroundColor: Colors.redAccent,
                                  content: Text('Nessun prodotto selezionato')
                              ),
                              );
                            }

                            _productNameController.clear();
                            _price = 0;
                            _currentMeasureChoiced = '';
                            initProductsList();
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
          ),

        ],
      ),
      body: Container(
        color: VENTI_METRI_BLUE,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          controller: _productNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nome Prodotto',
                            labelStyle: TextStyle(color: Colors.white),

                            focusedBorder: OutlineInputBorder (
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            Content(
                              child: ChipsChoice<String>.single(
                                choiceActiveStyle: C2ChoiceStyle(
                                  color: VENTI_METRI_MONOPOLI,
                                ),
                                choiceStyle: C2ChoiceStyle(
                                    color: VENTI_METRI_BLUE
                                ),
                                value: _currentMeasureChoiced,
                                onChanged: (val) => setState(() => _currentMeasureChoiced = val),
                                choiceItems: C2Choice.listFrom<String, String>(
                                  source: ['Bottiglia 75cl','Bottiglia 33cl','Lattina 33cl','Kg','l','Pacco','Scatolo','Altro'],
                                  value: (i, v) => v,
                                  label: (i, v) => v,
                                  tooltip: (i, v) => v,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _currentMeasureChoiced == 'Altro' ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          controller: _measureController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Misura',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder (
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                            ),
                          ),
                        ),
                      ) : SizedBox(height: 0,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text('-5', style: TextStyle(fontSize: 10.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                      RoundIconButton(
                                        icon: FontAwesomeIcons.minus,
                                        function: () {
                                          setState(() {
                                            if(_price > 5)
                                              _price = _price - 5;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('-0.5', style: TextStyle(fontSize: 10.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                      RoundIconButton(
                                        icon: FontAwesomeIcons.minus,
                                        function: () {
                                          setState(() {
                                            if(_price > 1)
                                              _price = _price - 0.5;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('-0.1', style: TextStyle(fontSize: 10.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                      RoundIconButton(
                                        icon: FontAwesomeIcons.minus,
                                        function: () {
                                          setState(() {
                                            if(_price > 0.1)
                                              _price = _price - 0.1;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text('Prezzo', style: TextStyle(fontSize: 17.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                        SizedBox(height: 4,),
                                        Text(_price.toStringAsFixed(2) + ' €', style: TextStyle(fontSize: 20.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text('+0.1', style: TextStyle(fontSize: 10.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                      RoundIconButton(
                                        icon: FontAwesomeIcons.plus,
                                        function: () {
                                          setState(() {
                                            _price = _price + 0.1;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('+0.5', style: TextStyle(fontSize: 10.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                      RoundIconButton(
                                        icon: FontAwesomeIcons.plus,
                                        function: () {
                                          setState(() {
                                            _price = _price + 0.5;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('+5', style: TextStyle(fontSize: 10.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                      RoundIconButton(
                                        icon: FontAwesomeIcons.plus,
                                        function: () {
                                          setState(() {
                                            _price = _price + 5;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            child: Text('Clean'),
                            onPressed: () =>{
                              _productNameController.clear(),
                              _price = 0,
                              _currentMeasureChoiced = ''
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(VENTI_METRI_MONOPOLI),
                            ),
                          ),
                          ElevatedButton(
                            child: Text('Crea Prodotto'),

                            onPressed: () async {

                              if(_productNameController.text == ''){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    backgroundColor: Colors.redAccent,
                                    content: Text('Inserire il nome Evento')));
                              }else if(_price == 0){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    backgroundColor: Colors.redAccent,
                                    content: Text('Inserire il prezzo')));
                              }else if(_currentMeasureChoiced == ''){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    backgroundColor: Colors.redAccent,
                                    content: Text('Selezionare unità di misura')));
                              }else if(_currentMeasureChoiced == 'Altro' && _measureController.value.text == ''){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    backgroundColor: Colors.redAccent,
                                    content: Text('Immettere unità di misura alternativa')));

                              }else if(listContainsProduct(_productNameController.value.text, _products)){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    backgroundColor: Colors.redAccent,
                                    content: Text(_productNameController.value.text + ' già presente nella lista prodotti')));
                              } else {

                                Product productClass = Product(
                                    id: uuid.v1(),
                                    name: _productNameController.value.text,
                                    docId: '',
                                    category: 'prodotto',
                                    available: 'true',
                                    price: _price,
                                    consumed: 0,
                                    stock: 0,
                                    selected: false,
                                    measure: _currentMeasureChoiced == 'Altro' ? _measureController.value.text : _currentMeasureChoiced
                                );
                                await _crudModelEventSchema.addProductObject(productClass);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    backgroundColor: Colors.green,
                                    content: Text('Prodotto ${_productNameController.value.text} creato!')));
                                _productNameController.clear();
                                _price = 0;
                                _currentMeasureChoiced = '';
                                initProductsList();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(VENTI_METRI_MONOPOLI),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              PaginatedDataTable(
                rowsPerPage: _rowsPerPage,
                availableRowsPerPage: const <int>[5, 10, 20, 25],
                onRowsPerPageChanged: (int value) {
                  setState(() {
                    _rowsPerPage = value;
                  });
                },
                columns: kTableColumns,
                source: ProductDataSource(_products),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initProductsList() async {
    var list = await _crudModelEventSchema.fetchProducts();
    setState(() {
      _products.clear();
      _products.addAll(list);
    });

  }

  bool listContainsProduct(String text, List<Product> products) {
    bool result = false;
    if(products == null || products.length == 0){
      result = false;
    }
    products.forEach((element) {
      if(element.name.toLowerCase() == text.toLowerCase()){
        result = true;
      }
    });
    return result;
  }
}

