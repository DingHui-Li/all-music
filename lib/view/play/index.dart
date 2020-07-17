import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:palette_generator/palette_generator.dart';

class Play extends StatefulWidget {
  final musics;
  final index;
  final isDark;
  Play({Key key, this.musics, this.index, this.isDark}) : super(key: key);

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
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
          itemCount: widget.musics.length,
          itemBuilder: (context, index) {
            int albumid = widget.musics[index]['data']['albumid'];
            String _cover =
                'http://imgcache.qq.com/music/photo/album_300/${albumid % 100}/300_albumpic_${albumid}_0.jpg';
            return Padding(
                //封面
                padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: _textColor.withOpacity(0.1),
                                offset: Offset(0, 1),
                                blurRadius: 10,
                                spreadRadius: 7)
                          ]),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(_cover, fit: BoxFit.cover),
                      ),
                    )));
          },
          onPageChanged: (index) {
            _temp.add(index);
            Future.delayed(Duration(milliseconds: 500), () {
              if (_temp.length > 0)
                Hive.box('play').put('index', _temp[_temp.length - 1]);
              _temp = [];
            });
          },
        ),
      ),
    );
  }

  Widget info() {
    String _name = widget.musics[widget.index]['data']['songname'];
    String _singer = widget.musics[widget.index]['data']['singer'][0]['name'];
    Color _textColor = widget.isDark ? Colors.white : Colors.black;
    return Padding(
        //歌名等信息
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListTile(
            title: Text(
              _name,
              style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
            ),
            subtitle: Text(
              _singer,
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
    double _duration = double.parse(
        widget.musics[widget.index]['data']['interval'].toString());
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
    int _duration = widget.musics[widget.index]['data']['interval'];
    Color _textColor = widget.isDark ? Colors.white : Colors.black;
    int total = widget.musics.length;
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
        //   leading: IconButton(
        //     icon: FaIcon(
        //       FontAwesomeIcons.chevronDown,
        //       size: 15,
        //     ),
        //     onPressed: () {
        //       widget.close();
        //     },
        //   ),
        //   title: Text(
        //     widget.musics[currentIndex]['name'],
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
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                  color: _textColor.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
            ),
            cover(),
            info(),
            progressBar(),
            actions()
          ],
        ));
  }
}
