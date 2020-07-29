import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_lists/dialogs.dart';

class ItemWidget extends StatelessWidget {
  final DocumentSnapshot document;

  ItemWidget(this.document);

  @override
  Widget build(BuildContext context) {
    final isFavourite = document.data()["is_favourite"] ?? false;
    return GestureDetector(
      child: CheckboxListTile(
        title: Text(
          document.get('name'),
          style: TextStyle(
            fontWeight: isFavourite ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        value: document.get('is_checked'),
        onChanged: (ch) {
          document.reference.set(
            {"is_checked": ch},
            SetOptions(merge: true),
          );
        },
        selected: isFavourite,
      ),
      onDoubleTap: () {
        document.reference.set(
          {"is_favourite": !isFavourite},
          SetOptions(merge: true),
        );
      },
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
  }
}
