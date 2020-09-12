import 'package:flutter/material.dart';
import 'package:our_lists/dialogs.dart';
import 'package:our_lists/item_widget.dart';
import 'package:our_lists/model.dart';
import 'package:our_lists/utils.dart';

class ItemsListScreen extends StatelessWidget {
  final String listId;

  ItemsListScreen({this.listId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<ItemsList>(
          stream: context.repo.observeList(listId),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                return Text(snapshot.data.name);
            }
          },
        ),
      ),
      body: StreamBuilder<List<Item>>(
        stream: context.repo.observeItemsInList(listId),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return Scrollbar(
                child: ListView(
                  children: [
                    ...snapshot.data.map((document) => ItemWidget(document)),
                    const SizedBox(height: 96),
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
            context.repo.addItem(listId, name);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
