import 'package:allMusic/api/controller.dart';
import 'package:allMusic/util/util.dart';
import 'package:allMusic/view/page/play/index.dart';
import 'package:allMusic/view/page/search/result/index.dart';
import 'package:allMusic/view/test2.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {
  Color _bgColor = Colors.white; //default value
  Color _primaryColor = Colors.white;
  Color _textColor = Colors.black;
  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();

  bool _focus = false; //搜索框是否焦点
  bool _topbarElevation = true; //topbar是否显示阴影
  bool loading = false;

  List musics;
  var box = Hive.box('play');
  List history = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    history = box.get('search_history', defaultValue: []);
    _focusNode.addListener(() {
      this.setState(() {
        this._focus = _focusNode.hasFocus;
      });
    });
  }

  _search(v) {
    this.setState(() {
      this.loading = true;
    });
    _pushHistory(v);
    search(v).then((res) {
      this.setState(() {
        this.musics = res;
        this.loading = false;
      });
    });
  }

  _pushHistory(v) {
    //添加搜索历史
    int index = history.indexOf(v);
    if (index == -1) {
      history.insert(0, v);
      box.put('search_history', history);
    } else {
      history.removeAt(index);
      history.insert(0, v);
    }

    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    _bgColor = getThemeColor(isDark)['_bgColor'];
    _primaryColor = Theme.of(context).primaryColor;
    _textColor = getThemeColor(isDark)['_textColor'];

    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          backgroundColor: _bgColor,
          appBar: AppBar(
              brightness: Brightness.dark,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: _topbarElevation ? 2 : 0,
              title: searchBar()),
          floatingActionButton: Visibility(
            visible: Hive.box('play').get('list', defaultValue: []).length > 0,
            child: OpenContainer(
              closedElevation: 5,
              closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              closedBuilder: (context, action) => Container(
                width: 80,
                height: 80,
                color: Colors.white,
              ),
              openBuilder: (context, action) =>
                  Play(isDark: Theme.of(context).brightness == Brightness.dark),
            ),
          ),
          body: Stack(
            children: <Widget>[
              musics != null && musics.length > 0
                  ? Result(data: this.musics)
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            iconSize: 50,
                            icon: FaIcon(FontAwesomeIcons.search,
                                color: isDark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor),
                            onPressed: () {},
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            musics != null && musics.length == 0
                                ? "没有结果"
                                : '搜索',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isDark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                    ),
              Visibility(
                //modal阴影
                visible: _focus,
                child: Container(
                    //height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.2)),
              ),
              Visibility(
                //加载动画
                visible: loading,
                child: Container(
                  color: isDark ? _primaryColor : Colors.white,
                  child: Center(
                    child: SpinKitWave(
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                onEnd: () {
                  this.setState(() {
                    this._topbarElevation = !this._topbarElevation;
                  });
                },
                top: _focus ? 0 : -MediaQuery.of(context).size.height / 2,
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: MediaQuery.of(context).size.height / 2),
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: history
                              .where((e) =>
                                  e.indexOf(_textEditingController.text) !=
                                      -1 ||
                                  _textEditingController.text.indexOf(e) != -1)
                              .toList()
                              .map((e) => historyItem(e))
                              .toList())),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        decoration: BoxDecoration(
            color: this._textColor.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _textEditingController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onSubmitted: (v) {
                  v = v.trim();
                  if (v.length > 0) {
                    _search(v);
                  }
                },
                onChanged: (v) {
                  this.setState(() {});
                },
              ),
            ),
            Visibility(
              visible: _textEditingController.text.length > 0,
              child: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  _textEditingController.clear();
                  this.setState(() {});
                },
                icon: FaIcon(
                  FontAwesomeIcons.timesCircle,
                  size: 17,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            )
          ],
        ));
  }

  Widget historyItem(keyword) {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        margin: EdgeInsets.all(0),
        color: Theme.of(context).primaryColor,
        child: ListTile(
            onTap: () {
              _textEditingController.text = keyword;
              _textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: keyword.length));
              _focusNode.unfocus();
              _search(keyword);
            },
            contentPadding: EdgeInsets.fromLTRB(16, 3, 0, 3),
            dense: true,
            leading: FaIcon(
              FontAwesomeIcons.solidClock,
              size: 18,
              color: Colors.white.withOpacity(0.5),
            ),
            title: Text(
              keyword,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.arrowUp,
                size: 16,
                color: Colors.white.withOpacity(0.5),
              ),
              onPressed: () {
                _textEditingController.text = keyword;
                _textEditingController.selection = TextSelection.fromPosition(
                    TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: keyword.length));
                this.setState(() {});
              },
            )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
