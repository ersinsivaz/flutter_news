import 'package:flutter_news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:http/testing.dart';
import 'package:http/http.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test('FetchTopIds returns a list of ids', () async {
    final newsApi = NewsApiProvider();

    newsApi.client = MockClient((request) async {
      return Response(json.encode([1,2,3,4]),200);
    });

    final ids = await newsApi.fetchTopIds();

    //expectation
    expect(ids, [1,2,3,4]);
  });

  test('FetchItem returns a item model', () async {
    final newsApi =NewsApiProvider();
    newsApi.client =MockClient((request) async {
      final jsonMap = {'id':123};
      return  Response(json.encode(jsonMap),200);
    });

    final item = await newsApi.fetchItem(999);
    
    //expectation
    expect(item.id, 123);
  });

}//main

