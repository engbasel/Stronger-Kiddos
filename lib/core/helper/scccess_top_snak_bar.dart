import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../utils/app_text_style.dart';

void succesTopSnackBar(BuildContext context, String message) {
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.success(
      message: message,
      textStyle: TextStyles.regular22.copyWith(color: Colors.white),
    ),
    displayDuration: const Duration(milliseconds: 300),
  );
}
