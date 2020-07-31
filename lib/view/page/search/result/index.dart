import 'package:allMusic/util/util.dart';
import 'package:allMusic/view/page/play/index.dart';
import 'package:allMusic/view/test2.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

class Result extends StatefulWidget {
  final List data;
  Result({Key key, this.data}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  Color _bgColor = Colors.white; //default value
  Color _primaryColor = Colors.white;
  Color _textColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    var box = Hive.box('play');
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    _bgColor = getThemeColor(isDark)['_bgColor'];
    _primaryColor = isDark ? Theme.of(context).primaryColor : Colors.white;
    _textColor = getThemeColor(isDark)['_textColor'];
    return ListView.builder(
        itemCount: widget.data.length,
        padding: EdgeInsets.only(top: 5),
        itemBuilder: (context, index) {
          var music = widget.data[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: OpenContainer(
              closedElevation: 0,
              closedColor: _primaryColor,
              openColor: _primaryColor,
              closedBuilder: (context, action) {
                List playlist = box.get('list', defaultValue: []); //添加到播放列表
                playlist.add(music);
                box.put('list', playlist);
                return _item(music, isDark);
              },
              openBuilder: (context, action) => Play(
                isDark: isDark,
              ),
            ),
          );
        });
  }

  _singer(source, singer) {
    if (source == 'kg') {
      return singer;
    } else {
      if (singer is List) {
        String s = singer.fold('', (curr, next) => curr + '/' + next['name']);
        return s.replaceFirst('/', '');
      }
    }
    return 'unknow';
  }

  _item(music, isDark) {
    return Container(
      color: _primaryColor,
      child: ListTile(
        title: Text(
          music['name'],
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_singer(music['source'], music['singer']),
                overflow: TextOverflow.ellipsis),
            // SizedBox(width: 5),
            // Text(' - ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
            // SizedBox(width: 5),
            Text(music['album']['name'], overflow: TextOverflow.ellipsis),
          ],
        ),
        isThreeLine: true,
        leading: AspectRatio(
            aspectRatio: 1,
            child: music['album']['img'] != ''
                ? Stack(
                    children: <Widget>[
                      Image.network(
                        music['album']['img'],
                        fit: BoxFit.cover,
                      ),
                      Visibility(
                        visible: isDark,
                        child: Container(color: Colors.black.withOpacity(0.4)),
                      )
                    ],
                  )
                : Center(
                    child: FaIcon(
                    FontAwesomeIcons.music,
                    size: 30,
                    color: isDark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black.withOpacity(0.5),
                  ))),
        trailing: Container(
          width: 20,
          height: 20,
          child: Image.asset('assets/logo/${music['source']}.png'),
        ),
      ),
    );
  }
}
