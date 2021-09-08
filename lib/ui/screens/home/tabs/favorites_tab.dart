import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jokes_interview_project/models/joke.dart';
import 'package:jokes_interview_project/res/firebase_keys.dart';
import 'package:jokes_interview_project/res/jokes_notifier.dart';
import 'package:jokes_interview_project/ui/screens/widgets/joke_item.dart';
import 'package:jokes_interview_project/ui/screens/widgets/no_data.dart';
import 'package:provider/provider.dart';

class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var favoriteIds = Provider.of<JokesProvider>(context).favorites;

    if (favoriteIds.isEmpty)
      return Center(
        child: NoData(),
      );

    return ListView.builder(
      itemCount: favoriteIds.length,
      itemBuilder: (_, index) {
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection(FirebaseKeys.jokes).doc(favoriteIds[index]).get(),
          builder: (_, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting)
              return Container();
            var joke = Joke.fromMap(snapshot.data!.data()!);
            return JokeItem(joke, allowResponse: false);
          },
        );
      },
    );
  }
}
