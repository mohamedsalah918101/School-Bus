// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final _firestore = FirebaseFirestore.instance;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore.collection('parent').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) return const CircularProgressIndicator();
//
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final DocumentSnapshot document = snapshot.data!.docs[index];
//               List<dynamic> children = document.data()!['children'];
//
//               return ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: children.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(children[index]['name']),
//                     subtitle: Text(children[index]['grade']),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }