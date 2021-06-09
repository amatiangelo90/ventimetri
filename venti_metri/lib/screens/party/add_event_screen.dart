import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:venti_metri/dao/crud_model.dart';
import 'package:venti_metri/model/event_class.dart';
import 'package:venti_metri/utils/utils.dart';

class AddEventScreen extends StatefulWidget {
  static String id = 'add_event_screen';
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {

  final DatePickerController _dateController = DatePickerController();

  var uuid = Uuid();

  DateTime _currentSelectedDate = null;

  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _passwordEventController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: VENTI_METRI_BLUE,
          centerTitle: true,
          title: Text('Crea Serata/Evento', style: TextStyle(fontSize: 18, color: Colors.white),),
        ),
        body: Container(
          color: VENTI_METRI_BLUE,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
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
                  SizedBox(height: 10,),
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
                          borderSide: BorderSide(color: VENTI_METRI_MONOPOLI, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: VENTI_METRI_MONOPOLI, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _locationController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Location',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder (
                          borderSide: BorderSide(color: VENTI_METRI_MONOPOLI, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: VENTI_METRI_MONOPOLI, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _passwordEventController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        /*icon: Icon(Icons.vpn_key, color: Colors.white,),*/
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder (
                          borderSide: BorderSide(color: VENTI_METRI_MONOPOLI, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: VENTI_METRI_MONOPOLI, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Text('Clean'),

                        onPressed: () =>{
                          _clearController(),
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(VENTI_METRI_MONOPOLI),
                        ),
                      ),
                      ElevatedButton(
                        child: Text('Crea Serata'),

                        onPressed: () async {

                          if(_eventNameController.text == ''){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text('Inserire il nome Evento')));
                          }else if(_locationController.text == ''){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text('Inserire la location')));
                          }else if(_passwordEventController.text == ''){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text('Assegnare una password all\'evento')));
                          }else if(_currentSelectedDate == null){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text('Selezionare una data valida')));
                          }else{
                            CRUDModel crudModel = CRUDModel(EVENTS_SCHEMA);

                            EventClass eventClass = EventClass(
                                id: uuid.v1(),
                                passwordEvent: int.parse(_passwordEventController.value.text),
                                listDrinkId: generateDrinkListId(),
                                date: _currentSelectedDate,
                                location: _locationController.value.text,
                                title: _eventNameController.value.text);

                            await crudModel.addEventObject(eventClass);

                            Navigator.pop(context);
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
        ),
      ),
    );
  }


  _clearController() {
    setState((){
      _eventNameController.clear();
      _locationController.clear();
      _passwordEventController.clear();
    });
  }

  int generateDrinkListId() {
    return 1234;
  }
}
