import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:our_lists/dialogs.dart';
import 'package:our_lists/list_screen.dart';
import 'package:our_lists/model.dart';
import 'package:our_lists/repo.dart';
import 'package:our_lists/repo_impl.dart';
import 'package:our_lists/utils.dart';
import 'package:provider/provider.dart';

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
    return Provider<Repo>.value(
      value: RepoImpl(listsPath: LISTS_PATH),
      child: MaterialApp(
        title: 'Our Lists',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
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
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemsList>>(
      stream: context.repo.observeLists(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Our Lists"),
            ),
            body: const Text('Loading...'),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Our Lists"),
          ),
          body: Scrollbar(
            child: ListView(
              children: snapshot.data.map<Widget>((itemsList) {
                    return ListTile(
                      title: Text(itemsList.name),
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteNames.itemsList,
                        arguments: itemsList.id,
                      ),
                      onLongPress: () async {
                        final delete = await showDialog(
                          context: context,
                          builder: (context) => DeleteItemDialog(
                            itemName: itemsList.name,
                          ),
                        );
                        if (delete == true) {
                          context.repo.removeList(itemsList.id);
                        }
                      },
                    );
                  }).toList() +
                  [const SizedBox(height: 96)],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final name = await showDialog(
                context: context,
                builder: (context) => NewListDialog(),
              );
              if (name != null) {
                context.repo.addList(name);
              }
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
