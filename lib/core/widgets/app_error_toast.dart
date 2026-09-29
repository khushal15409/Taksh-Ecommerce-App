import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';

class AppErrorToast {
  AppErrorToast._();

  static const String genericMessage = 'Something went wrong';

  static void show(BuildContext context, {String? message}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message ?? genericMessage),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.grey800,
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
