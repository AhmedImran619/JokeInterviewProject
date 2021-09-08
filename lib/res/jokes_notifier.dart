import 'package:flutter/material.dart';
import 'package:jokes_interview_project/models/joke.dart';

class JokesProvider extends ChangeNotifier {
  final List<Joke> _publicJokes = [];
  final List<Joke> _myJokes = [];
  final List<String> _favorites = [];

  List<Joke> get publicJokes => _publicJokes;

  List<Joke> get myJokes => _myJokes;

  List<String> get favorites => _favorites;

  void update({List<Joke>? my, List<Joke>? public, List<String>? favorite}) {
    if (my != null && my.isNotEmpty) {
      myJokes.clear();
      myJokes.addAll(my);
    }
    if (public != null && public.isNotEmpty) {
      publicJokes.clear();
      publicJokes.addAll(public);
    }
    if (favorite != null && favorite.isNotEmpty) {
      favorites.clear();
      favorites.addAll(favorite);
    }

    notifyListeners();
  }
}
