import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

// void main() => runApp(const MyApp());


class MyHomePage extends StatefulWidget {


@override
State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 1;
  List<int> _list = List.generate(12, (v) => v);

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    setState(() {
      _list.addAll(List.generate(5, (v) => v + _currentPage * 5 + 7));
      _currentPage++;
    });
    return true;
  }

  Future<void> _refresh() async {
    setState(() {
      _list.clear();
      _list.addAll(List.generate(12, (v) => v));
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: LoadMore(
          isFinish: _list.length >= 50, // لضمان الاستمرار حتى 50 عنصر
          onLoadMore: _loadMore,
          whenEmptyLoad: true,
          delegate: const DefaultLoadMoreDelegate(),
          textBuilder: DefaultLoadMoreTextBuilder.chinese,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('Item $index'),
                subtitle: Text('The value: ${_list[index]}'),
              );
            },
            itemCount: _list.length,
          ),
        ),
      ),
    );
  }
}// class HomePage extends StatefulWidget {
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