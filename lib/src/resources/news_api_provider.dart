import 'dart:async';
import 'dart:convert';
import 'package:flutter_news/src/models/item_model.dart';
import 'package:flutter_news/src/resources/repository.dart';
import 'package:http/http.dart' show Client;

final _root ='https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  Client client = Client();

  Future<List<int>> fetchTopIds() async {
    final response = await client.get('$_root/topstories.json');
    final ids = json.decode(response.body);

    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get('$_root/item/$id.json');
    final parsedJson = json.decode(response.body);
    //print(parsedJson);
    return ItemModel.fromJson(parsedJson);
  }

}//cs