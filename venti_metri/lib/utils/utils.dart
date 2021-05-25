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

const String MATTIA = 'MATTIA';
const String DANIELE = 'DANIELE';
const String POS = 'POS';


final Color VENTI_METRI_RED = Colors.red.shade900;
final Color VENTI_METRI_GREEN = const Color(0xff53fdd7);
final Color VENTI_METRI_PINK = const Color(0xffff5182);
final Color VENTI_METRI_GREY = Colors.blueGrey.shade900;

const kTableColumns = <DataColumn>[
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