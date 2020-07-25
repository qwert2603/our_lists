import 'package:meta/meta.dart';
import 'package:our_lists/util/utils.dart';

@immutable
class Item {
  final String uuid;
  final Stream name;
  final bool isChecked;

  Item({
    @required this.uuid,
    @required this.name,
    @required this.isChecked,
  });
}

@immutable
class ItemsList {
  final String uuid;
  final String name;
  final List<Item> items;

  ItemsList({
    @required this.uuid,
    @required this.name,
    @required List<Item> items,
  }) : this.items = items.toUnmodifiable();
}
