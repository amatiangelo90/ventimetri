import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:venti_metri/model/event_class.dart';
import 'package:venti_metri/screens/party/utils_event.dart';
import 'package:venti_metri/utils/utils.dart';

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

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<EventClass> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: VENTI_METRI_BLUE,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
            child: IconButton(
              icon: Icon(Icons.add_circle, color: Colors.white, size: 30,),
              onPressed: () {
                Navigator.pushNamed(context, AddEventScreen.id);
              },
            ),
          ),
        ],
        title: Text('Calendario Eventi - 20m²'),
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
              color: VENTI_METRI_RED,
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
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: VENTI_METRI_GREY,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                    child: ListTile(
                      onTap: () => print('${value[index]}'),
                      subtitle: Text('Codice Evento: ${value[index].id}', style: TextStyle(fontSize: 10, color: Colors.white),),

                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${value[index].title}', style: TextStyle(color: Colors.white, fontSize: 20),),
                              Row(
                                children: [
                                  Text('Password: ', style: TextStyle(color: Colors.white),),
                                  Text('${value[index].passwordEvent}', style: TextStyle(color: Colors.orange),),
                                ],
                              ),


                            ],
                          ),
                          SizedBox(height: 3,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${value[index].location}', style: TextStyle(color: Colors.white, fontSize: 15),),
                              Text('', style: TextStyle(color: VENTI_METRI_BLUE, fontSize: 15),),

                            ],
                          ),
                          SizedBox(height: 10,),
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
}