import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniestagios/theme.dart';

AppBar buildAppBar(BuildContext context) {
  final icon = CupertinoIcons.moon_stars;

  return AppBar(
    leading: BackButton(
      color: kPrimaryColor,
      onPressed: () {
        Get.back();
      },
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
