import 'package:flutter/material.dart';

class cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => cartState();
}

class cartState extends State<cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NexaFlow",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart,
              color: Colors.grey,
              size: 200,
            ),
            Center(child: Text("Cart empty, add items to continue",style: TextStyle(fontSize: 20,color: Colors.grey),))
          ],
        ),
      ),
    );
  }
}
