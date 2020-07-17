import 'dart:convert';

import 'package:allMusic/api/qq/musics.dart';
import 'package:allMusic/view/search/components/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List hot = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHot().then((res) => {
          if (res.statusCode == 200)
            {
              this.setState(() {
                this.hot = json.decode(res.data)['data']['hotkey'];
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 120),
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 80),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: hot.length,
                  itemBuilder: (context, index) {
                    var _opacity = ((30 - index) / 30);
                    return ListTile(
                      title: Text(hot[index]['k']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('${hot[index]['n'] ~/ 10000}w'),
                          SizedBox(
                            width: 5,
                          ),
                          FaIcon(
                            FontAwesomeIcons.fire,
                            color: Colors.red.withOpacity(_opacity),
                            size: 20,
                          ),
                        ],
                      ),
                      leading: Text((index + 1).toString()),
                    );
                  }),
            ),
            SearchBar(),
          ],
        ));
  }
}
