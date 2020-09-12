import 'package:meta/meta.dart';

@immutable
class Item {
  final String id;
  final String name;
  final String listId;
  final bool isChecked;
  final bool isFavourite;

  Item({
    this.id,
    this.name,
    this.listId,
    this.isChecked,
    this.isFavourite,
  });
}

@immutable
class ItemsList {
  final String id;
  final String name;

  ItemsList({
    this.id,
    this.name,
  });
}
