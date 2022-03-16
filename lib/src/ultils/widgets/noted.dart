import 'package:flutter/material.dart';
import 'package:streamer/src/constants.dart';

class KAlertDialog {
  final BuildContext context;

  factory KAlertDialog.of(BuildContext context) {
    return KAlertDialog(context);
  }

  KAlertDialog(this.context);

  Future<T?> confirm<T>({
    required String title,
    required String content,
    void Function()? onConfirm,
    void Function()? onCancel,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final cancelButton = TextButton(
      child: Text(
        confirmText,
        style: const TextStyle(color: kRedColor),
      ),
      onPressed: onConfirm ??
          () {
            Navigator.of(context).maybePop(true);
          },
    );
    final continueButton = TextButton(
      child: Text(
        cancelText,
        style: const TextStyle(color: kBlackColor),
      ),
      onPressed: onCancel ??
          () {
            Navigator.of(context).maybePop(false);
          },
    );

    // show the dialog
    final result = await showDialog<T>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );

    return result;
  }
}
