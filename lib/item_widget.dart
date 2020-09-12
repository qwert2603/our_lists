import 'package:flutter/material.dart';
import 'package:our_lists/dialogs.dart';
import 'package:our_lists/model.dart';
import 'package:our_lists/utils.dart';

class ItemWidget extends StatelessWidget {
  final Item item;

  ItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    final isFavourite = item.isFavourite;
    return GestureDetector(
      child: CheckboxListTile(
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: isFavourite ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        value: item.isChecked,
        onChanged: (ch) =>
            context.repo.setItemChecked(item.listId, item.id, ch),
        selected: isFavourite,
      ),
      onDoubleTap: () => context.repo
          .setItemFavourite(item.listId, item.id, !item.isFavourite),
      onLongPress: () async {
        final delete = await showDialog(
          context: context,
          child: DeleteItemDialog(
            itemName: item.name,
          ),
        );
        if (delete == true) {
          context.repo.removeItem(item.listId, item.id);
        }
      },
    );
  }
}
