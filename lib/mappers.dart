import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_lists/model.dart';

extension DocumentX on DocumentSnapshot {
  Item toItem({required String listId}) => Item(
        id: id,
        name: get("name") as String,
        listId: listId,
        isChecked: get("is_checked") as bool? ?? false,
        isFavourite: get("is_favourite") as bool? ?? false,
      );

  ItemsList toItemsList() => ItemsList(
        id: id,
        name: get("name") as String,
      );
}
