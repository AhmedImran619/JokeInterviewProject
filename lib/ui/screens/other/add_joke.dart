import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jokes_interview_project/models/joke.dart';
import 'package:jokes_interview_project/res/firebase_keys.dart';
import 'package:jokes_interview_project/res/static_info.dart';
import 'package:jokes_interview_project/ui/screens/widgets/joke_preview.dart';

class AddJoke extends StatefulWidget {
  @override
  _AddJokeState createState() => _AddJokeState();
}

class _AddJokeState extends State<AddJoke> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  final bgColors = [
    BgColor('White', 0xfffff),
    BgColor('Red', 0xffff0000),
    BgColor('Green', 0xff00ff00),
    BgColor('Blue', 0xff0000ff),
    BgColor('Cyan', 0xff00FFE1),
    BgColor('Pink', 0xffE600FF),
  ];

  final textColors = [
    BgColor('Black', 0xff000000),
    BgColor('White', 0xffffffff),
  ];

  final textSizes = [14, 16, 18, 20, 22];

  final fontStyles = [
    Font('Roboto'),
    Font('AzeretMono'),
    Font('IndieFlower'),
    Font('KaiseiHarunoUmi'),
  ];

  late BgColor selectedBgColor;
  late BgColor selectedTextColor;
  late int selectedTextSize;
  late Font selectedFontStyle;

  @override
  void initState() {
    super.initState();

    selectedBgColor = bgColors.first;
    selectedTextColor = textColors.first;
    selectedTextSize = textSizes.first;
    selectedFontStyle = fontStyles.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xff000000),
        title: Text('Add Joke'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller,
                  maxLines: 5,
                  validator: (txt) {
                    return txt!.isEmpty ? 'Type something here' : null;
                  },
                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Type here'),
                ),
                SizedBox(height: 10),
                _DropDown(
                  title: 'Background Color: ',
                  selected: selectedBgColor,
                  colors: bgColors,
                  onChange: (color) {
                    setState(() {
                      selectedBgColor = color!;
                    });
                  },
                ),
                SizedBox(height: 10),
                _DropDown(
                  title: 'Text Color: ',
                  selected: selectedTextColor,
                  colors: textColors,
                  onChange: (color) {
                    setState(() {
                      selectedTextColor = color!;
                    });
                  },
                ),
                SizedBox(height: 10),
                _DropDown(
                  title: 'Text Size: ',
                  selected: selectedTextSize,
                  colors: textSizes,
                  onChange: (size) {
                    setState(() {
                      selectedTextSize = size!;
                    });
                  },
                ),
                SizedBox(height: 10),
                _DropDown(
                  title: 'Font Styles: ',
                  selected: selectedFontStyle,
                  colors: fontStyles,
                  onChange: (style) {
                    setState(() {
                      selectedFontStyle = style!;
                    });
                  },
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _preview,
                      child: Text('Preview'),
                    ),
                    ElevatedButton(
                      onPressed: _save,
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Joke _createObject() {
    FocusScope.of(context).unfocus();
    return Joke(
      id: FirebaseFirestore.instance.collection(FirebaseKeys.jokes).doc().id,
      uploaderName: StaticInfo.currentUser!.name,
      uploaderId: StaticInfo.currentUser!.id,
      text: controller.text.trim(),
      likes: 0,
      dislikes: 0,
      creationTime: DateTime.now().millisecondsSinceEpoch,
      fontSize: selectedTextSize,
      bgColor: selectedBgColor.color,
      fontStyle: selectedFontStyle.fontStyle,
      textColor: selectedTextColor.color,
      rating: 0,
    );
  }

  _preview() {
    var joke = _createObject();
    Get.bottomSheet(Padding(
      padding: const EdgeInsets.all(8.0),
      child: JokePreview(joke),
    ));
  }

  _save() async {
    var joke = _createObject();
    StaticInfo.showDialog();

    try {
      await FirebaseFirestore.instance.collection(FirebaseKeys.jokes).doc(joke.id).set(joke.toMap());

      Get.back();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}

class _DropDown extends StatelessWidget {
  final String title;
  final dynamic selected;
  final List colors;
  final Function(dynamic color) onChange;

  const _DropDown({
    required this.title,
    required this.selected,
    required this.colors,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        DropdownButton(
          value: selected,
          items: colors
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: item is BgColor
                        ? Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(color: Color(item.color), border: Border.all()),
                              ),
                              SizedBox(width: 5),
                              Text(item.name.toString()),
                            ],
                          )
                        : item is Font
                            ? Text(
                                item.text.toString(),
                                style: TextStyle(fontFamily: item.fontStyle),
                              )
                            : Text(item.toString()),
                  ))
              .toList(),
          onChanged: onChange,
        ),
        Expanded(child: Container()),
      ],
    );
  }
}

class BgColor {
  String name;
  int color;

  BgColor(this.name, this.color);
}

class Font {
  String text, fontStyle;

  Font(this.fontStyle, [this.text = 'Font Styles']);
}
