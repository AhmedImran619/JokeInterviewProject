import 'package:jokes_interview_project/res/static_info.dart';

class Joke {
  String id, uploaderId, uploaderName, text, fontStyle;
  int bgColor, textColor, fontSize, likes, dislikes, rating, creationTime;

  Joke({
    required this.id,
    required this.uploaderName,
    required this.uploaderId,
    required this.text,
    required this.fontStyle,
    required this.bgColor,
    required this.textColor,
    required this.fontSize,
    required this.likes,
    required this.dislikes,
    required this.rating,
    required this.creationTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'uploaderName': this.uploaderName,
      'uploaderId': this.uploaderId,
      'text': this.text,
      'fontStyle': this.fontStyle,
      'bgColor': this.bgColor,
      'textColor': this.textColor,
      'fontSize': this.fontSize,
      'likes': this.likes,
      'dislikes': this.dislikes,
      'rating': this.rating,
      'creationTime': this.creationTime,
    };
  }

  factory Joke.fromMap(Map<String, dynamic> map) {
    return Joke(
      id: map['id'] as String,
      uploaderName: map['uploaderName'] as String,
      uploaderId: map['uploaderId'] as String,
      text: map['text'] as String,
      fontStyle: map['fontStyle'] as String,
      bgColor: map['bgColor'] as int,
      textColor: map['textColor'] as int,
      fontSize: map['fontSize'] as int,
      likes: map['likes'] as int,
      dislikes: map['dislikes'] as int,
      rating: map['rating'] as int,
      creationTime: map['creationTime'] as int,
    );
  }

  @override
  String toString() {
    return 'Joke{uploaderId: $uploaderId, text: $text, fontStyle: $fontStyle, bgColor: $bgColor, textColor: $textColor, fontSize: $fontSize, likes: $likes, dislikes: $dislikes, creationTime: $creationTime}';
  }

  bool isMyJoke() => uploaderId == StaticInfo.currentUser!.id;

  Joke copyWith({
    String? text,
    String? fontStyle,
    int? bgColor,
    int? textColor,
    int? fontSize,
    int? likes,
    int? dislikes,
    int? rating,
  }) {
    return Joke(
      id: this.id,
      uploaderId: this.uploaderId,
      uploaderName: this.uploaderName,
      text: text ?? this.text,
      fontStyle: fontStyle ?? this.fontStyle,
      bgColor: bgColor ?? this.bgColor,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      rating: rating ?? this.rating,
      creationTime: this.creationTime,
    );
  }
}
