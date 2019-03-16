import 'package:flutter_news/src/models/item_model.dart';
import 'package:flutter_news/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class StoriesBloc {

  StoriesBloc(){
    items = _items.stream.transform(_itemsTransformer());
  }

  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _items = BehaviorSubject<int>();

  Observable<Map<int,Future<ItemModel>>> items;

  //Getters to Stream
  Observable<List<int>> get topIds => _topIds.stream;

  //getters to Sink
  Function(int) get fetchItem => _items.sink.add;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  _itemsTransformer(){
    return ScanStreamTransformer(
      (Map<int,Future<ItemModel>> cache,int id,_){
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
    <int, Future<ItemModel>>  {},
    );
  }

  dispose(){
    _topIds.close();
    _items.close();
  }
}