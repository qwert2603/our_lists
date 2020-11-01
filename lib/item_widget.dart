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
    return Padding(
      padding: EdgeInsets.all(2),
      child: Row(
        children: [
          Checkbox(
            value: item.isChecked,
            onChanged: (ch) =>
                context.repo.setItemChecked(item.listId, item.id, ch),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
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
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 16.0,
                  color: item.isChecked ? Colors.grey[600] : Colors.black,
                  decoration:
                      item.isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
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
    );
  }
}
