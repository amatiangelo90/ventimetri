import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/events_models/bar_position_class.dart';
import 'package:venti_metri/model/events_models/event_class.dart';
import 'package:venti_metri/model/events_models/product_event.dart';
import 'package:venti_metri/model/expence_class.dart';
import 'package:venti_metri/screens/event/utils_event/utils_event.dart';
import 'package:venti_metri/utils/utils.dart';

class RecapEventPage extends StatefulWidget {
  static String id = 'recap_page';

  final EventClass eventClass;
  final List<BarPositionClass> barPositionList;
  final List<BarPositionClass> champPositionList;


  const RecapEventPage({@required this.eventClass,
    @required this.barPositionList,
    @required this.champPositionList});

  @override
  _RecapEventPageState createState() => _RecapEventPageState();
}

class _RecapEventPageState extends State<RecapEventPage> {

  EventClass _currentEventclass;
  List<BarPositionClass> _currentBarList;
  List<BarPositionClass> _currentChampagnerieList;
  bool _insertExpencesBottonPressed;
  Map<String, double> currentBarMapData = Map<String, double>();
  Map<String, double> currentChampMapData = Map<String, double>();

  TextEditingController _casualeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  var uuid = Uuid();
  CRUDModel crudModelExpences;

  User loggedInUser;

  @override
  void initState() {
    super.initState();
    _currentEventclass = this.widget.eventClass;
    _currentBarList = this.widget.barPositionList;
    _currentChampagnerieList = this.widget.champPositionList;
    _insertExpencesBottonPressed = false;
    crudModelExpences = CRUDModel(EXPENCES_EVENT_SCHEMA + getAppIxFromNameEvent(_currentEventclass.title));
    initMaps();

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: VENTI_METRI_BLUE,
        appBar: AppBar(
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 10, 4),
              child: IconButton(onPressed: (){
                setState(() {
                  if(_insertExpencesBottonPressed){
                    _insertExpencesBottonPressed = false;
                  }else{
                    _insertExpencesBottonPressed = true;
                  }

                });
              }, icon: Icon(_insertExpencesBottonPressed ? Icons.close : Icons.add_rounded, size: 30,)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 10, 4),
              child: IconButton(onPressed: (){
                refresh();
              }, icon: Icon(Icons.refresh)),
            ),
          ],
          backgroundColor: VENTI_METRI_BLUE,
          title: const Text('Resoconto', style: TextStyle(color: Colors.white, fontSize: 17.0, fontFamily: 'LoraFont')),
        ),
        body: Container(
          child: FutureBuilder(
            initialData: <Widget>[Column(
              children: [
                Center(child: CircularProgressIndicator(
                  color: VENTI_METRI_PINK,
                )),
                const SizedBox(),
                const Center(child: Text('Caricamento dati..',
                  style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                ),),
              ],
            )],
            future: buildWidgetListExpences(),
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
    );
  }


  Future buildWidgetListExpences() async {

    List<Widget> listOut = <Widget>[
      Container(
          width: double.infinity,
          height: 35,
          child: Card(child: Center(child: Text(_currentEventclass.title,style: TextStyle(fontSize: 19, color: VENTI_METRI_BLUE, fontFamily: 'LoraFont'),)))),
    ];

    var expenceList = await crudModelExpences.fetchAllExpences();

    double _total = 0.0;

    expenceList.forEach((element) {
      _total = _total + (double.parse(element.amount) * double.parse(element.details));
    });
    currentBarMapData.keys.forEach((element) {
      _total = _total + currentBarMapData[element];
    });

    currentChampMapData.keys.forEach((element) {
      _total = _total + currentChampMapData[element];
    });


    if(_insertExpencesBottonPressed){

      listOut.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Inserisci Importo e Dettaglio Costi',style: TextStyle(fontSize: 15, color: VENTI_METRI_MONOPOLI, fontFamily: 'LoraFont'),)),
          ),
      );

      listOut.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                  style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'LoraFont'),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    labelText: 'Quantità',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('x', style: TextStyle(fontSize: 20, color: Colors.white),),
              ),
              Flexible(
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                  style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'LoraFont'),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    labelText: 'Prezzo',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      listOut.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _casualeController,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'LoraFont'),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
              ),
              focusColor: Colors.white,
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              labelText: 'Casuale',
            ),
          ),
        ),
      );
      listOut.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            textColor: Colors.green,
            onPressed: () async {
              if(_casualeController.text == ''){
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text('Immettere la casuale')));
              }else if(double.tryParse(_amountController.text.replaceAll(",", ".")) == null){
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text('Formato del numero non valido (Quantità).')));
              }else if(double.tryParse(_priceController.text.replaceAll(",", ".")) == null){
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text('Formato del numero non valido (Prezzo).')));
              }else if(_amountController.text == '' || double.parse(_amountController.text.replaceAll(",", ".")) == 0){
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text('Inserire la quantità')));
              }else if(_priceController.text == '' || double.parse(_priceController.text.replaceAll(",", ".")) == 0){
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text('Immettere l\'importo')));
              } else{

                var dateTime = DateTime.now();
                ExpenceClass expenceClass = ExpenceClass(
                    id: uuid.v1(),
                    casuale: _casualeController.text.replaceAll("\"", "\'"),
                    amount: _priceController.text.replaceAll(",", "."),
                    date: Timestamp.fromDate(DateTime.now()),
                    month: dateTime.month.toString(),
                    hour: dateTime.hour.toString()+ ":" +  dateTime.minute.toString() + ":" + dateTime.second.toString(),
                    details: _amountController.text.replaceAll(",", "."),
                    inout: 'OUT',
                    location: _currentEventclass.title,
                    official: 'false'
                );

                await crudModelExpences.addExpenceObject(expenceClass);

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Voce spesa salvata correttamente')));

                setState(() {
                  _insertExpencesBottonPressed = false;
                  _casualeController.clear();
                  _priceController.clear();
                  _amountController.clear();
                });
              }

            },
            child: Text('Salva'),

          ),
        ),
      );
    }

    listOut.add(
        ExpansionTile(
            trailing: SizedBox.shrink(),
            initiallyExpanded: false,
            maintainState: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(flex: 2,child: Text('Casuale', style: TextStyle(fontSize: 15, color: VENTI_METRI_LOCOROTONDO),)),
              Expanded(flex: 1,child: Text('Q', style: TextStyle(fontSize: 15,color: VENTI_METRI_LOCOROTONDO),)),
              Expanded(flex: 1,child: Text('€', style: TextStyle(fontSize: 15,color: VENTI_METRI_LOCOROTONDO),)),
              Expanded(flex: 0,child: Text('Totale', style: TextStyle(fontSize: 15, color: VENTI_METRI_LOCOROTONDO),)),
            ],
          ),
        ),
    );

    expenceList.forEach((currentExpenceObject) {
      TextEditingController _currentAmountController = TextEditingController(text: currentExpenceObject.details.toString());
      TextEditingController _currentPriceController = TextEditingController(text: currentExpenceObject.amount.toString());

      listOut.add(
        Dismissible(
          direction: DismissDirection.endToStart,
          key: Key(currentExpenceObject.id),
          onDismissed: (direction) {
            crudModelExpences.removeDocumentById(currentExpenceObject.documentId);
            setState(() {
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
                duration: Duration(milliseconds: 600),
                backgroundColor: VENTI_METRI_RED,
                content: Text("${currentExpenceObject.casuale} eliminato")
            ));
          },
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
              color: Colors.red.shade900),
          child: Card(
            color: VENTI_METRI_BLUE,
            child: ExpansionTile(
                trailing: SizedBox.shrink(),
                initiallyExpanded: false,
                maintainState: false,
                onExpansionChanged: (change) {
                  setState((){
                    _insertExpencesBottonPressed = false;
                  });
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(flex: 2,child: Text('${currentExpenceObject.casuale.toString()}', style: TextStyle(fontSize: 13,color: Colors.white),)),
                    Expanded(flex: 1,child: Text('${currentExpenceObject.details.toString()}', style: TextStyle(fontSize: 13,color: Colors.blueGrey.shade300),)),
                    Expanded(flex: 1,child: Text('${currentExpenceObject.amount.toString()}', style: TextStyle(fontSize: 13,color: Colors.blueGrey.shade300),)),
                    Expanded(flex: 0,child: Text((double.parse(currentExpenceObject.details) * double.parse(currentExpenceObject.amount)).toStringAsFixed(2), style: TextStyle(fontSize: 13,color: Colors.greenAccent),)),
                  ],
                ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: _currentAmountController,
                          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                          style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'LoraFont'),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0),
                            ),
                            focusColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                            labelText: 'Quantità',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('x', style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
                      Flexible(
                        child: TextField(
                          controller: _currentPriceController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                          style: TextStyle(fontSize: 17, color: Colors.white, fontFamily: 'LoraFont'),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0),
                            ),
                            focusColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(),
                            labelText: 'Prezzo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  textColor: Colors.orange,
                  onPressed: () async {
                    if(double.tryParse(_currentAmountController.text.replaceAll(",", ".")) == null){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('Formato del numero non valido (Quantità).')));
                    }else if(double.tryParse(_currentPriceController.text.replaceAll(",", ".")) == null){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('Formato del numero non valido (Prezzo).')));
                    }else if(_currentAmountController.text == '' || double.parse(_currentAmountController.text.replaceAll(",", ".")) == 0){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('Inserire la quantità')));
                    }else if(_currentPriceController.text == '' || double.parse(_currentPriceController.text.replaceAll(",", ".")) == 0){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('Immettere l\'importo')));
                    } else{

                      currentExpenceObject.amount = _currentPriceController.value.text;
                      currentExpenceObject.details = _currentAmountController.value.text;

                      await crudModelExpences.updateExpence(currentExpenceObject, currentExpenceObject.documentId);

                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Voce spesa aggiornata correttamente')));

                      refresh();
                    }

                  },
                  child: Text('Aggiorna'),

                ),
              ],
            ),
          ),
        ),
      );
    });

    try{
      currentBarMapData.keys.forEach((currentBarChampagnerie) {
        listOut.add(
          Card(
            color: VENTI_METRI_BLUE,
            child: ExpansionTile(
              trailing: SizedBox.shrink(),
              initiallyExpanded: false,
              maintainState: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(flex: 2,child: Text(currentBarChampagnerie, style: TextStyle(fontSize: 13,color: Colors.white),)),
                  Expanded(flex: 1,child: Text('1', style: TextStyle(fontSize: 13,color: Colors.blueGrey.shade300),)),
                  Expanded(flex: 1,child: Text(currentBarMapData[currentBarChampagnerie].toStringAsFixed(2), style: TextStyle(fontSize: 13,color: Colors.blueGrey.shade300),)),
                  Expanded(flex: 0,child: Text(currentBarMapData[currentBarChampagnerie].toStringAsFixed(2), style: TextStyle(fontSize: 13,color: Colors.greenAccent),)),
                ],
              ),
              children: [
              Container(
                  child: FutureBuilder(
                    initialData: <Widget>[Column(
                      children: [
                        Center(child: CircularProgressIndicator(
                          color: VENTI_METRI_LOCOROTONDO,
                        )),
                        SizedBox(height: 4,),
                        Center(child: Text('Caricamento dati per tabella resoconto..',
                          style: TextStyle(fontSize: 14.0, color: Colors.white, fontFamily: 'LoraFont'),
                        ),),
                      ],
                    )],
                    future: buildCurrentBarRecapTable(currentBarChampagnerie),
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
              ],
            ),
          ),
        );
      });
    }catch(e){
      print('Error : ' + e);
    }


    try{
      currentChampMapData.keys.forEach((element) {
        listOut.add(
          Card(
            color: VENTI_METRI_BLUE,
            child: ExpansionTile(
              trailing: SizedBox.shrink(),
              initiallyExpanded: false,
              maintainState: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(flex: 2,child: Text(element, style: TextStyle(fontSize: 13,color: Colors.white),)),
                  Expanded(flex: 1,child: Text('1', style: TextStyle(fontSize: 13,color: Colors.blueGrey.shade300),)),
                  Expanded(flex: 1,child: Text(currentChampMapData[element].toStringAsFixed(2), style: TextStyle(fontSize: 13,color: Colors.blueGrey.shade300),)),
                  Expanded(flex: 0,child: Text(currentChampMapData[element].toStringAsFixed(2), style: TextStyle(fontSize: 13,color: Colors.greenAccent),)),
                ],
              ),
              //children: buildCurrentChampagnerieRecapTable(element),
            ),
          ),
        );
      });
    }catch(e){
      print('Error : ' + e);
    }


    listOut.add(
      ExpansionTile(
          trailing: SizedBox.shrink(),
          initiallyExpanded: false,
          maintainState: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(flex: 6,child: Text('Tot.', style: TextStyle(fontSize: 15, color: VENTI_METRI_LOCOROTONDO),)),
              Expanded(flex: 1,child: Text('', style: TextStyle(fontSize: 15,color: VENTI_METRI_LOCOROTONDO),)),
              Expanded(flex: 1,child: Text('', style: TextStyle(fontSize: 15,color: VENTI_METRI_LOCOROTONDO),)),
              Expanded(flex: 0,child: Text('€ ' + _total.toStringAsFixed(2), style: TextStyle(fontSize: 15, color: VENTI_METRI_LOCOROTONDO),)),
            ],
          )
      ),
    );

    return listOut;
  }

  double getExpencesByListProducts(List<Product> fetchProducts) {

    double sum = 0.0;
    fetchProducts.forEach((element) {
      sum = sum + (element.stock - element.consumed);
    });

    return sum;


  }

  void initMaps() {


    _currentBarList.forEach((currentBarPositionObject) async {
      CRUDModel currentBarSchema = CRUDModel(BAR_LIST_PRODUCT_SCHEMA
          + currentBarPositionObject.passwordEvent.toString()
          + currentBarPositionObject.passwordBarChampPosition.toString());

      var fetchProducts = await currentBarSchema.fetchProducts();
      currentBarMapData[currentBarPositionObject.name] = getExpencesByListProducts(fetchProducts);

    });

    _currentChampagnerieList.forEach((currentChampPositionObject) async {
      CRUDModel currentBarSchema = CRUDModel(CHAMPAGNERIE_LIST_PRODUCT_SCHEMA
          + currentChampPositionObject.passwordEvent.toString()
          + currentChampPositionObject.passwordBarChampPosition.toString());

      var fetchProducts = await currentBarSchema.fetchProducts();
      currentChampMapData[currentChampPositionObject.name] = getExpencesByListProducts(fetchProducts);
    });

  }

  void refresh() {
    setState(() {
    });
  }

  //RECAP
  Future<List<Widget>> buildRecapTableBarChampConsumption(BarPositionClass currentBarChampagneriePos,
      bool barRecap,
      bool champRecap) async{

    String currentSchema;

    if(barRecap){
      currentSchema = BAR_LIST_PRODUCT_SCHEMA;
    } else if(champRecap){
      currentSchema = CHAMPAGNERIE_LIST_PRODUCT_SCHEMA;
    }
    List<Widget> listOut = <Widget>[];

    if(currentBarChampagneriePos != null){
        print('Schema to retrieve bar/champagnerie product ' + currentSchema + currentBarChampagneriePos.passwordEvent.toString() + currentBarChampagneriePos.passwordBarChampPosition.toString());
        CRUDModel currentCrudModel = CRUDModel(currentSchema + currentBarChampagneriePos.passwordEvent.toString() + currentBarChampagneriePos.passwordBarChampPosition.toString());
        List<Product> currentProductList = await currentCrudModel.fetchProducts();
        listOut.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 8),
            child: Card(
              color: barRecap ? VENTI_METRI_MONOPOLI : VENTI_METRI_LOCOROTONDO,
              child: Center(
                child: Column(
                  children: [
                    Text('${currentBarChampagneriePos.name}', style: TextStyle(fontSize: 17, color: barRecap ? Colors.white : VENTI_METRI_BLUE, fontFamily: 'LoraFont')),
                    currentBarChampagneriePos.ownerBar != '' ? Text('Responsabile : ${currentBarChampagneriePos.ownerBar}', style: TextStyle(fontSize: 17, color: barRecap ? Colors.white : VENTI_METRI_BLUE, fontFamily: 'LoraFont')) : SizedBox(height: 0,),
                  ],
                ),
              ),
            ),
          ),
        );
        listOut.add(
            buildTableWithCurrentBarChampagnerieProductElements(currentProductList)
        );
    }

    print('SDSDSDDQDFQSD');
    print('List: ' + listOut.toString());
    return listOut;
  }

  Widget buildTableWithCurrentBarChampagnerieProductElements(List<Product> currentProductList) {

    print("XXXXXX");
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

  buildCurrentBarRecapTable(String currentBarChampagnerie) {
    print('123123123123123123123');
    _currentBarList.forEach((element) {
      print(element.name);
      print(currentBarChampagnerie);
      if(element.name == currentBarChampagnerie){
        return buildRecapTableBarChampConsumption(element, true, false);
      }
    });
  }

  buildCurrentChampagnerieRecapTable(String currentBarChampagnerie) {
    print('123123123rerferf123123123123');
    _currentBarList.forEach((element) {
      if(element.name == currentBarChampagnerie){
        return buildRecapTableBarChampConsumption(element, false, true);
      }
    });
  }
}
