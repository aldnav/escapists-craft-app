import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final data;

  const ItemCard({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 14.0),
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        constraints: BoxConstraints(
          minWidth: 40,
          minHeight: 40,
          maxWidth: 60,
          maxHeight: 60,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40.0,
              height: 40.0,
              child: CachedNetworkImage(
                imageUrl: data.icon,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              data.name,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String title;

  const Header({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
