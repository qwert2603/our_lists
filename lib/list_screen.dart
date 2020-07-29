import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_lists/dialogs.dart';
import 'package:our_lists/item_widget.dart';
import 'package:our_lists/main.dart';
import 'package:our_lists/util/utils.dart';

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
              return Scrollbar(
                child: ListView(
                  children: [
                    ...snapshot.data.docs.sortedByQ([
                      (d) => -1 * ((d.data()["is_favourite"] ?? false) ? 1 : 0),
                      (d) => -1 * ((d.data()["is_checked"] ?? false) ? 1 : 0),
                      (d) => d.data()["name"] ?? "",
                    ]).map<Widget>((document) => ItemWidget(document)),
                    SizedBox(height: 96),
                  ],
                ),
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
