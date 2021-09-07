import 'package:flutter/material.dart';
import 'package:jokes_interview_project/models/joke.dart';

class JokesProvider extends ChangeNotifier {
  final List<Joke> _publicJokes = [];
  final List<Joke> _myJokes = [];

  List<Joke> get publicJokes => _publicJokes;

  List<Joke> get myJokes => _myJokes;

  void update(List<Joke> my, List<Joke> public) {
    if (my.isNotEmpty) {
      myJokes.clear();
      myJokes.addAll(my);
    }  if (public.isNotEmpty) {
      publicJokes.clear();
      publicJokes.addAll(public);
    }

    notifyListeners();
  }

}
