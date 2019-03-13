import 'package:flutter/material.dart';
import 'package:flutter_news/src/screens/news_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News',
      home: NewsList(),
    );
  }
  
}