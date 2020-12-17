import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

Future<List<dynamic>> getJson() async {
  return await rootBundle
      .loadString('assets/data.json')
      .then((value) => json.decode(value));
}

class Item {
  String name = '';
  List requirements = [];
  String intelligence = '';
  String intelligence_1 = '';
  String intelligence_2 = '';
  String extraInfo = '';
  String icon = '';
  String description = '';
  String defence = '';
  String stats = ''; // Stats in TE 2
  String confiscated = '';
  String category = '';
  List image_urls = []; // Some items have two images (for both TE editions)

  Item({
    @required this.name,
    @required this.icon,
    this.requirements,
    this.intelligence,
    this.intelligence_1,
    this.intelligence_2,
    this.extraInfo,
    this.description,
    this.defence,
    this.stats,
    this.confiscated,
    this.image_urls,
    this.category,
  });

  String key() => this.name.toLowerCase().replaceAll(RegExp(' +'), '_');

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      icon: json['icon_url'],
      requirements: json['requirements'],
      description: json['description'],
      intelligence: json['intelligence'],
      intelligence_1: json['intelligence_1'],
      intelligence_2: json['intelligence_2'],
      extraInfo: json['extra_info'],
      defence: json['defence'],
      stats: json['stats_in_2'],
      confiscated: json['confiscated'],
      image_urls: json['image_urls'],
      category: json['category'],
    );
  }
}

class ToolsList {
  List items = [];
  Future loadItems() async {
    var jsonString = await getJson();
    this.items = jsonString.map((e) => Item.fromJson(e)).toList();
    return this.items;
  }

  // @TODO: Put in a separate class to potentially initate only once?
  Item getItemWithKey(String key) {
    return this.items.firstWhere((element) => element.key() == key,
        orElse: () => Item(name: 'N/A', icon: ''));
  }

  String getKeyGivenName(String name) {
    return name.toLowerCase().replaceAll(RegExp(' +'), '_');
  }
}
