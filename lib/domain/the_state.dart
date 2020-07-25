import 'package:flutter/material.dart';
import 'package:our_lists/data/uuid_generator.dart';
import 'package:our_lists/entity/item.dart';

class TheState extends ChangeNotifier {
  final UuidGenerator _uuidGenerator;

  List<ItemsList> _lists;

  List<ItemsList> get lists => _lists;

  TheState(this._uuidGenerator);

  void createList({String name}) {
    _lists.add(ItemsList(
      uuid: _uuidGenerator.generateRandomUuid(),
      name: name,
      items: [],
    ));
  }

  void renameList({String uuid, String newName}) {}

  void deleteList({String uuid}) {}

  void addItem({String listUuid, String itemName}) {}

  void renameItem({String itemUuid, String newName}) {}

  void checkItem({String itemUuid, bool isChecked}) {}

  void deleteItem({String itemUuid}) {}

  void updateState(Function() updater) {
    updater();
    notifyListeners();
  }
}
