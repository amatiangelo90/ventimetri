import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:venti_metri/component/round_icon_botton.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/calendar_manager.dart';
import 'package:venti_metri/model/events_models/event_class.dart';
import 'package:venti_metri/model/location.dart';
import 'package:venti_metri/model/timeslot.dart';
import 'package:venti_metri/services/http_service.dart';
import 'package:venti_metri/utils/utils.dart';

class EventReservationScreen extends StatefulWidget {

  static String id = 'reservation_event';

  final List<CalendarManagerClass> listCalendarConfiguration;
  final EventClass currentEvent;

  EventReservationScreen({@required this.listCalendarConfiguration, this.currentEvent});

  @override
  _EventReservationScreenState createState() => _EventReservationScreenState();
}

class _EventReservationScreenState extends State<EventReservationScreen> {

  int _guests = 1;
  String EMPTY_STRING = '';

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

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Prenotazione Evento 20m2'),
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
                              Center(child: Text('20m2', style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'LoraFont'),),),

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
                                Text(this.widget.currentEvent.title, style: TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: 'LoraFont'),),
                                SizedBox(height: 20,),
                                Text(' - Location - ', style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'LoraFont'),),
                                SizedBox(height: 3,),
                                Text(this.widget.currentEvent.address, style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont'),),
                                SizedBox(height: 20,),
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
                                    if(_guests > 1)
                                      _guests = _guests - 1;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Ospiti : ' + _guests.toString(), style: TextStyle(color: Colors.white,fontSize: 20.0, fontFamily: 'LoraFont'),),
                              ),
                              RoundIconButton(
                                icon: FontAwesomeIcons.plus,
                                function: () {
                                  setState(() {
                                    _guests = _guests + 1;
                                  });
                                },
                              ),
                            ],
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
                            } else {
                              HttpService.sendMessage(number20m2,
                                  buildMessageReservation(
                                      _nameController.value.text,
                                      getCurrentDateTime(),
                                      this.widget.currentEvent.address,
                                      _guests.toString(),
                                      _detailsReservationController.value.text,
                                  ),
                                  _nameController.value.text,
                                  '0',
                                  getCurrentDateTime(),
                                  null,
                                  '',
                                  '',
                                  '',
                                  '',
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
      String location,
      String coperti,
      String detailsReservation
      ) {


    String message =
        "RICHIESTA PRENOTAZIONE EVENTO 20m2%0a" +
            "%0aEvento : ${this.widget.currentEvent.title}%0a"+
            "%0aNome: $name%0a" +
            "%0aLocation: $location" +
            "%0a" +
            "%0aOspiti : $coperti"
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

}

