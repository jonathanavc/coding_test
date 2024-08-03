class Article {
  final int id;
  final String ?storyTitle;
  final String ?author;
  final DateTime ?createdAt;

  Article({
    required this.id,
    required this.storyTitle,
    required this.author,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['story_id'],
      storyTitle: json['story_title'],
      author: json['author'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storyTitle': storyTitle,
      'author': author,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}