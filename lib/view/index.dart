import 'dart:ui';

import 'package:allMusic/util/util.dart';
import 'package:allMusic/view/components/musicCard.dart';
import 'package:allMusic/view/components/playCard.dart';
import 'package:allMusic/view/components/songListTab.dart';
import 'package:allMusic/view/play/index.dart';
import 'package:allMusic/view/test2.dart';
import 'package:animations/animations.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // SwiperController _swiperController = SwiperController();
  // PanelController _panelController = PanelController();
  ScrollController _scrollController = ScrollController();
  List routerStack = ['/'];
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
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color _textColor = isDark ? Colors.white : Colors.black;
    Color _bgColor = isDark ? Colors.black : Colors.white;
    return Material(
      color: HexColor('#eeeeee'),
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
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: TextField(
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.adjust),
                      onPressed: () {},
                    )
                  ],
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'assets/bg1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GridView.count(
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
                                          fontSize: 20,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '/7',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                title: '今日推荐',
                                color: Theme.of(context).primaryColor,
                                cover: '',
                              ),
                              musicCard(
                                icon: FaIcon(FontAwesomeIcons.bomb,
                                    color: Colors.black),
                                title: '私人FM',
                                cover:
                                    'http://y.gtimg.cn/music/photo_new/T002R180x180M000002lJJi244utqN_1.jpg',
                              ),
                              musicCard(
                                icon: FaIcon(FontAwesomeIcons.solidHeart,
                                    color: Colors.red),
                                title: '我喜欢的音乐',
                                cover:
                                    'http://y.gtimg.cn/music/photo_new/T002R180x180M000002lJJi244utqN_1.jpg',
                              ),
                            ],
                          ),
                          SongListTab(),
                        ],
                      ),
                    )),
              )
            ],
          ),
          PlayCard(sc: _scrollController)
        ],
      ),
    );
  }
}
