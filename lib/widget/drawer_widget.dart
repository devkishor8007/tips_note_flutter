import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tips_note_fluxfire/pages/auth_pages/login_page.dart';
import 'package:tips_note_fluxfire/riverpod/auth_riverpod.dart';
import 'package:tips_note_fluxfire/utilis/routes.dart';

class DrawerWidget extends ConsumerWidget {
  final String username;
  const DrawerWidget({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = FirebaseAuth.instance.currentUser;
    final firebaseAuthy = watch(authServiceRiverpod);
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(user!.email ?? ""),
          ),
          ListTile(
            onTap: () {
              firebaseAuthy.signout();
              pushReplacement(context, const LoginPage());
            },
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
          )
        ],
      ),
    );
  }
}
