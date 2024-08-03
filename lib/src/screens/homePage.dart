import 'package:flutter/material.dart';
import 'package:coding_test/src/services/api.dart';
import 'package:coding_test/src/widgets/Article.dart';
import 'package:coding_test/src/models/article.dart';
import 'package:coding_test/src/services/localStorage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = true;
  bool usingLocal = false;
  final apiService = ApiService();
  final localSorage = localStorage();
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  void errorDialog(String e) {
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

  void fetchLocalArticles() async {
    usingLocal = true;
    print("fetchLocalArticles");
    loading = true;
    try {
      final List<Article> localArticles = await localSorage.articles();
      setState(() {
        this.articles = localArticles;
        loading = false;
      });
    } catch (e) {
      errorDialog(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  void fetchArticles() async {
    print("fetchArticles");
    setState(() {
      loading = true;
    });
    try {
      final List<Article> articles = await apiService.fetchArticles();
      setState(() {
        this.articles = articles;
        loading = false;
      });
      localSorage.insertArticles(articles);
      usingLocal = false;
    } catch (e) {
      errorDialog(e.toString());
      setState(() {
        loading = false;
      });
      fetchLocalArticles();
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
                usingLocal
                    ? const ListTile(
                        title: Text('Using local data',
                            style: TextStyle(color: Colors.red)),
                      )
                    : const ListTile(
                        title: Text('Using API data',
                            style: TextStyle(color: Colors.green)),
                      ),
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
