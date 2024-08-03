class Article {
  final String ?storyTitle;
  final String ?author;
  final DateTime ?createdAt;

  Article({
    required this.storyTitle,
    required this.author,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      storyTitle: json['story_title'],
      author: json['author'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': storyTitle,
      'author': author,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}