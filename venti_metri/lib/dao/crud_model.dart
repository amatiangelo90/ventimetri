import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venti_metri/model/expence_class.dart';

import 'dao.dart';

class CRUDModel{

  final String collection;

  Dao _dao;
  List<ExpenceClass> expencesList;

  CRUDModel(this.collection){
    _dao = Dao(this.collection);
  }

  Future<List<ExpenceClass>> fetchExpences(DateTime start, DateTime end) async {
    var result = await _dao.getDataCollection(start, end);

    print('XXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    expencesList = result.docs
        .map((doc) => ExpenceClass.fromMap(doc.data(), doc.id))
        .toList();

    return expencesList;
  }


  Stream<QuerySnapshot> fetchExpenceAsStream() {
    return _dao.streamDataCollection();
  }

  Future<ExpenceClass> getProductById(String id) async {
    var doc = await _dao.getDocumentById(id);
    return  ExpenceClass.fromMap(doc.data(), doc.id) ;
  }


  Future removeProduct(String id) async{
    await _dao.removeDocument(id) ;
    return ;
  }
  Future updateProduct(ExpenceClass data, String id) async{
    await _dao.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addExpenceObject(ExpenceClass data) async{

    await _dao.addDocument(data.toJson());
    return ;
  }
}