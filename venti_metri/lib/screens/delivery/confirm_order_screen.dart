import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/model/cart.dart';
import 'package:venti_metri/screens/delivery/utils/utils.dart';
import 'package:venti_metri/services/http_service.dart';
import 'package:venti_metri/utils/utils.dart';

class ConfirmScreen extends StatefulWidget {

  final List<Cart> cartItems;
  final double total;
  final String uniqueId;
  final String covers;

  ConfirmScreen({@required this.cartItems, this.total, this.uniqueId, this.covers});

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {

  List<TimeSlotPickup> _slotsPicker = TimeSlotPickup.getPickupSlots();

  List<DropdownMenuItem<TimeSlotPickup>> _dropdownTimeSlotPickup;
  var _isButtonEnabled = true;
  TimeSlotPickup _selectedTimeSlotPikup;
  final _datePikerController = DatePickerController();
  List<PaymentPreference> _paymentType = PaymentPreference
      .getPreferredPayment();

  List<DropdownMenuItem<PaymentPreference>> _dropdownPayments;

  PaymentPreference _selectedPaymentPreference;
  DateTime _selectedDateTime;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _dropdownTimeSlotPickup = buildDropdownSlotPickup(_slotsPicker);
    _selectedTimeSlotPikup = _dropdownTimeSlotPickup[0].value;

    _dropdownPayments = buildDropdownPaymentType(_paymentType);
    _selectedPaymentPreference = _dropdownPayments[0].value;

    super.initState();
  }

  List<DropdownMenuItem<PaymentPreference>> buildDropdownPaymentType(
      List paymentType) {
    List<DropdownMenuItem<PaymentPreference>> items = [];
    for (PaymentPreference payType in paymentType) {
      items.add(
        DropdownMenuItem(
          value: payType,
          child: Center(child: Text(payType.type, style: TextStyle(
              color: Colors.white, fontSize: 16.0, fontFamily: 'LoraFont'),)),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<TimeSlotPickup>> buildDropdownSlotPickup(List slots) {
    List<DropdownMenuItem<TimeSlotPickup>> items = [];
    for (TimeSlotPickup slotItem in slots) {
      items.add(
        DropdownMenuItem(
          value: slotItem,
          child: Center(child: Text(slotItem.slot, style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'LoraFont'),)),
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


  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: VENTI_METRI_BLUE,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: VENTI_METRI_BLUE,
          title: Text('Conferma ordine', style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont')),
        ),
        body: ListView(
          children: [

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: screenHeight - 50,
                width: screenWidth - 50,
                decoration: BoxDecoration(
                  color: VENTI_METRI_BLUE,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Card(
                          color: VENTI_METRI_BLUE,
                          elevation: 0.0,
                          child: Column(
                            children: [
                              Text('Sessione ' +this.widget.uniqueId , style: TextStyle(color: Colors.white, fontSize: 7.0, fontFamily: 'LoraFont'),),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Totale € ' + this.widget.total.toString() , style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont'),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Coperti: ' + this.widget.covers, style: TextStyle(color: Colors.white, fontSize: 15.0, fontFamily: 'LoraFont')),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              color: VENTI_METRI_BLUE,
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: _nameController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white,
                                  labelText: 'Nome',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              color: VENTI_METRI_BLUE,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: _phoneNumberController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white,
                                  labelText: 'Cellulare',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              color: VENTI_METRI_BLUE,
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                controller: _addressController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white,
                                  labelText: 'Indirizzo',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DatePicker(
                                DateTime.now(),
                                dateTextStyle: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'LoraFont'),
                                dayTextStyle: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'LoraFont'),
                                monthTextStyle: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'LoraFont'),
                                selectionColor: VENTI_METRI_MONOPOLI,
                                deactivatedColor: Colors.grey,
                                selectedTextColor: Colors.white,
                                daysCount: 25,
                                locale: 'it',
                                controller: _datePikerController,
                                onDateChange: (date) {
                                  setSelectedDate(date);
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 3.0),
                          child: Center(
                            child: Card(
                              color: VENTI_METRI_BLUE,
                              borderOnForeground: true,
                              elevation: 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: DropdownButton(
                                      dropdownColor: VENTI_METRI_MONOPOLI,
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
                          padding: const EdgeInsets.fromLTRB(
                              20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              color: VENTI_METRI_BLUE,
                              borderOnForeground: true,
                              elevation: 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: DropdownButton(
                                      dropdownColor: VENTI_METRI_MONOPOLI,
                                      isExpanded: true,
                                      value: _selectedPaymentPreference,
                                      items: _dropdownPayments,
                                      onChanged: onChangePaymentSelected,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isButtonEnabled ? RaisedButton(
                                child: Text('Invia Ordine',style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                                color: VENTI_METRI_MONOPOLI,
                                elevation: 5.0,
                                onPressed: () async {
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
                                  } else if(_phoneNumberController.value.text == ''){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                          content: Text('Seleziona numero Cellulare', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text("Indietro"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if(_addressController.value.text == ''){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                          content: Text('Immettere un indirizzo valido', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text("Indietro"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  else if(_selectedTimeSlotPikup.slot == 'Seleziona Orario Consegna'){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                          content: Text('Seleziona Orario Consegna', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text("Indietro"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if(_selectedDateTime == null){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                          content: Text('Selezionare una data di ritiro valida', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text("Indietro"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if(_selectedPaymentPreference.type == 'Selezione Preferenza Pagamento'){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                          content: Text('Selezione Preferenza Pagamento', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text("Indietro"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else{
                                    try{
                                      updateButtonAvailability();
                                      HttpService.sendMessage(number20m2,
                                          buildMessageFromCartPickUp(
                                              this.widget.cartItems,
                                              _nameController.value.text,
                                              _addressController.value.text,
                                              this.widget.total.toString(),
                                              getCurrentDateTime(),
                                              _selectedTimeSlotPikup.slot,
                                              _selectedDateTime
                                          ),
                                          _nameController.value.text,
                                          this.widget.total.toString(),
                                          getCurrentDateTime(),
                                          this.widget.cartItems,
                                          this.widget.uniqueId,
                                          PICKUP_TYPE,
                                          Utils.getWeekDay(_selectedDateTime.weekday) +" ${_selectedDateTime.day} " + Utils.getMonthDay(_selectedDateTime.month),
                                          _selectedTimeSlotPikup.slot,
                                          EMPTY_STRING,
                                          EMPTY_STRING
                                      );
                                    }catch(e){
                                      print('Exception Crud: ' + e.toString());
                                    }
                                  }
                                }
                            ) : RaisedButton(
                                child: Text('Invio in Corso',style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                                color: Colors.grey,
                                elevation: 5.0,
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(backgroundColor: Colors.orangeAccent ,
                                      content: Text('Invio in corso ...')));
                                }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    String getCurrentDateTime() {
    return DateTime.now().toString();
  }

  onChangePaymentSelected(PaymentPreference currentPaymentPreferred) {
    setState(() {
      _selectedPaymentPreference = currentPaymentPreferred;
    });
  }

  void updateButtonAvailability() {
    /*setState(() {
      if(_isButtonEnabled){
        _isButtonEnabled = false;
      }
    });*/
  }

  String getDateByHour() {
    if(DateTime.now().hour < 3)
      return Utils.getWeekDay(DateTime.now().subtract(Duration(days: 1)).weekday) +" ${DateTime.now().subtract(Duration(days: 1)).day} " + Utils.getMonthDay(DateTime.now().subtract(Duration(days: 1)).month);

      return Utils.getWeekDay(DateTime.now().weekday) +" ${DateTime.now().day} " + Utils.getMonthDay(DateTime.now().month);
  }

  String buildMessageFromCartPickUp(
      List<Cart> cartItems,
      String name,
      String address,
      String total,
      String date,
      String slot,
      DateTime selectedDateTime,) {

    String itemList = '';

    cartItems.forEach((element) {
      itemList = itemList + "%0a" + element.numberOfItem.toString() + " x " + element.product.name;
      if(element.changes.length != 0){
        itemList = itemList + "%0a  " + element.changes.toString();
      }
    });

    String message =
        "ORDINE DELIVERY%0a" +
            "%0aVenti Metri Quadri%0a"+
            "%0aNome: $name" +
            "%0aIndirizzo Ritiro: $address" +
            "%0aProvincia: BR" +
            "%0aData Consegna: " + Utils.getWeekDay(selectedDateTime.weekday) +" ${selectedDateTime.day} " + Utils.getMonthDay(selectedDateTime.month) +
            "%0aOre Consegna: $slot " +
            "%0a%0a-------------------------------------------------%0a"
            + itemList + "%0a"
            + "%0aTot. " + total + " € ";

    message = message.replaceAll('&', '%26');
    return message;

  }

  void setSelectedDate(DateTime date) {
    setState(() {
      _selectedDateTime = date;
    });
  }
}

class TimeSlotPickup {
  int id;
  String slot;

  TimeSlotPickup(this.id, this.slot);

  static List<TimeSlotPickup> getPickupSlots() {

    DateTime currentDatePlus10Min = DateTime.now().add(Duration(minutes: 10));

    String firstSlot;
    String secondSlot;

    if(currentDatePlus10Min.hour < 18 && currentDatePlus10Min.hour > 3){
      firstSlot = '18:15';
      secondSlot = '18:30';
    }else{
      if(currentDatePlus10Min.minute >= 0 && currentDatePlus10Min.minute < 15){
        firstSlot = currentDatePlus10Min.hour.toString() + ':15';
        secondSlot = currentDatePlus10Min.hour.toString() + ':30';
      }else if(currentDatePlus10Min.minute >= 15 && currentDatePlus10Min.minute < 30){
        firstSlot = currentDatePlus10Min.hour.toString() + ':30';
        secondSlot = currentDatePlus10Min.hour.toString() + ':45';
      }else if(currentDatePlus10Min.minute >= 30 && currentDatePlus10Min.minute < 45){
        firstSlot = currentDatePlus10Min.hour.toString() + ':45';
        secondSlot = (currentDatePlus10Min.hour + 1).toString() + ':00';
      }else if(currentDatePlus10Min.minute >= 45 && currentDatePlus10Min.minute <= 59){
        firstSlot = (currentDatePlus10Min.hour + 1).toString() + ':00';
        secondSlot = (currentDatePlus10Min.hour + 1).toString() + ':15';
      }
    }

    return <TimeSlotPickup>[
      TimeSlotPickup(1, 'Seleziona Orario Consegna'),
      TimeSlotPickup(2, firstSlot),
      TimeSlotPickup(3, secondSlot),
    ];
  }

  static List<TimeSlotPickup> getReservationSlots() {
    return <TimeSlotPickup>[
      TimeSlotPickup(1, 'Seleziona Orario'),
      TimeSlotPickup(2, '18:00'),
      TimeSlotPickup(3, '19:00'),
      TimeSlotPickup(4, '20:00'),
      TimeSlotPickup(5, '21:00'),
      TimeSlotPickup(6, '22:00'),
      TimeSlotPickup(7, '23:00'),
    ];
  }

  static List<TimeSlotPickup> buildTimeSlotPickupListByMap(Map<String, int> currentDataMap) {

    List<String> slotList = ['18:00', '19:00', '20:00', '21:00', '22:00', '23:00'];

    List<TimeSlotPickup> list = <TimeSlotPickup>[
      TimeSlotPickup(1, 'Seleziona Orario'),
    ];

    for(int i = 0; i < slotList.length; i++){
      if(!currentDataMap.containsKey(slotList[i]) || (currentDataMap.containsKey(slotList[i]) && currentDataMap[slotList[i]] < 8)){
        list.add(TimeSlotPickup(i+2, slotList[i]));
      }
    }
    return list;
  }
}

class PaymentPreference {
  int id;
  String type;

  PaymentPreference(this.id, this.type);

  static List<PaymentPreference> getPreferredPayment() {
    return <PaymentPreference>[
      PaymentPreference(1, 'Selezione Preferenza Pagamento'),
      PaymentPreference(1, 'Cash'),
      PaymentPreference(2, 'Carta di Credito/Debito'),
    ];
  }
}

