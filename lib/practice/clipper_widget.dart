import 'package:flutter/material.dart';

class clip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("clipper widget")),
      body: Center(
        child: ClipRRect(
          child: Align(
            alignment: Alignment.center,
            heightFactor: 0.9,
            widthFactor: 0.9,
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbNE2qoC_Wx2xLJn69oOGpkSQReAOdPlRaxg&s",
            ),
          ),
        ),
      ),
    );
  }
}
