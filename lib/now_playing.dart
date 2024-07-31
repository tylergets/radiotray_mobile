import 'package:flutter/material.dart';

class NowPlaying extends StatelessWidget {

  Stream<String> radioStream;

  NowPlaying(this.radioStream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: radioStream, builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Text(snapshot.data.toString());
      }
      return Text("No data from Stream");
    });
  }
}
