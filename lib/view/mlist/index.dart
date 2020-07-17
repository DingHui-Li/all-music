import 'package:allMusic/view/mlist/item.dart';
import 'package:flutter/material.dart';

class MList extends StatefulWidget {
  final musics;
  final index;
  MList({Key key, this.musics, this.index}) : super(key: key);

  @override
  _MListState createState() => _MListState();
}

class _MListState extends State<MList> {
  ScrollController _scrollController = ScrollController();
  double _itemHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    if (this._scrollController.hasClients) {
      double _screenHeight = MediaQuery.of(context).size.height - 200;
      double _scrollHeight = _itemHeight * widget.musics.length - _screenHeight;
      double _moveOffset = _itemHeight * widget.index;
      double _offset = this._scrollController.offset;
      if (_offset + _screenHeight < _moveOffset ||
          _moveOffset < _screenHeight) {
        _scrollController.animateTo(
            _moveOffset < _scrollHeight ? _moveOffset : _scrollHeight,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn);
      }
    }
    return ListView.builder(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: widget.musics.length,
        itemBuilder: (context, index) => Item(
            data: widget.musics[index],
            isPlay: widget.index == index,
            index: index));
  }
}
