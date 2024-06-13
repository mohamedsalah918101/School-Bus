import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

// void main() => runApp(const MyApp());


// class MyHomePage extends StatefulWidget {
//
//
// @override
// State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _currentPage = 1;
//   List<int> _list = List.generate(12, (v) => v);
//
//   Future<bool> _loadMore() async {
//     print("onLoadMore");
//     await Future.delayed(Duration(seconds: 2)); // Simulate network delay
//     setState(() {
//       _list.addAll(List.generate(5, (v) => v + _currentPage * 5 + 7));
//       _currentPage++;
//     });
//     return true;
//   }
//
//   Future<void> _refresh() async {
//     setState(() {
//       _list.clear();
//       _list.addAll(List.generate(12, (v) => v));
//       _currentPage = 1;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         onRefresh: _refresh,
//         child: LoadMore(
//           isFinish: _list.length >= 50, // لضمان الاستمرار حتى 50 عنصر
//           onLoadMore: _loadMore,
//           whenEmptyLoad: true,
//           delegate: const DefaultLoadMoreDelegate(),
//           textBuilder: DefaultLoadMoreTextBuilder.chinese,
//           child: ListView.builder(
//             itemBuilder: (BuildContext context, int index) {
//               return ListTile(
//                 title: Text('Item $index'),
//                 subtitle: Text('The value: ${_list[index]}'),
//               );
//             },
//             itemCount: _list.length,
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final _scrollController = ScrollController();
  final _list = List.generate(20, (index) => 'Item ${index + 1}');
  int _currentPage = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoading) {
        setState(() {
          _isLoading = true;
        });
        Future.delayed(Duration(milliseconds: 500)).then((_) {
          setState(() {
            _currentPage++;
            _list.addAll(List.generate(5, (index) => 'Item ${index + 1 + _currentPage * 5}'));
            _isLoading = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite Scrolling Example'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _list.length + (_isLoading? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index < _list.length) {
            return ListTile(
              title: Text(_list[index]),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}