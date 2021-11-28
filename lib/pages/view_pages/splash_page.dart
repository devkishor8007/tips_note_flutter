import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:tips_note_fluxfire/pages/auth_pages/login_page.dart';
import 'package:tips_note_fluxfire/utilis/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  getTimer() {
    _timer = Timer(const Duration(seconds: 3), _getNext);
  }

  _getNext() {
    pushReplacement(context, const LoginPage());
  }

  @override
  void initState() {
    getTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            TextLiquidFill(
              text: "T",
              boxHeight: MediaQuery.of(context).size.height,
              waveColor: Colors.blueAccent,
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.headline1!.fontSize),
            ),
          ],
        ),
      ),
    );
  }
}
