import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tips_note_fluxfire/data/models/post_user.dart';

class UserPostServices {
  final CollectionReference _db = FirebaseFirestore.instance.collection('post');

  Stream<List<PostUserModel>> get getDataFromFirebase {
    return _db
        .orderBy(
          "date",
          descending: true,
        )
        .snapshots()
        .map(_getFromSnap);
  }

  List<PostUserModel> _getFromSnap(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((snap) => PostUserModel(
              id: snap.id,
              title: snap['title'],
              postby: snap['postby'],
              photo: snap['photo'],
              // comment: snap['comment'],
              date: snap['date'],
              uid: snap['uid'],
              isLiked: snap['isLiked'],
              count: snap['count'],
            ))
        .toList();
  }

  Future insertPost({
    required String title,
    required String photo,
    required String comment,
    required String uid,
    required String postby,
    required String postId,
  }) async {
    try {
      await _db.doc(postId).set({
        'title': title,
        'photo': photo,
        'comment': comment,
        'date': Timestamp.now(),
        'uid': uid,
        'isLiked': false,
        'count': 0,
        'postby': postby,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future deletePost(postId) async {
    try {
      await _db.doc(postId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future updatePost({
    required String updateId,
    required String title,
  }) async {
    await _db.doc(updateId).update({
      'title': title,
    });
  }
}
