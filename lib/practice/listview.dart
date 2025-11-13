import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class list extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => listState();
}

class listState extends State<list> {
  @override
  Widget build(BuildContext context) {
    var arrMeds = [
      "PCM",
      "Labetalol",
      "CT head",
      "NSAIDS",
      "Citrizine",
      "Azithromycin",
      "ESR",
      "pneumothorax",
      "babesi PCR",
      "Babeiosis",
      "Tick Bite",
      "CBC"
    ];
    return Scaffold(
      appBar: AppBar(title: Text("List view")),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text('${index+1}'),
            title: Text(arrMeds[index]),
            subtitle: Text("Dosage"),
            trailing: Icon(Icons.add),
          );
        },
        itemCount: arrMeds.length,
        separatorBuilder: (context, index) {
          return Divider(height: 20, thickness: 2);
        },
      ),
    );
  }
}
