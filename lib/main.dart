import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:radiotray_mobile/models/bookmarks.dart';
import 'package:http/http.dart' as http;
import 'package:radiotray_mobile/radio.dart';

RadioClass radioClass = RadioClass();

void main() {
  runApp(const MyApp());
}

void playStream(String title, String url) async {
  // Is the URL an m3u or other palylist file?
  if (url.endsWith("m3u")) {
    print('Loading Playlist Data');
    String playlistData = await http.read(Uri.parse(url));
    print(playlistData);
    url = playlistData.split("\n")[0];
  }

  // TODO Add ASX Parsing

  radioClass.setChannel(title, url);

  Future.delayed(
    const Duration(seconds: 1),
        () => radioClass.play(),
  );
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'group',
          builder: (BuildContext context, GoRouterState state) {
            return GroupScreen(state.extra as dynamic);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var stationList = FutureBuilder(
        future: getBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
                "Error loading bookmarks: " + snapshot.error.toString());
          }
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.expand((e) {
                return [
                  ListTile(
                    title: Text(e.name),
                    onTap: () {
                      context.go("/group", extra: e);
                    },
                  )
                ];
              }).toList(),
            );
          }

          return Text("Loading");
        });

    return Scaffold(
      appBar: AppBar(title: const Text('Radiotray Mobile')),
      body: stationList,
    );
  }
}

class GroupScreen extends StatelessWidget {
  GroupScreen(this.group) : super();

  Group group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: ListView(
        children: group.stations.map((e) {
          return ListTile(
            title: Text(e['name']),
            subtitle: Text(e['url']),
            onTap: () {
              playStream(e['name'], e['url']);
            },
          );
        }).toList(),
      ),
    );
  }
}
