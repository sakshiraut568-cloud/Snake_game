class GameScore {
  final int score;
  final String date;

  GameScore({required this.score, required this.date});

  Map<String, dynamic> toJson() => {
    'score': score,
    'date': date,
  };

  factory GameScore.fromJson(Map<String, dynamic> json) => GameScore(
    score: json['score'],
    date: json['date'],
  );
}
