import 'dart:convert';

import 'package:allMusic/api/qq/musics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FocusNode _focusNode = FocusNode();
  String _keyword = '';
  List _song = [];
  List _album = [];
  List _mv = [];
  List _singer = [];

  Widget _smartAsso() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      height: _keyword.length > 0 ? MediaQuery.of(context).size.height / 2 : 0,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: _keyword.length > 0
              ? <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(2, 2),
                      blurRadius: 7,
                      spreadRadius: 5)
                ]
              : <BoxShadow>[],
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('歌曲'),
                Divider(),
                ListView.builder(
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: this._song.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        Hive.box('app').put(
                            'route', {'action': 'push', 'route': '/search'});
                        _focusNode.unfocus();
                      },
                      title: Text(this._song[index]['name']),
                      subtitle: Text(this._song[index]['singer']),
                    );
                  },
                ),
                Text('专辑'),
                Divider(),
                ListView.builder(
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: this._album.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(this._album[index]['name']),
                      subtitle: Text(this._album[index]['singer']),
                      leading: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(this._album[index]['pic'],
                            fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
                Text('歌手'),
                Divider(),
                ListView.builder(
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: this._singer.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(this._singer[index]['name']),
                      subtitle: Text(this._singer[index]['singer']),
                      leading: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(this._singer[index]['pic'],
                            fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
                // Text('MV'),
                // Divider(),
                // ListView.builder(
                //   padding: EdgeInsets.all(0),
                //   physics: NeverScrollableScrollPhysics(),
                //   shrinkWrap: true,
                //   itemCount: this._mv.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     return ListTile(
                //       title: Text(this._mv[index]['name']),
                //       subtitle: Text(this._mv[index]['singer']),
                //     );
                //   },
                // ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              boxShadow: _focusNode.hasFocus
                  ? <BoxShadow>[
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(2, 2),
                          blurRadius: 7,
                          spreadRadius: 5)
                    ]
                  : <BoxShadow>[],
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: TextField(
            autofocus: false,
            focusNode: _focusNode,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(20)
            ],
            decoration: InputDecoration(
                border: InputBorder.none, fillColor: Colors.grey),
            onChanged: (v) {
              this.setState(() {
                this._keyword = v.trim();
              });
              smartAsso(v).then((res) {
                if (res.statusCode == 200) {
                  var data = json.decode(res.data);
                  if (data['code'] == 0) {
                    //(album, mv, singer, song)
                    this.setState(() {
                      this._song = data['data']['song']['itemlist'];
                      print(data['data']['song']['itemlist']);
                      this._album = data['data']['album']['itemlist'];
                      this._mv = data['data']['mv']['itemlist'];
                      this._singer = data['data']['singer']['itemlist'];
                    });
                  }
                }
              });
            },
          ),
        ),
        _smartAsso()
      ],
    );
  }
}
