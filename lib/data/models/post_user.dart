import 'package:cloud_firestore/cloud_firestore.dart';

class PostUserModel {
  String? id;
  String? title;
  String? postby;
  String? photo;
  String? comment;
  Timestamp? date;
  String? uid;
  bool isLiked = false;
  int count = 0;
  PostUserModel({
    this.id,
    this.title,
    this.postby,
    this.photo,
    this.comment,
    this.date,
    this.uid,
    required this.isLiked,
    required this.count,
  });

  factory PostUserModel.fromJson(DocumentSnapshot snap) {
    return PostUserModel(
      id: snap.id,
      title: snap['title'],
      postby: snap['postby'],
      photo: snap['photo'],
      comment: snap['comment'],
      date: snap['date'],
      uid: snap['uid'],
      isLiked: snap['isLiked'],
      count: snap['count'],
    );
  }
}
