import 'package:flutter/material.dart';
import 'package:jokes_interview_project/res/jokes_notifier.dart';
import 'package:jokes_interview_project/ui/screens/widgets/joke_item.dart';
import 'package:jokes_interview_project/ui/screens/widgets/joke_preview.dart';
import 'package:jokes_interview_project/ui/screens/widgets/no_data.dart';
import 'package:provider/provider.dart';

class MyJokesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<JokesProvider>(
      builder: (_, provider, child) {
        final jokes = provider.myJokes;

        if (jokes.isEmpty)
          return Center(
            child: NoData(),
          );

        return ListView.builder(
          itemCount: jokes.length,
          itemBuilder: (_, index) {
            var joke = jokes[index];
            return JokeItem(joke);
          },
        );
      },
    );
  }
}
