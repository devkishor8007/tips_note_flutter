import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tips_note_fluxfire/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

final initializeRverpod = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp();
});

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final initialize = watch(initializeRverpod);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      home: initialize.when(
        data: (data) {
          return const IsAuth();
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, stackTrace) => Container(),
      ),
    );
  }
}
