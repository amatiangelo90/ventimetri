import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/events_models/event_class.dart';
import 'package:venti_metri/screens/event/single_event_manager_screen.dart';
import 'package:venti_metri/screens/event/products_manager_page.dart';
import 'package:venti_metri/screens/event/utils_event/utils_event.dart';
import 'package:venti_metri/utils/utils.dart';

import '../branch_choose.dart';
import 'add_event_screen.dart';

class PartyScreenManager extends StatefulWidget {
  static String id = 'party_screen_manager';
  @override
  _PartyScreenManagerState createState() => _PartyScreenManagerState();
}

class _PartyScreenManagerState extends State<PartyScreenManager> {

  ValueNotifier<List<EventClass>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;

  LinkedHashMap<DateTime, List<EventClass>> _kEvents = new LinkedHashMap();
  List<EventClass> currentEventList;

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  Map<String,String> _alreadyUsedPasswordMap;

  @override
  void initState() {
    super.initState();

    initEvents();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));

  }

  refresh(){
    setState(() {});
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<EventClass> _getEventsForDay(DateTime day){
    return _kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay,
      DateTime focusedDay) {

    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: VENTI_METRI_BLUE,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.home, color: Colors.white, size: 25,),
            onPressed: () {
              Navigator.pushNamed(context, BranchChooseScreen.id);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(FontAwesomeIcons.wineBottle, color: Colors.white, size: 25,),
              onPressed: () {
                Navigator.pushNamed(context, ProductPageManager.id);
              },
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.white, size: 25,),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddEventScreen(alreadyUsedPasswordMap: _alreadyUsedPasswordMap,),),);

              },
            ),
          ],
          title: GestureDetector(
            onTap: (){
              setState(() {

              });
            },
            child: Text('Calendario Eventi',style: TextStyle(fontFamily: 'LoraFont'),
            ),
          ),
        ),
        body: Container(
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
            future: getCalendarWidget(),
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
    );
  }


  Future<Widget> getCalendarWidget() async {

    return Column(
      children: [
        TableCalendar<EventClass>(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            markerSize: 10,
            markerDecoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            outsideDaysVisible: false,
            canMarkersOverflow: true,
            isTodayHighlighted: true,
          ),
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<EventClass>>(
            valueListenable: _selectedEvents,
            builder: (context, eventsList, _) {
              return ListView.builder(
                itemCount: eventsList.length,
                itemBuilder: (context, event) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: VENTI_METRI_BLUE,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                    child: ListTile(
                      onTap: () => {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SingleEventManagerScreen(eventClass: eventsList[event], function: refresh,),),),
                      },
                      subtitle: Text('Codice Evento: ${eventsList[event].id}', style: TextStyle(fontSize: 8, color: Colors.white, fontFamily: 'LoraFont'),),

                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${eventsList[event].title}', style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'LoraFont'),),
                              Row(
                                children: [
                                  Text('Password: ', style: TextStyle(color: Colors.white, fontFamily: 'LoraFont'),),
                                  Text('${eventsList[event].passwordEvent}', style: TextStyle(color: Colors.orange, fontFamily: 'LoraFont'),),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text('Posizioni Bar: ${eventsList[event].listBarPositionIds.length}', style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'LoraFont'),),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Champagnerie: ${eventsList[event].listChampagneriePositionIds.length}', style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'LoraFont'),),
                            ],
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void initEvents() async {
    CRUDModel crudModel = CRUDModel(EVENTS_SCHEMA);
    await crudModel.fetchEvents().then((value) {
      setState(() {
        _alreadyUsedPasswordMap = getMapAlreadyUsedPassword(value);
        _kEvents.addAll(getKEvents(value));
      });
    });
  }

}