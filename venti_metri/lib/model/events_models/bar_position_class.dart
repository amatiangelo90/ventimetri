import 'package:flutter/material.dart';

class BarPositionClass {

  String docId;
  String id;
  String idEvent;
  String name;
  String eventName;
  String ownerBar;
  int passwordEvent;
  int passwordBarChampPosition;
  String listDrinkId;

  BarPositionClass({
    @required this.docId,
    @required this.name,
    @required this.id,
    @required this.idEvent,
    @required this.eventName,
    @required this.ownerBar,
    @required this.passwordEvent,
    @required this.passwordBarChampPosition,
    @required this.listDrinkId
  });



  Map<String, dynamic> toJson() => {
    'docId': docId,
    'id': id,
    'idEvent': idEvent,
    'name': name,
    'eventName': eventName,
    'ownerBar': ownerBar,
    'passwordEvent': passwordEvent,
    'passwordBarChampPosition': passwordBarChampPosition,
    'listDrinkId': listDrinkId};

  @override
  String toString() => name;


  factory BarPositionClass.fromMap(Map cartMap, String docId){

    return BarPositionClass(
      name: cartMap['name'].toString(),
      id: cartMap['id'].toString(),
      idEvent: cartMap['idEvent'].toString(),
      eventName: cartMap['eventName'].toString(),
      ownerBar: cartMap['ownerBar'].toString(),
      docId: docId,
      passwordEvent: int.parse(cartMap['passwordEvent'].toString()),
      passwordBarChampPosition: int.parse(cartMap['passwordBarChampPosition'].toString()),
      listDrinkId: cartMap['listDrinkId'].toString(),
    );

  }

}