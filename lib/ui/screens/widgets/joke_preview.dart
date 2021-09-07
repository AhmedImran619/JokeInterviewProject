import 'package:flutter/material.dart';
import 'package:jokes_interview_project/models/joke.dart';

class JokePreview extends StatelessWidget {
  final Joke joke;

  JokePreview(this.joke);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 100),
      color: Color(joke.bgColor),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Text(
        joke.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(joke.textColor),
          fontSize: joke.fontSize.toDouble(),
          fontFamily: joke.fontStyle,
        ),
      ),
    );
  }
}
