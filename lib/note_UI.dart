// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:nexaflow/DataBase/local/db_helper.dart';
//
// class NoteUI extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return NoteUIState();
//   }
// }
//
// class NoteUIState extends State<NoteUI> {
//   List<Map<String, dynamic>> allNotes = [];
//   DBHelper? dbRef;
//   @override
//   void initState() {
//     super.initState();
//     dbRef = DBHelper.getInstance;
//     getNotes();
//   }
//
//   void getNotes() async {
//     allNotes = await dbRef!.getAllNotes();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Note UI")),
//       body: allNotes.isNotEmpty
//           ? ListView.builder(
//               itemCount: allNotes.length,
//               itemBuilder: (_, index) {
//                 //adding note
//                 return ListTile(
//                   //leading: Text($'{allNotes[index][DBHelper.COLUMN_NOTE_SNO]}'),
//                   title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
//                   subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
//                 );
//               },
//             )
//           : Center(child: Text("No notes here")),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async{
//           bool check=await dbRef!.addNote(mTitle: 'fav note', mDesc: 'hello');
//           if(check)
//             {
//               getNotes();
//             }
//
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
