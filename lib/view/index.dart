import 'package:allMusic/util/util.dart';
import 'package:allMusic/view/page/home/index.dart';
import 'package:allMusic/view/page/search/index.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Index extends StatefulWidget {
  Index({Key key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  PageController _pageController = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color color =
        isDark ? Colors.white.withOpacity(0.5) : Theme.of(context).primaryColor;
    Color _primaryColor =
        isDark ? Theme.of(context).primaryColor : Colors.white;
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        showElevation: false,
        selectedIndex: _index,
        backgroundColor: _primaryColor,
        onItemSelected: (index) {
          this.setState(() {
            this._index = index;
          });
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.linear);
        },
        items: [
          BottomNavyBarItem(
              activeColor: color,
              icon: FaIcon(
                FontAwesomeIcons.home,
                color: color,
              ),
              title: Text('首页')),
          BottomNavyBarItem(
              activeColor: color,
              icon: FaIcon(
                FontAwesomeIcons.search,
                color: color,
              ),
              title: Text('搜索')),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[Home(), Search()],
        onPageChanged: (index) {
          this.setState(() {
            this._index = index;
          });
        },
      ),
    );
  }
}
