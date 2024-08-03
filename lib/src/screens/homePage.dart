import 'package:flutter/material.dart';
import 'package:coding_test/src/services/api.dart';
import 'package:coding_test/src/widgets/Article.dart';
import 'package:coding_test/src/models/article.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = true;
  String texto = 'Hola Mundo';
  final apiService = ApiService();
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  void fetchArticles() async {
    setState(() {
      loading = true;
    });
    try {
      final List<Article> articles = await apiService.fetchArticles();
      setState(() {
        this.articles = articles;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                Column(
                  children: articles
                      .map((article) => ArticleWidget(article: article))
                      .toList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchArticles,
        tooltip: 'Refresh Data',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
