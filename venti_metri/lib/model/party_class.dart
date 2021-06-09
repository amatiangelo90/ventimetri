import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PartyModelClass{

  String id;
  int partyId;
  String locationAddress;
  Timestamp creationDate;
  Timestamp partyDate;
  String startHour;
  String endHour;
  String details;
  int listDrinkId;


  PartyModelClass({
    @required this.id,
    @required this.partyId,
    @required this.locationAddress,
    @required this.creationDate,
    @required this.partyDate,
    @required this.startHour,
    @required this.endHour,
    @required this.details,
    @required this.listDrinkId
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'partyId': partyId,
    'locationAddress': locationAddress,
    'creationDate': creationDate,
    'partyDate': partyDate,
    'startHour': startHour,
    'endHour': endHour,
    'details': details,
    'listDrinkId': listDrinkId,
  };

  factory PartyModelClass.fromMap(Map cartMap, String id){
    return PartyModelClass(
      id: cartMap['id'].toString(),
      partyId: int.parse(cartMap['partyId'].toString()),
      locationAddress : cartMap['locationAddress'].toString(),
      creationDate : cartMap['creationDate'],
      partyDate: cartMap['partyDate'],
      startHour: cartMap['startHour'].toString(),
      endHour: cartMap['endHour'].toString(),
      details: cartMap['details'].toString(),
      listDrinkId: int.parse(cartMap['listDrinkId'].toString()),
    );
  }

}