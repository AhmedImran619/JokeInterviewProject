import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:jokes_interview_project/models/joke.dart';
import 'package:jokes_interview_project/models/response.dart' as model;
import 'package:jokes_interview_project/res/firebase_keys.dart';
import 'package:jokes_interview_project/res/static_info.dart';
import 'package:jokes_interview_project/ui/screens/widgets/joke_preview.dart';

class JokeItem extends StatefulWidget {
  final Joke joke;

  JokeItem(this.joke);

  @override
  _JokeItemState createState() => _JokeItemState();
}

class _JokeItemState extends State<JokeItem> {
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
          JokePreview(widget.joke),
          Divider(),
          Row(
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
              Expanded(
                child: TextButton.icon(
                  onPressed: btnEnabled
                      ? () {
                          _getRating().then((rating) {
                            if (rating != null) _response(FirebaseKeys.rating, rating);
                          });
                        }
                      : null,
                  icon: Icon(Icons.star),
                  label: Text('(${widget.joke.rating})'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: btnEnabled ? () {} : null,
                  icon: Icon(Icons.share),
                  label: Container(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<int?> _getRating() async {
    var rating;
    rating = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: RatingBar(
          itemCount: 5,
          allowHalfRating: false,
          ratingWidget: RatingWidget(
            empty: Icon(Icons.star_border),
            full: Icon(Icons.star),
            half: Container(),
          ),
          onRatingUpdate: (val) {
            rating = val;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(rating);
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
    return rating == null? null: (rating as double).toInt();
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
