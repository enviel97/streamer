import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:streamer/src/constants.dart';
import 'package:streamer/src/ultils/migrates/spacing.dart';

class KAlertDialog {
  final BuildContext context;

  factory KAlertDialog.of(BuildContext context) {
    return KAlertDialog(context);
  }

  KAlertDialog(this.context);

  void showLoading(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: kWhiteColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Container(
              height: 70.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(children: [
                const SpinKitFadingCube(color: kBlackColor),
                Spacing.horizantal.lg,
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    style: const TextStyle(
                        color: kBlackColor,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 28.0),
                  ),
                )
              ])),
        ),
      ),
    );
  }

  Future<T?> error<T>({
    required String title,
    required String content,
    void Function()? onConfirm,
    String confirmText = 'Confirm',
  }) async {
    final continueButton = TextButton(
      child: Text(
        confirmText,
        style: const TextStyle(color: kRedColor),
      ),
      onPressed: onConfirm ??
          () {
            Navigator.of(context).maybePop(true);
          },
    );

    // show the dialog
    final result = await showDialog<T>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [continueButton],
        );
      },
    );

    return result;
  }

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
      onPressed: onCancel ??
          () {
            Navigator.of(context).maybePop(true);
          },
    );
    final continueButton = TextButton(
      child: Text(
        cancelText,
        style: const TextStyle(color: kBlackColor),
      ),
      onPressed: onConfirm ??
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
