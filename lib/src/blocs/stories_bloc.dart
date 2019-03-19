import 'dart:async';

import 'package:flutter_news/src/models/item_model.dart';
import 'package:flutter_news/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class StoriesBloc {

  StoriesBloc(){
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int,Future<ItemModel>>>();
  final _itemsFetcher =  PublishSubject<int>();

  

  //Getters to Stream
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int,Future<ItemModel>>> get items => _itemsOutput.stream;

  //getters to Sink
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache(){
    return _repository.clearCache();
  }

  _itemsTransformer(){
    return ScanStreamTransformer(
      (Map<int,Future<ItemModel>> cache,int id,index){
        cache[id] = _repository.fetchItem(id);
        //print(index);
        return cache;
      },
    <int, Future<ItemModel>>  {},
    );
  }

  dispose(){
    _topIds.close();
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}