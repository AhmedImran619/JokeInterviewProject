import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Logo extends StatelessWidget {

  final double? size;


  Logo(this.size);

  @override
  Widget build(BuildContext context) {

    return FlutterLogo(
      size: size,

    );
  }
}
