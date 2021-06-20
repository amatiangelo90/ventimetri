import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venti_metri/model/events_models/bar_position_class.dart';
import 'package:venti_metri/model/events_models/event_class.dart';
import 'package:venti_metri/model/events_models/product_class.dart';
import 'package:venti_metri/model/expence_class.dart';

import 'dao.dart';

class CRUDModel {
  final String collection;

  Dao _dao;

  CRUDModel(this.collection) {
    _dao = Dao(this.collection);
  }
  Future<List<ExpenceClass>> fetchExpences(DateTime start, DateTime end) async {
    var result = await _dao.getDataCollection(start, end);
    List<ExpenceClass> expencesList;
    expencesList = result.docs
        .map((doc) => ExpenceClass.fromMap(doc.data(), doc.id))
        .toList();

    return expencesList;
  }

  Future<List<Product>> fetchProducts() async {
    var result = await _dao.getAllProductOrderByName();
    List<Product> productList;

    result.docs.forEach((element) {
      print(element.data());
    });

    productList =
        result.docs.map((doc) => Product.fromMap(doc.data(), doc.id)).toList();

    return productList;
  }

  Future<List<EventClass>> fetchEvents() async {
    List<EventClass> eventsList;
    var result = await _dao.getAllData();
    eventsList = result.docs
        .map((doc) => EventClass.fromMap(doc.data(), doc.id))
        .toList();
    return eventsList;
  }

  Future<List<ExpenceClass>> fetchExpencesById(String id) async {
    List<ExpenceClass> expencesList;
    try {
      var result = await _dao.getDataCollectionById(id);
      expencesList = result.docs
          .map((doc) => ExpenceClass.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Errore - ${e}');
    }
    return expencesList;
  }

  Future<List<BarPositionClass>> fetchBarPositionListByEventId(
      String eventId) async {
    List<BarPositionClass> barPositionList;

    try {
      var result = await _dao.getBarPositionCollectionByEventId(eventId);
      barPositionList = result.docs
          .map((doc) => BarPositionClass.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Errore - ${e}');
    }
    return barPositionList;
  }

  Future<List<BarPositionClass>> fetchBarPositionList() async {
    List<BarPositionClass> barPositionList;
    var result = await _dao.getBarPositionCollection();
    barPositionList = result.docs
        .map((doc) => BarPositionClass.fromMap(doc.data(), doc.id))
        .toList();
    return barPositionList;
  }

  Stream<QuerySnapshot> fetchExpenceAsStream() {
    return _dao.streamDataCollection();
  }

  Future<ExpenceClass> getExpenceById(String id) async {
    var doc = await _dao.getDocumentById(id);
    return ExpenceClass.fromMap(doc.data(), doc.id);
  }

  Future removeDocumentById(String id) async {
    await _dao.removeDocument(id);
    return;
  }

  Future deleteCollection(String collection) async{
    await _dao.deleteCollection(collection);
  }

  Future updateProduct(ExpenceClass data, String id) async {
    await _dao.updateDocument(data.toJson(), id);
    return;
  }

  Future addExpenceObject(ExpenceClass data) async {
    await _dao.addDocument(data.toJson());
    return;
  }

  Future addEventObject(EventClass eventClass) async {
    await _dao.addDocument(eventClass.toJson());
    return;
  }

  Future<String> addProductObject(Product product) async {
    var documentReference = await _dao.addDocument(product.toJson());
    return documentReference.id;
  }

  Future<String> addBarPositionObject(BarPositionClass barPositionClass) async {
    DocumentReference documentReference =
        await _dao.addDocument(barPositionClass.toJson());
    return documentReference.id;
  }

  Future updateEventClassById(EventClass data, String id) async {
    await _dao.updateDocument(data.toJson(), id);
    return;
  }

  Future updateBarPositionClassById(BarPositionClass data, String id) async {
    await _dao.updateDocument(data.toJson(), id);
    return;
  }
}
