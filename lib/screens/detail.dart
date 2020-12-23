import 'package:cached_network_image/cached_network_image.dart';
import 'package:escapists_craft_app/models/tools_list.dart';
import 'package:flutter/material.dart';

class RequirementItem extends StatelessWidget {
  final data;

  RequirementItem({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 70,
                minHeight: 70,
                maxWidth: 70,
                maxHeight: 70,
              ),
              child: CachedNetworkImage(
                imageUrl: data['icon'],
                fit: BoxFit.contain,
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
                width: 4.0,
              ),
            ),
          ),
          Text(
            data['name'],
            style: TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final item;
  final toolsList = ToolsList();

  DetailPage({@required this.item});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    var intelligenceLabel = 'Intelligence';
    var intelligence = widget.item.intelligence ?? widget.item.intelligence_1;
    if (widget.item.intelligence_2 != null) {
      var intelligence_2 = widget.item.intelligence_2;
      intelligenceLabel = 'Intelligence For TE 1 & TE 2';
      intelligence = "$intelligence (TE 1) & $intelligence_2 (TE 2)";
      if (intelligence_2.toLowerCase().contains("both") ||
          intelligence_2.toLowerCase().contains('all')) {
        intelligence = widget.item.intelligence_2;
      }
    }
    var description = widget.item.description;
    if (widget.item.extraInfo != null) {
      description = "$description\n\n${widget.item.extraInfo}";
    }

    var confiscated = widget.item.confiscated;
    Color confiscatedColor =
        confiscated.contains('Will be') ? Colors.orange : Colors.black;

    var name = widget.item.name;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(name),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 90,
                minHeight: 90,
                maxWidth: 90,
                maxHeight: 90,
              ),
              child: CachedNetworkImage(
                imageUrl: widget.item.icon,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 120.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView.builder(
                    itemCount: widget.item.requirements.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var requirement = widget.item.requirements[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: RequirementItem(
                          data: requirement,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Text(
                    intelligenceLabel + ": ",
                    style: TextStyle(),
                  ),
                  Text(
                    intelligence,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(description.trim()),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Text("Confiscated:"),
                  Text(
                    widget.item.confiscated ?? "N/A",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: confiscatedColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Text("Category/DLC:"),
                  Text(
                    widget.item.category ?? "N/A",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Text("Stats in TE 2:"),
                  Text(
                    widget.item.stats ?? 'N/A',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Text("Defence:"),
                  Text(
                    widget.item.defence ?? 'N/A',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
