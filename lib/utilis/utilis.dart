import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// TextStyle buildLoginTextStyle(BuildContext context) => TextStyle(
//     fontWeight: FontWeight.bold,
//     letterSpacing: 3.65,
//     fontSize: Theme.of(context).textTheme.headline5!.fontSize);

TextStyle buildLoginMotoTextStyle(context) => GoogleFonts.lato(
      fontSize: Theme.of(context).textTheme.headline5!.fontSize,
    );

TextStyle buildOtherTextStyle(
  context, {
  double? fontsize,
  Color? color,
}) =>
    GoogleFonts.lato(
      color: color,
      fontSize: fontsize ?? Theme.of(context).textTheme.headline5!.fontSize,
    );
