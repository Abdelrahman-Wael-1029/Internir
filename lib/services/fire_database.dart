import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internir/utils/utils.dart';

class FireDatabase {
  FireDatabase._();

  static final _firebaseFirestore = FirebaseFirestore.instance;
  static Future<DocumentReference<Map<String, dynamic>>?> addData({
    required String collection,
    String? doc,
    required Map<String, dynamic> data,
  }) async {
    try {
      if (doc != null) {
        await _firebaseFirestore.collection(collection).doc(doc).set(data);
      } else {
        // add data with auto generated id
        return await _firebaseFirestore.collection(collection).add(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<void> updateData(
      String collection, String id, Map<String, dynamic> data) async {
    try {
      await _firebaseFirestore.collection(collection).doc(id).update(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> deleteData(String collection, String id) async {
    try {
      await _firebaseFirestore.collection(collection).doc(id).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<dynamic> getData(
    String collection, {
    String? orderBy,
    bool descending = false,
    // List of filters
    // example: [['field', 'value', OperationFilter.isEqualTo.name],]
    List<List<dynamic>>? filters,
    // for pagination
    int? limit,
    dynamic startAfterValue,
    dynamic endBeforeValue,
    bool isPrevious = false,
  }) async {
    try {
      Query<Map<String, dynamic>> query =
          _firebaseFirestore.collection(collection);

      // Apply ordering
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      if (filters != null) {
        for (final filter in filters) {
          query = query.where(
            filter[0],
            isEqualTo:
                filter[2] == OperationFilter.isEqualTo.name ? filter[1] : null,
            isLessThan:
                filter[2] == OperationFilter.isLessThan.name ? filter[1] : null,
            isLessThanOrEqualTo:
                filter[2] == OperationFilter.isLessThanOrEqualTo.name
                    ? filter[1]
                    : null,
            isGreaterThan: filter[2] == OperationFilter.isGreaterThan.name
                ? filter[1]
                : null,
            isGreaterThanOrEqualTo:
                filter[2] == OperationFilter.isGreaterThanOrEqualTo.name
                    ? filter[1]
                    : null,
            whereIn:
                filter[2] == OperationFilter.whereIn.name ? filter[1] : null,
            arrayContains: filter[2] == OperationFilter.arrayContains.name
                ? filter[1]
                : null,
            arrayContainsAny: filter[2] == OperationFilter.arrayContainsAny.name
                ? filter[1]
                : null,
            isNull: filter[2] == OperationFilter.isNull.name ? filter[1] : null,
            isNotEqualTo: filter[2] == OperationFilter.isNotEqualTo.name
                ? filter[1]
                : null,
            whereNotIn:
                filter[2] == OperationFilter.whereNotIn.name ? filter[1] : null,
          );
        }
      }

      // For next page
      if (startAfterValue != null && !isPrevious) {
        query = query.startAfter([startAfterValue]);
      }

      // For previous page (reverse the order)
      if (endBeforeValue != null && isPrevious) {
        query = query.endBefore([endBeforeValue]);
      }

      // Apply limit
      if (limit != null) {
        if (isPrevious) {
          query = query.limitToLast(limit);
        } else {
          query = query.limit(limit);
        }
      }

      // Get results
      return await query.get();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<dynamic> getDocument(String collection, String id) async {
    try {
      final data =
          await _firebaseFirestore.collection(collection).doc(id).get();
      return data.data();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Stream<QuerySnapshot> streamData(String collection) {
    return _firebaseFirestore.collection(collection).snapshots();
  }

  static Stream<DocumentSnapshot> streamDocument(String collection, String id) {
    return _firebaseFirestore.collection(collection).doc(id).snapshots();
  }

  static Future<void> addDataWithId(
      String collection, String id, Map<String, dynamic> data) async {
    try {
      await _firebaseFirestore.collection(collection).doc(id).set(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
