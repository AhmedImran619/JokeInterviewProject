import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jokes_interview_project/models/joke.dart';
import 'package:jokes_interview_project/res/firebase_keys.dart';
import 'package:jokes_interview_project/res/jokes_notifier.dart';
import 'package:jokes_interview_project/res/static_info.dart';
import 'package:jokes_interview_project/ui/screens/home/tabs/favorites_tab.dart';
import 'package:jokes_interview_project/ui/screens/home/tabs/my_jokes_tab.dart';
import 'package:jokes_interview_project/ui/screens/home/tabs/newsfeed_tab.dart';
import 'package:jokes_interview_project/ui/screens/home/tabs/profile_tab.dart';
import 'package:jokes_interview_project/ui/screens/other/add_joke.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  late StreamSubscription jokesSubscription, favoriteSubscription;

  @override
  void initState() {
    super.initState();

    _init();
  }

  _init() {
    jokesSubscription = FirebaseFirestore.instance.collection(FirebaseKeys.jokes).snapshots().listen((event) {
      List<Joke> public = [], my = [];
      for (var doc in event.docs) {
        var joke = Joke.fromMap(doc.data());
        if (joke.isMyJoke())
          my.add(joke);
        else
          public.add(joke);
      }

      Provider.of<JokesProvider>(context, listen: false).update(my: my, public: public);
    });

    favoriteSubscription = FirebaseFirestore.instance.collection(FirebaseKeys.users).doc(StaticInfo.currentUser!.id).collection(FirebaseKeys.favorites).snapshots().listen((event) {
      List<String> fav = [];
      for(var doc in event.docs)
        fav.add(doc.id);
      Provider.of<JokesProvider>(context, listen: false).update(favorite: fav);

    });
  }

  @override
  void dispose() {
    jokesSubscription.cancel();
    favoriteSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes 😂'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.sort_outlined))],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: [
          NewsfeedTab(),
          MyJokesTab(),
          FavoritesTab(),
          ProfileTab(),
        ],
      ),
      floatingActionButton: currentPageIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Get.to(AddJoke());
              },
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.animation), label: 'Newsfeed'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_ind_outlined), label: 'My Jokes'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (val) {
          setState(() {
            currentPageIndex = val;
          });
        },
      ),
    );
  }
}
