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

  Future<QuerySnapshot> getAllDataCollection(){
    return _collectionReference.get();
  }

  Future<QuerySnapshot> getAllData(){
    return _collectionReference.get();
  }

  Future<QuerySnapshot> getAllProductOrderByName(){
    return _collectionReference.orderBy('name',descending: false).get();
  }

  Future<QuerySnapshot> getDataCollectionById(String id){
    return _collectionReference
        .where('id', isEqualTo: id)
        .get();
  }

  Future<QuerySnapshot> getBarPositionCollectionByEventId(String eventId){
    return _collectionReference.orderBy('name')
        .where('idEvent', isEqualTo: eventId)
        .get();
  }

  Future<QuerySnapshot> getBarPositionCollection(){
    return _collectionReference.orderBy('name')
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

  Future<void> deleteCollection(String collection) {
    _db.collection(collection).snapshots().forEach((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      }
    });
  }

  Future<QuerySnapshot> getWineCollectionOrderedByType(){
    return _collectionReference.orderBy('category', descending: true).orderBy('name').get();
  }

  Future<QuerySnapshot> getOrdersStoreCollection() {
    return _collectionReference.orderBy('address',descending: false).orderBy('hourPickupDelivery', descending: false).get();
  }
}