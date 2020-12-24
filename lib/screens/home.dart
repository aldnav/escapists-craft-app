import 'package:async/async.dart';
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
  final searchTextController = TextEditingController();
  // https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2
  AsyncMemoizer _memoizer;

  _fetchData() {
    return this._memoizer.runOnce(() {
      Future.delayed(Duration(seconds: 2), () {
        toolsList.loadItems().then((items) {
          setState(() {
            allItems = items;
            _filteredItems = List.from(allItems);
          });
        });
      });
      return true;
    });
  }

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

  searchItems() {
    var name = searchTextController.text;
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
  void initState() {
    super.initState();
    _memoizer = AsyncMemoizer();
    searchTextController.addListener(searchItems);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _fetchData(),
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
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: SearchBar(
                            searchTextController: searchTextController),
                      ),
                      backgroundColor: Colors.white,
                      toolbarHeight: 10.0,
                    ),
                    ...categorizedSlivers,
                  ],
                ),
              ),
            );
          } else {
            // We can show the loading view until the data comes back.
            return Center(child: CircularProgressIndicator());
          }
        },
      );
}

class SearchBar extends StatelessWidget {
  final TextEditingController searchTextController;

  const SearchBar({
    Key key,
    this.searchTextController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: searchTextController,
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
