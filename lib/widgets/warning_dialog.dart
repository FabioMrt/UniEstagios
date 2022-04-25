import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/theme.dart';

appWarningDialog(
    {required String title,
    required String middleText,
    String? buttonText,
    bool cancel = false,
    void Function()? onConfirm}) {
  return Get.defaultDialog(
    title: title,
    radius: 0,
    middleText: middleText,
    titlePadding: const EdgeInsets.all(8),
    confirm: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(kPrimaryColor),
      ),
      child: Text(
        buttonText ?? 'Ok',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: onConfirm ?? Get.back,
    ),
    cancel: cancel
        ? ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: Text(
              buttonText ?? 'Ok',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: Get.back,
          )
        : null,
  );
}
