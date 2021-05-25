import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/expence_class.dart';
import 'package:venti_metri/utils/utils.dart';

class VentiMetriQuadriDashboard extends StatefulWidget {

  static String id = 'dashboard';
  final String branch;

  VentiMetriQuadriDashboard({this.branch});

  @override
  _VentiMetriQuadriDashboardState createState() => _VentiMetriQuadriDashboardState();
}

class _VentiMetriQuadriDashboardState extends State<VentiMetriQuadriDashboard> {

  double _width;
  double _height;
  DateTimeRange _currentDateTimeRange;
  DateTime _currentDateForDateRangePicker;

  bool _buttonMattiaPressed = false;
  bool _buttonDanielePressed = false;
  bool _buttonPosPressed = false;

  bool _buttonSpese = false;
  bool _buttonIntroiti = false;


  TextEditingController _casualeController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _daylyProfitCash = TextEditingController();
  TextEditingController _daylyProfitDaniele = TextEditingController();
  TextEditingController _daylyProfitPos = TextEditingController();
  TextEditingController _daylyProfitMattia = TextEditingController();
  TextEditingController _daylyProfitTotal = TextEditingController();

  String _currentSchemaMattiaIn;
  String _currentSchemaMattiaOut;
  String _currentSchemaDanieleIn;
  String _currentSchemaDanieleOut;
  String _currentSchemaPosIn;
  var uuid = Uuid();

  ScrollController scrollViewColtroller = ScrollController();
  ScrollController controllerExpencePage = ScrollController();
  String listType;
  String reportType;
  String insertExpencesProfitType;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime dateTimeSelected;

  final DatePickerController _dateController = DatePickerController();
  String _currentBranch;

  @override
  void dispose() {

    _daylyProfitCash.dispose();
    _daylyProfitDaniele.dispose();
    _daylyProfitPos.dispose();
    _daylyProfitMattia.dispose();
    _daylyProfitTotal.dispose();
    super.dispose();
  }

  @override
  void initState() {

    _currentBranch = this.widget.branch;
    switch(_currentBranch){
      case 'Cisternino':
        _currentSchemaMattiaIn = CIST_MATTIA_IN;
        _currentSchemaMattiaOut = CIST_MATTIA_OUT;
        _currentSchemaDanieleIn = CIST_DANIELE_IN;
        _currentSchemaDanieleOut = CIST_DANIELE_OUT;
        _currentSchemaPosIn = CIST_POS_IN;
        break;
      case 'Locorotondo':
        _currentSchemaMattiaIn = LOC_MATTIA_IN;
        _currentSchemaMattiaOut = LOC_MATTIA_OUT;
        _currentSchemaDanieleIn = LOC_DANIELE_IN;
        _currentSchemaDanieleOut = LOC_DANIELE_OUT;
        _currentSchemaPosIn = LOC_POS_IN;
        break;
      case 'Monopoli':
        _currentSchemaMattiaIn = MON_MATTIA_IN;
        _currentSchemaMattiaOut = MON_MATTIA_OUT;
        _currentSchemaDanieleIn = MON_DANIELE_IN;
        _currentSchemaDanieleOut = MON_DANIELE_OUT;
        _currentSchemaPosIn = MON_POS_IN;
        break;
    }
    dateTimeSelected = DateTime.now();
    listType = INTROITI;
    reportType = WEEKLY;

    insertExpencesProfitType = SINGLE;

    _currentDateForDateRangePicker = DateTime.now();
    _currentDateTimeRange = DateTimeRange(
      start: DateTime.utc(_currentDateForDateRangePicker.year , _currentDateForDateRangePicker.month , 1 ,0 ,0 ,0 ,0 ,0),
      end: DateTime.utc(_currentDateForDateRangePicker.year , _currentDateForDateRangePicker.month +1).subtract(Duration(days: 1)),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        color: VENTI_METRI_GREY,
        child: Scaffold(
          body: DefaultTabController(
            length: 5,
            child: Scaffold(
              key: this._scaffoldKey,
              /*floatingActionButton: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  backgroundColor: VENTI_METRI_PINK,
                  onPressed: () {
                    Navigator.pushNamed(context, AddItemScreen.id);
                  },
                  child: Icon(Icons.add),
                ),
              ),*/
              appBar: AppBar(
                actions: [
                  IconButton(icon: Icon(Icons.calendar_today,
                    size: 25.0,
                    color: Colors.white,), onPressed: (){
                    _selectDateRange(context);
                  }),
                  IconButton(icon: Icon(Icons.refresh ,
                    size: 30.0,
                    color: Colors.white,), onPressed: (){
                    setState(() {
                    });
                  }),
                ],
                title: Column(
                  children: [
                    Text(this.widget.branch ),
                    Text(_currentDateTimeRange.start.day.toString()
                        +'/'+ _currentDateTimeRange.start.month.toString()
                        +'/'+ _currentDateTimeRange.start.year.toString()
                        +' - '+ _currentDateTimeRange.end.day.toString()
                        +'/'+ _currentDateTimeRange.end.month.toString()
                        +'/'+ _currentDateTimeRange.end.year.toString()

                      , style: TextStyle(fontSize: 15),),
                  ],
                ),
                centerTitle: true,
                backgroundColor: VENTI_METRI_GREY,
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.euro_symbol),),
                    Tab(text: 'Mattia',),
                    Tab(text: 'Daniele',),
                    Tab(text: 'Pos'),
                    Tab(text: 'Totale',),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  buildDailyExpencesForm(),
                  buildExpencesManagment(MATTIA),
                  buildExpencesManagment(DANIELE),
                  buildExpencesManagment(POS),
                  buildTotalPageCounter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildExpencesManagment(String object) {

    if(object == POS){
      setState(() {
        listType = INTROITI;
      });
    }
    return SingleChildScrollView(
      controller: scrollViewColtroller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: object == POS ? Center(
              child: FlatButton(
                textColor: listType == INTROITI ? Colors.green : Colors.grey,
                onPressed: () {
                  setState(() {
                    listType = INTROITI;
                  });
                },
                child: Text(INTROITI),
              ),
            ) : ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  textColor: listType == INTROITI ? Colors.green : Colors.grey,
                  onPressed: () {
                    setState(() {
                      listType = INTROITI;
                    });
                  },
                  child: Text(INTROITI),
                ),
                FlatButton(
                  textColor: listType == SPESE ? Colors.red.shade900 : Colors.grey,
                  onPressed: () {
                    setState(() {
                      listType = SPESE;
                    });
                  },
                  child: Text(SPESE),
                ),
                FlatButton(
                  textColor: Colors.teal,
                  onPressed: () {
                    setState(() {
                      listType = CHART;
                    });
                  },
                  child: Icon(Icons.insert_chart),
                ),
              ],
            ),
          ),
          Container(
              child: FutureBuilder(
                initialData: <Widget>[Column(
                  children: [
                    Center(child: CircularProgressIndicator(
                      color: VENTI_METRI_PINK,
                    )),
                    SizedBox(),
                    Center(child: Text('Caricamento dati..',
                      style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                    ),),
                  ],
                )],
                future: getExpencesProfitList(listType, object),
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
    );
  }

  Future getExpencesProfitList(String type, String user) async {

    switch(user){
      case MATTIA:
        switch(type){
          case SPESE:
            return buildWidgetListExpences(_currentSchemaMattiaOut);
          case INTROITI:
            return buildWidgetListExpences(_currentSchemaMattiaIn);
          case CHART:
            return buildChart(_currentSchemaMattiaIn, _currentSchemaMattiaOut);
        }
        return;
      case DANIELE:
        switch(type){
          case SPESE:
            return buildWidgetListExpences(_currentSchemaDanieleOut);
          case INTROITI:
            return buildWidgetListExpences(_currentSchemaDanieleIn);
          case CHART:
            return buildChart(_currentSchemaDanieleIn, _currentSchemaDanieleOut);
        }
        return;
      case POS:
        switch(type){
          case SPESE:
            return buildWidgetListExpences('-');
          case INTROITI:
            return buildWidgetListExpences(_currentSchemaPosIn);
        }
        return;
    }
  }

  buildWidgetListExpences(String schema) async {

    List<Widget> listOut = <Widget>[];


    CRUDModel crudModel = CRUDModel(schema);
    var expenceList = await crudModel.fetchExpences(_currentDateTimeRange.start, _currentDateTimeRange.end);

    double sum = 0.0;

    expenceList.forEach((element) {
      sum = sum + double.parse(element.amount);
    });

    listOut.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text('Totale : ' + sum.toString())),
      ),
    );

    expenceList.forEach((element) {

      listOut.add(
        Dismissible(
          direction: DismissDirection.endToStart,
          key: Key(element.id),
          onDismissed: (direction) {
            crudModel.removeProduct(element.documentId);
            setState(() {
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
                backgroundColor: VENTI_METRI_RED,
                content: Text("${element.casuale} in data ${element.date} eliminato")
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
            color: VENTI_METRI_GREY,
            child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text('${element.casuale.toString()}', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text('${element.date.toDate().day.toString() + '/' + element.date.toDate().month.toString() + '/' + element.date.toDate().year.toString()}', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text('${element.amount.toString()} €', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.edit, color: Colors.white,),
                      ],
                    ),
                  ],
                )
            ),
          ),
        ),
      );
    });

    print('ListSize: ' + listOut.length.toString());
    return listOut;
  }


  Future buildChart(String schema_in, String schema_out) async {

    double _sumProfits = 0.0;
    double _sumExpences = 0.0;

    CRUDModel profitCrudModel = CRUDModel(schema_in);
    var profitList = await profitCrudModel.fetchExpences(_currentDateTimeRange.start, _currentDateTimeRange.end);

    CRUDModel expenceCrudModel = CRUDModel(schema_out);
    var expenceList = await expenceCrudModel.fetchExpences(_currentDateTimeRange.start, _currentDateTimeRange.end);

    profitList.forEach((element) {
      _sumProfits = _sumProfits + double.parse(element.amount);
    });

    expenceList.forEach((element) {
      _sumExpences = _sumExpences + double.parse(element.amount);
    });

    List<Widget> expenceListWidget = <Widget>[];

    expenceListWidget.add(
      Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        Text('Introiti totali'),
                      ],
                    ),
                    Column(
                        children: [
                          Text(_sumProfits.toString(), style: TextStyle(fontSize: 20, color: VENTI_METRI_GREY),),
                        ]
                    ),
                  ],
                ),
                Column(
                  children: [
                    Column(
                      children: [
                        Text('Spese totali'),
                      ],
                    ),
                    Column(
                        children: [
                          Text(_sumExpences.toString(), style: TextStyle(fontSize: 20, color: Colors.redAccent.shade700),),
                        ]
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: Column(
                children: [
                  Column(
                    children: [
                      Text('Utile'),
                    ],
                  ),
                  Column(
                      children: [
                        Text((_sumProfits - _sumExpences).toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: _sumProfits>_sumExpences ? Colors.green : Colors.redAccent.shade700),
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return expenceListWidget;
  }

  buildDailyExpencesForm() {
    return SingleChildScrollView(
      controller: scrollViewColtroller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          insertExpencesProfitType == DAILY ? Container(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          textColor: insertExpencesProfitType == SINGLE ? Colors.green : Colors.grey,
                          onPressed: () {
                            setState(() {
                              insertExpencesProfitType = SINGLE;
                            });
                          },
                          child: Text(SINGLE),
                        ),
                        FlatButton(
                          textColor: insertExpencesProfitType == DAILY ? Colors.red.shade900 : Colors.grey,
                          onPressed: () {
                            setState(() {
                              insertExpencesProfitType = DAILY;
                            });
                          },
                          child: Text(DAILY),
                        ),
                      ],
                    ),
                    DatePicker(
                      DateTime.now(),
                      initialSelectedDate: DateTime.now(),
                      dateTextStyle: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),
                      dayTextStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),
                      monthTextStyle: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'LoraFont'),
                      selectionColor: VENTI_METRI_PINK,
                      deactivatedColor: Colors.grey,
                      selectedTextColor: Colors.white,
                      daysCount: 50,
                      locale: 'it',
                      controller: _dateController,
                      onDateChange: (date) {
                        setState(() {
                          dateTimeSelected = date;
                        });
                      },
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _daylyProfitCash,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.euro_symbol),
                          labelText: 'Cash',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _daylyProfitDaniele,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person),
                          labelText: 'Daniele',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _daylyProfitMattia,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person),
                          labelText: 'Mattia',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _daylyProfitPos,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.credit_card),
                          labelText: 'Pos',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _daylyProfitTotal,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.line_style),
                          labelText: 'Totale',
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          textColor: Colors.green,

                          onPressed: () async {


                            if(double.parse(_daylyProfitPos.text) > double.parse(_daylyProfitDaniele.text)){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text('Importo Pos > Importo Daniele')));

                            }else{
                              setState(() {
                                _daylyProfitTotal.text = (double.parse(_daylyProfitPos.text) + double.parse(_daylyProfitCash.text)).toString();
                                _daylyProfitMattia.text = (double.parse(_daylyProfitTotal.text) - double.parse(_daylyProfitDaniele.text)).toString();
                              });
                              CRUDModel crudModel = CRUDModel(_currentSchemaMattiaIn);
                              ExpenceClass expenceClass = ExpenceClass(
                                  id: uuid.v1(),
                                  casuale: 'Introiti Mattia',
                                  amount: (double.parse(_daylyProfitTotal.text) - double.parse(_daylyProfitDaniele.text)).toString(),
                                  date: Timestamp.fromDate(dateTimeSelected),
                                  month: dateTimeSelected.month.toString(),
                                  hour: '',
                                  details: '',
                                  inout: 'IN',
                                  location: _currentBranch,
                                  official: 'N'
                              );
                              await crudModel.addExpenceObject(expenceClass);
                              CRUDModel crudModelDaniele = CRUDModel(_currentSchemaDanieleIn);
                              ExpenceClass expenceClassDaniele = ExpenceClass(
                                  id: uuid.v1(),
                                  casuale: 'Introiti Daniele',
                                  amount: _daylyProfitDaniele.text,
                                  date: Timestamp.fromDate(dateTimeSelected),
                                  month: dateTimeSelected.month.toString(),
                                  hour: '',
                                  details: '',
                                  inout: 'IN',
                                  location: _currentBranch,
                                  official: 'N'
                              );
                              await crudModelDaniele.addExpenceObject(expenceClassDaniele);

                              CRUDModel crudModelPos = CRUDModel(_currentSchemaPosIn);
                              ExpenceClass expenceClassPos = ExpenceClass(
                                  id: uuid.v1(),
                                  casuale: 'Introiti Pos',
                                  amount: _daylyProfitPos.text,
                                  date: Timestamp.fromDate(dateTimeSelected),
                                  month: dateTimeSelected.month.toString(),
                                  hour: '',
                                  details: '',
                                  inout: 'IN',
                                  location: _currentBranch,
                                  official: 'N'
                              );
                              await crudModelPos.addExpenceObject(expenceClassPos);
                              _daylyProfitTotal.clear();
                              _daylyProfitCash.clear();
                              _daylyProfitMattia.clear();
                              _daylyProfitDaniele.clear();
                              _daylyProfitPos.clear();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Dati Salvati')));
                              setState(() {});

                            }
                          },
                          child: Text('Salva'),
                        ),
                        FlatButton(
                          textColor: Colors.deepOrange.shade500,
                          onPressed: () async {

                            setState(() {
                              _daylyProfitTotal.text = (double.parse(_daylyProfitPos.text) + double.parse(_daylyProfitCash.text)).toString();
                              _daylyProfitMattia.text = (double.parse(_daylyProfitTotal.text) - double.parse(_daylyProfitDaniele.text)).toString();
                            });
                          },
                          child: Text('Calcola'),
                        ),
                        FlatButton(
                          textColor: VENTI_METRI_GREY,
                          onPressed: () async {
                            setState(() {
                              _daylyProfitTotal.clear();
                              _daylyProfitCash.clear();
                              _daylyProfitMattia.clear();
                              _daylyProfitDaniele.clear();
                              _daylyProfitPos.clear();
                            });
                          },
                          child: Text('Clear'),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ) : Container(
            height: _height - 150,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView(
                children: <Widget>[
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        textColor: insertExpencesProfitType == SINGLE ? Colors.red.shade900 : Colors.grey,
                        onPressed: () {
                          setState(() {
                            insertExpencesProfitType = SINGLE;
                          });
                        },
                        child: Text(SINGLE),
                      ),
                      FlatButton(
                        textColor: insertExpencesProfitType == DAILY ?  Colors.green : Colors.grey,
                        onPressed: () {
                          setState(() {
                            insertExpencesProfitType = DAILY;
                          });
                        },
                        child: Text(DAILY),
                      ),
                    ],
                  ),
                  DatePicker(
                    DateTime.now(),
                    initialSelectedDate: DateTime.now(),
                    dateTextStyle: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),
                    dayTextStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),
                    monthTextStyle: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'LoraFont'),
                    selectionColor: VENTI_METRI_PINK,
                    deactivatedColor: Colors.grey,
                    selectedTextColor: Colors.white,
                    daysCount: 50,
                    locale: 'it',
                    controller: _dateController,
                    onDateChange: (date) {
                      setState(() {
                        dateTimeSelected = date;
                      });
                    },
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton.extended(
                        label: Text('Mattia', style: TextStyle(color: Colors.white),),
                        elevation: 5.0,
                        backgroundColor: _buttonMattiaPressed ? VENTI_METRI_GREY : Colors.grey,
                        onPressed: () {
                          setState(() {
                            _buttonMattiaPressed = true;
                            _buttonDanielePressed = false;
                            _buttonPosPressed = false;

                          });
                        },
                      ),
                      FloatingActionButton.extended(
                        label: Text('Daniele', style: TextStyle(color: Colors.white),),
                        elevation: 5.0,
                        backgroundColor: _buttonDanielePressed ? VENTI_METRI_GREY : Colors.grey,
                        onPressed: () {
                          setState(() {
                            _buttonMattiaPressed = false;
                            _buttonDanielePressed = true;
                            _buttonPosPressed = false;

                          });
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 3,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.euro),
                        labelText: 'Importo',
                      ),
                    ),
                  ),
                  const SizedBox(height: 3,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _casualeController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.line_style),
                        labelText: 'Casuale',
                      ),
                    ),
                  ),
                  
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        textColor: Colors.green,
                        onPressed: () async {
                          if(_buttonMattiaPressed == false && _buttonDanielePressed == false){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text('Selezionare uno fra Daniele e Mattia')));
                          }else if(_casualeController.text == ''){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text('Immettere la casuale spesa')));
                          }else if(_amountController.text == '' || double.parse(_amountController.text) == 0){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text('Immettere l\'importo')));
                          }else{

                            //TODO to delete _buttonSpese = true; se torniamo alla gestione spese/incassi
                            _buttonSpese = true;
                            var dateTime = DateTime.now();
                            ExpenceClass expenceClass = ExpenceClass(
                                id: uuid.v1(),
                                casuale: _casualeController.text,
                                amount: _amountController.text,
                                date: Timestamp.fromDate(dateTimeSelected),
                                month: dateTime.month.toString(),
                                hour: dateTime.hour.toString()+ ":" +  dateTime.minute.toString() + ":" + dateTime.second.toString(),
                                details: '',
                                inout: _buttonSpese ? 'OUT' : 'IN',
                                location: this._currentBranch,
                                official: 'N'
                            );

                            CRUDModel crudModel = CRUDModel(retrieveSchemaByButtonConfiguration(
                                _buttonMattiaPressed,
                                _buttonDanielePressed,
                                _buttonPosPressed,
                                _buttonSpese,
                                _buttonIntroiti,
                                _currentBranch
                            ));

                            await crudModel.addExpenceObject(expenceClass);

                            setState(() {
                              _buttonMattiaPressed = false;
                              _buttonDanielePressed = false;
                              _buttonPosPressed = false;
                              _casualeController.clear();
                              _amountController.clear();
                              _buttonSpese = false;
                              _buttonIntroiti = false;
                            });
                          }

                        },
                        child: Text('Salva'),

                      ),
                      FlatButton(
                        textColor: VENTI_METRI_GREY,
                        onPressed: () {
                          setState(() {
                            _buttonMattiaPressed = false;
                            _buttonDanielePressed = false;
                            _buttonPosPressed = false;
                            _casualeController.clear();
                            _amountController.clear();
                            _buttonSpese = false;
                            _buttonIntroiti = false;
                          });
                        },
                        child: Text('Clean'),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateMattia(TextEditingValue value, TextEditingValue value2) {

    int sub = (int.parse(value.toString())) - (int.parse(value2.toString()));
    print(sub);
    return double.parse(sub.toString());
  }

  String retrieveSchemaByButtonConfiguration(
      bool buttonMattiaPressed,
      bool buttonDanielePressed,
      bool buttonPosPressed,
      bool buttonSpese,
      bool buttonIntroiti,
      String currentBranch
      ) {
    switch(currentBranch){
      case 'Cisternino':
        if(buttonSpese){
          if(buttonMattiaPressed){
            return CIST_MATTIA_OUT;
          }else if(buttonDanielePressed){
            return CIST_DANIELE_OUT;
          }else{

          }
        }else if(buttonIntroiti){
          if(buttonMattiaPressed){
            return CIST_MATTIA_IN;
          }else if(buttonDanielePressed){
            return CIST_DANIELE_IN;
          }else if(buttonPosPressed){
            return CIST_POS_IN;
          }
        }else{

        }
        break;
      case 'Locorotondo':
        if(buttonSpese){
          if(buttonMattiaPressed){
            return CIST_MATTIA_OUT;
          }else if(buttonDanielePressed){
            return CIST_DANIELE_OUT;
          }else{

          }
        }else if(buttonIntroiti){
          if(buttonMattiaPressed){
            return LOC_MATTIA_IN;
          }else if(buttonDanielePressed){
            return LOC_DANIELE_IN;
          }else if(buttonPosPressed){
            return LOC_POS_IN;
          }
        }else{

        }
        break;
      case 'Monopoli':
        if(buttonSpese){
          if(buttonMattiaPressed){
            return MON_MATTIA_OUT;
          }else if(buttonDanielePressed){
            return MON_DANIELE_OUT;
          }else{

          }
        }else if(buttonIntroiti){
          if(buttonMattiaPressed){
            return MON_MATTIA_IN;
          }else if(buttonDanielePressed){
            return MON_DANIELE_IN;
          }else if(buttonPosPressed){
            return MON_POS_IN;
          }
        }else{

        }
        break;
    }
  }

  buildTotalPageCounter() {
    return SingleChildScrollView(
      controller: scrollViewColtroller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  textColor: reportType == WEEKLY ? Colors.green : Colors.grey,
                  onPressed: () {
                    setState(() {
                      reportType = WEEKLY;
                    });
                  },
                  child: Text(WEEKLY),
                ),
                FlatButton(
                  textColor: reportType == MONTHLY ? Colors.green : Colors.grey,
                  onPressed: () {
                    setState(() {
                      reportType = MONTHLY;
                    });
                  },
                  child: Text(MONTHLY),
                ),
              ],
            ),
          ),
          Container(
              child: FutureBuilder(
                initialData: <Widget>[
                  Column(
                    children: [
                      Center(child: CircularProgressIndicator(
                        color: VENTI_METRI_PINK,
                      )),
                      SizedBox(),
                      Center(child: Text('Caricamento dati..',
                        style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                      ),),
                    ],
                  )],
                future: getReportPageByReportType(reportType),
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
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange dateTimeRange = await showDateRangePicker(
      context: context,
      initialDateRange: _currentDateTimeRange,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: VENTI_METRI_PINK,
            ),
            dialogBackgroundColor: VENTI_METRI_GREEN,
          ),
          child: child,
        );
      },
    );

    if (dateTimeRange != null && dateTimeRange != _currentDateTimeRange)
      setState(() {
        _currentDateTimeRange = dateTimeRange;
      });
  }



  Future getReportPageByReportType(String reportType) async {

    double _mattiaInAmount = 0.0;
    double _danieleInAmount = 0.0;
    double _danieleOutAmount = 0.0;
    double _mattiaOutAmount = 0.0;
    double _posInAmount = 0.0;

    CRUDModel crudModelDanieleIn = CRUDModel(_currentSchemaDanieleIn);
    List<ExpenceClass> _expenceListDanieleIn = await crudModelDanieleIn.fetchExpences(_currentDateTimeRange.start, _currentDateTimeRange.end);

    _expenceListDanieleIn.forEach((element) {
      _danieleInAmount = _danieleInAmount + double.parse(element.amount);
    });

    CRUDModel crudModelDanieleOut = CRUDModel(_currentSchemaDanieleOut);
    List<ExpenceClass> _expenceListDanieleOut = await crudModelDanieleOut.fetchExpences(_currentDateTimeRange.start, _currentDateTimeRange.end);

    _expenceListDanieleOut.forEach((element) {
      _danieleOutAmount = _danieleOutAmount + double.parse(element.amount);
    });

    CRUDModel crudModelMattiaIn = CRUDModel(_currentSchemaMattiaIn);
    List<ExpenceClass> _expenceListMattiaIn = await crudModelMattiaIn.fetchExpences(_currentDateTimeRange.start, _currentDateTimeRange.end);

    _expenceListMattiaIn.forEach((element) {
      _mattiaInAmount = _mattiaInAmount + double.parse(element.amount);
    });

    CRUDModel crudModelMattiaOut = CRUDModel(_currentSchemaMattiaOut);
    List<ExpenceClass> _expenceListMattiaOut = await crudModelMattiaOut.fetchExpences(_currentDateTimeRange.start, _currentDateTimeRange.end);

    _expenceListMattiaOut.forEach((element) {
      _mattiaOutAmount = _mattiaOutAmount + double.parse(element.amount);
    });

    CRUDModel crudModelPosIn = CRUDModel(_currentSchemaPosIn);
    List<ExpenceClass> _expenceListPosIn = await crudModelPosIn.fetchExpences(_currentDateTimeRange.start, _currentDateTimeRange.end);

    _expenceListPosIn.forEach((element) {
      _posInAmount = _posInAmount + double.parse(element.amount);
    });

    List<Widget> listOut = <Widget>[];

    switch(reportType){
      case WEEKLY:
        listOut.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Table(
                  children: [
                    TableRow(
                        children: [
                          TableCell(
                              child: Text('Incassi Daniele')
                          ),
                          TableCell(
                            child: Text('Spese Daniele'),
                          ),
                          TableCell(
                            child: Text('Da Versare'),
                          ),
                        ]),
                    TableRow(
                        children: [
                          TableCell(
                            child: Text(_danieleInAmount.toString()),
                          ),
                          TableCell(
                            child: Text(_danieleOutAmount.toString()),
                          ),
                          TableCell(
                            child: Text((_danieleInAmount - _danieleOutAmount).toString()),
                          ),
                        ]
                    ),
                    TableRow(
                        children: [
                          TableCell(
                            child: Text(''),
                          ),
                          TableCell(
                            child: Text(''),
                          ),
                          TableCell(
                            child: Text((_posInAmount).toString() + ' (Pos)'),
                          ),
                        ]
                    ),
                    TableRow(
                        children: [
                          TableCell(
                            child: Text(''),
                          ),
                          TableCell(
                            child: Text(''),
                          ),
                          TableCell(
                            child: Text('Tot.  ' + (_danieleInAmount - _danieleOutAmount - _posInAmount).toString()),
                          ),
                        ]
                    ),
                  ],
                ),
                SizedBox(height: 100,),
                Table(
                  children: [
                    TableRow(
                        children: [
                          TableCell(
                              child: Text('Incassi Mattia')
                          ),
                          TableCell(
                            child: Text('Spese Mattia'),
                          ),
                          TableCell(
                            child: Text('Da Dividere'),
                          ),
                        ]),
                    TableRow(
                        children: [
                          TableCell(
                            child: Text(_mattiaInAmount.toString()),
                          ),
                          TableCell(
                            child: Text(_mattiaOutAmount.toString()),
                          ),
                          TableCell(
                            child: Text((_mattiaInAmount - _mattiaOutAmount).toString()),
                          ),
                        ]),
                  ],
                ),
              ],
            ),
          ),
        );
        break;
      case MONTHLY:
        listOut.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Table(
                  children: [
                    TableRow(
                        children: [
                          TableCell(
                              child: Text('Fatture')
                          ),
                          TableCell(
                            child: Text('Incassi Daniele'),
                          ),
                          TableCell(
                            child: Text('Fissi'),
                          ),
                          TableCell(
                            child: Text('Utile'),
                          ),
                        ]),
                    TableRow(
                        children: [
                          TableCell(
                            child: Text(0.0.toString()),
                          ),
                          TableCell(
                            child: Text(_danieleInAmount.toString()),
                          ),
                          TableCell(
                            child: Text(0.0.toString()),
                          ),
                          TableCell(
                            child: Text((0.0 - _danieleInAmount - 0.0).toString()),
                          ),
                        ]),
                  ],
                ),
                SizedBox(height: 100,),
                Table(
                  children: [
                    TableRow(
                        children: [
                          TableCell(
                            child: Text('Incassi Mattia'),
                          ),
                          TableCell(
                            child: Text('Spese Mattia'),
                          ),
                          TableCell(
                            child: Text('Resoconto'),
                          ),
                        ]),
                    TableRow(
                        children: [
                          TableCell(
                            child: Text(_mattiaInAmount.toString()),
                          ),
                          TableCell(
                            child: Text(_mattiaOutAmount.toString()),
                          ),
                          TableCell(
                            child: Text((_mattiaInAmount - _mattiaOutAmount).toString()),
                          ),
                        ]),
                  ],
                ),
              ],
            ),
          ),
        );
        break;
    }
    return listOut;
  }
}