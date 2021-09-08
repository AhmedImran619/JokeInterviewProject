import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:jokes_interview_project/models/joke.dart';
import 'package:jokes_interview_project/models/response.dart' as model;
import 'package:jokes_interview_project/res/firebase_keys.dart';
import 'package:jokes_interview_project/res/jokes_notifier.dart';
import 'package:jokes_interview_project/res/static_info.dart';
import 'package:jokes_interview_project/ui/screens/widgets/joke_preview.dart';
import 'package:provider/provider.dart';

class JokeItem extends StatefulWidget {
  final Joke joke;
  final bool allowResponse;

  JokeItem(this.joke, {this.allowResponse = true});

  @override
  _JokeItemState createState() => _JokeItemState();
}

class _JokeItemState extends State<JokeItem> {
  final globalKey = GlobalKey();
  bool btnEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
              backgroundColor: Colors.black38,
            ),
            title: Text(widget.joke.uploaderName),
          ),
          JokePreview(widget.joke, key: globalKey),
          Divider(),
          Row(
            children: [
              widget.allowResponse
                  ? Expanded(
                flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: btnEnabled ? () => _response(FirebaseKeys.like) : null,
                              icon: Icon(Icons.thumb_up),
                              label: Text('(${widget.joke.likes})'),
                            ),
                          ),
                          Expanded(
                            child: TextButton.icon(
                              onPressed: btnEnabled ? () => _response(FirebaseKeys.dislike) : null,
                              icon: Icon(Icons.thumb_down),
                              label: Text('(${widget.joke.dislikes})'),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              widget.joke.isMyJoke()
                  ? Container()
                  : Expanded(
                      child: TextButton.icon(
                        onPressed: btnEnabled
                            ? _addToFavorite
                            : null,
                        icon: Icon(
                          Icons.star,
                          color: Provider.of<JokesProvider>(context).favorites.contains(widget.joke.id) ? null : Colors.grey,
                        ),
                        label: Container(),
                      ),
                    ),
              // Expanded(
              //   child: TextButton.icon(
              //     onPressed: btnEnabled ? _share : null,
              //     icon: Icon(Icons.share),
              //     label: Container(),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  _addToFavorite() async {
    setState(() {
      btnEnabled = false;
    });

    if (Provider.of<JokesProvider>(context, listen: false).favorites.contains(widget.joke.id))
      await FirebaseFirestore.instance.collection(FirebaseKeys.users).doc(StaticInfo.currentUser!.id).collection(FirebaseKeys.favorites).doc(widget.joke.id).delete();
    else
      await FirebaseFirestore.instance.collection(FirebaseKeys.users).doc(StaticInfo.currentUser!.id).collection(FirebaseKeys.favorites).doc(widget.joke.id).set({widget.joke.id: true});

    setState(() {
      btnEnabled = true;
    });
  }

  _response(String responseType, [int? rating]) async {
    if (widget.joke.isMyJoke()) {
      Get.snackbar('Error', 'Cannot response your own joke');
      return;
    }

    var response = model.Response(
      jokeId: widget.joke.id,
      userId: StaticInfo.currentUser!.id,
      action: responseType,
      rating: rating,
    );

    setState(() {
      btnEnabled = false;
    });

    try {
      var savedData = await FirebaseFirestore.instance
          .collection(FirebaseKeys.responses)
          .where('jokeId', isEqualTo: response.jokeId)
          .where('userId', isEqualTo: response.userId)
          .where('action', isEqualTo: response.action)
          .get();

      if (savedData.docs.isNotEmpty) {
        Get.snackbar('Error', 'Already done');
        return;
      }

      await FirebaseFirestore.instance.collection(FirebaseKeys.responses).doc().set(response.toMap());
      var updatedJoke = widget.joke.copyWith(
        likes: responseType == FirebaseKeys.like ? widget.joke.likes + 1 : null,
        dislikes: responseType == FirebaseKeys.dislike ? widget.joke.dislikes + 1 : null,
        rating: responseType == FirebaseKeys.rating ? widget.joke.rating + rating! : null,
      );

      await FirebaseFirestore.instance.collection(FirebaseKeys.jokes).doc(updatedJoke.id).update(updatedJoke.toMap());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() {
        btnEnabled = true;
      });
    }
  }
}
