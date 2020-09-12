import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_lists/mappers.dart';
import 'package:our_lists/model.dart';
import 'package:our_lists/repo.dart';
import 'package:our_lists/utils.dart';

class RepoImpl implements Repo {
  final firestore = FirebaseFirestore.instance;
  final String listsPath;

  RepoImpl({this.listsPath});

  @override
  Stream<List<ItemsList>> observeLists() =>
      firestore.collection(listsPath).snapshots().map(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (queryDocumentsSnapshot) =>
                      queryDocumentsSnapshot.toItemsList(),
                )
                .toList()
                .toUnmodifiable(),
          );

  @override
  Stream<ItemsList> observeList(String listId) =>
      firestore.doc("$listsPath/$listId").snapshots().map(
            (querySnapshot) => querySnapshot.toItemsList(),
          );

  @override
  Stream<List<Item>> observeItemsInList(String listId) => firestore
      .collection("$listsPath/$listId/items")
      .snapshots()
      .map((querySnapshot) => List<DocumentSnapshot>.of(querySnapshot.docs)
              .map((e) => e.toItem(listId: listId))
              .toList()
              .sortedByQ(
            [
              (d) => -1 * (d.isFavourite ? 1 : 0),
              (d) => -1 * (d.isChecked ? 1 : 0),
              (d) => d.name,
            ],
          ).toUnmodifiable());

  @override
  void setItemFavourite(String listId, String itemId, bool isFavourite) {
    firestore.doc("$listsPath/$listId/items/$itemId").set(
      {"is_favourite": isFavourite},
      SetOptions(merge: true),
    );
  }

  @override
  void setItemChecked(String listId, String itemId, bool isChecked) {
    firestore.doc("$listsPath/$listId/items/$itemId").set(
      {"is_checked": isChecked},
      SetOptions(merge: true),
    );
  }

  @override
  void removeItem(String listId, String itemId) {
    firestore.doc("$listsPath/$listId/items/$itemId").delete();
  }

  @override
  void removeList(String listId) {
    firestore.doc("$listsPath/$listId").delete();
  }

  @override
  void addItem(String listId, String name) {
    firestore.collection("$listsPath/$listId/items").doc().set(
      {
        "name": name,
        "is_checked": false,
      },
    );
  }

  @override
  void addList(String name) {
    firestore.collection(listsPath).doc().set(
      {"name": name},
    );
  }
}
