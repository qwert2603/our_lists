import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:our_lists/dialogs.dart';
import 'package:our_lists/list_screen.dart';

const LISTS_PATH = "/apps/our_lists/lists";

class RouteNames {
  static const itemsList = "itemsList";
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
            builder: (context) => ItemsListScreen(
              listId: routeSettings.arguments as String,
            ),
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
        stream: FirebaseFirestore.instance.collection(LISTS_PATH).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                  children: snapshot.data.docs.map((document) {
                return ListTile(
                  title: Text(document.get('name')),
                  onTap: () => Navigator.pushNamed(
                    context,
                    RouteNames.itemsList,
                    arguments: document.id,
                  ),
                  onLongPress: () async {
                    final delete = await showDialog(
                      context: context,
                      child: DeleteItemDialog(
                        itemName: document.get("name"),
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
            FirebaseFirestore.instance.collection(LISTS_PATH).doc().set(
              {"name": name},
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
