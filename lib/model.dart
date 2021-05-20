import 'package:meta/meta.dart';

@immutable
class Item {
  final String id;
  final String name;
  final String listId;
  final bool isChecked;
  final bool isFavourite;

  Item({
    required this.id,
    required this.name,
    required this.listId,
    required this.isChecked,
    required this.isFavourite,
  });
}

@immutable
class ItemsList {
  final String id;
  final String name;

  ItemsList({
    required this.id,
    required this.name,
  });
}
