import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:palette_generator/palette_generator.dart';

class Body extends StatefulWidget {
  final musics;
  final changeMusic;
  Body({Key key, this.musics, this.changeMusic}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  double current = 111; //当前播放位置 s
  bool play = false; //播放
  Timer timer; //定时器-模拟播放
  int currentIndex = 0;
  SwiperController _swiperController = SwiperController();

  Color progressColor = Colors.white;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getColor(0);
  }

  void getColor(index) async {
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(widget.musics[index]['cover']),
        maximumColorCount: 1);
    this.progressColor = paletteGenerator.paletteColors[0].color;
    this.setState(() {});
  }

  Widget cover(String cover) {
    return Padding(
      //封面
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Image.network(cover, fit: BoxFit.cover),
      ),
    );
  }

  Widget info() {
    return Padding(
        //歌名等信息
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListTile(
            title: Text(
              widget.musics[currentIndex]['name'],
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Text(
              widget.musics[currentIndex]['singer'],
              style: TextStyle(color: Colors.white),
            ),
            trailing: ClipOval(
              child: Container(
                  width: 33,
                  height: 33,
                  color: Colors.white.withOpacity(0.15),
                  child: IconButton(
                    iconSize: 13,
                    icon: FaIcon(FontAwesomeIcons.heart,
                        color: Colors.white.withOpacity(0.7)),
                    onPressed: () {},
                  )),
            )));
  }

  Widget progressBar() {
    //进度条
    var textStyle =
        TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.7));
    int durationSec = (widget.musics[currentIndex]['duration'] % 60).round();
    int currentSec = (current % 60).round();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SliderTheme(
              data: SliderThemeData(
                  thumbColor: Colors.white,
                  activeTrackColor: progressColor,
                  trackHeight: 4,
                  inactiveTrackColor: Colors.white.withOpacity(0.15),
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 15)),
              child: Slider(
                max: widget.musics[currentIndex]['duration'],
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
                  '${(widget.musics[currentIndex]['duration'] ~/ 60)}:${durationSec < 10 ? '0' + durationSec.toString() : durationSec}',
                  style: textStyle)
            ],
          ),
        )
      ],
    );
  }

  Widget actions() {
    int total = widget.musics.length;
    //播放操作
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.stepBackward,
                color: Colors.white.withOpacity(0.7)),
            onPressed: () {
              if (this.currentIndex - 1 >= 0) _swiperController.previous();
            },
          ),
          FloatingActionButton(
            elevation: 8,
            backgroundColor: Colors.white.withOpacity(0.4),
            onPressed: () {
              play = !play;
              if (play) {
                this.timer = Timer.periodic(Duration(seconds: 1), (timer) {
                  this.current++;
                  this.setState(() {});
                  if (this.current >= widget.musics[currentIndex]['duration'])
                    timer.cancel();
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
                color: Colors.white.withOpacity(0.7)),
            onPressed: () {
              if (this.currentIndex + 1 < total) _swiperController.next();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 15,
            ),
            onPressed: () {},
          ),
          title: Text(
            widget.musics[currentIndex]['name'],
            style: TextStyle(fontSize: 14),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.ellipsisH,
                size: 15,
              ),
              onPressed: () {},
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Swiper(
                  controller: _swiperController,
                  loop: false,
                  physics: BouncingScrollPhysics(),
                  itemCount: widget.musics.length,
                  itemBuilder: (context, index) =>
                      cover(widget.musics[index]['cover']),
                  onIndexChanged: (value) {
                    widget.changeMusic(value);
                    Future.delayed(Duration(milliseconds: 500),
                        () => this.getColor(value));
                    this.currentIndex = value;
                    this.setState(() {});
                  },
                ),
              ),
            ),
            info(),
            progressBar(),
            actions()
          ],
        ));
  }
}
