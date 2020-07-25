import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_lists/dialogs.dart';
import 'package:our_lists/list_screen.dart';

const LISTS_PATH = "/apps/our_lists/lists";

class RouteNames {
  static const itemsList = "itemsList";
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Lists',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == RouteNames.itemsList) {
          return MaterialPageRoute(
            builder: (context) =>
                ItemsListScreen(listId: routeSettings.arguments as String),
            settings: routeSettings,
          );
        }
        return null;
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Our Lists"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(LISTS_PATH).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                  children: snapshot.data.documents.map((document) {
                return ListTile(
                  title: Text(document['name']),
                  onTap: () => Navigator.pushNamed(
                    context,
                    RouteNames.itemsList,
                    arguments: document.documentID,
                  ),
                  onLongPress: () async {
                    final delete = await showDialog(
                      context: context,
                      child: DeleteItemDialog(
                        itemName: document["name"],
                      ),
                    );
                    if (delete == true) {
                      document.reference.delete();
                    }
                  },
                );
              }).toList());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showDialog(
            context: context,
            child: NewListDialog(),
          );
          if (name != null) {
            Firestore.instance.collection(LISTS_PATH).document().setData(
              {"name": name},
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
