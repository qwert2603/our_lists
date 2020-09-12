import 'package:our_lists/model.dart';

abstract class Repo {
  Stream<List<ItemsList>> observeLists();

  Stream<ItemsList> observeList(String listId);

  Stream<List<Item>> observeItemsInList(String listId);

  void addList(String name);

  void addItem(String listId, String name);

  void removeList(String listId);

  void removeItem(String listId, String itemId);

  void setItemChecked(String listId, String itemId, bool isChecked);

  void setItemFavourite(String listId, String itemId, bool isFavourite);
}
