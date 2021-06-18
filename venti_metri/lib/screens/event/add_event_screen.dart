import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:venti_metri/component/round_icon_botton.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/events_models/bar_position_class.dart';
import 'package:venti_metri/model/events_models/event_class.dart';
import 'package:venti_metri/model/events_models/product_class.dart';
import 'package:venti_metri/model/events_models/product_datasource.dart';
import 'package:venti_metri/screens/event/utils_event/utils_event.dart';
import 'package:venti_metri/utils/utils.dart';

import 'event_manager_screen.dart';

class AddEventScreen extends StatefulWidget {
  static String id = 'add_event_screen';

  final Map<String, EventClass> alreadyUsedPasswordMap;

  const AddEventScreen({@required this.alreadyUsedPasswordMap});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {

  final DatePickerController _dateController = DatePickerController();
  final ScrollController _scrollViewController = ScrollController();
  var uuid = Uuid();

  int _counterBar = 1;
  int _counterChampagnerie = 1;
  DateTime _currentSelectedDate;
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _passwordEventController = TextEditingController();
  Map<String, EventClass> _alreadyUsedPasswordMap;
  bool _isCreaSerataNotPressed = true;

  CRUDModel _crudModelEventSchema;
  CRUDModel _crudBarProdEventSchema;
  CRUDModel _crudChampProdEventSchema;
  int _rowsPerPage = 5;
  int _rowsPerPageChampagnerie = 5;
  List<Product> _productsBarList;
  List<Product> _productsChampagnerieList;

  @override
  void initState() {
    super.initState();
    _alreadyUsedPasswordMap = this.widget.alreadyUsedPasswordMap;
    _productsBarList = <Product>[];
    _productsChampagnerieList = <Product>[];
    _crudModelEventSchema = CRUDModel(PRODUCT_LIST_SCHEMA);

    initProductsList();
  }

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        backgroundColor: VENTI_METRI_BLUE,
        appBar: AppBar(
          backgroundColor: VENTI_METRI_BLUE,
          centerTitle: true,
          title: Text('Crea Serata/Evento', style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'LoraFont'),),
        ),
        body: Container(
          color: VENTI_METRI_BLUE,
          child: SingleChildScrollView(
            controller: _scrollViewController,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    DatePicker(
                      DateTime.now(),
                      dateTextStyle: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'LoraFont'),
                      dayTextStyle: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'LoraFont'),
                      monthTextStyle: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'LoraFont'),
                      selectionColor: VENTI_METRI_MONOPOLI,
                      deactivatedColor: Colors.grey,
                      selectedTextColor: Colors.white,
                      daysCount: 20,
                      locale: 'it',
                      controller: _dateController,
                      onDateChange: (date) {
                        setState(() {
                          _currentSelectedDate = date;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: _eventNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          /*icon: Icon(Icons.line_style),*/
                          labelText: 'Nome Evento',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (currentText){
                          if(currentText.length == 4 && _alreadyUsedPasswordMap.keys.contains(currentText)){

                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                duration: Duration(milliseconds: 1500),
                                backgroundColor: Colors.redAccent,
                                content: Text('Attenzione! Password già in uso per l\'evento ${_alreadyUsedPasswordMap[currentText].title}')));
                            _refreshPassword();
                          }
                        },
                        maxLength: 4,
                        style: TextStyle(color: Colors.white),
                        controller: _passwordEventController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder (
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Text('Bar', style: TextStyle(fontSize: 17.0,color: Colors.white, fontFamily: 'LoraFont'),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RoundIconButton(
                                    color: VENTI_METRI_MONOPOLI,
                                    icon: FontAwesomeIcons.minus,
                                    function: () {
                                      setState(() {
                                        if(_counterBar > 1)
                                          _counterBar = _counterBar - 1;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 4,),
                                        Text(_counterBar.toString(), style: TextStyle(fontSize: 20.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                      ],
                                    ),
                                  ),
                                  RoundIconButton(
                                    color: VENTI_METRI_MONOPOLI,
                                    icon: FontAwesomeIcons.plus,
                                    function: () {
                                      setState(() {
                                        _counterBar = _counterBar + 1;
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
                    Text('Lista prodotti per carico bar', style: TextStyle(fontSize: 17.0,color: Colors.white, fontFamily: 'LoraFont'),),
                    PaginatedDataTable(
                      rowsPerPage: _rowsPerPage,
                      availableRowsPerPage: const <int>[5, 10, 20, 25],
                      onRowsPerPageChanged: (int value) {
                        setState(() {
                          _rowsPerPage = value;
                        });
                      },
                      columns: kTableColumns,
                      source: ProductDataSource(_productsBarList),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Text('Champagnerie', style: TextStyle(fontSize: 17.0,color: Colors.white, fontFamily: 'LoraFont'),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RoundIconButton(
                                    color: VENTI_METRI_LOCOROTONDO,
                                    icon: FontAwesomeIcons.minus,
                                    function: () {
                                      setState(() {
                                        if(_counterChampagnerie > 1)
                                          _counterChampagnerie = _counterChampagnerie - 1;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 4,),
                                        Text(_counterChampagnerie.toString(), style: TextStyle(fontSize: 20.0,color: Colors.white, fontFamily: 'LoraFont'),),
                                      ],
                                    ),
                                  ),
                                  RoundIconButton(
                                    color: VENTI_METRI_LOCOROTONDO,
                                    icon: FontAwesomeIcons.plus,
                                    function: () {
                                      setState(() {
                                        _counterChampagnerie = _counterChampagnerie + 1;
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
                    Text('Lista prodotti per carico Champagnerie', style: TextStyle(fontSize: 17.0,color: Colors.white, fontFamily: 'LoraFont'),),
                    PaginatedDataTable(
                      rowsPerPage: _rowsPerPageChampagnerie,
                      availableRowsPerPage: const <int>[5, 10, 20, 25],
                      onRowsPerPageChanged: (int value) {
                        setState(() {
                          _rowsPerPageChampagnerie = value;
                        });
                      },
                      columns: kTableColumns,
                      source: ProductDataSource(_productsChampagnerieList),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            child: Text('Clean', style: TextStyle(fontSize: 20, fontFamily: 'LoraFont' ),),

                            onPressed: () =>{
                              _clearController(),
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(VENTI_METRI_BLUE),
                            ),
                          ),
                          _isCreaSerataNotPressed ? ElevatedButton(
                            child: Text('Crea Serata', style: TextStyle(fontSize: 20, fontFamily: 'LoraFont')),
                            onPressed: () async {
                              if(_eventNameController.text == ''){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1000),
                                    backgroundColor: Colors.redAccent,
                                    content: Text('Inserire il nome Evento')));
                              }else if(_passwordEventController.text == ''){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1000),
                                    backgroundColor: Colors.redAccent,
                                    content: Text('Assegnare una password all\'evento')));
                              }else if(_passwordEventController.text.length < 4){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1000),
                                    backgroundColor: Colors.redAccent,
                                    content: Text('Inserire una passoword di 4 cifre')));
                              }else if(_currentSelectedDate == null){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 1000),
                                    backgroundColor: Colors.redAccent,
                                    content: Text('Selezionare una data valida')));
                              }else{
                                setState((){
                                  _isCreaSerataNotPressed = false;
                                });
                                /*FirebaseFirestore.instance.runTransaction((Transaction transaction) async {

                                });*/
                                CRUDModel crudModelEventSchema = CRUDModel(EVENTS_SCHEMA);
                                String eventId = uuid.v1();

                                CRUDModel crudModelBarPositionSchema = CRUDModel(BAR_POSITION_SCHEMA);

                                List<String> barPositionList = [];

                                for(int i = 0; i < _counterBar; i++){
                                  String currentId = uuid.v1();
                                  BarPositionClass barPosClass = BarPositionClass(
                                    docId: '',
                                    id: currentId,
                                    eventName: _eventNameController.value.text,
                                    name: 'Bar ' + (i+1).toString(),
                                    ownerBar: '',
                                    listDrinkId: '-',
                                    passwordEvent: int.parse(_passwordEventController.value.text),
                                    idEvent: eventId
                                  );
                                  String addBarPositionObject = await crudModelBarPositionSchema.addBarPositionObject(barPosClass);
                                  barPositionList.add(addBarPositionObject);
                                }

                                CRUDModel crudModelChampagnerieSchema = CRUDModel(CHAMPAGNERIE_SCHEMA);
                                List<String> champagnerieList = [];

                                for(int i = 0; i < _counterChampagnerie; i++){
                                  String currentId = uuid.v1();
                                  BarPositionClass barPosClass = BarPositionClass(
                                      docId: '',
                                      id: currentId,
                                      eventName: _eventNameController.value.text,
                                      name: 'Champagnerie ' + (i+1).toString(),
                                      ownerBar: '',
                                      listDrinkId: '-',
                                      passwordEvent: int.parse(_passwordEventController.value.text),
                                      idEvent: eventId
                                  );
                                  String addChampagnerieObject = await crudModelChampagnerieSchema.addBarPositionObject(barPosClass);
                                  champagnerieList.add(addChampagnerieObject);
                                }
                                _crudBarProdEventSchema = CRUDModel(BAR_LIST_PRODUCT_SCHEMA + getAppIxFromNameEvent(_eventNameController.text));
                                _crudChampProdEventSchema = CRUDModel(CHAMPAGNERIE_LIST_PRODUCT_SCHEMA + getAppIxFromNameEvent(_eventNameController.text));

                                List<String> barProdIdsList = <String>[];
                                for(int i = 0; i < _productsBarList.length; i++){
                                  if(_productsBarList[i].selected){
                                    String addProductIdBar = await _crudBarProdEventSchema.addProductObject(_productsBarList[i]);
                                    barProdIdsList.add(addProductIdBar);
                                  }
                                }
                                List<String> champProdIdsList = <String>[];
                                for(int i = 0; i < _productsChampagnerieList.length; i++){
                                  if(_productsChampagnerieList[i].selected){
                                    String addProductIdChamp = await _crudChampProdEventSchema.addProductObject(_productsChampagnerieList[i]);
                                    champProdIdsList.add(addProductIdChamp);
                                  }
                                }


                                EventClass eventClass = EventClass(
                                    docId: '',
                                    id: eventId,
                                    passwordEvent: _passwordEventController.value.text,
                                    listBarPositionIds: barPositionList,
                                    listChampagneriePositionIds: champagnerieList,
                                    date: Timestamp.fromDate(_currentSelectedDate),
                                    productBarList: barProdIdsList,
                                    title: _eventNameController.value.text,
                                    productChampagnerieList: champProdIdsList);

                                await crudModelEventSchema.addEventObject(eventClass);


                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Evento ${_eventNameController.value.text} creato per la data ${_currentSelectedDate.day}'+'/'
                                        + '${_currentSelectedDate.month}' +'/${_currentSelectedDate.year}')));
                                Navigator.pushNamed(context, PartyScreenManager.id);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(VENTI_METRI_BLUE),
                            ),
                          ) : ElevatedButton(
                            child: Text('Creazione in corso..', style: TextStyle(fontSize: 20, fontFamily: 'LoraFont')),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(VENTI_METRI_MONOPOLI),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _clearController() {
    setState((){
      _eventNameController.clear();
      _counterChampagnerie = 1;
      _counterBar = 1;
      _passwordEventController.clear();
    });
  }

  _refreshPassword() {
    setState((){
      _passwordEventController.clear();
    });
  }

  Future<void> initProductsList() async {
    var list = await _crudModelEventSchema.fetchProducts();
    var listChamp = await _crudModelEventSchema.fetchProducts();
    setState(() {
      _productsBarList.clear();
      _productsChampagnerieList.clear();
      _productsBarList.addAll(list);
      _productsChampagnerieList.addAll(listChamp);
    });

  }

  List<Product> retrieveListProductSelected(List<Product> productsChampagnerie) {
    List<Product> list = <Product>[];
    productsChampagnerie.forEach((element) {
      if(element.selected) {
        list.add(element);
      }
    });

    return list;
  }




}
