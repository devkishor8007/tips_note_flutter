import 'package:flutter/material.dart';

pushReplacement(BuildContext context, Widget widget) =>
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => widget,
      ),
    );

push(BuildContext context, Widget widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => widget,
      ),
    );

pop(context) => Navigator.pop(context);
