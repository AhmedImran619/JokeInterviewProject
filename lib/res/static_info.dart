import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jokes_interview_project/models/user.dart' as app;

class StaticInfo {
  static app.User? currentUser;

  static void showDialog() => Get.dialog(Material(
        color: Colors.black26,
        child: Center(child: CircularProgressIndicator()),
      ));
}
