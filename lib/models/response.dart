class Response {
  String jokeId, userId, action;
  int? rating;

  Response({
    required this.jokeId,
    required this.userId,
    required this.action,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'jokeId': this.jokeId,
      'userId': this.userId,
      'action': this.action,
      'rating': this.rating,
    };
  }

  factory Response.fromMap(Map<String, dynamic> map) {
    return Response(
      jokeId: map['jokeId'] as String,
      userId: map['userId'] as String,
      action: map['action'] as String,
      rating: map['rating'],
    );
  }
}
