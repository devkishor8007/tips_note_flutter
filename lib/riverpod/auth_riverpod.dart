import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tips_note_fluxfire/data/services/auth_services.dart';

final authServiceRiverpod = Provider<AuthServices>((ref) => AuthServices());

final authStateProvider = StreamProvider.autoDispose<User?>((ref) {
  return ref.read(authServiceRiverpod).authStareChanges;
});

final firebaseDetailProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
