import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpenceClass{

  String id;
  String casuale;
  Timestamp date;
  String month;
  String hour;
  String amount;
  String inout;
  String location;
  String official;
  String details;
  String documentId;

  ExpenceClass({
    @required this.id,
    @required this.casuale,
    @required this.date,
    @required this.month,
    @required this.hour,
    @required this.amount,
    @required this.inout,
    @required this.location,
    @required this.official,
    @required this.details,
    @required this.documentId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'casuale': casuale,
    'date': date,
    'month': month,
    'hour': hour,
    'amount': amount,
    'inout': inout,
    'location': location,
    'official': official,
    'details': details,
    'documentId': documentId,
  };

  factory ExpenceClass.fromMap(Map cartMap, String id){
    return ExpenceClass(
      id: cartMap['id'].toString(),
      casuale: cartMap['casuale'].toString(),
      date: cartMap['date'],
      month: cartMap['month'].toString(),
      hour: cartMap['hour'].toString(),
      amount: cartMap['amount'],
      inout: cartMap['inout'].toString(),
      location: cartMap['location'].toString(),
      official: cartMap['official'].toString(),
      details: cartMap['details'].toString(),
      documentId: id,
    );
  }

}