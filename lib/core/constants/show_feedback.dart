import 'package:flutter/material.dart';

void showFeedback(BuildContext context, String result, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result),
      backgroundColor: !success ? Colors.red : null,
    ));
  }