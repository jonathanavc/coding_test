import 'package:flutter/material.dart';
import 'package:coding_test/src/models/article.dart';

class ArticleWidget extends StatelessWidget {
  const ArticleWidget({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final String formattedDate = '${article.createdAt!.day}/${article.createdAt!.month}/${article.createdAt!.year}';
    return Column(
      children: [
        ListTile(
          title: Text(article.storyTitle ?? ''),
          subtitle: Text('${article.author} - $formattedDate'),
        ),
        const Divider(
          height: 1,
        ), // Agregar Divider
      ],
    );
  }
}
