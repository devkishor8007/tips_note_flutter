import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tips_note_fluxfire/pages/view_pages/home_page.dart';
import 'package:tips_note_fluxfire/pages/view_pages/splash_page.dart';
import 'package:tips_note_fluxfire/riverpod/auth_riverpod.dart';

class IsAuth extends ConsumerWidget {
  const IsAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final checkingauth = watch(authStateProvider);
    return checkingauth.when(
      data: (data) {
        if (data != null) {
          debugPrint(data.uid);
          return HomePage(
            uid: data.uid,
          );
        } else {
          return const SplashPage();
        }
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, stackTrace) => Container(),
    );
  }
}
