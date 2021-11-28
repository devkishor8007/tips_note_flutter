import 'package:flutter/material.dart';

Widget buildMaterialButton({
  required Widget child,
  Function()? onPressed,
  double? minWidth,
  double? height,
  Color? color,
}) {
  return MaterialButton(
    onPressed: onPressed,
    child: child,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    color: color ?? Colors.green,
    textColor: Colors.white,
    minWidth: minWidth ?? 200.3,
    height: height ?? 40,
  );
}
