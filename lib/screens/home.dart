import 'package:cached_network_image/cached_network_image.dart';
import 'package:escapists_craft_app/models/tools_list.dart';
import 'package:escapists_craft_app/screens/detail.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final searchTextController = TextEditingController();
  var _filteredItems = [];
  List allItems = [];
  var toolsList = ToolsList();
  var query = '';

  @override
  void initState() {
    toolsList.loadItems().then((items) {
      setState(() {
        allItems = items;
        _filteredItems = List.from(allItems);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    searchTextController.dispose();
    super.dispose();
  }

  void searchItems(String name) {
    if (name.isNotEmpty) {
      setState(() {
        _filteredItems = allItems
            .where((o) => o.name.toLowerCase().contains(name.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _filteredItems = List.from(allItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // setState(() {
    //   allItems = ToolsList().items;
    //   _filteredItems = List.from(allItems);
    //   print(allItems);
    // });

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchTextController,
                onChanged: (value) {
                  setState(() {
                    query = value;
                    searchItems(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  var data = _filteredItems[index];
                  return ListTile(
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                        maxWidth: 60,
                        maxHeight: 60,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: data.icon,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: Text(data.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            item: data,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
