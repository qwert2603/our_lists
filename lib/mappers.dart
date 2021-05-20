import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_lists/model.dart';

extension DocumentX on DocumentSnapshot {
  Item toItem({required String listId}) {
    final Map<String, dynamic> map = data() as Map<String, dynamic>;
    return Item(
      id: id,
      name: map["name"] as String,
      listId: listId,
      isChecked: map["is_checked"] as bool? ?? false,
      isFavourite: map["is_favourite"] as bool? ?? false,
    );
  }

  ItemsList toItemsList() => ItemsList(
        id: id,
        name: get("name") as String,
      );
}
