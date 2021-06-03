import 'package:cloud_firestore/cloud_firestore.dart';

class Dao{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath;
  CollectionReference _collectionReference;

  Dao(this.collectionPath) {
    _collectionReference = _db.collection(collectionPath);
  }

  Future<QuerySnapshot> getDataCollection(DateTime start, 
      DateTime end){
    return _collectionReference
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();
  }

  Future<QuerySnapshot> getDataCollectionById(String id){
    return _collectionReference
        .where('id', isEqualTo: id)
        .get();
  }

  Future<QuerySnapshot> getDataCollectionByDateRange() {
    return _collectionReference.get();
  }

  Stream<QuerySnapshot> streamDataCollection(){
    return _collectionReference.get().asStream();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return _collectionReference.doc(id).get();
  }

  Future<void> removeDocument(String id){
    return _collectionReference.doc(id).delete();
  }
  Future<DocumentReference> addDocument(Map data) {

    return _collectionReference.add(data);
  }
  Future<void> updateDocument(Map data , String id) {
    return _collectionReference.doc(id).update(data) ;
  }
}