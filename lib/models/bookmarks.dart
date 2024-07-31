import 'dart:convert';

import 'package:flutter/services.dart';

class Station {
  String name;
  String url;
  Station(this.name, this.url);
}

class Group {
  String name;
  List<dynamic> stations;

  Group(this.name, this.stations);

  Group.fromJson(this.name, List<Map<String, dynamic>> stationsJson) :
    stations = stationsJson.map<Station>((e) {
          return Station(e['name'], e['url']);
        }).toList();
}

Future<List<Group>> getBookmarks() async {
  // load json from the file
  final String fileData = await rootBundle.loadString('bookmarks.json');
  List<dynamic> jsonMap = jsonDecode(fileData);

  return jsonMap.map<Group>((e) {
    print(e);
    return Group(e['group'] ?? 'Unknown', e['stations']);
  }).toList();

}