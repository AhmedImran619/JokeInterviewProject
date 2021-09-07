import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jokes_interview_project/res/static_info.dart';
import 'package:jokes_interview_project/ui/screens/auth/login.dart';
import 'package:jokes_interview_project/ui/screens/widgets/logo.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(vertical: 50.h),
          child: Logo(MediaQuery.of(context).size.width * 0.2),
        ),
        Text(
          'Profile',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20.h),
        _tile('Name: ${StaticInfo.currentUser!.name}'),
        Divider(),
        _tile('Email: ${StaticInfo.currentUser!.email}'),
        Divider(),
        SizedBox(height: 50.h),
        ElevatedButton(onPressed: _logout, child: Text('Logout')),
      ],
    );
  }

  Widget _tile(String title) {
    return ListTile(
      title: Text(title),
    );
  }

  _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      StaticInfo.currentUser = null;

      Get.offAll(Login());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
