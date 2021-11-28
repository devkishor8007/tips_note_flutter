import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tips_note_fluxfire/app.dart';
import 'package:tips_note_fluxfire/riverpod/auth_riverpod.dart';
import 'package:tips_note_fluxfire/riverpod/user_data_riverpod.dart';
import 'package:tips_note_fluxfire/utilis/routes.dart';
import 'package:tips_note_fluxfire/utilis/utilis.dart';
import 'package:tips_note_fluxfire/widget/materialbutton_widget.dart';
import 'package:tips_note_fluxfire/widget/textformfield_widget.dart';

enum Status {
  signin,
  signup,
}

Status type = Status.signin;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void _switchType() {
    if (type == Status.signup) {
      setState(() {
        type = Status.signin;
      });
    } else {
      setState(() {
        type = Status.signup;
      });
    }
    debugPrint(type.toString());
  }

  bool _isLoading = false;

  void loading() {
    _isLoading = !_isLoading;
  }

  final GlobalKey<FormState> _gKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, watch, child) {
          final auth = watch(authServiceRiverpod);
          final userData = watch(userDataRiverpod);

          Future<void> onPressed() async {
            if (!_gKey.currentState!.validate()) {
              return;
            }
            if (type == Status.signin) {
              loading();
              await auth
                  .signIn(email: _email.text, password: _password.text)
                  .whenComplete(
                      () => auth.authStareChanges.listen((event) async {
                            if (event == null) {
                              loading();
                              return;
                            }

                            pushReplacement(context, const IsAuth());
                          }));
            } else {
              loading();
              await auth
                  .createAccount(email: _email.text, password: _password.text)
                  .whenComplete(
                      () => auth.authStareChanges.listen((event) async {
                            if (event == null) {
                              loading();
                              return;
                            }
                            final User? users =
                                FirebaseAuth.instance.currentUser;
                            final _uids = users!.uid;
                            userData.insertUser(
                              email: _email.text,
                              name: _name.text,
                              uid: _uids,
                            );
                            pushReplacement(context, const IsAuth());
                          }));
            }
          }

          return Form(
            key: _gKey,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  height: 150,
                  color: Colors.grey.withOpacity(0.1),
                  child: AnimatedTextKit(
                    isRepeatingAnimation: true,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Each day learn something new, and just as important, relearn something old.',
                        textStyle: buildLoginMotoTextStyle(context),
                      ),
                      TypewriterAnimatedText(
                        'Mistakes - call them unexpected learning experiences.',
                        textStyle: buildLoginMotoTextStyle(context),
                      ),
                    ],
                  ),
                ),
                if (type == Status.signup)
                  buildTextFormFieldWidget(
                    controller: _name,
                    hintText: "Enter your name",
                    obscureText: false,
                    validator: type == Status.signup
                        ? (val) {
                            if (val!.isEmpty) {
                              return "Invalid Name";
                            }
                            return null;
                          }
                        : null,
                  ),
                buildTextFormFieldWidget(
                  controller: _email,
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                buildTextFormFieldWidget(
                    controller: _password,
                    hintText: "Enter password",
                    obscureText: true,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 5) {
                        return 'Invalid password to short';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 10,
                ),
                if (type == Status.signup)
                  buildTextFormFieldWidget(
                    hintText: "Confirm password",
                    obscureText: true,
                    validator: type == Status.signup
                        ? (val) {
                            if (val != _password.text) {
                              return "Invalid Confirm password";
                            }
                            return null;
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 10,
                ),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : buildMaterialButton(
                        child:
                            Text(type == Status.signin ? "SignIn" : "SignUp"),
                        onPressed: onPressed,
                      ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(type == Status.signin
                        ? "Don't have an account"
                        : "Already have an account"),
                    TextButton(
                      onPressed: () {
                        _switchType();
                      },
                      child: Text(
                        type == Status.signin ? "SignIn" : "SignUp",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
