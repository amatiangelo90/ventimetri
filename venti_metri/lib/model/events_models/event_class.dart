import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:venti_metri/model/events_models/product_class.dart';

class EventClass {

  final String docId;
  final String id;
  final String title;
  final Timestamp date;
  final List<dynamic> listBarPositionIds;
  final List<dynamic> listChampagneriePositionIds;
  final String passwordEvent;
  final List<dynamic> productBarList;
  final List<dynamic> productChampagnerieList;

  const EventClass({
    @required this.docId,
    @required this.title,
    @required this.id,
    @required this.date,
    @required this.listBarPositionIds,
    @required this.listChampagneriePositionIds,
    @required this.passwordEvent,
    @required this.productBarList,
    @required this.productChampagnerieList
  });

  Map<String, dynamic> toJson() => {
    'docId': docId,
    'id': id,
    'title': title,
    'date': date,
    'listBarPositionIds': listBarPositionIds,
    'listChampagneriePositionIds': listChampagneriePositionIds,
    'passwordEvent': passwordEvent,
    'productBarList': productBarList,
    'productChampagnerieList': productChampagnerieList};

  @override
  String toString() => title;


  factory EventClass.fromMap(Map cartMap, String docId){

    return EventClass(
        title: cartMap['title'].toString(),
        id: cartMap['id'].toString(),
        docId: docId,
        date: cartMap['date'],
        listBarPositionIds: cartMap['listBarPositionIds'] as List,
        listChampagneriePositionIds: cartMap['listChampagneriePositionIds'] as List,
        passwordEvent: cartMap['passwordEvent'],
        productBarList: cartMap['productBarList'] as List,
        productChampagnerieList: cartMap['productChampagnerieList'] as List);
  }

  serializeList(List<dynamic> listProducts) {
    List<dynamic> orderDeserialized = <dynamic>[];

    listProducts.forEach((element) {
      orderDeserialized.add(element.toJson().toString());
    });
    return orderDeserialized;
  }

}