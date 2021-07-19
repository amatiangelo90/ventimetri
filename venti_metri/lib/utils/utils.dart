import 'dart:ui';

import 'package:flutter/material.dart';

class LocationListClass {
  int id;
  String location;

  LocationListClass(this.id, this.location);

  static List<LocationListClass> getLocations() {
    return <LocationListClass>[
      LocationListClass(1, 'Cisternino'),
      LocationListClass(2, 'Locorotondo'),
      LocationListClass(3, 'Monopoli'),
    ];
  }
}

enum ExpenceInOut {
  Bills,
  Profit
}

const String SINGLE = 'Spese';
const String DAILY = 'Incasso Giornaliero';

const String WEEKLY = 'Settimanale';
const String MONTHLY = 'Mensile';

const String INTROITI = 'INTROITI';
const String SPESE = 'SPESE';
const String CHART = 'CHART';

const String CIST_MATTIA_IN = 'cist_mattia_in';
const String CIST_MATTIA_OUT = 'cist_mattia_out';
const String CIST_DANIELE_IN = 'cist_daniele_in';
const String CIST_DANIELE_OUT = 'cist_daniele_out';
const String CIST_POS_IN = 'cist_pos_in';

const String LOC_MATTIA_IN = 'loc_mattia_in';
const String LOC_MATTIA_OUT = 'loc_mattia_out';
const String LOC_DANIELE_IN = 'loc_daniele_in';
const String LOC_DANIELE_OUT = 'loc_daniele_out';
const String LOC_POS_IN = 'loc_pos_in';

const String MON_MATTIA_IN = 'mon_mattia_in';
const String MON_MATTIA_OUT = 'mon_mattia_out';
const String MON_DANIELE_IN = 'mon_daniele_in';
const String MON_DANIELE_OUT = 'mon_daniele_out';
const String MON_POS_IN = 'mon_pos_in';

const String EVENTS_SCHEMA = 'events_schema';
const String BAR_POSITION_SCHEMA = 'bar_position_schema';
const String CHAMPAGNERIE_POSITION_SCHEMA = 'champagnerie_position_schema';
const String BAR_LIST_PRODUCT_SCHEMA = 'bar_product_schema_';
const String CHAMPAGNERIE_LIST_PRODUCT_SCHEMA = 'champ_product_schema_';
const String EXPENCES_EVENT_SCHEMA = 'expences_event_';

const String PRODUCT_LIST_SCHEMA = 'product_list_schema';

const String MATTIA = 'MATTIA';
const String DANIELE = 'DANIELE';
const String POS = 'POS';
const String CURRENT_PASSWORD = '1234';


final Color VENTI_METRI_RED = Colors.red.shade900;
final Color VENTI_METRI_GREEN = const Color(0xff53fdd7);
final Color VENTI_METRI_PINK = const Color(0xffff5182);
final Color VENTI_METRI_BLUE = Colors.blueGrey.shade900;
final Color VENTI_METRI_CISTERNINO = Colors.teal.shade50;
final Color VENTI_METRI_MONOPOLI = Colors.redAccent.shade100;
final Color VENTI_METRI_LOCOROTONDO = Colors.orangeAccent.shade100;

const kTableColumns = <DataColumn>[
  DataColumn(
    label: Text('Prodotto'),
  ),
  DataColumn(
    label: Text('Misura'),
    numeric: true,
  ),
  DataColumn(
    label: Text('Prezzo'),
    numeric: true,
  ),
];

const kTableExpencesColumns = <DataColumn>[
  DataColumn(
    label: Text('Casuale'),
  ),
  DataColumn(
    label: Text('Quantità'),
    numeric: true,
  ),
  DataColumn(
    label: Text('Prezzo'),
    numeric: true,
  ),
  DataColumn(
    label: Text('Totale'),
    numeric: true,
  ),
];

const kTableColumns2 = <DataColumn>[
  DataColumn(
    label: Text('Fornitore'),
  ),
  DataColumn(
    label: Text('IdFornitore'),
    numeric: true,
  ),
  DataColumn(
    label: Text('Data'),
  ),
  DataColumn(
    label: Text('Importo Netto'),
    numeric: true,
  ),
  DataColumn(
    label: Text('Importo Iva'),
    numeric: true,
  ),
  DataColumn(
    label: Text('Importo Totale'),
    numeric: true,
  ),
  DataColumn(
    label: Text('Valuta'),
  ),
  DataColumn(
    label: Text('Tipo'),
  ),
  DataColumn(
    label: Text('Prossima Scadenza'),
  ),
];

String getDateFromDateTime(DateTime dateTimeSelected) {

  return dateTimeSelected.toUtc().toString();
  /*return dateTimeSelected.day.toString()+'/'+dateTimeSelected.month.toString()+'/'+dateTimeSelected.year.toString();
*/
}

String formatDateTimefromString(String dateTimeSelected) {
  return DateTime.parse(dateTimeSelected).day.toString()+'/'+DateTime.parse(dateTimeSelected).month.toString()+'/'+ DateTime.parse(dateTimeSelected).year.toString();
}