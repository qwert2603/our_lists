import 'package:flutter/material.dart';

class NewListDialog extends StatefulWidget {
  @override
  _NewListDialogState createState() => _NewListDialogState();
}

class _NewListDialogState extends State<NewListDialog> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New list"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: controller,
            onChanged: (s) => setState(() {}),
            decoration: InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: controller.text.trim().isNotEmpty
              ? () => Navigator.pop(context, controller.text)
              : null,
          child: Text("Save"),
        ),
      ],
    );
  }
}

class NewItemDialog extends StatefulWidget {
  @override
  _NewItemDialogState createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<NewItemDialog> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New item"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: controller,
            onChanged: (s) => setState(() {}),
            decoration: InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: controller.text.trim().isNotEmpty
              ? () => Navigator.pop(context, controller.text)
              : null,
          child: Text("Save"),
        ),
      ],
    );
  }
}

class DeleteItemDialog extends StatelessWidget {
  final String itemName;

  DeleteItemDialog({this.itemName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete "$itemName"?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text("Delete"),
        ),
      ],
    );
  }
}
