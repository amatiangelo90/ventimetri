import 'package:flutter/material.dart';

class EventClass {

  final String id;
  final String title;
  final DateTime date;
  final String location;
  final int passwordEvent;
  final int listDrinkId;

  const EventClass({
    @required this.title,
    @required this.id,
    @required this.date,
    @required this.location,
    @required this.passwordEvent,
    @required this.listDrinkId
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date,
    'location': location,
    'passwordEvent': passwordEvent,
    'listDrinkId': listDrinkId};

  @override
  String toString() => title;
}