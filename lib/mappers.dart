import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_lists/model.dart';

extension DocumentX on DocumentSnapshot {
  Item toItem({String listId}) => Item(
        id: id,
        name: get("name"),
        listId: listId,
        isChecked: data()["is_checked"] ?? false,
        isFavourite: data()["is_favourite"] ?? false,
      );

  ItemsList toItemsList() => ItemsList(
        id: id,
        name: get("name"),
      );
}
