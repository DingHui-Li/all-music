import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';

class Item extends StatefulWidget {
  final data;
  final isPlay;
  final index;
  Item({Key key, this.data, this.isPlay, this.index}) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    int albumid = widget.data['data']['albumid'];
    String _cover =
        'http://imgcache.qq.com/music/photo/album_300/${albumid % 100}/300_albumpic_${albumid}_0.jpg';
    String _name = widget.data['data']['songname'];
    String _singer = widget.data['data']['singer'][0]['name'];

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color _textColor = isDark ? Colors.white : Colors.black;
    Color _bgColor = isDark ? Colors.black : Colors.white;
    return Container(
      height: 70,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(),
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            width: widget.isPlay ? MediaQuery.of(context).size.width : 0,
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: Stack(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: Image.network(_cover, fit: BoxFit.cover),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(_name, style: TextStyle(color: _textColor)),
            subtitle: Text(_singer, style: TextStyle(color: _textColor)),
            leading: AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Image.network(_cover, fit: BoxFit.cover),
              ),
            ),
            onTap: () {
              Hive.box('play').put('index', widget.index);
              Hive.box('play').put('action', 'click');
            },
          ),
        ],
      ),
    );
  }
}
