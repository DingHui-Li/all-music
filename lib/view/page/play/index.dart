import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

class Play extends StatefulWidget {
  final index;
  final isDark;
  Play({Key key, this.index = 0, this.isDark = false}) : super(key: key);

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  List musics = Hive.box('play').get('list', defaultValue: []);

  double current = 0; //当前播放位置 s
  bool play = false; //播放
  Timer timer; //定时器-模拟播放
  PageController _pageController = PageController();
  List _temp = [];

  Widget cover() {
    Color _textColor = widget.isDark ? Colors.white : Colors.black;
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: PageView.builder(
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          itemCount: musics.length,
          itemBuilder: (context, index) {
            var music = musics[index];
            return Padding(
                //封面
                padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        // boxShadow: <BoxShadow>[
                        //   BoxShadow(
                        //       color: _textColor.withOpacity(0.1),
                        //       offset: Offset(0, 1),
                        //       blurRadius: 10,
                        //       spreadRadius: 7)
                        // ]
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: music['album']['img'] != ''
                              ? Stack(
                                  children: <Widget>[
                                    ConstrainedBox(
                                      constraints: BoxConstraints.expand(),
                                      child: Image.network(
                                        music['album']['img'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Visibility(
                                        visible: widget.isDark,
                                        child: Container(
                                          color: Colors.black.withOpacity(0.4),
                                        ))
                                  ],
                                )
                              : Center(
                                  child: FaIcon(
                                  FontAwesomeIcons.music,
                                  size: 60,
                                  color: Colors.white.withOpacity(0.5),
                                ))),
                    )));
          },
          onPageChanged: (index) {
            // _temp.add(index);
            // Future.delayed(Duration(milliseconds: 500), () {
            //   if (_temp.length > 0)
            //     Hive.box('play').put('index', _temp[_temp.length - 1]);
            //   _temp = [];
            // });
          },
        ),
      ),
    );
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

  Widget info() {
    var music = musics[widget.index];
    // String _name = musics[widget.index]['data']['songname'];
    // String _singer = musics[widget.index]['data']['singer'][0]['name'];
    Color _textColor = widget.isDark ? Colors.white : Colors.black;
    return Padding(
        //歌名等信息
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListTile(
            title: Text(
              music['name'],
              style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
            ),
            subtitle: Text(
              _singer(music['source'], music['singer']),
              style: TextStyle(color: _textColor),
            ),
            trailing: ClipOval(
              child: Container(
                  width: 33,
                  height: 33,
                  color: _textColor.withOpacity(0.15),
                  child: IconButton(
                    iconSize: 13,
                    icon: FaIcon(FontAwesomeIcons.heart,
                        color: _textColor.withOpacity(0.7)),
                    onPressed: () {},
                  )),
            )));
  }

  Widget progressBar() {
    double _duration =
        double.parse(musics[widget.index]['duration'].toString());
    Color _textColor = widget.isDark ? Colors.white : Colors.black;
    //进度条
    var textStyle = TextStyle(fontSize: 10, color: _textColor.withOpacity(0.7));
    int durationSec = (_duration % 60).round();
    int currentSec = (current % 60).round();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SliderTheme(
              data: SliderThemeData(
                  thumbColor: _textColor.withOpacity(0.6),
                  activeTrackColor: _textColor.withOpacity(0.4),
                  trackHeight: 4,
                  inactiveTrackColor: _textColor.withOpacity(0.1),
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 15)),
              child: Slider(
                max: _duration,
                min: 0.0,
                value: current,
                onChanged: (v) {
                  current = double.parse(v.round().toString());
                  this.setState(() {});
                },
              )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 21, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  '${(current ~/ 60)}:${currentSec < 10 ? '0' + currentSec.toString() : currentSec}',
                  style: textStyle),
              Text(
                  '${(_duration ~/ 60)}:${durationSec < 10 ? '0' + durationSec.toString() : durationSec}',
                  style: textStyle)
            ],
          ),
        )
      ],
    );
  }

  Widget actions() {
    int _duration = musics[widget.index]['duration'];
    Color _textColor = widget.isDark ? Colors.white : Colors.black;
    int total = musics.length;
    //播放操作
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.stepBackward,
                color: _textColor.withOpacity(0.7)),
            onPressed: () {
              if (widget.index - 1 >= 0)
                _pageController.animateToPage(widget.index - 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear);
            },
          ),
          FloatingActionButton(
            elevation: 8,
            backgroundColor: _textColor.withOpacity(0.4),
            onPressed: () {
              play = !play;
              if (play) {
                this.timer = Timer.periodic(Duration(seconds: 1), (timer) {
                  this.current++;
                  this.setState(() {});
                  if (this.current >= _duration) timer.cancel();
                });
              } else {
                if (this.timer != null) this.timer.cancel();
              }
              this.setState(() {});
            },
            child: FaIcon(play ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                color: Colors.white),
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.stepForward,
                color: _textColor.withOpacity(0.7)),
            onPressed: () {
              if (widget.index + 1 < total)
                _pageController.animateToPage(widget.index + 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color _textColor = widget.isDark ? Colors.white : Colors.black;
    if (this._pageController.hasClients) {
      _pageController.animateToPage(widget.index,
          duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    }
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     musics[widget.index]['name'],
        //     style: TextStyle(fontSize: 14),
        //   ),
        //   centerTitle: true,
        //   actions: <Widget>[
        //     IconButton(
        //       icon: FaIcon(
        //         FontAwesomeIcons.ellipsisH,
        //         size: 15,
        //       ),
        //       onPressed: () {},
        //     )
        //   ],
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: Stack(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Image.network(musics[widget.index]['album']['img'],
              fit: BoxFit.cover),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
              color: widget.isDark
                  ? Colors.black.withOpacity(0.8)
                  : Colors.white.withOpacity(0.2)),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(height: 1),
            ListTile(
              leading: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  size: 18,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(musics[widget.index]['name'],
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
              trailing: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.ellipsisH,
                  size: 15,
                ),
                onPressed: () {},
              ),
            ),
            cover(),
            info(),
            progressBar(),
            actions()
          ],
        )
      ],
    ));
  }
}
