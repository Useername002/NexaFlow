import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class underconstruction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => constructionState();
}

class constructionState extends State<underconstruction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NexaFlow",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            "Page will be ready soon",
            style: TextStyle(fontSize: 30, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
