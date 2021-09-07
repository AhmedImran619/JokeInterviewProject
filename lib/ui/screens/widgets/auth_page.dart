import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:jokes_interview_project/ui/screens/widgets/auth_text_field.dart';
import 'package:jokes_interview_project/ui/screens/widgets/logo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthPage extends StatelessWidget {
  final TextEditingController emailController, passwordController;
  final GlobalKey<FormState> formKey;
  final Widget? moreFields, moreWidgets;
  final Function()? btnTap;
  final String logoText, btnText;

  AuthPage({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.logoText,
    required this.btnText,
    required this.btnTap,
    this.moreFields,
    this.moreWidgets,
  });

  @override
  Widget build(BuildContext context) {
    final availableHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: availableHeight,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Logo(availableHeight * 0.15),
                              SizedBox(height: 20),
                              Text(
                                logoText,
                                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              moreFields ?? Container(),
                              SizedBox(height: 10),
                              AuthTextField(
                                controller: emailController,
                                label: 'Enter your email',
                                validator: (txt) {
                                  if (txt!.isEmpty)
                                    return 'Email is required';
                                  else if (!EmailValidator.validate(txt))
                                    return 'Email invalid';
                                  else
                                    return null;
                                },
                              ),
                              SizedBox(height: 10),
                              AuthTextField(
                                controller: passwordController,
                                label: 'Enter password',
                                obscure: true,
                                validator: (txt) {
                                  if (txt!.isEmpty)
                                    return 'Password is required';
                                  else
                                    return null;
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(onPressed: btnTap, child: Text(btnText)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  moreWidgets ?? Container(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
