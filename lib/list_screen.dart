import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_lists/dialogs.dart';
import 'package:our_lists/main.dart';

class ItemsListScreen extends StatelessWidget {
  final String listId;

  String get itemsPath => "$LISTS_PATH/$listId/items";

  ItemsListScreen({this.listId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              Firestore.instance.document("$LISTS_PATH/$listId").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                return Text(snapshot.data.data['name']);
            }
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(itemsPath).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return GestureDetector(
                    child: CheckboxListTile(
                      title: Text(document['name']),
                      value: document['is_checked'],
                      onChanged: (ch) {
                        Firestore.instance.runTransaction((transaction) async {
                          await transaction.update(
                            document.reference,
                            {"is_checked": ch},
                          );
                        });
                      },
                    ),
                    onLongPress: () async {
                      final delete = await showDialog(
                        context: context,
                        child: DeleteItemDialog(
                          itemName: document["name"],
                        ),
                      );
                      if (delete == true) {
                        document.reference.delete();
                      }
                    },
                  );
                }).toList(),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showDialog(
            context: context,
            child: NewItemDialog(),
          );
          if (name != null) {
            Firestore.instance.collection(itemsPath).document().setData(
              {
                "name": name,
                "is_checked": false,
              },
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
