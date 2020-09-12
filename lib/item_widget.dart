import 'package:flutter/material.dart';
import 'package:our_lists/dialogs.dart';
import 'package:our_lists/model.dart';
import 'package:our_lists/utils.dart';

class ItemWidget extends StatelessWidget {
  final Item item;

  ItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    //todo: ripple on touch
    //todo: don't consume long press on checkBox and fav-icon
    return Padding(
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        child: Row(
          children: [
            Checkbox(
              value: item.isChecked,
              onChanged: (ch) =>
                  context.repo.setItemChecked(item.listId, item.id, ch),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              icon: Icon(
                item.isFavourite ? Icons.star : Icons.star_border,
              ),
              onPressed: () => context.repo
                  .setItemFavourite(item.listId, item.id, !item.isFavourite),
            ),
          ],
        ),
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
      ),
    );
  }
}
