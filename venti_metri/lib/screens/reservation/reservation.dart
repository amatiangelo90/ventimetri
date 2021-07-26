import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:venti_metri/component/round_icon_botton.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/calendar_manager.dart';
import 'package:venti_metri/model/location.dart';
import 'package:venti_metri/model/timeslot.dart';
import 'package:venti_metri/services/http_service.dart';
import 'package:venti_metri/utils/utils.dart';

class TableReservationScreen extends StatefulWidget {

  static String id = 'reservation';

  final List<CalendarManagerClass> listCalendarConfiguration;

  TableReservationScreen({@required this.listCalendarConfiguration});

  @override
  _TableReservationScreenState createState() => _TableReservationScreenState();
}

class _TableReservationScreenState extends State<TableReservationScreen> {

  DateTime _selectedDateTime;
  final _datePikerController = DatePickerController();
  int _covers = 1;
  String EMPTY_STRING = '';

  List<TimeSlotPickup> _slotsPicker = TimeSlotPickup.getTimeSlots();
  List<DropdownMenuItem<TimeSlotPickup>> _dropdownTimeSlotPickup;
  TimeSlotPickup _selectedTimeSlotPikup;

  List<Location> _locationPicker = Location.getLocationSlots();
  List<DropdownMenuItem<Location>> _dropdownLocationPickup;
  Location _selectedLocation;

  final _nameController = TextEditingController();
  final _detailsReservationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _detailsReservationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print(this.widget.listCalendarConfiguration);
    _dropdownTimeSlotPickup = buildDropdownSlotPickup(_slotsPicker);
    _selectedTimeSlotPikup = _dropdownTimeSlotPickup[0].value;

    _dropdownLocationPickup = buildLocationPickup(_locationPicker);
    _selectedLocation = _dropdownLocationPickup[0].value;

    super.initState();
  }

  List<DropdownMenuItem<TimeSlotPickup>> buildDropdownSlotPickup(List slots) {
    List<DropdownMenuItem<TimeSlotPickup>> items = [];
    for (TimeSlotPickup slotItem in slots) {
      items.add(
        DropdownMenuItem(
          value: slotItem,
          child: Center(child: Text(slotItem.slot, style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Location>> buildLocationPickup(List locations) {
    List<DropdownMenuItem<Location>> items = [];
    for (Location slotItem in locations) {
      items.add(
        DropdownMenuItem(
          value: slotItem,
          child: Center(child: Text(slotItem.location, style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)),
        ),
      );
    }
    return items;
  }

  onChangeDropTimeSlotPickup(TimeSlotPickup currentPickupSlot) {
    setState(() {
      _selectedTimeSlotPikup = currentPickupSlot;
    });
  }

  onChangeDropLocation(Location currLoc) {
    setState(() {
      _selectedLocation = currLoc;
    });
  }

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Prenotazione 20m2'),
          backgroundColor: VENTI_METRI_BLUE,
        ),
        backgroundColor: Colors.white,
        body: Container(
          color: VENTI_METRI_BLUE,
          child: ListView(
            children: [
              Container(
                height: screenHeight - 50,
                width: screenWidth - 50,
                decoration: BoxDecoration(
                  color: VENTI_METRI_BLUE_800,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Card(
                          elevation: 0.0,
                          child: Column(
                            children: [
                              Center(child: Text('Richiesta Prenotazione', style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'LoraFont'),),),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Card(
                            color: VENTI_METRI_BLUE_800,
                            elevation: 0.0,
                            child: Column(
                              children: [
                                Text('20m2', style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont'),),
                                Text('', style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont'),),
                                Text('Cisternino (BR) - Cap 72014', style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont'),),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              child: TextField(
                                controller: _nameController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nome',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                function: () {
                                  setState(() {
                                    if(_covers > 1)
                                      _covers = _covers - 1;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Coperti : ' + _covers.toString(), style: TextStyle(color: Colors.white,fontSize: 20.0, fontFamily: 'LoraFont'),),
                              ),
                              RoundIconButton(
                                icon: FontAwesomeIcons.plus,
                                function: () {
                                  setState(() {
                                    _covers = _covers + 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DatePicker(
                                DateTime.now(),
                                dateTextStyle: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),
                                dayTextStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),
                                monthTextStyle: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'LoraFont'),
                                selectionColor: VENTI_METRI_BLUE,
                                deactivatedColor: Colors.grey,
                                selectedTextColor: Colors.white,
                                daysCount: 25,
                                locale: 'it',
                                controller: _datePikerController,
                                onDateChange: (date) {
                                  _setSelectedDate(date);
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 3.0),
                          child: Center(
                            child: Card(
                              borderOnForeground: true,
                              elevation: 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: _selectedLocation,
                                      items: _dropdownLocationPickup,
                                      onChanged: onChangeDropLocation,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(_selectedLocation.addressLc, style: TextStyle(color: Colors.white),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 3.0),
                          child: Center(
                            child: Card(
                              borderOnForeground: true,
                              elevation: 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: _selectedTimeSlotPikup,
                                      items: _dropdownTimeSlotPickup,
                                      onChanged: onChangeDropTimeSlotPickup,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              child: TextField(
                                controller: _detailsReservationController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Note',
                                ),
                                maxLines: 4,
                              ),
                            ),
                          ),
                        ),

                        IconButton(
                            icon: Image.asset('images/whatapp_icon_c.png'),
                            iconSize: 90.0, onPressed: () async {
                          try{
                            if(_nameController.value.text == ''){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    content: Text('Inserire il nome', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("Indietro"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }else if(_selectedDateTime == null){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    content: Text('Selezionare la data per la prenotazione', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("Indietro"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if(_selectedTimeSlotPikup.slot == 'Seleziona Orario'){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    content: Text('Seleziona Orario', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("Indietro"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if(_selectedLocation.location == 'Selezionare la Sede'){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    content: Text('Seleziona Sede', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("Indietro"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }else {
                              HttpService.sendMessage('393803268119',
                                  buildMessageReservation(
                                      _nameController.value.text,
                                      getCurrentDateTime(),
                                      _selectedTimeSlotPikup.slot,
                                      _selectedDateTime,
                                      _covers.toString(),
                                      _detailsReservationController.value.text,
                                      _selectedLocation
                                  ),
                                  _nameController.value.text,
                                  '0',
                                  getCurrentDateTime(),
                                  null,
                                  '',
                                  '',
                                  getWeekDay(_selectedDateTime.weekday) +" ${_selectedDateTime.day} " + getMonthDay(_selectedDateTime.month),
                                  _selectedTimeSlotPikup.slot,
                                  EMPTY_STRING,
                                  EMPTY_STRING
                              );
                            }
                          }catch(e){
                            CRUDModel crudModel = CRUDModel('errors-report');
                            await crudModel.addException(
                                'Error report',
                                e.toString(),
                                DateTime.now().toString());
                          }
                        }
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  String buildMessageReservation(
      String name,
      String date,
      String slot,
      DateTime selectedDateTime,
      String coperti,
      String detailsReservation,
      Location selectedLocation
      ) {


    String message =
        "RICHIESTA PRENOTAZIONE%0a" +
            "%0a20m2%0a"+
            "%0aNome: $name%0a" +
            "%0aIndirizzo: ${selectedLocation.addressLc}" +
            "%0aCittà: ${selectedLocation.location}" +
            "%0a" +
            "%0aData Prenotazione: " + getWeekDay(selectedDateTime.weekday) +" ${selectedDateTime.day} " + getMonthDay(selectedDateTime.month) +

            "%0aOre: $slot " +
            "%0aCoperti : $coperti"
                "%0a%0aNote : $detailsReservation"
    ;

    message = message.replaceAll('&', '%26');
    return message;

  }


  String getCurrentDateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat.yMd().add_jm();
    return formatter.format(now);
  }

  _setSelectedDate(DateTime date) {
    setState(() {
      _selectedDateTime = date;
    });

    setState(() {
      _dropdownTimeSlotPickup = buildDropdownSlotPickup(TimeSlotPickup.getTimeSlots());
      _selectedTimeSlotPikup = _dropdownTimeSlotPickup[0].value;
    });
  }

  _buildActiveDateListFromConfigurationList(List<CalendarManagerClass> listCalendarConfiguration) {
    List<DateTime> activeDateList = <DateTime>[];
    if(listCalendarConfiguration == null){
      return activeDateList;
    }
    if(listCalendarConfiguration != null && listCalendarConfiguration.length == 0){
      return activeDateList;
    }
    listCalendarConfiguration.forEach((element) {
      activeDateList.add(DateTime.fromMillisecondsSinceEpoch(int.parse(element.date)));
    });

    return activeDateList;
  }

  static String getWeekDay(int weekday) {
    switch(weekday){
      case 1:
        return "Lunedi";
      case 2:
        return "Martedi";
      case 3:
        return "Mercoledi";
      case 4:
        return "Gioverdi";
      case 5:
        return "Venerdi";
      case 6:
        return "Sabato";
      case 7:
        return "Domenica";
    }
    return "";
  }

  static String getMonthDay(int month) {
    switch(month){
      case 1:
        return "Gennaio";
      case 2:
        return "Febbraio";
      case 3:
        return "Marzo";
      case 4:
        return "Aprile";
      case 5:
        return "Maggio";
      case 6:
        return "Giugno";
      case 7:
        return "Luglio";
      case 8:
        return "Agosto";
      case 9:
        return "Settembre";
      case 10:
        return "Ottobre";
      case 11:
        return "Novembre";
      case 12:
        return "Dicembre";
    }
    return "";
  }

}

