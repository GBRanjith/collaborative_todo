
// database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/constants.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to the users collection
  CollectionReference get usersCollection =>
      _firestore.collection(Constants.usersCollection);
 
  // Reference to the tasks collection
  CollectionReference get tasksCollection =>
      _firestore.collection(Constants.tasksCollection);
 
  // Create a document with custom ID
  Future<void> setDocument(String collection, String documentId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(documentId).set(data);
  }
 
  // Create a document with auto-generated ID
  Future<DocumentReference> addDocument(String collection, Map<String, dynamic> data) async {
    return await _firestore.collection(collection).add(data);
  }
 
  // Get a document by ID
  Future<DocumentSnapshot> getDocument(String collection, String documentId) async {
    return await _firestore.collection(collection).doc(documentId).get();
  }
 
  // Update a document
  Future<void> updateDocument(String collection, String documentId, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }
 
  // Delete a document
  Future<void> deleteDocument(String collection, String documentId) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }
 
  // Query documents
  Future<QuerySnapshot> queryDocuments(
    String collection, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    Query query = _firestore.collection(collection);
   
    // Apply filters
    if (filters != null) {
      for (var filter in filters) {
        query = filter.apply(query);
      }
    }
   
    // Apply ordering
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
   
    // Apply limit
    if (limit != null) {
      query = query.limit(limit);
    }
   
    return await query.get();
  }
 
  // Listen to a document
  Stream<DocumentSnapshot> documentStream(String collection, String documentId) {
    return _firestore.collection(collection).doc(documentId).snapshots();
  }
 
  // Listen to a collection
  Stream<QuerySnapshot> collectionStream(
    String collection, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query query = _firestore.collection(collection);
   
    // Apply filters
    if (filters != null) {
      for (var filter in filters) {
        query = filter.apply(query);
      }
    }
   
    // Apply ordering
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
   
    // Apply limit
    if (limit != null) {
      query = query.limit(limit);
    }
   
    return query.snapshots();
  }
 
  // Transaction to update multiple documents
  Future<void> runTransaction(Function(Transaction) updateFunction) async {
    await _firestore.runTransaction((transaction) async {
      await updateFunction(transaction);
    });
  }
 
  // Batch write
  Future<void> batchWrite(Function(WriteBatch) updateFunction) async {
    WriteBatch batch = _firestore.batch();
    updateFunction(batch);
    await batch.commit();
  }
}

// Query filter helper class
class QueryFilter {
  final String field;
  final dynamic value;
  final FilterOperator operator;
 
  QueryFilter(this.field, this.operator, this.value);
 
  Query apply(Query query) {
    switch (operator) {
      case FilterOperator.isEqualTo:
        return query.where(field, isEqualTo: value);
      case FilterOperator.isNotEqualTo:
        return query.where(field, isNotEqualTo: value);
      case FilterOperator.isLessThan:
        return query.where(field, isLessThan: value);
      case FilterOperator.isLessThanOrEqualTo:
        return query.where(field, isLessThanOrEqualTo: value);
      case FilterOperator.isGreaterThan:
        return query.where(field, isGreaterThan: value);
      case FilterOperator.isGreaterThanOrEqualTo:
        return query.where(field, isGreaterThanOrEqualTo: value);
      case FilterOperator.arrayContains:
        return query.where(field, arrayContains: value);
      case FilterOperator.arrayContainsAny:
        return query.where(field, arrayContainsAny: value);
      case FilterOperator.whereIn:
        return query.where(field, whereIn: value);
      case FilterOperator.whereNotIn:
        return query.where(field, whereNotIn: value);
    }
  }
}

enum FilterOperator {
  isEqualTo,
  isNotEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  arrayContains,
  arrayContainsAny,
  whereIn,
  whereNotIn,
}


