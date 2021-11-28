import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tips_note_fluxfire/data/services/user_post_service.dart';

final userPostRiverpod =
    Provider<UserPostServices>((ref) => UserPostServices());

final getAllPostRiverpod = StreamProvider((ref) {
  return ref.read(userPostRiverpod).getDataFromFirebase;
});
