import 'dart:ui';

import 'package:escapists_craft_app/models/tools_list.dart';
import 'package:escapists_craft_app/screens/common.dart';
import 'package:escapists_craft_app/screens/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _filteredItems = [];
  List allItems = [];
  var toolsList = ToolsList();

  Future<bool> fetchData() => Future.delayed(Duration(seconds: 1), () {
        toolsList.loadItems().then((items) {
          setState(() {
            allItems = items;
            _filteredItems = List.from(allItems);
          });
        });
        return true;
      });

  Map categorizeItems(items) {
    var categories = Map();
    items.forEach((element) {
      if (!categories.containsKey(element.category)) {
        categories[element.category] = List();
      }
      categories[element.category].add(element);
    });
    return categories;
  }

  List<Widget> buildSlivers(itemsMap) {
    List<Widget> slivers = [];
    itemsMap.forEach((category, items) {
      slivers.add(SliverStickyHeader(
        header: Header(title: category),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return InkWell(
                child: ItemCard(data: items[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        item: items[index],
                      ),
                    ),
                  );
                },
              );
            },
            childCount: items.length,
          ),
        ),
      ));
    });
    return slivers;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Build the widget with data.
            Map categorizedItems = categorizeItems(_filteredItems);
            var categorizedSlivers = buildSlivers(categorizedItems);

            return Scaffold(
              body: Container(
                color: Colors.white,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 20.0,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(widget.title),
                      ),
                      backgroundColor: Colors.black,
                      textTheme: TextTheme(
                        headline6: TextStyle(
                          color: Colors.black,
                          fontSize: 36.0,
                        ),
                      ),
                    ),
                    ...categorizedSlivers,
                  ],
                ),
              ),
            );
          } else {
            // We can show the loading view until the data comes back.
            debugPrint('Step 1, build loading widget');
            return CircularProgressIndicator();
          }
        },
      );
}
