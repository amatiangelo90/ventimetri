
import 'package:venti_metri/model/cart.dart';

class OrderStore {

  final String docId;
  final String id;
  final String name;
  final List<Cart> cartItemsList;
  final String date;
  final String total;
  bool confirmed;
  final String typeOrder;
  final String datePickupDelivery;
  final String hourPickupDelivery;
  final String city;
  final String address;

  OrderStore(
      this.docId,
      this.id,
      this.name,
      this.cartItemsList,
      this.date,
      this.total,
      this.confirmed,
      this.typeOrder,
      this.datePickupDelivery,
      this.hourPickupDelivery,
      this.city,
      this.address,
      );


  toJson(){
    return {
      'docId' : docId,
      'id' : id,
      'name' : name,
      'cartItemsList': serializeList(cartItemsList),
      'date': date,
      'total' : total + ' €',
      'confirmed' : confirmed,
      'typeOrder' : typeOrder,
      'datePickupDelivery' : datePickupDelivery,
      'hourPickupDelivery' : hourPickupDelivery,
      'city' : city,
      'address' : address
    };
  }

  factory OrderStore.fromMap(
      Map snapshot,
      String docId,
      List<Cart> cartList
      ){
    return OrderStore(
      docId,
      snapshot['id'] as String,
      snapshot['name'] as String,
      cartList,
      snapshot['date'] as String,
      snapshot['total'] as String,
      snapshot['confirmed'] as bool,
      snapshot['typeOrder'] as String,
      snapshot['datePickupDelivery'] as String,
      snapshot['hourPickupDelivery'] as String,
      snapshot['city'] as String,
      snapshot['address'] as String,
    );
  }

  serializeList(List<Cart> cartItemsList) {
    List<String> orderDeserialized = <String>[];

    cartItemsList.forEach((element) {
      orderDeserialized.add(element.toJson().toString());
    });
    return orderDeserialized;
  }

  @override
  String toString() {
    return 'Name: ' + name + ' - Hour PickupDelivery: '
        + hourPickupDelivery + ' '
        '- Cart: ' + cartItemsList.toString();
  }

  void buildCartListFromListOfString(String cartList) {
    print(cartList);
  }


}