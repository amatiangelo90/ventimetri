import 'package:flutter/cupertino.dart';

class Product {
  String docId;
  String id;
  String name;
  double price;
  double stock;
  double consumed;
  String category;
  String available;
  String measure;
  bool selected = false;

  Product({
    @required this.docId,
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.stock,
    @required this.consumed,
    @required this.category,
    @required this.available,
    @required this.measure,
    @required this.selected
});

  factory Product.fromJson(dynamic json){
    return Product(
      docId: json['docId'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as double,
      stock: json['stock'] as double,
      consumed: json['consumed'] as double,
      category: json['category'] as String,
      available: json['available'] as String,
      measure: json['measure'] as String,
      selected: json['selected'] as bool,
    );
  }

  factory Product.fromMap(
      Map snapshot,
      String docId){

    double price = 0.0;
    double stock = 0.0;
    double consumed = 0.0;

   /* if(snapshot['price'].runtimeType == double){
      price = snapshot['price'];
    }else if(snapshot['price'].runtimeType == int){
      int intPrice = snapshot['price'];
      price = intPrice.toDouble();
    }else if(snapshot['price'].runtimeType == String){
    }else{
      print('Errore parsing object');
    }*/

    /*if(snapshot['stock'].runtimeType == double){
      price = snapshot['stock'];
    }else if(snapshot['stock'].runtimeType == int){
      int intPrice = snapshot['stock'];
      price = intPrice.toDouble();
    }else{
      print('Errore parsing stock object');
    }
*/
    /*if(snapshot['consumed'].runtimeType == double){
      price = snapshot['consumed'];
    }else if(snapshot['consumed'].runtimeType == int){
      int intPrice = snapshot['consumed'];
      price = intPrice.toDouble();
    }else{
      print('Errore parsing consumed object');
    }
*/
    return Product(
      docId: docId ,
      id: snapshot['id'] as String,
      name: snapshot['name'] as String,
      price: snapshot['price'],
      stock: snapshot['stock'],
      consumed: snapshot['consumed'],
      category: snapshot['category'] as String,
      available: snapshot['available'] as String,
      measure: snapshot['measure'] as String,
      selected: snapshot['selected'] as bool,
    );
  }

  toJson(){

    return {
      'docId' : docId,
      'id' : id,
      'name': name,
      'price' : price,
      'stock' : stock,
      'consumed' : consumed,
      'category' : category,
      'available' : available,
      'measure' : measure,
      'selected' : selected
    };

  }


  @override
  String toString() {
    return this.name.toString();
  }

}