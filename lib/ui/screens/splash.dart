import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jokes_interview_project/models/user.dart' as app;
import 'package:jokes_interview_project/res/firebase_keys.dart';
import 'package:jokes_interview_project/res/static_info.dart';
import 'package:jokes_interview_project/ui/screens/auth/login.dart';
import 'package:jokes_interview_project/ui/screens/home/home.dart';
import 'package:jokes_interview_project/ui/screens/widgets/logo.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((_) => _init());
  }

  _init() async {
    await Firebase.initializeApp();

    ScreenUtil.init(
      BoxConstraints(maxHeight: MediaQuery.of(context).size.height, maxWidth: MediaQuery.of(context).size.width),
      designSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
    );

    var fUser = FirebaseAuth.instance.currentUser;
    if (fUser == null)
      Future.delayed(Duration(seconds: 3)).then((value) {
        Get.to(Login());
      });
    else {
      var snapshot = await FirebaseFirestore.instance.collection(FirebaseKeys.users).doc(fUser.uid).get();
      StaticInfo.currentUser = app.User.fromMap(snapshot.data()!);
      Get.offAll(Home());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Logo(MediaQuery.of(context).size.width / 2),
      ),
    );
  }
}
