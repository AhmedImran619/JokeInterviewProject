import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jokes_interview_project/res/jokes_notifier.dart';
import 'package:jokes_interview_project/ui/screens/splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => JokesProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );

  }
}
