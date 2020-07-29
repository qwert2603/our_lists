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
              FirebaseFirestore.instance.doc("$LISTS_PATH/$listId").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                return Text(snapshot.data.data()['name']);
            }
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(itemsPath).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                children:
                snapshot.data.docs.map((DocumentSnapshot document) {
                  return GestureDetector(
                    child: CheckboxListTile(
                      title: Text(document.get('name')),
                      value: document.get('is_checked'),
                      onChanged: (ch) {
                        document.reference.set(
                          {"is_checked": ch},
                          SetOptions(merge: true),
                        );
                      },
                    ),
                    onLongPress: () async {
                      final delete = await showDialog(
                        context: context,
                        child: DeleteItemDialog(
                          itemName: document.get("name"),
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
            FirebaseFirestore.instance.collection(itemsPath).doc().set(
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
