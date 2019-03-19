import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_news/src/models/item_model.dart';
import 'package:flutter_news/src/widgets/loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap,this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final item =snapshot.data;

        final children = <Widget>[
          ListTile(
            title: buildText(item.text) ,
            subtitle: item.by =="" ? Text('Deleted') : Text(item.by),
            contentPadding: EdgeInsets.only(right: 16.0,left: (depth + 1) * 16.0),
          ),
          Divider(),
        ];

        item.kids.forEach((kidId) {
          children.add(
            Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1,
            ),
          );
        });

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(String text){
    final textReplaced =text
        .replaceAll('&#x27;', " ' ")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');
    return Text(textReplaced);
  }
}//cs
