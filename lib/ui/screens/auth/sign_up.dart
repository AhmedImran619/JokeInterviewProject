import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jokes_interview_project/models/user.dart' as app;
import 'package:jokes_interview_project/res/firebase_keys.dart';
import 'package:jokes_interview_project/res/static_info.dart';
import 'package:jokes_interview_project/ui/screens/home/home.dart';
import 'package:jokes_interview_project/ui/screens/widgets/auth_page.dart';
import 'package:jokes_interview_project/ui/screens/widgets/auth_text_field.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      logoText: 'Sign Up',
      btnText: 'Sign Up',
      emailController: emailController,
      passwordController: passwordController,
      formKey: formKey,
      btnTap: _sigUp,
      moreFields: AuthTextField(
        controller: nameController,
        label: 'Enter your name',
        validator: (txt) {
          if (txt!.isEmpty)
            return 'Name is required';
          else
            return null;
        },
      ),
    );
  }

  _sigUp() async {
    // if (!formKey.currentState!.validate()) return;

    StaticInfo.showDialog();
    FocusScope.of(context).unfocus();

    try {
      var credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text);

      app.User user = app.User(
        id: credentials.user!.uid,
        email: emailController.text.trim(),
        name: nameController.text.trim(),
      );

      await FirebaseFirestore.instance.collection(FirebaseKeys.users).doc(user.id).set(user.toMap());

      StaticInfo.currentUser = user;
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
