import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venti_metri/model/cart.dart';
import 'package:venti_metri/model/events_models/bar_position_class.dart';
import 'package:venti_metri/model/events_models/event_class.dart';
import 'package:venti_metri/model/events_models/product_event.dart';
import 'package:venti_metri/model/product_restaurant.dart';
import 'package:venti_metri/model/exception_event.dart';
import 'package:venti_metri/model/expence_class.dart';
import 'package:venti_metri/model/order_store.dart';

import 'dao.dart';

class CRUDModel {
  final String collection;

  Dao _dao;
  List<OrderStore> customerOrders;

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

  Future<List<ExpenceClass>> fetchAllExpences() async {
    var result = await _dao.getAllDataCollection();
    List<ExpenceClass> expencesList = result.docs
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

  Future<List<ProductRestaurant>> fetchRestaurantProducts() async {
    var result = await _dao.getAllProductOrderByName();
    List<ProductRestaurant> productList;

    result.docs.forEach((element) {
      print(element.data());
    });
    productList =
        result.docs.map((doc) => ProductRestaurant.fromMap(doc.data(), doc.id)).toList();

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

  Future<List<ProductRestaurant>> fetchWine() async {

    List<ProductRestaurant> products = <ProductRestaurant>[];

    var result = await _dao.getWineCollectionOrderedByType();

    products = result.docs
        .map((doc) => ProductRestaurant.fromMap(doc.data(), doc.id))
        .toList();

    return products;
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

  Future updateExpence(ExpenceClass data, String id) async {
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

  Future addException(
      String name,
      String exception,
      String time) async {

    ExceptionEvent exceptionEv = ExceptionEvent(
        Random.secure().nextInt(40000000).toString(),
        name,
        exception,
        time);

    await _dao.addDocument(exceptionEv.toJson());
    return ;
  }


  Future addOrder(
      String uniqueId,
      String name,
      String total,
      String time,
      List<dynamic> cartItems,
      bool confirmed,
      String typeOrder,
      String datePickupDelivery,
      String hourPickupDelivery,
      String address,
      String city) async {

    OrderStore orderStore = OrderStore(
        '',
        uniqueId,
        name,
        cartItems,
        time,
        total,
        confirmed,
        typeOrder,
        datePickupDelivery,
        hourPickupDelivery,
        city,
        address);

    await _dao.addDocument(orderStore.toJson());
    return ;
  }

  Future removeProduct(String id) async{
    await _dao.removeDocument(id) ;
    return ;
  }

  Future<List<OrderStore>> fetchCustomersOrder() async {

    try{
      var result = await _dao.getOrdersStoreCollection();

      //customerOrders = result.docs
      //    .map((doc) => OrderStore.fromMap(
      //    doc.data(),
      //    doc.id,
      //    buildListCart(doc.data()['cartItemsList'])))
      //   .toList();

      print(customerOrders);

      return customerOrders.toList();
    }catch(e){
      throw Exception(e);
    }
  }

  List buildListCart(List element) {
    try{
      List<Cart> listCart = <Cart>[];
      element.forEach((currentItem) {
        currentItem = currentItem.toString().replaceAll('{', '{"');
        currentItem = currentItem.toString().replaceAll('}', '"}');
        currentItem = currentItem.toString().replaceAll(',', '","');
        currentItem = currentItem.toString().replaceAll(':', '":"');
        currentItem = currentItem.toString().replaceAll(' product', 'product');
        currentItem = currentItem.toString().replaceAll(' numberOfItem', 'numberOfItem');
        currentItem = currentItem.toString().replaceAll(' changes', 'changes');
        Map valueMap = json.decode(currentItem);

        listCart.add(Cart(
            product : ProductRestaurant('', valueMap['product'], '', ["-"], ["-"], 0.0, 0, ["-"], '', 'true'),
            numberOfItem: int.parse(valueMap['numberOfItem'].toString().replaceAll(" ", "")),
            changes: null
        ));
      });

      return listCart;
    }catch(e){
      print('Exception: ' + e.toString());
      throw Exception(e);
    }

  }

  Future addProduct(ProductRestaurant data) async{
    await _dao.addDocument(data.toJson());
    return ;
  }

  Future updateOrder(OrderStore orderStore, String id) async{
    await _dao.updateDocument(orderStore.toJson(), id) ;
    return ;
  }

  Future updateProduct(ProductRestaurant data, String id) async{
    await _dao.updateDocument(data.toJson(), id) ;
    return ;
  }

}
