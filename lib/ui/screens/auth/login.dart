import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jokes_interview_project/models/user.dart' as app;
import 'package:jokes_interview_project/res/firebase_keys.dart';
import 'package:jokes_interview_project/res/static_info.dart';
import 'package:jokes_interview_project/ui/screens/auth/sign_up.dart';
import 'package:jokes_interview_project/ui/screens/home/home.dart';
import 'package:jokes_interview_project/ui/screens/widgets/auth_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      logoText: 'Login',
      btnText: 'Login',
      emailController: emailController,
      passwordController: passwordController,
      formKey: formKey,
      btnTap: _login,
      moreWidgets: TextButton(
        onPressed: () {
          Get.to(SignUp());
        },
        child: Text("Don't have account? Create new"),
      ),
    );
  }

  _login() async {
    if (!formKey.currentState!.validate()) return;

    StaticInfo.showDialog();

    FocusScope.of(context).unfocus();

    try {
      var credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text);
      var snapshot = await FirebaseFirestore.instance.collection(FirebaseKeys.users).doc(credentials.user!.uid).get();

      StaticInfo.currentUser = app.User.fromMap(snapshot.data()!);
      Get.back();
      Get.offAll(Home());
    } catch (e) {
      Get.back();
      if (e is FirebaseAuthException)
        Get.snackbar('Error', '${e.message}', backgroundColor: Theme.of(context).accentColor, colorText: Colors.white);
      else
        Get.snackbar('Error', '${e.toString()}');
    }
  }
}
