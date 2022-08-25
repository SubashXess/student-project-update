import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text, {Color? bgColor}) {
  return ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(backgroundColor: bgColor, content: Text(text)));
}
