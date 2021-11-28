import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDataService {
  final CollectionReference _db = FirebaseFirestore.instance.collection('user');

  Future insertUser({
    required String name,
    required String email,
    required String uid,
  }) async {
    try {
      await _db.doc(uid).set({
        'name': name,
        'email': email,
        'date': Timestamp.now(),
        'uid': uid,
        'userImage': '',
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getData(String uid, {required String currentuserName}) async {
    final DocumentSnapshot userDocs =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();

    currentuserName = userDocs.get('name');
  }
}
