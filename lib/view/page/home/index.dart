import 'dart:ui';

import 'package:allMusic/util/util.dart';
import 'package:allMusic/view/page/home/musicCard.dart';
import 'package:allMusic/view/page/home/playCard.dart';
import 'package:allMusic/view/page/home/songListTab.dart';
import 'package:allMusic/view/play/index.dart';
import 'package:allMusic/view/test2.dart';
import 'package:animations/animations.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // SwiperController _swiperController = SwiperController();
  // PanelController _panelController = PanelController();
  ScrollController _scrollController = ScrollController();
  Color _bgColor = Colors.white; //default value
  Color _primaryColor = Colors.white;
  Color _textColor = Colors.black;
  bool _scrollTop = false;
  @override
  void initState() {
    super.initState();
    // smartAsso('x').then((res) {
    //   var data = json.decode(res.data);
    //   if (data['code'] == 0) {
    //     //(album, mv, singer, song)
    //     print(data['data']['album']['itemlist']);
    //   }
    // });
    _scrollController.addListener(() {
      var temp = false; //避免重复更新-
      if (_scrollController.offset < 10) {
        temp = false;
        if (temp != this._scrollTop) {
          this.setState(() {
            this._scrollTop = temp;
          });
        }
      } else {
        temp = true;
        if (temp != this._scrollTop) {
          this.setState(() {
            this._scrollTop = temp;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    _bgColor = getThemeColor(isDark)['_bgColor'];
    _primaryColor = getThemeColor(isDark)['_primaryColor'];
    _textColor = getThemeColor(isDark)['_textColor'];
    return Material(
      color: _bgColor,
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.height / 3,
                title: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  title: Container(
                    clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: _primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: TextField(
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                      color: _primaryColor,
                      icon: FaIcon(FontAwesomeIcons.adjust),
                      onPressed: () {
                        var box = Hive.box('app');
                        box.put('dark', !box.get('dark', defaultValue: false));
                      },
                    )
                  ],
                ),
                flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: Image.asset(
                        'assets/bg1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Visibility(
                      visible: isDark,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    )
                  ],
                )),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          padding: EdgeInsets.only(top:this._scrollTop?20:60),
                          child: GridView.count(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3 / 4,
                            children: <Widget>[
                              musicCard(
                                icon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      '20',
                                      style: TextStyle(
                                          fontSize: 28,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '/7',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                title: '今日推荐',
                                color: Colors.blue,
                                cover: '',
                                primaryColor: this._primaryColor,
                              ),
                              musicCard(
                                icon: FaIcon(FontAwesomeIcons.bomb,
                                    color: Colors.black),
                                title: '私人FM',
                                cover:
                                    'http://y.gtimg.cn/music/photo_new/T002R180x180M000002lJJi244utqN_1.jpg',
                                primaryColor: this._primaryColor,
                                color: this._textColor,
                              ),
                              musicCard(
                                icon: FaIcon(FontAwesomeIcons.solidHeart,
                                    color: Colors.red),
                                title: '我喜欢的音乐',
                                cover:
                                    'http://y.gtimg.cn/music/photo_new/T002R180x180M000002lJJi244utqN_1.jpg',
                                primaryColor: this._primaryColor,
                                color: this._textColor,
                              ),
                            ],
                          ),
                        ),
                        Container(height: 500,)
                      ],
                    )),
              )
            ],
          ),
          PlayCard(
            sc: _scrollController,
            primaryColor: this._primaryColor,
            textColor: this._textColor,
          )
        ],
      ),
    );
  }
}
