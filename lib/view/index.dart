import 'package:allMusic/view/page/home/index.dart';
import 'package:allMusic/view/page/search/index.dart';
import 'package:flutter/material.dart';

class Index extends StatelessWidget {
  const Index({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[Home(), Search()],
      ),
    );
  }
}
