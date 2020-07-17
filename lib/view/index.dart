import 'dart:convert';
import 'dart:ui';

import 'package:allMusic/api/qq/musics.dart';
import 'package:allMusic/components/CardNavigation/cardNavigation.dart';
import 'package:allMusic/util/hive.dart';
import 'package:allMusic/view/mlist/index.dart';
import 'package:allMusic/view/search/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:allMusic/view/play/index.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SwiperController _swiperController = SwiperController();
  PanelController _panelController = PanelController();
  List routerStack = ['/'];
  @override
  void initState() {
    super.initState();
    getRandomMusics().then((res) => this.setState(() {
          if (res.statusCode == 200) {
            //this.musics = res.data['songlist'];
            var data = json.decode(res.data);
            if (data != null) {
              Hive.box('play').put('list', data['songlist']);
            }
          }
        }));
  }

  // int _currentIndex = 0;
  Widget _panel(isDark, musics, index) {
    return Container(
      decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Play(
        musics: musics,
        isDark: isDark,
        index: index,
      ),
    );
  }

  List _temp = [];
  Widget _collapsed(isDark, musics, index) {
    Color _textColor = isDark ? Colors.white : Colors.black;
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        children: <Widget>[
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
                color: _textColor.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(30))),
          ),
          Expanded(
            child: Swiper(
                controller: _swiperController,
                physics: BouncingScrollPhysics(),
                itemCount: musics.length,
                onIndexChanged: (index) {
                  _temp.add(index);
                  Future.delayed(Duration(milliseconds: 500), () {
                    if (_temp.length > 0)
                      Hive.box('play').put('index', _temp[_temp.length - 1]);
                    _temp = [];
                  });
                },
                itemBuilder: (context, index) {
                  int albumid = musics[index]['data']['albumid'];
                  String _cover =
                      'http://imgcache.qq.com/music/photo/album_300/${albumid % 100}/300_albumpic_${albumid}_0.jpg';
                  String _name = musics[index]['data']['songname'];
                  String _singer = musics[index]['data']['singer'][0]['name'];
                  return ListTile(
                    onTap: () {
                      this._panelController.open();
                    },
                    title: Text(_name, overflow: TextOverflow.ellipsis),
                    subtitle: Text(_singer, overflow: TextOverflow.ellipsis),
                    leading: Container(
                      constraints: BoxConstraints(maxWidth: 50),
                      child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Image.network(_cover, fit: BoxFit.cover))),
                    ),
                    trailing: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: CircularProgressIndicator(
                                value: 0.5,
                                backgroundColor: _textColor.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation(_textColor)),
                          ),
                          Center(
                              child: ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.play,
                                  size: 15,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color _textColor = isDark ? Colors.white : Colors.black;
    Color _bgColor = isDark ? Colors.black : Colors.white;
    // TextStyle _textStyle1 =
    //     TextStyle(fontWeight: FontWeight.bold, fontSize: 30);
    // TextStyle _textStyle2 =
    //     TextStyle(fontWeight: FontWeight.normal, fontSize: 15);
    return WillPopScope(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value:
              isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: Scaffold(
            backgroundColor: isDark ? Colors.black : Colors.white,
            body: ValueListenableBuilder(
              valueListenable:
                  Hive.box('play').listenable(keys: ['list', 'index']),
              builder: (BuildContext context, dynamic box, Widget child) {
                this._swiperController.move(box.get('index'));
                return box.get('list').length > 0
                    ? SlidingUpPanel(
                        controller: _panelController,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.05),
                              offset: Offset(1, -5),
                              blurRadius: 20,
                              spreadRadius: 1)
                        ],
                        maxHeight: MediaQuery.of(context).size.height - 150,
                        color: Colors.transparent,
                        panel: _panel(isDark, box.get('list', defaultValue: []),
                            box.get('index', defaultValue: 0)),
                        collapsed: _collapsed(
                            isDark,
                            box.get('list', defaultValue: []),
                            box.get('index', defaultValue: 0)),
                        parallaxOffset: 0.2,
                        parallaxEnabled: true,
                        body: ValueListenableBuilder(
                          valueListenable:
                              Hive.box('app').listenable(keys: ['route']),
                          builder: (context, box, widget) {
                            if (box.get('route')['action'] == 'push' &&
                                routerStack
                                        .indexOf(box.get('route')['route']) ==
                                    -1) {
                              routerStack.add(box.get('route')['route']);
                            }
                            return IndexedStack(
                              index: routes[box.get('route')['route']],
                              children: <Widget>[
                                AnimateTabNavigation(
                                  sectionList: <CardSection>[
                                    new CardSection(
                                      title: 'Feed',
                                      leftColor: _bgColor,
                                      rightColor: _bgColor,
                                      textColor: _textColor,
                                      img: 'bg2.png',
                                      contentWidget: ValueListenableBuilder(
                                        valueListenable: Hive.box('play')
                                            .listenable(
                                                keys: ['list', 'index']),
                                        builder: (BuildContext context,
                                            dynamic box, Widget child) {
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 100),
                                            child: MList(
                                              musics: box.get('list',
                                                  defaultValue: []),
                                              index: box.get('index',
                                                  defaultValue: 0),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    new CardSection(
                                        title: 'Search',
                                        leftColor: _bgColor,
                                        rightColor: _bgColor,
                                        textColor: _textColor,
                                        img: 'bg1.png',
                                        contentWidget: Search()),
                                  ],
                                ),
                                Container(
                                  color: Colors.red,
                                )
                              ],
                            );
                          },
                        ))
                    : Text('');
              },
            ),
          ),
        ),
        onWillPop: () async {
          if (this._panelController.isPanelOpen) {
            this._panelController.close();
            return false;
          }
          print(routerStack);
          if (routerStack.length > 1) {
            routerStack.removeAt(routerStack.length - 1);
            var box = Hive.box('app');
            box.put('route', {
              'action': 'back',
              'route': routerStack[routerStack.length - 1]
            });
            return false;
          }
          return true;
        });
  }
}
